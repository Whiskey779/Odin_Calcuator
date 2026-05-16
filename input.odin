package main

import "core:fmt"
import "core:os"
import "core:strings"

MaxInputLength :: 50

Cmd :: struct {
	cmd:  string,
	args: string,
}

stringToCmd :: proc(input: string) -> Cmd {
	cmd: Cmd
	if !strings.contains(input, " ") {
		return {input, ""}
	}
	i := 0
	for r in input {
		i += 1
		if r == ' ' {
			break
		}
	}
	cmd.cmd = input[:i]
	cmd.args = input[i:]
	return cmd

}

getUserInput :: proc(buf: []byte) -> (string, int) {
	fmt.print("Math> ")
	num_bytes, err := os.read(os.stdin, buf)
	if err != 0 {
		fmt.printfln("Error Reading from stdin: %d", err)
		return "", 1
	}
	return string(buf[:num_bytes - 1]), 0
}
