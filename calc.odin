package main

import "core:fmt"
import "core:strconv"

Triangle :: struct {
	adjacent:   f32,
	opposite:   f32,
	hypotenuse: f32,
	deg:        f32,
	rad:        f32,
}

Defaulat_Triangle :: Triangle {
	opposite   = 0,
	adjacent   = 0,
	hypotenuse = 0,
	deg        = 0,
	rad        = 0,
}

TokenType :: enum {
	Number,
	Equals,
	TriPart,
}

TriParts :: enum {
	Degrees,
	Radians,
	Opposite,
	Adjacent,
	Hypotenuse,
	Null,
}

GetTriPart :: proc(str: string) -> TriParts {
	switch str {
	case "a":
		return TriParts.Adjacent
	case "o":
		return TriParts.Opposite
	case "h":
		return TriParts.Hypotenuse
	case "rad":
		return TriParts.Radians
	case "deg":
		return TriParts.Degrees
	case:
		return TriParts.Null
	}
}

CalculateValueError :: enum {
	Ok,
	TriPartNotRecognised,
	MissingEquales,
	FloatConvertion,
}

InsertValueTri :: proc(tri: ^Triangle, part: TriParts, value: f32) {
	switch part {
	case TriParts.Degrees:
		tri.deg = value
	case TriParts.Radians:
		tri.rad = value
	case TriParts.Adjacent:
		tri.adjacent = value
	case TriParts.Opposite:
		tri.opposite = value
	case TriParts.Hypotenuse:
		tri.hypotenuse = value
	case TriParts.Null:
	}
}

GetMissingValue :: proc(
	input: [dynamic]string,
) -> (
	value: f32,
	message: string,
	error: CalculateValueError,
) {
	trig: Triangle = Defaulat_Triangle
	value = -1
	error = CalculateValueError.Ok
	activeTriPart := TriParts.Null
	expectedToken := TokenType.TriPart
	for token in input {
		if expectedToken == TokenType.TriPart {
			activeTriPart = GetTriPart(token)
			if activeTriPart == TriParts.Null {
				error = CalculateValueError.TriPartNotRecognised
				message = fmt.tprintf("Error: '%s' is not a part of a triangle.", token)
				return
			}
			expectedToken = TokenType.Equals
		} else if expectedToken == TokenType.Equals {
			if token != "=" {
				message = fmt.tprintf("Error: Expected '=' but got '%s'", token)
				error = CalculateValueError.MissingEquales
				return
			}
			expectedToken = TokenType.Number
		} else {
			if token == "?" {
				InsertValueTri(&trig, activeTriPart, -1)
			} else {
				num, ok := strconv.parse_f32(token)
				if !ok {
					message = fmt.tprintf("Error: Can not convert '%s' to float", token)
					error = CalculateValueError.FloatConvertion
					return
				}
				InsertValueTri(&trig, activeTriPart, num)
			}
			expectedToken = TokenType.TriPart
		}
	}
	fmt.println(trig)
	return
}
