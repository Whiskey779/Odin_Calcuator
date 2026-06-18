package main

import "core:fmt"

PrintHelpDoc :: proc() {
	fmt.println(
		`OTRIG - Right Triangle Calculator

Usage:
    otrig [values]
    otrig help
    otrig --help
    otrig -h

Examples:
    otrig o=4 h=5 a=?
    otrig o=6 h=9 deg=?
    otrig deg=45 a=10 h=?
    otrig rad=0.5 h=8 o=?

Variables:
    o      opposite side
    a      adjacent side
    h      hypotenuse
    deg    angle in degrees
    rad    angle in radians

Rules:
    - Exactly one value must be ?
    - Provide enough information to solve a right triangle
    - Use either deg or rad for angles
`,
	)
}
