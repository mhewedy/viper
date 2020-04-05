package main

import (
	"bytes"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"sort"
	"strconv"
	"strings"
)

type vmInfo struct {
	name  string
	image string
	cpu   int
	mem   int
	tags  string
}

// Get VM Info
// vminfo vm_01 vm_02 vm_03
func main() {
	args := os.Args[1:]

	if len(args) == 0 {
		fmt.Println("VM NAME\t\tIMAGE\t\t\tCPU\t\tMEM\t\tTAGS")
		return
	}

	ch := make(chan *vmInfo, len(args))

	for _, vmName := range args {
		go func(vm string) {
			ch <- getVMInfo(vm)
		}(vmName)
	}

	// collect from channel
	out := make([]*vmInfo, 0)

	var i int
	for {
		select {
		case vmInfo := <-ch:
			out = append(out, vmInfo)
			i++
		}
		if i == len(args) {
			break
		}
	}

	printInfo(out)
}

func printInfo(out []*vmInfo) {
	sort.Slice(out, func(i, j int) bool {
		return out[i].name < out[j].name
	})
	fmt.Println("VM NAME\t\tIMAGE\t\t\tCPU\t\tMEM\t\tTAGS")
	for _, e := range out {
		fmt.Printf("%s\t\t%s\t\t%d\t\t%d\t\t%s\n", e.name, e.image, e.cpu, e.mem, e.tags)
	}
}

func getVMInfo(vm string) *vmInfo {

	o, _ := execute("vboxmanage", "showvminfo", vm, "--machinereadable")
	output := *linesToMap(o, "=")

	cpu, _ := strconv.Atoi(output["cpus"])
	mem, _ := strconv.Atoi(output["memory"])

	image := readFromVMDB(vm, "image", "\t")
	tags := readFromVMDB(vm, "tags", "\t")

	return &vmInfo{
		name:  vm,
		image: image,
		cpu:   cpu,
		mem:   mem,
		tags:  tags,
	}
}

func readFromVMDB(vm string, dbFile string, defaultValue string) string {
	b, _ := ioutil.ReadFile(os.Getenv("HOME") + "/.vms/" + vm + "/" + dbFile)
	v := strings.ReplaceAll(string(b), "\n", " ")
	if len(v) == 0 {
		return defaultValue
	}
	return v
}

func linesToMap(lines string, sep string) *map[string]string {
	mapped := make(map[string]string)

	fields := strings.Split(lines, "\n")
	for i := range fields {
		s := strings.Split(fields[i], sep)
		if len(s) > 1 {
			mapped[s[0]] = s[1]
		}
	}
	return &mapped
}

func execute(command string, args ...string) (string, error) {
	cmd := exec.Command(command, args...)

	var stdout bytes.Buffer
	var stderr bytes.Buffer

	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()

	if err != nil {
		return "", errors.New(string(stderr.Bytes()))
	}

	return string(stdout.Bytes()), nil
}
