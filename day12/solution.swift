#!/usr/bin/swift sh
import Foundation

extension Character {
	func convertToHeight() -> Int {
		if self == Character("S") { return 1 } // one less than it actually is
		if self == Character("E") { return 26 }
		return Int(self.asciiValue!) - 96 // 1 - 26
	}
}

struct Point {
	var row: Int
	var col: Int
	var z: Int
	
	func getCandidates(map: [[Int]], goingUp: Bool) -> [Point] {
		var candidates = [Point]()
		
		for (i, j) in [(row-1, col), (row+1, col), (row, col-1), (row, col+1)] {
			guard i >= 0, i < map.count, j >= 0, j < map[0].count else { continue }
			
			if goingUp {
				if map[i][j] <= z + 1 { 
					candidates.append(Point(row: i, col: j, z: map[i][j]))
				}
			} else {
				if map[i][j] >= z - 1 { 
					candidates.append(Point(row: i, col: j, z: map[i][j]))
				}
			}
		}
		return candidates
	}
}

struct Step {
	let parent: [Step]
	let point: Point
	let count: Int
}

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let lines = rawInput.split(separator: "\n")
var heightMap = lines.map { $0.map { $0.convertToHeight() } }

let startRow = lines.firstIndex(where: { $0.contains("S") })!
let startCol = lines[startRow].split(separator: "").firstIndex(of: "S")!
let endRow = lines.firstIndex(where: { $0.contains("E") })!
let endCol = lines[endRow].split(separator: "").firstIndex(of: "E")!


let start = Point(row: startRow, col: startCol, z: 1)
let end = Point(row: endRow, col: endCol, z: 26)


func find(start: Point, end:Point?, map: [[Int]]) -> Step {
	var exploredMap = [[Bool]](repeating: [Bool](repeating: false, count: map[0].count), count: map.count)
	let startStep = Step(parent: [], point: start, count: 0)
	exploredMap[start.row][start.col] = true
	
	var queue = [startStep]
	while let step = queue.first {
		print("\(step.point) \(step.count)")
		queue.removeFirst()
		
		// part two
		if end == nil, step.point.z == 1 {
			return step
		}
		
		if step.point.row == end?.row, step.point.col == end?.col {
			return step
		}
		
		let candidates = step.point.getCandidates(map: map, goingUp: end != nil)//.sorted(by: { $0.z > $1.z })
		for next in candidates {
			guard exploredMap[next.row][next.col] == false else { continue }
			exploredMap[next.row][next.col] = true
			queue.append(Step(parent: [step], point: next, count: step.count+1))
		}
	}
	fatalError()
}

let partOne = find(start: start, end: end, map: heightMap)
print("Part one: \(partOne.count)")

var partTwo = find(start: end, end: nil, map: heightMap)
print("Part two: \(partTwo.count)")