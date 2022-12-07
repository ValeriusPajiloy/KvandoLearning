package main

import (
	"fmt"
	"math"
)

type Vertex struct {
	X, Y float64
}

type MyFloat float64

type Abser interface {
	Abs() float64
}

type I interface {
	M()
}
type T struct {
	S string
}
type F float64

type Person struct {
	Name string
	Age  int
}
type IPAddr [4]byte

type P struct {
	t *T
}

func main() {
	fmt.Println("--1-------------------------------")

	v := Vertex{3, 4}
	fmt.Println(v.Abs())

	fmt.Println("--2-------------------------------")

	v2 := Vertex{3, 4}
	fmt.Println(Abs(v2))

	fmt.Println("--3-------------------------------")

	f := MyFloat(-math.Sqrt2)
	fmt.Println(f.Abs())

	fmt.Println("--4-------------------------------")

	v4 := Vertex{3, 4}
	v4.Scale(10)
	fmt.Println(v4.Abs())

	fmt.Println("--5-------------------------------")

	v5 := Vertex{3, 4}
	Scale(&v5, 10)
	fmt.Println(Abs(v5))

	fmt.Println("--6-------------------------------")

	v6 := Vertex{3, 4}
	v6.Scale(2)
	Scale(&v6, 10)

	p6 := &Vertex{4, 3}
	p6.Scale(3)
	ScaleFunc(p6, 8)

	fmt.Println(v6, p6)

	fmt.Println("--7-------------------------------")

	v7 := Vertex{3, 4}
	fmt.Println(v7.Abs())
	fmt.Println(AbsFunc(v7))

	p7 := &Vertex{4, 3}
	fmt.Println(p7.Abs())
	fmt.Println(AbsFunc(*p7))

	fmt.Println("--8-------------------------------")

	v8 := &Vertex{3, 4}
	fmt.Printf("Before scaling: %+v, Abs: %v\n", v8, v8.Abs())
	v8.Scale(5)
	fmt.Printf("After scaling: %+v, Abs: %v\n", v8, v8.Abs())

	fmt.Println("--9-------------------------------")
	var a9 Abser
	f9 := MyFloat(-math.Sqrt2)
	v9 := Vertex{3, 4}

	a9 = f9
	a9 = &v9
	a9 = v9

	fmt.Println(a9.Abs())

	// fmt.Println("--10-------------------------------")

	// var i I = T{"hello"}
	// i.M()

	fmt.Println("--11-------------------------------")

	var i I

	i = &T{"Hello"}
	describe(i)
	i.M()

	i = F(math.Pi)
	describe(i)
	i.M()

	fmt.Println("--12-------------------------------")

	var i12 I

	var t *T
	i12 = t
	describe(i12)
	i12.M()

	i12 = &T{"hello"}
	describe(i12)
	i12.M()

	// fmt.Println("--13-------------------------------")

	// var i13 I
	// describe(i13)
	// i13.M()

	fmt.Println("--14-------------------------------")

	var i14 interface{}
	describeI(i14)

	i14 = 42
	describeI(i14)

	i14 = "hello"
	describeI(i14)

	fmt.Println("--15-------------------------------")

	var i15 interface{} = "hello"

	s15 := i15.(string)
	fmt.Println(s15)

	s15, ok15 := i15.(string)
	fmt.Println(s15, ok15)

	f15, ok15 := i15.(float64)
	fmt.Println(f15, ok15)

	// f15 = i15.(float64) // panic
	// fmt.Println(f15)

	fmt.Println("--16-------------------------------")

	do(21)
	do("hello")
	do(true)

	fmt.Println("--17-------------------------------")

	a := Person{"Arthur Dent", 42}
	z := Person{"Zaphod Beeblebrox", 9001}
	fmt.Println(a, z)

	fmt.Println("--18-------------------------------")

	hosts := map[string]IPAddr{
		"loopback":  {127, 0, 0, 1},
		"googleDNS": {8, 8, 8, 8},
	}
	for name, ip := range hosts {
		fmt.Printf("%v: %v\n", name, ip)
	}

	fmt.Println("--19-------------------------------")

	temp := &T{
		S: "str",
	}

	ptemp := &P{
		t: temp,
	}

	ptemp.t.S = "qwr"

	fmt.Println("--20-------------------------------")

	fmt.Println("--21-------------------------------")

	fmt.Println("--22-------------------------------")

	fmt.Println("--23-------------------------------")

	fmt.Println("--24-------------------------------")

	fmt.Println("--25-------------------------------")
}

// 1, 4, 6, 7, 8
func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

// 2, 5
func Abs(v Vertex) float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}
func Scale(v *Vertex, f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

// 3
func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

// 6
func ScaleFunc(v *Vertex, f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

// 7
func AbsFunc(v Vertex) float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

// 10
//
//	func (t T) M() {
//		fmt.Println(t.S)
//	}
//

// 11
// func (t *T) M() {
// 	fmt.Println(t.S)
// }

func (f F) M() {
	fmt.Println(f)
}
func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}

//12

func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}

// 14
func describeI(i interface{}) {
	fmt.Printf("(%v, %T)\n", i, i)
}

// 16
func do(i interface{}) {
	switch v := i.(type) {
	case int:
		fmt.Printf("Twice %v is %v\n", v, v*2)
	case string:
		fmt.Printf("%q is %v bytes long\n", v, len(v))
	default:
		fmt.Printf("I don't know about type %T!\n", v)
	}
}

// 17
func (p Person) String() string {
	return fmt.Sprintf("%v (%v years)", p.Name, p.Age)
}
