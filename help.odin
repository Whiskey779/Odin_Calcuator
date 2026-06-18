package main

import "core:fmt"

PrintHelpDoc :: proc() {
	fmt.println("----------------- Help Doc -----------------")
	fmt.println("To exit the programme enter 'exit'")
	fmt.print(
		"To use basic trig functions like sin cos and tan with degrees you can by stating the function then the values you would like to use\n e.g. sin 30 45 90\n",
	)
}
