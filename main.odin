package main

import "core:fmt"
import "core:os"

main :: proc() {
	//mainLoop()
	if len(os.args) < 2 {
		fmt.println("Enter the 'help' command to get usage info")
		return
	}
	if os.args[1] == "help" || os.args[1] == "--help" || os.args[1] == "-h" {
		PrintHelpDoc()
	} else {
		value, message, ok := GetMissingValue(os.args[1:])
		if !ok {
			fmt.println(message)
			fmt.println("Enter the 'help' command to get usage info")
			return
		}
		fmt.printfln("%s %f", message, value)
	}
}
