package main

import (
    "C"
    "fmt"
)

//export Multiply
func Multiply(a, b C.int) C.int {
    return a * b
}

func main() {
    fmt.Println("Hello from Go Multiply Library")
}
