package main

import (
	"fmt"
	"sync"
	"time"
)

type List[T any] struct {
	next *List[T]
	val  T
}

type SafeCounter struct {
	mu sync.Mutex
	v  map[string]int
}

type Fetcher interface {
	Fetch(url string) (body string, urls []string, err error)
}
type fakeResult struct {
	body string
	urls []string
}
type fakeFetcher map[string]*fakeResult

var fetcher = fakeFetcher{
	"https://golang.org/": &fakeResult{
		"The Go Programming Language",
		[]string{
			"https://golang.org/pkg/",
			"https://golang.org/cmd/",
		},
	},
	"https://golang.org/pkg/": &fakeResult{
		"Packages",
		[]string{
			"https://golang.org/",
			"https://golang.org/cmd/",
			"https://golang.org/pkg/fmt/",
			"https://golang.org/pkg/os/",
		},
	},
	"https://golang.org/pkg/fmt/": &fakeResult{
		"Package fmt",
		[]string{
			"https://golang.org/",
			"https://golang.org/pkg/",
		},
	},
	"https://golang.org/pkg/os/": &fakeResult{
		"Package os",
		[]string{
			"https://golang.org/",
			"https://golang.org/pkg/",
		},
	},
}

func main() {
	fmt.Println("--1-------------------------------")
	si := []int{10, 20, 15, -10}
	fmt.Println(Index(si, 15))

	ss := []string{"foo", "bar", "baz", "hello"}
	fmt.Println(Index(ss, "hello"))

	fmt.Println("--2-------------------------------")
	go say("world")
	say("hello")

	fmt.Println("--3-------------------------------")
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], c)
	x, y := <-c, <-c // receive from c

	fmt.Println(x, y, x+y)

	fmt.Println("--4-------------------------------")
	ch := make(chan int, 2)
	ch <- 1
	ch <- 2
	fmt.Println(<-ch)
	fmt.Println(<-ch)

	fmt.Println("--4-------------------------------")
	c4 := make(chan int, 10)
	go fibonacci(cap(c4), c4)
	for i := range c4 {
		fmt.Println(i)
	}

	fmt.Println("--5-------------------------------")
	c5 := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c5)
		}
		quit <- 0
	}()
	fibonacci_5(c5, quit)

	// fmt.Println("--6-------------------------------")
	// tick := time.Tick(100 * time.Millisecond)
	// boom := time.After(500 * time.Millisecond)
	// for {
	// 	select {
	// 	case <-tick:
	// 		fmt.Println("tick.")
	// 	case <-boom:
	// 		fmt.Println("BOOM!")
	// 		return
	// 	default:
	// 		fmt.Println("    .")
	// 		time.Sleep(50 * time.Millisecond)
	// 	}
	// }

	fmt.Println("--7-------------------------------")

	c7 := SafeCounter{v: make(map[string]int)}
	for i := 0; i < 1000; i++ {
		go c7.Inc("somekey")
	}

	time.Sleep(time.Second)
	fmt.Println(c7.Value("somekey"))

	fmt.Println("--8-------------------------------")
	Crawl("https://golang.org/", 4, fetcher)

}

// 1
func Index[T comparable](s []T, x T) int {
	for i, v := range s {

		if v == x {
			return i
		}
	}
	return -1
}

// 2
func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
}

// 3
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum
}

// 4
func fibonacci(n int, c chan int) {
	x, y := 0, 1
	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}
	close(c)
}

// 5
func fibonacci_5(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x:
			x, y = y, x+y
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}

// 7
func (c *SafeCounter) Inc(key string) {
	c.mu.Lock()
	c.v[key]++
	c.mu.Unlock()
}

func (c *SafeCounter) Value(key string) int {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.v[key]
}

// 8
func Crawl(url string, depth int, fetcher Fetcher) {
	if depth <= 0 {
		return
	}
	body, urls, err := fetcher.Fetch(url)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("found: %s %q\n", url, body)
	for _, u := range urls {
		Crawl(u, depth-1, fetcher)
	}
	return
}
func (f fakeFetcher) Fetch(url string) (string, []string, error) {
	if res, ok := f[url]; ok {
		return res.body, res.urls, nil
	}
	return "", nil, fmt.Errorf("not found: %s", url)
}
