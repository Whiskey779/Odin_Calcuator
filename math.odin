package main

import "core:math"


GetSin :: proc(num: f32) -> f32 {
	return math.sin(math.to_radians(num))
}

GetCos :: proc(num: f32) -> f32 {
	return math.cos(math.to_radians(num))
}

GetTan :: proc(num: f32) -> f32 {
	return math.tan(math.to_radians(num))
}
