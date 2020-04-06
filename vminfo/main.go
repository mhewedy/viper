package main

import (
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"log"
	"os"
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

	c, m := getVMCpuAndMem(vm)
	cpu, _ := strconv.Atoi(c)
	mem, _ := strconv.Atoi(m)

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
	b, _ := ioutil.ReadFile(getDBPath(vm) + "/" + dbFile)
	v := strings.ReplaceAll(string(b), "\n", " ")
	if len(v) == 0 {
		return defaultValue
	}
	return v
}

func getVMCpuAndMem(vm string) (string, string) {

	type vbox struct {
		XMLName xml.Name `xml:"VirtualBox"`
		Machine struct {
			Hardware struct {
				CPU struct {
					Count string `xml:"count,attr"`
				} `xml:"CPU"`
				Memory struct {
					RAMSize string `xml:"RAMSize,attr"`
				} `xml:"Memory"`
			} `xml:"Hardware"`
		} `xml:"Machine"`
	}

	var vb vbox
	b, _ := ioutil.ReadFile(getDBPath(vm) + "/" + vm + ".vbox")
	err := xml.Unmarshal(b, &vb)

	if err != nil {
		log.Fatal(err)
	}

	cpuCount := vb.Machine.Hardware.CPU.Count
	if len(cpuCount) == 0 {
		cpuCount = "1"
	}
	return cpuCount,
		vb.Machine.Hardware.Memory.RAMSize
}

func getDBPath(vm string) string {
	return os.Getenv("HOME") + "/.vms/" + vm + "/"
}
