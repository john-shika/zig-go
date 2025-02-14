package main

import (
	"C"
	"fmt"
)

//export Sum
func Sum(a, b C.int) C.int {
    return a + b
}

func main() {
	fmt.Println("Hello from Go Sum Library")
}
