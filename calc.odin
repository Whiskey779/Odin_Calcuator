package main

import "core:fmt"
import "core:math"
import "core:strconv"

// Represents a right triangle.
//
// A value of:
//   0  -> not provided
//  -1  -> the unknown value to solve for
Triangle :: struct {
	adjacent:   f32,
	opposite:   f32,
	hypotenuse: f32,
	deg:        f32,
	rad:        f32,
}

// Default empty triangle.
Default_Triangle :: Triangle {
	opposite   = 0,
	adjacent   = 0,
	hypotenuse = 0,
	deg        = 0,
	rad        = 0,
}

// States used by the input parser.
TokenType :: enum {
	Number,
	Equals,
	TriPart,
}

// Supported triangle components.
TriParts :: enum {
	Degrees,
	Radians,
	Opposite,
	Adjacent,
	Hypotenuse,
	Null,
}

// Converts user input into a triangle component.
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

// Possible parsing/calculation errors.
CalculateValueError :: enum {
	Ok,
	TriPartNotRecognised,
	MissingEquales,
	FloatConvertion,
}

// Inserts a value into the selected triangle field.
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

// Calculates the missing triangle value.
//
// Currently supports:
//   - Pythagorean theorem calculations
//
// Planned:
//   - Trigonometric calculations using
//     sin, cos, and tan.
CalcMissingPartOfTriangle :: proc(tri: ^Triangle) -> (value: f32, ok: bool) {

	// Ensure there is at least one unknown value.
	if !(tri.adjacent == -1 ||
		   tri.deg == -1 ||
		   tri.hypotenuse == -1 ||
		   tri.opposite == -1 ||
		   tri.rad == -1) {
		return -1, false
	}

	// No angle information provided.
	// Use Pythagoras if two sides are known.
	if tri.rad == 0 && tri.deg == 0 {

		if tri.adjacent == 0 || tri.opposite == 0 || tri.hypotenuse == 0 {
			return -1, false
		}

		// Solve hypotenuse.
		if tri.hypotenuse == -1 {
			return math.sqrt(tri.adjacent * tri.adjacent + tri.opposite * tri.opposite), true

			// Solve opposite side.
		} else if tri.opposite == -1 {
			return math.sqrt(tri.hypotenuse * tri.hypotenuse - tri.adjacent * tri.adjacent), true

			// Solve adjacent side.
		} else {
			return math.sqrt(tri.hypotenuse * tri.hypotenuse - tri.opposite * tri.opposite), true
		}

		// Exactly one angle representation exists.
		// (degrees XOR radians)
	} else if (tri.rad == 0) != (tri.deg == 0) {

		// Opposite + Hypotenuse available.
		// Use sine relationships.
		if tri.opposite != 0 && tri.hypotenuse != 0 {

			if tri.rad != 0 {

				// Solve for radians.
				if tri.rad == -1 {

					// Solve for a missing side using radians.
				} else {

				}

			} else {

				// Solve for degrees.
				if tri.deg == -1 {

					// Solve for a missing side using degrees.
				} else {

				}
			}

			// Adjacent + Hypotenuse available.
			// Use cosine relationships.
		} else if tri.adjacent != 0 && tri.hypotenuse != 0 {

			// Adjacent + Opposite available.
			// Use tangent relationships.
		} else if tri.adjacent != 0 && tri.opposite != 0 {

		}
	}

	return -1, false
}

// Parses input tokens and calculates the missing value.
//
// Example:
//   a = 3 o = 4 h = ?
//
// Returns:
//   value   -> calculated answer
//   message -> error description
//   error   -> error code
GetMissingValue :: proc(
	input: [dynamic]string,
) -> (
	value: f32,
	message: string,
	error: CalculateValueError,
) {
	trig: Triangle = Default_Triangle

	value = -1
	error = CalculateValueError.Ok

	activeTriPart := TriParts.Null

	// Begin parser expecting a triangle component.
	expectedToken := TokenType.TriPart

	for token in input {

		// Read component name.
		if expectedToken == TokenType.TriPart {

			activeTriPart = GetTriPart(token)

			if activeTriPart == TriParts.Null {
				error = CalculateValueError.TriPartNotRecognised
				message = fmt.tprintf("Error: '%s' is not a part of a triangle.", token)
				return
			}

			expectedToken = TokenType.Equals

			// Read '='.
		} else if expectedToken == TokenType.Equals {

			if token != "=" {
				message = fmt.tprintf("Error: Expected '=' but got '%s'", token)
				error = CalculateValueError.MissingEquales
				return
			}

			expectedToken = TokenType.Number

			// Read numeric value or '?'.
		} else {

			// Mark this field as the unknown value.
			if token == "?" {

				InsertValueTri(&trig, activeTriPart, -1)

			} else {

				// Convert text to float.
				num, ok := strconv.parse_f32(token)

				if !ok {
					message = fmt.tprintf("Error: Can not convert '%s' to float", token)
					error = CalculateValueError.FloatConvertion
					return
				}

				InsertValueTri(&trig, activeTriPart, num)
			}

			// Begin reading the next triangle component.
			expectedToken = TokenType.TriPart
		}
	}

	// Debug output.
	fmt.println(trig)

	// Attempt to solve the triangle.
	value, _ = CalcMissingPartOfTriangle(&trig)

	return
}
