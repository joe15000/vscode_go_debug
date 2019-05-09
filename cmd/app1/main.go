package main

import (
	"fmt"
	"net/http"

	"github.com/joe15000/vscode_go_debug/package1"
)

func main() {

	sampleHandler := package1.NewSampleHandler("dbRef")

	fmt.Println("App1 Server up, listening for connections on port 8080")

	http.HandleFunc("/", sampleHandler.HelloHandler)
	http.ListenAndServe(":8080", nil)
}
