package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	servername := os.Getenv("SERVERNAME")
	if len(servername) == 0 {
		servername = "serverbot"
	}
	fmt.Fprintf(w, "Hello, my name is %s! I'm running from instance '%s'\n", servername, os.Getenv("HOSTNAME"))
	fmt.Printf("Got a connection from %s\n", r.Host)
}
