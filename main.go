package main

import (
	"net/http"
	"context"
	"log"
	"github.com/gorilla/mux"
	"github.com/aws/aws-sdk-go-v2/aws/external"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

func RootHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello!\n"))
}

func GetInstanceHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Load AWS Credential")
	awsCfg, err := external.LoadDefaultAWSConfig()
	if err != nil {
		log.Println("Unable to load SDK config")
		w.Write([]byte("Internal Server Error!\n"))
		return
	}
	awsEC2 := ec2.New(awsCfg)
	input := &ec2.DescribeInstancesInput {}
	req := awsEC2.DescribeInstancesRequest(input)
	log.Println("Send EC2 Request")
	res, err := req.Send(context.Background())
	if err != nil {
		log.Println("Unable to get instances")
		w.Write([]byte("Internal Server Error!\n"))
		return
	} 
	w.Write([]byte(res.String()))
}

func main() {
    r := mux.NewRouter()
    // Routes consist of a path and a handler function.
	r.HandleFunc("/", RootHandler)
	r.HandleFunc("/instances", GetInstanceHandler)

    // Bind to a port and pass our router in
    log.Fatal(http.ListenAndServe(":8000", r))
}