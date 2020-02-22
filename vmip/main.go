package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"sync"
)

type addr struct {
	ip  string
	mac string
}

const max = 255

func main() {
	flag.Parse()
	if len(flag.Args()) < 1 {
		fmt.Println("usage: vmip <vmName> [--purge]")
		os.Exit(-1)
	}

	vmName := flag.Arg(0)
	purge := false
	if len(flag.Args()) > 1 {
		purge = flag.Arg(1) == "--purge"
	}

	mac, _ := getMACAddr(vmName)

	var pong bool

	if purge {
		ping()
		pong = true
	}

	for {
		arp := getArpTable()
		for i := len(arp) - 1; i >= 0; i-- {
			a := arp[i]
			if a.mac == mac {
				fmt.Println(a.ip)
				return
			}
		}

		if pong {
			break
		}

		ping()
		pong = true
	}

	os.Exit(-1)
}

func ping() {
	var wg sync.WaitGroup
	wg.Add(max)

	for i := range [max]int{} {
		go func(i int) {
			ip := "192.168.1." + strconv.Itoa(i)
			cmd := exec.Command("nmap", "-sP", "--max-retries=1", "--host-timeout=100ms", ip)
			_ = cmd.Run()
			wg.Done()
		}(i)
	}

	wg.Wait()
}

func getMACAddr(vmName string) (string, error) {
	cmd := exec.Command("VBoxManage", "showvminfo", vmName, "--machinereadable")

	var stdout bytes.Buffer
	cmd.Stdout = &stdout

	_ = cmd.Run()

	fields := strings.Fields(string(stdout.Bytes()))
	for _, field := range fields {
		if strings.HasPrefix(field, "macaddress1") {
			mac := strings.Split(field, "=")[1]
			mac = strings.ToLower(strings.Trim(mac, `""`))
			return formatMACAddr(mac), nil
		}
	}
	return "", errors.New("not found")
}

func formatMACAddr(mac string) string {
	ret := make([]rune, 0)

	for i := range mac {
		if i%2 == 0 && mac[i] == '0' {
			continue
		}
		ret = append(ret, rune(mac[i]))
		if i%2 == 1 && i < len(mac)-1 {
			ret = append(ret, ':')
		}
	}
	return string(ret)
}

func getArpTable() []addr {
	var stdout bytes.Buffer
	cmd := exec.Command("arp", "-an")
	cmd.Stdout = &stdout

	_ = cmd.Run()

	addrs := make([]addr, 0)

	fields := strings.Split(string(stdout.Bytes()), "\n")
	for _, field := range fields {
		row := strings.Fields(field)
		if len(row) > 4 {
			ip := strings.TrimFunc(row[1], func(r rune) bool {
				return r == '(' || r == ')'
			})
			addrs = append(addrs, addr{
				ip:  ip,
				mac: row[3],
			})
		}
	}

	return addrs
}
