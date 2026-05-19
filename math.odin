package main

import "core:math"

// retuns the sin of the input in degrees
GetSin :: proc(num: f32) -> f32 {
	return math.sin(math.to_radians(num))
}

// retuns the cos of the input in degrees
GetCos :: proc(num: f32) -> f32 {
	return math.cos(math.to_radians(num))
}

// retuns the tan of the input in degrees
GetTan :: proc(num: f32) -> f32 {
	return math.tan(math.to_radians(num))
}
