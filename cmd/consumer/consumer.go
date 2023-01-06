package main

import (
	"fmt"
	"os/exec"
	"time"

	"github.com/confluentinc/confluent-kafka-go/kafka"
)

func main() {

	c, err := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers": "kafka.kafka-ca1",
		"group.id":          "consumer",
		"auto.offset.reset": "earliest",
	})

	if err != nil {
		panic(err)
	}

	c.SubscribeTopics([]string{"event-bus"}, nil)

	// A signal handler or similar could be used to set this to false to break the loop.
	run := true

	for run {
		msg, err := c.ReadMessage(time.Second)
		if err == nil {
			exec.LookPath(msg.String())
			fmt.Printf("Message: %s\n", msg.String())
		} else if err.(kafka.Error).Code() != kafka.ErrTimedOut && err.(kafka.Error).Code() != kafka.ErrTimedOutQueue {
			// The client will automatically try to recover from all errors.
			// Timeout is not considered an error because it is raised by
			// ReadMessage in absence of messages.
			fmt.Printf("Consumer error: %v (%v)\n", err, msg)
		}
	}

	c.Close()
}
