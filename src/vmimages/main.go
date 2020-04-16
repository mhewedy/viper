package main

import (
	"errors"
	"fmt"
	"log"
	"os"
	"strings"
)

// --list
// --create <image>
func main() {
	args := os.Args[1:]

	if args[0] == "--list" {
		images, err := list()
		if err != nil {
			fmt.Println(err)
		}
		fmt.Print(images)
	} else if args[0] == "--create" {
		err := create(args[1])
		if err != nil {
			fmt.Println(err)
		}
	} else {
		log.Fatal("invalid args")
	}
}

func create(image string) error {

	// check image against cached
	cached, err := listCachedImages()
	if err != nil {
		return err
	}

	for i := range cached {
		if cached[i] == image {
			return nil // already cached
		}
	}

	remote, err := listRemoteImages()
	if err != nil {
		return err
	}

	// check image against remote
	var vm *vm
	for i := range remote {
		r := remote[i]
		if r.Name == image {
			vm = &r
			break
		}
	}

	if vm == nil {
		return errors.New("invalid image name: " + image)
	}

	return download(vm)
}

func download(vm *vm) error {
	fmt.Println("Downloading image", vm.Name, "from", vm.URL)
	fmt.Print("It might take a while depending on your internet connection")

	sp := strings.Split(vm.Name, "/")
	vmBasePath := getViperHomeDir() + "/boxes/" + sp[0]

	_, err := execute("mkdir", "-p", vmBasePath)
	if err != nil {
		return err
	}

	err = executeAndShowProgress("wget", "-O", vmBasePath+"/"+sp[1]+".ova", vm.URL)
	if err != nil {
		return err
	}
	return nil
}

func list() (string, error) {

	var result string

	cached, err := listCachedImages()
	if err != nil {
		return "", err
	}

	for i := range cached {
		result += cached[i] + "\t(cached)\n"
	}

	remote, err := listRemoteImagesNames()
	if err != nil {
		return "", err
	}
	for i := range remote {
		r := remote[i]
		if !contains(cached, r) {
			result += r + "\n"
		}
	}

	return result, nil
}
