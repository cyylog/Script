package main

import (
	"fmt"
	"sync"
	"time"
)

func job(index int) int {
	time.Sleep(time.Millisecond * 500)
	return index
}

func main() {
	start := time.Now()
	num := 5
	retCh := make(chan int)
	wg := sync.WaitGroup{}
	for i := 0; i < num; i++ {
		wg.Add(1)
		go func(param int) {
			defer wg.Done()
			retCh <- job(param)
		}(i)
	}
	go func() {
		defer close(retCh)
		wg.Wait()
	}()

	for item := range retCh {
		fmt.Println("收到结果", item)
	}
	end := time.Since(start)
	fmt.Println("耗时：", end.String())
}
