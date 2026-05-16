package main

import "core:fmt"


mainLoop :: proc() {
	buf: [MaxInputLength]byte
	for true {
		input, err := getUserInput(buf[:])
		if err != 0 {
			continue
		}
		cmd := stringToCmd(input)
		fmt.printfln("Cmd:%s", cmd.cmd)
		fmt.printfln("Args:%s", cmd.args)
		if cmd.cmd == "exit" {
			break
		}
	}
}

main :: proc() {
	mainLoop()
}
