package main

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"time"
)

func getViperHomeDir() string {
	return os.Getenv("HOME") + "/.viper"
}

func executeAndShowProgress(command string, args ...string) error {
	cmd := exec.Command(command, args...)

	err := cmd.Start()
	if err != nil {
		return err
	}

	go func() {
		for {
			fmt.Print(".")
			time.Sleep(3 * time.Second)
		}
	}()

	err = cmd.Wait()
	if err != nil {
		return err
	}
	fmt.Println()
	return nil
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

func contains(a []string, s string) bool {
	for i := range a {
		if a[i] == s {
			return true
		}
	}
	return false
}
