package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"

main :: proc() {
	MaxInputLength :: 50
	fmt.print("Enter Float: ")
	buf: [MaxInputLength]byte
	num_bytes, err := os.read(os.stdin, buf[:])
	if err != 0 {
		fmt.printfln("Error Reading from stdin: %d", err)
		return
	}
	if num_bytes > MaxInputLength {
		fmt.println("Error: Input is to long it can only be %d charturs long.", MaxInputLength - 1)
	}
	input := string(buf[:num_bytes - 1])
	number, ok := strconv.parse_f32(input)
	if !ok {
		fmt.println("Error Pasing string to f32")
		return
	}
	fmt.print(math.sin(math.to_radians(number)))
}
