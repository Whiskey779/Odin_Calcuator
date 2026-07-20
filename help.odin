package main

import "core:fmt"

PrintHelpDoc :: proc() {
	fmt.println(
		`OTRIG - Right Triangle Calculator

Commands:
    otrig [values]   - prints the missing value for the info previded
    otrig help       - prints the help text

Variables:
    o      opposite side
    a      adjacent side
    h      hypotenuse
    deg    angle in degrees
    rad    angle in radians

Rules:
    - Exactly one value must be ?
    - Provide three bits of information to solve a right triangle incuding the ?
    - The values must be between 0 and 1001
    - Make sure that the triangle is possible (hint: make sure the hypotenuse is bigger than the opposite and adjacent)
    - Must only define a part once
    - Use either deg or rad for angles

Examples:
    otrig o = 4 h = 5 a = ?
    otrig o = 6 h = 9 deg = ?
    otrig deg = 45 a = 10 h = ?
    otrig rad = 0.5 h = 8 o = ?
`,
	)
}
