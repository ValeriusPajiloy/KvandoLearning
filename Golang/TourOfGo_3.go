package main

import (
	"fmt"
	"math"
	"strings"
	// "golang.org/x/tour/wc"
)

type Vertex struct {
	X int
	Y int
}

var (
	v1 = Vertex{1, 2}
	v2 = Vertex{X: 1}
	v3 = Vertex{}
	p  = &Vertex{1, 2}
)

type VertexFloat struct {
	Lat, Long float64
}

var m map[string]VertexFloat

var m20 = map[string]VertexFloat{
	"Bell Labs": VertexFloat{
		40.68433, -74.39967,
	},
	"Google": VertexFloat{
		37.42202, -122.08408,
	},
}

var m21 = map[string]VertexFloat{
	"Bell Labs": {40.68433, -74.39967},
	"Google":    {37.42202, -122.08408},
}

var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

func main() {
	i, j := 42, 2701

	p := &i
	fmt.Println(*p)
	*p = 21
	fmt.Println(i)

	p = &j
	*p = *p / 37
	fmt.Println(j)

	fmt.Println("-------------------------------")

	fmt.Println(Vertex{1, 2})

	fmt.Println("-------------------------------")

	v := Vertex{1, 2}
	v.X = 4
	fmt.Println(v.X)

	fmt.Println("-------------------------------")

	v1 := Vertex{1, 2}
	p1 := &v1
	p1.X = 1e9
	fmt.Println(v1)

	fmt.Println("-------------------------------")

	fmt.Println(v1, p, v2, v3)

	fmt.Println("-------------------------------")

	var a [2]string
	a[0] = "Hello"
	a[1] = "World"
	fmt.Println(a[0], a[1])
	fmt.Println(a)

	primes := [6]int{2, 3, 5, 7, 11, 13}
	fmt.Println(primes)

	fmt.Println("-------------------------------")

	primes2 := [6]int{2, 3, 5, 7, 11, 13}

	var s []int = primes2[1:4]
	fmt.Println(s)

	fmt.Println("-------------------------------")

	names := [4]string{
		"John",
		"Paul",
		"George",
		"Ringo",
	}
	fmt.Println(names)

	a2 := names[0:2]
	b2 := names[1:3]
	fmt.Println(a2, b2)

	b2[0] = "XXX"
	fmt.Println(a2, b2)
	fmt.Println(names)

	fmt.Println("-------------------------------")

	q := []int{2, 3, 5, 7, 11, 13}
	fmt.Println(q)

	r := []bool{true, false, true, true, false, true}
	fmt.Println(r)

	s2 := []struct {
		i int
		b bool
	}{
		{2, true},
		{3, false},
		{5, true},
		{7, true},
		{11, false},
		{13, true},
	}
	fmt.Println(s2)

	fmt.Println("-------------------------------")

	s3 := []int{2, 3, 5, 7, 11, 13}

	s3 = s3[1:4]
	fmt.Println(s3)

	s3 = s3[:2]
	fmt.Println(s3)

	s3 = s3[1:]
	fmt.Println(s3)

	fmt.Println("-------------------------------")

	s4 := []int{2, 3, 5, 7, 11, 13}
	printSlice(s4)

	s4 = s4[:0]
	printSlice(s4)

	s4 = s4[:4]
	printSlice(s4)

	s4 = s4[2:]
	printSlice(s4)

	fmt.Println("-------------------------------")

	var s5 []int
	fmt.Println(s5, len(s5), cap(s5))
	if s5 == nil {
		fmt.Println("nil!")
	}

	fmt.Println("-------------------------------")

	a13 := make([]int, 5)
	printSlice13("a", a13)

	b13 := make([]int, 0, 5)
	printSlice13("b", b13)

	c13 := b13[:2]
	printSlice13("c", c13)

	d13 := c13[2:5]
	printSlice13("d", d13)

	fmt.Println("-------------------------------")

	board := [][]string{
		[]string{"_", "_", "_"},
		[]string{"_", "_", "_"},
		[]string{"_", "_", "_"},
	}

	// The players take turns.
	board[0][0] = "X"
	board[2][2] = "O"
	board[1][2] = "X"
	board[1][0] = "O"
	board[0][2] = "X"

	for i := 0; i < len(board); i++ {
		fmt.Printf("%s\n", strings.Join(board[i], " "))
	}

	fmt.Println("-------------------------------")

	var s15 []int
	printSlice(s15)

	s15 = append(s15, 0)
	printSlice(s15)

	s15 = append(s15, 1)
	printSlice(s15)

	s15 = append(s15, 2, 3, 4)
	printSlice(s15)

	fmt.Println("-------------------------------")

	for i, v := range pow {
		fmt.Printf("2**%d = %d\n", i, v)
	}

	fmt.Println("-------------------------------")

	pow17 := make([]int, 10)
	for i := range pow17 {
		pow17[i] = 1 << uint(i) // == 2**i
	}
	for _, value := range pow17 {
		fmt.Printf("%d\n", value)
	}

	fmt.Println("-------------------------------")

	// pic.Show(Pic)

	// fmt.Println("-------------------------------")

	m = make(map[string]VertexFloat)
	m["Bell Labs"] = VertexFloat{
		40.68433, -74.39967,
	}
	fmt.Println(m["Bell Labs"])

	fmt.Println("-------------------------------")

	fmt.Println(m20)

	fmt.Println("-------------------------------")

	fmt.Println(m21)

	fmt.Println("-------------------------------")

	m22 := make(map[string]int)

	m22["Answer"] = 42
	fmt.Println("The value:", m22["Answer"])

	m22["Answer"] = 48
	fmt.Println("The value:", m22["Answer"])

	delete(m22, "Answer")
	fmt.Println("The value:", m22["Answer"])

	v22, ok := m22["Answer"]
	fmt.Println("The value:", v22, "Present?", ok)

	// fmt.Println("-------------------------------")
	// wc.Test(WordCount)

	fmt.Println("-------------------------------")

	hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
	}
	fmt.Println(hypot(5, 12))

	fmt.Println(compute(hypot))
	fmt.Println(compute(math.Pow))

	fmt.Println("-------------------------------")

	pos, neg := adder(), adder()
	for i := 0; i < 10; i++ {
		fmt.Println(
			pos(i),
			neg(-2*i),
		)
	}
	fmt.Println("-------------------------------")

	f := fibonacci()
	for i := 0; i < 10; i++ {
		fmt.Println(f())
	}
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
func printSlice13(s string, x []int) {
	fmt.Printf("%s len=%d cap=%d %v\n", s, len(x), cap(x), x)
}

// func Pic(dx, dy int) [][]uint8 {
// }

func WordCount(s string) map[string]int {
	return map[string]int{"x": 1}
}
func compute(fn func(float64, float64) float64) float64 {
	return fn(3, 4)
}
func adder() func(int) int {
	sum := 0
	return func(x int) int {
		sum += x
		return sum
	}
}

func fibonacci() func() int {
	current := 0
	next := 1
	return func() int {
		returned := current
		current = next
		next = returned + next
		return returned
	}
}
