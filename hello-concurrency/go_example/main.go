package main

import (
	"os"
	"path/filepath"
)

type Command int

const (
	ListDir Command = iota
	GetFile
)

type Request struct {
	Command Command
	Args    []string
	Client  chan Response
}

type Response struct {
	Data interface{}
}

func start(dir string) chan Request {
	requests := make(chan Request)
	go loop(dir, requests)
	return requests
}

func loop(dir string, requests chan Request) {
	for {
		request := <-requests
		switch request.Command {
		case ListDir:
			files, err := os.ReadDir(dir)
			if err != nil {
				request.Client <- Response{Data: err.Error()}
				continue
			}
			fileNames := make([]string, len(files))
			for i, file := range files {
				fileNames[i] = file.Name()
			}
			request.Client <- Response{Data: fileNames}
		case GetFile:
			if len(request.Args) < 1 {
				request.Client <- Response{Data: "Filename not specified"}
				continue
			}
			fullPath := filepath.Join(dir, request.Args[0])
			data, err := os.ReadFile(fullPath)
			if err != nil {
				request.Client <- Response{Data: err.Error()}
				continue
			}
			request.Client <- Response{Data: data}
		}
	}
}

func main() {
	// Example usage
	dir := "./"            // the directory to manage
	requests := start(dir) // Start the file server and get the requests channel

	clientChan := make(chan Response)
	requests <- Request{Command: ListDir, Client: clientChan} // Send list directory request
	response := <-clientChan                                  // Receive the response
	println("Directory listing:")
	if fileNames, ok := response.Data.([]string); ok {
		for _, name := range fileNames {
			println(name)
		}
	} else {
		println("Error:", response.Data)
	}

	// Send get file request
	requests <- Request{Command: GetFile, Args: []string{"main.go"}, Client: clientChan}
	response = <-clientChan // Receive the response
	if data, ok := response.Data.([]byte); ok {
		println("File contents:", string(data))
	} else {
		println("Error:", response.Data)
	}
}
