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

CalcPartOfTriangleReturnValues :: enum {
	NoMissingValue,
	NotANumber,
	NotEoughInfo,
	FoundSideOpposite,
	FoundSideAdjacent,
	FoundSideHypotenuse,
	FoundAngleRad,
	FoundAngleDeg,
	Error,
}

// Calculates the missing triangle value.
//
// Currently supports:
//   - Pythagorean theorem calculations
//
// Planned:
//   - Trigonometric calculations using
//     sin, cos, and tan.
CalcMissingPartOfTriangle :: proc(
	tri: ^Triangle,
) -> (
	value: f32,
	type: CalcPartOfTriangleReturnValues,
) {

	// Ensure there is at least one unknown value.
	if !(tri.adjacent == -1 ||
		   tri.deg == -1 ||
		   tri.hypotenuse == -1 ||
		   tri.opposite == -1 ||
		   tri.rad == -1) {
		return -1, CalcPartOfTriangleReturnValues.NoMissingValue
	}

	// No angle information provided.
	// Use Pythagoras if two sides are known.
	if tri.rad == 0 && tri.deg == 0 {

		if tri.adjacent == 0 || tri.opposite == 0 || tri.hypotenuse == 0 {
			return -1, CalcPartOfTriangleReturnValues.NotEoughInfo
		}

		// Solve hypotenuse.
		if tri.hypotenuse == -1 {
			ans := math.sqrt(tri.adjacent * tri.adjacent + tri.opposite * tri.opposite)
			if math.is_nan(ans) {
				return -1, CalcPartOfTriangleReturnValues.NotANumber
			}
			return ans, CalcPartOfTriangleReturnValues.FoundSideHypotenuse
			// Solve opposite side.
		} else if tri.opposite == -1 {
			ans := math.sqrt(tri.hypotenuse * tri.hypotenuse - tri.adjacent * tri.adjacent)
			if math.is_nan(ans) {
				return -1, CalcPartOfTriangleReturnValues.NotANumber
			}
			return ans, CalcPartOfTriangleReturnValues.FoundSideOpposite

			// Solve adjacent side.
		} else {
			ans := math.sqrt(tri.hypotenuse * tri.hypotenuse - tri.opposite * tri.opposite)
			if math.is_nan(ans) {
				return -1, CalcPartOfTriangleReturnValues.NotANumber
			}
			return ans, CalcPartOfTriangleReturnValues.FoundSideAdjacent
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
					ans := math.asin(tri.opposite / tri.hypotenuse)
					if math.is_nan(ans) {
						return -1, CalcPartOfTriangleReturnValues.NotANumber
					}
					return ans, CalcPartOfTriangleReturnValues.FoundAngleRad
					// Solve for a missing side using radians.
				} else {
					if tri.opposite == -1 {
						ans := math.sin(tri.rad) * tri.hypotenuse
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideOpposite
					} else if tri.hypotenuse == -1 {
						ans := tri.opposite / math.sin(tri.rad)
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideHypotenuse
					}
				}

			} else {

				// Solve for degrees.
				if tri.deg == -1 {
					ans := math.to_degrees(math.asin(tri.opposite / tri.hypotenuse))
					if math.is_nan(ans) {
						return -1, CalcPartOfTriangleReturnValues.NotANumber
					}
					return ans, CalcPartOfTriangleReturnValues.FoundAngleDeg
					// Solve for a missing side using degrees.
				} else {
					if tri.opposite == -1 {
						ans := math.sin(math.to_radians(tri.deg)) * tri.hypotenuse
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideOpposite
					} else if tri.hypotenuse == -1 {
						ans := tri.opposite / math.sin(math.to_radians(tri.deg))
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideHypotenuse
					}
				}
			}

			// Adjacent + Hypotenuse available.
			// Use cosine relationships.
		}
		if tri.adjacent != 0 && tri.hypotenuse != 0 {
			if tri.rad != 0 {
				if tri.rad == -1 {
					ans := math.acos(tri.adjacent / tri.hypotenuse)
					if math.is_nan(ans) {
						return -1, CalcPartOfTriangleReturnValues.NotANumber
					}
					return ans, CalcPartOfTriangleReturnValues.FoundAngleRad
				} else {
					if tri.adjacent == -1 {
						ans := math.cos(tri.rad) * tri.hypotenuse
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideAdjacent
					} else if tri.hypotenuse == -1 {
						ans := tri.adjacent / math.cos(tri.rad)
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideHypotenuse
					}
				}
			} else {
				if tri.deg == -1 {
					ans := math.to_degrees(math.acos(tri.adjacent / tri.hypotenuse))
					if math.is_nan(ans) {
						return -1, CalcPartOfTriangleReturnValues.NotANumber
					}
					return ans, CalcPartOfTriangleReturnValues.FoundAngleDeg
				} else {
					if tri.adjacent == -1 {
						ans := math.cos(math.to_radians(tri.deg)) * tri.hypotenuse
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideAdjacent
					} else if tri.hypotenuse == -1 {
						ans := tri.adjacent / math.cos(math.to_radians(tri.deg))
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideHypotenuse
					}
				}
			}
			// Adjacent + Opposite available.
			// Use tangent relationships.
		}
		if tri.adjacent != 0 && tri.opposite != 0 {
			if tri.rad != 0 {
				if tri.rad == -1 {
					ans := math.atan(tri.opposite / tri.adjacent)
					if math.is_nan(ans) {
						return -1, CalcPartOfTriangleReturnValues.NotANumber
					}
					return ans, CalcPartOfTriangleReturnValues.FoundAngleRad
				} else {
					if tri.opposite == -1 {
						ans := math.tan(tri.rad) * tri.adjacent
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideOpposite
					} else if tri.adjacent == -1 {
						ans := tri.opposite / math.tan(tri.rad)
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideAdjacent
					}
				}
			} else {
				if tri.deg == -1 {
					ans := math.to_degrees(math.atan(tri.opposite / tri.adjacent))
					if math.is_nan(ans) {
						return -1, CalcPartOfTriangleReturnValues.NotANumber
					}
					return ans, CalcPartOfTriangleReturnValues.FoundAngleDeg
				} else {
					if tri.opposite == -1 {
						ans := math.tan(math.to_radians(tri.deg)) * tri.adjacent
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideOpposite
					} else if tri.adjacent == -1 {
						ans := tri.opposite / math.tan(math.to_radians(tri.deg))
						if math.is_nan(ans) {
							return -1, CalcPartOfTriangleReturnValues.NotANumber
						}
						return ans, CalcPartOfTriangleReturnValues.FoundSideAdjacent
					}
				}
			}
		}
	}

	return -1, CalcPartOfTriangleReturnValues.Error
}

// Parses input tokens and calculates the missing value.
//
// Example:
//   a = 3 o = 4 h = ?
//
// Returns:
//   value   -> calculated answer
//   message -> error description
//   ok      -> did it succeed
GetMissingValue :: proc(input: []string) -> (value: f32, message: string, ok: bool) {
	trig: Triangle = Default_Triangle

	value = -1
	ok = true

	activeTriPart := TriParts.Null

	// Begin parser expecting a triangle component.
	expectedToken := TokenType.TriPart

	for token in input {

		// Read component name.
		if expectedToken == TokenType.TriPart {

			activeTriPart = GetTriPart(token)

			if activeTriPart == TriParts.Null {
				ok = false
				message = fmt.tprintf("Error: '%s' is not a part of a triangle.", token)
				return
			}

			expectedToken = TokenType.Equals

			// Read '='.
		} else if expectedToken == TokenType.Equals {

			if token != "=" {
				message = fmt.tprintf("Error: Expected '=' but got '%s'", token)
				ok = false
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
				num, err := strconv.parse_f32(token)

				if !err {
					message = fmt.tprintf("Error: Can not convert '%s' to float", token)
					ok = false
					return
				}

				if num <= 0 {
					ok = false
					message = "Error: input value must be bigger than zero"
					return
				}

				InsertValueTri(&trig, activeTriPart, num)
			}

			// Begin reading the next triangle component.
			expectedToken = TokenType.TriPart
		}
	}

	// Attempt to solve the triangle.
	ans, type := CalcMissingPartOfTriangle(&trig)

	switch type {
	case CalcPartOfTriangleReturnValues.NoMissingValue:
		message = "Error: No missing part to find. Please define one with '?'"
		ok = false
	case CalcPartOfTriangleReturnValues.NotEoughInfo:
		ok = false
		message = "Error: Not enough info to find the part you are looking for"
	case CalcPartOfTriangleReturnValues.Error:
		ok = false
		message = "Error: Faild to find missing side"
	case CalcPartOfTriangleReturnValues.NotANumber:
		ok = false
		message = "Error: Please make sure that the triangle is posible. (hint: make sure the hypotenues is bigger than the opposite and adjacent)"
	case CalcPartOfTriangleReturnValues.FoundSideOpposite:
		value = ans
		message = "The opposite side is equal to"
	case CalcPartOfTriangleReturnValues.FoundSideAdjacent:
		value = ans
		message = "The adjacent side is equal to"
	case CalcPartOfTriangleReturnValues.FoundSideHypotenuse:
		value = ans
		message = "The hypotenuse side is equal to"
	case CalcPartOfTriangleReturnValues.FoundAngleRad:
		value = ans
		message = "The main angle of this triangle in radians is"
	case CalcPartOfTriangleReturnValues.FoundAngleDeg:
		value = ans
		message = "The main angle of this triangle in degrees is"
	}

	return
}
