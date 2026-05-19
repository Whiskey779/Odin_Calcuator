package main

import "core:fmt"
import "core:os"
import "core:strings"

// the max number of characters the user can input
MaxInputLength :: 50

// A Struct to store the user input and pass it around
Cmd :: struct {
	cmd:  string,
	args: [dynamic]string,
}

// parses the user input string into teh Cmd struct
stringToCmd :: proc(input: string) -> Cmd {
	cmd: Cmd
	if !strings.contains(input, " ") {
		return {input, {}}
	}
	i := 0
	isCmd := true
	lastSpace := 0
	for r in input {
		i += 1
		if r == ' ' {
			if isCmd {
				cmd.cmd = input[:i - 1]
				isCmd = false
				lastSpace = i
			} else {
				append(&cmd.args, input[lastSpace:i - 1])
				lastSpace = i
			}
		}
	}
	append(&cmd.args, input[lastSpace:])
	return cmd

}

//gets the users input from standard in
getUserInput :: proc(buf: []byte) -> (string, int) {
	fmt.print("Math> ")
	num_bytes, err := os.read(os.stdin, buf)
	if err != 0 {
		fmt.printfln("Error Reading from stdin: %d", err)
		return "", 1
	}
	return string(buf[:num_bytes - 1]), 0
}
