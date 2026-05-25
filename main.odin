package main

import "core:fmt"
import "core:strconv"

// Main Loop
mainLoop :: proc() {
	buf: [MaxInputLength]byte
	for true {
		input, err := getUserInput(buf[:])
		if err != 0 {
			continue
		}
		cmd := stringToCmd(input)
		if cmd.cmd == "exit" {
			break
		} else if cmd.cmd == "calc" {
			value, prefix, err := GetMissingValue(cmd.args)
			if err != 0 {
				// add err mesage using prefix
				continue
			}
			fmt.printfln("%s %f", prefix, value)
		} else if cmd.cmd == "sin" {
			for str in cmd.args {
				num, ok := strconv.parse_f32(str)
				if !ok {
					fmt.printfln("Error: '%s' is not a valid float", str)
					continue
				}
				fmt.printfln("sin(%f) = %f", num, GetSin(num))
			}
		} else if cmd.cmd == "cos" {
			for str in cmd.args {
				num, ok := strconv.parse_f32(str)
				if !ok {
					fmt.printfln("Error: '%s' is not a valid float", str)
					continue
				}
				fmt.printfln("cos(%f) = %f", num, GetCos(num))
			}
		} else if cmd.cmd == "tan" {
			for str in cmd.args {
				num, ok := strconv.parse_f32(str)
				if !ok {
					fmt.printfln("Error: '%s' is not a valid float", str)
					continue
				}
				fmt.printfln("tan(%f) = %f", num, GetTan(num))
			}
		}
	}
}

main :: proc() {
	mainLoop()
}
