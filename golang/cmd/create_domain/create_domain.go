// Usage: TOKEN=token go run cmd/create_domain/create_domain.go example.com
package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/dnsimple/dnsimple-go/dnsimple"
	"golang.org/x/oauth2"
)

func main() {
	oauthToken := os.Getenv("TOKEN")
	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: oauthToken})
	tc := oauth2.NewClient(context.Background(), ts)

	client := dnsimple.NewClient(tc)
	client.BaseURL = "https://api.sandbox.dnsimple.com"

	// get the current authenticated account (if you don't know who you are)
	whoamiResponse, err := client.Identity.Whoami()
	if err != nil {
		fmt.Printf("Whoami() returned error: %v\n", err)
		os.Exit(1)
	}

	accountId := strconv.Itoa(whoamiResponse.Data.Account.ID)

	name := os.Args[1]
	fmt.Printf("Adding domain %v\n", name)
	domain := dnsimple.Domain{Name: name}
	createDomainResponse, err := client.Domains.CreateDomain(accountId, domain)
	if err != nil {
		fmt.Printf("CreateDomain() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", createDomainResponse.Data)
}
