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
	if !strings.contains(input, " ") {
		return {input, {}}
	}
	cmd: Cmd
	i := 0
	isCmd := true
	isLastRuneSpace := true
	firstletter := 0
	for r in input {
		i += 1
		if r == ' ' {
			if !isLastRuneSpace {
				if isCmd {
					cmd.cmd = input[firstletter:i - 1]
					isCmd = false
				} else {
					append(&cmd.args, input[firstletter:i - 1])
				}
			}
			isLastRuneSpace = true
		} else {
			if isLastRuneSpace {
				firstletter = i - 1
			}
			isLastRuneSpace = false
		}
	}
	if !isLastRuneSpace {
		append(&cmd.args, input[firstletter:])
	}
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
