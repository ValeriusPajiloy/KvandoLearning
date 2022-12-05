package main

import (
	"fmt"
	"math"
	"runtime"
	"time"
)

func main() {
	fmt.Println("Hi!")
	fmt.Println("-------------------------------")

	sum := 0
	for i := 0; i < 10; i++ {
		sum += 1
	}
	fmt.Println(sum)
	fmt.Println("-------------------------------")

	sum = 1
	for sum < 1000 {
		sum += sum
	}

	fmt.Println(sum)
	fmt.Println("-------------------------------")

	fmt.Println(sqrt(2), sqrt(-4))
	fmt.Println("-------------------------------")

	fmt.Println(
		pow(3, 2, 10),
		pow(3, 3, 20),
	)
	fmt.Println("-------------------------------")

	fmt.Println(
		newPow(3, 2, 10),
		newPow(3, 3, 20),
	)
	fmt.Println("-------------------------------")

	n := 118.0
	fmt.Println(Sqrt(n))
	fmt.Println(math.Sqrt(n))

	fmt.Println("-------------------------------")

	fmt.Print("Go runs on ")
	switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("OS X.")
	case "linux":
		fmt.Println("Linux.")
	default:
		fmt.Printf("%s.\n", os)
	}
	fmt.Println("-------------------------------")

	fmt.Println("When's Saturday?")
	today := time.Now().Weekday()
	switch time.Saturday {
	case today + 0:
		fmt.Println("Today.")
	case today + 1:
		fmt.Println("Tomorrow.")
	case today + 2:
		fmt.Println("In two days.")
	default:
		fmt.Println("To far away.")
	}
	fmt.Println("-------------------------------")

	t := time.Now()
	switch {
	case t.Hour() < 12:
		fmt.Println("Good morning!")
	case t.Hour() < 17:
		fmt.Println("Good afternoon.")
	default:
		fmt.Println("Good evening.")
	}
	fmt.Println("-------------------------------")

	defer fmt.Println("-------------------------------")
	defer fmt.Println("bye")
	defer fmt.Println("after main()")

	fmt.Println("counting")

	for i := 0; i < 10; i++ {
		defer fmt.Println(i)
	}

}
func sqrt(x float64) string {
	if x < 0 {
		return sqrt(-x) + "i"
	}
	return fmt.Sprint(math.Sqrt(x))
}

func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	}
	return lim
}

func newPow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	} else {
		fmt.Printf("%g >= %g\n", v, lim)
	}
	return lim
}
func Sqrt(x float64) float64 {
	z := float64(1)
	for i := 0; i < 10; i++ {
		z -= (z*z - x) / (2 * z)
	}
	return z
}
