package main

// import "fmt"

// func main() {
// 	fmt.Println("Hello, world")
// }

import (
	"fmt"
	"math"
	"math/cmplx"
	"math/rand"
	"time"
)

func init() {
	fmt.Println("Preload")

	rand.Seed(time.Now().Unix())
}

const Pi = 3.14

var c, python, java bool
var i_1, j int = 1, 2

var (
	toBe   bool       = false
	MaxInt uint64     = 1<<64 - 1
	z      complex128 = cmplx.Sqrt(-5 + 12i)
)

const (
	Big   = 1 << 100
	Small = Big >> 99
)

func main() {
	fmt.Println("Hello, world")

	fmt.Println("Welcome to the playground!")

	fmt.Println("The time is", time.Now())

	fmt.Println("My favorite number is", rand.Intn(10))

	fmt.Printf("Now you have %g problems.\n", math.Sqrt(7))

	fmt.Println(math.Pi)

	fmt.Println(add(42, 13))

	fmt.Println(add2(42, 13))

	a, b := swap("hello", "world")

	fmt.Println(a, b)

	fmt.Println(split(17))

	var i int
	fmt.Println(i, c, python, java)

	var c_1, python_1, java_1 = true, false, "no!"

	fmt.Println(i_1, j, c_1, python_1, java_1)

	var i_2, j_2 = 1, 2
	k_2 := 3
	c_2, python_2, java_2 := true, false, "no"
	fmt.Println(i_2, j_2, k_2, c_2, python_2, java_2)

	fmt.Printf("Type: %T Value: %v\n", toBe, toBe)
	fmt.Printf("Type: %T Value: %v\n", MaxInt, MaxInt)
	fmt.Printf("Type: %T Value: %v\n", z, z)

	var i_3 int
	var f float64
	var b_2 bool
	var s string
	fmt.Printf("%v %v %v %q\n", i_3, f, b_2, s)

	var x_13, y_13 int = 3, 4
	var f_13 float64 = math.Sqrt(float64(x_13*x_13 + y_13*y_13))
	var z_13 uint = uint(f_13)
	fmt.Println(x_13, y_13, z_13, f_13)

	v_1 := 42
	fmt.Printf("v is of type %T\n", v_1)
	v_2 := 42.1234
	fmt.Printf("v is of type %T\n", v_2)
	v_3 := 10.15 + 0.56i
	fmt.Printf("v is of type %T\n", v_3)

	const World = "World"
	fmt.Println("Hello", World)
	fmt.Println("Happy", Pi, "Day")

	const Truth = true
	fmt.Println("Go rules?", Truth)

	fmt.Println(needInt(Small))
	fmt.Println(needFloat(Small))
	fmt.Println(needFloat(Big))

	fmt.Println(Small)
}

func add(x, y int) int {
	return x + y
}
func add2(x int, y int) int {
	return x + y
}
func swap(x, y string) (string, string) {
	return y, x
}

func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}

func needInt(x int) int { return x*10 + 1 }

func needFloat(x float64) float64 {
	return x * 0.1
}
