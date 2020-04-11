package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	baseDir := os.Getenv("HOME") + "/.viper/boxes/"

	err := filepath.Walk(baseDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			name := strings.ReplaceAll(path, baseDir, "")
			fmt.Println(strings.ReplaceAll(name, ".ova", ""))
		}
		return nil
	})

	if err != nil {
		os.Exit(1)
	}
}
