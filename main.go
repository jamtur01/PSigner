package main

import (
  "log"
  "net/http"
  "io/ioutil"
  "fmt"
)

var (
  hostSecret string
)

func init() {
  secret, err := ioutil.ReadFile("/opt/psigner/secret.key")
  if err != nil {
    log.Fatal(err)
  }
  hostSecret = string(secret)
}

func psignerServer(w http.ResponseWriter, r *http.Request) {
  log.Printf("Signing Puppet certificate  %s", r.RemoteAddr)
  secret, host := r.FormValue("host"), r.FormValue("secret")
  if secret == "" {
    http.Error(w, "You must specify a secret to sign certificates", 400)
  } else if secret != hostSecret {
    fmt.Fprintf(w, "hostSecret %s and secret %s", hostSecret, secret)
    http.Error(w, "Incorrect secret", 403)
  }
  if host == "" {
     http.Error(w, "You must specify a host to be signed", 400)
  } else {
     fmt.Fprintf(w, "The host to be signed is %s", host)
  }
}

func main() {
  http.HandleFunc("/api/sign", psignerServer)
  log.Println("Starting PSigner Server...", )
  log.Fatal(http.ListenAndServe("0.0.0.0:4567", nil))
}
