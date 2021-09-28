package main

import "time"

func job(intdex int) int {
	time.Sleep(time.Millisecond * 500)
	return intdex
}

func main() {

}
