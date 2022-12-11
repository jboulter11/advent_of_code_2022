#!/usr/bin/swift sh
import Foundation

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let lines = rawInput.split(separator: "\n")

struct Point: Hashable {
	var x: Int
	var y: Int
}
var tailLocations = Set<Point>()

var rope = Array(repeating: Point(x: 0, y: 0), count: 10)// change count to 2 for part 1

for line in lines {
	let cmd = line.split(separator: " ")
	let direction = cmd[0]
	let count = Int(cmd[1])!
	
	for _ in 0..<count {
		switch direction {
			case "L":
				rope[0].x -= 1
			case "R":
				rope[0].x += 1
			case "U":
				rope[0].y += 1
			case "D":
				rope[0].y -= 1
			default:
				fatalError("no")
		}
		
		for t in 1..<rope.count {
			let h = t-1 // head index = tail index - 1
			let xDist = rope[h].x - rope[t].x
			let yDist = rope[h].y - rope[t].y
			
			// not touching, not cardinal
			if abs(xDist) + abs(yDist) > 2 {
				// diagonal
				rope[t].x += xDist/abs(xDist)
				rope[t].y += yDist/abs(yDist)
			} else {
				// cardinal moves
				rope[t].x += xDist/2
				rope[t].y += yDist/2
			}
		}
		
		// log tail location
		tailLocations.insert(rope[rope.count-1])
	}
}

let partOne = tailLocations.count
print("Part one or two: \(partOne)")
