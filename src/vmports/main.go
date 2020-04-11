package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const rangeSep = "-"

// sample input: 3000 4040:40040 8080-8088:9080-9088
func main() {

	args := os.Args[1:]
	var result string

	for _, arg := range args {
		mapping := strings.Split(arg, ":")
		vmPort := mapping[0]
		var localPort string
		if len(mapping) == 1 {
			localPort = vmPort
		} else {
			localPort = mapping[1]
		}

		portMapping := getPortMapping(vmPort, localPort)
		for vm, local := range portMapping {
			result += "-L 0.0.0.0:" + local + ":localhost:" + vm + " "
		}
	}
	if len(result) != 0 {
		fmt.Println(result)
	}
}

func getPortMapping(vmPort string, localPort string) map[string]string {
	checkIfPortsAreInInvalidRangeFormat(vmPort, localPort)
	return _getPortMapping(vmPort, localPort)
}

func checkIfPortsAreInInvalidRangeFormat(vmPort string, localPort string) {
	if strings.Contains(vmPort, rangeSep) && !strings.Contains(localPort, rangeSep) {
		_, _ = fmt.Fprintln(os.Stderr, "Range ports not matched", vmPort, localPort)
		os.Exit(1)
	}
}

func _getPortMapping(vmPort string, localPort string) map[string]string {

	if strings.Contains(vmPort, rangeSep) {
		vmPorts := strings.Split(vmPort, rangeSep)
		localPorts := strings.Split(localPort, rangeSep)

		firstVmPort, _ := strconv.Atoi(vmPorts[0])
		lastVmPort, _ := strconv.Atoi(vmPorts[1])

		firstLocalPort, _ := strconv.Atoi(localPorts[0])
		lastLocalPort, _ := strconv.Atoi(localPorts[1])

		if lastVmPort-firstVmPort != lastLocalPort-firstLocalPort {
			_, _ = fmt.Fprintln(os.Stderr, "Number of ports not equals", vmPort, localPort,
				lastVmPort-firstVmPort, "ports vs", lastLocalPort-firstLocalPort, "ports")
			os.Exit(1)
		}

		var ret = make(map[string]string)

		for i := 0; i <= lastVmPort-firstVmPort; i++ {
			ret[strconv.Itoa(firstVmPort+i)] = strconv.Itoa(firstLocalPort + i)
		}
		return ret
	} else {
		return map[string]string{vmPort: localPort}
	}
}
