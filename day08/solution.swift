#!/usr/bin/swift sh
import Foundation

extension Sequence where Element == Substring {
	func mapToString() -> [String] {
		return self.map { String($0) }
	}
}

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let lines = rawInput.split(separator: "\n")
var grid = lines.map { $0.map { Int(String($0))! } }

var minX = 0
var minY = 0
var maxX = grid.count - 1
var maxY = grid[0].count - 1

struct Point: Hashable {
	let x: Int
	let y: Int
}
var visible = Set<Point>()

// top -> bottom
for i in minX...maxX {
	var maxZInRow = -1
	for j in minY...maxY {
		if grid[i][j] > maxZInRow {
			visible.insert(Point(x: i, y: j))
			maxZInRow = grid[i][j]
		}
	}
}

// bottom -> top
for i in (minX...maxX).reversed() {
	var maxZInRow = -1
	for j in (minY...maxY).reversed() {
		if grid[i][j] > maxZInRow {
			visible.insert(Point(x: i, y: j))
			maxZInRow = grid[i][j]
		}
	}
}

// left -> right
for i in minY...maxY {
	var maxZInCol = -1
	for j in minX...maxX {
		if grid[j][i] > maxZInCol {
			visible.insert(Point(x: j, y: i))
			maxZInCol = grid[j][i]
		}
	}
}

// right -> left
for i in (minY...maxY).reversed() {
	var maxZInCol = -1
	for j in (minX...maxX).reversed() {
		if grid[j][i] > maxZInCol {
			visible.insert(Point(x: j, y: i))
			maxZInCol = grid[j][i]
		}
	}
}

let partOne = visible.count
print("Part one: \(partOne)")

func getScenicScore(x: Int, y: Int) -> Int {
	var scores = (up:0, down:0, left:0, right:0)
	let z = grid[x][y]
	
	// down
	if x+1 <= maxX {
		for i in x+1...maxX {
			let otherZ = grid[i][y]
			scores.down += 1
			if otherZ >= z {
				break
			}
		}
	}
	
	// up
	if x-1 >= minX {
		for i in (minX...x-1).reversed() {
			let otherZ = grid[i][y]
			scores.up += 1
			if otherZ >= z {
				break
			}
		}
	}
	
	// right
	if y+1 <= maxY {
		for j in (y+1...maxY) {
			let otherZ = grid[x][j]
			scores.right += 1
			if otherZ >= z {
				break
			}
		}
	}
	
	// left
	if y-1 >= minY {
		for j in (minY...y-1).reversed() {
			let otherZ = grid[x][j]
				scores.left += 1
			if otherZ >= z {
				break
			}
		}
	}
	return scores.up * scores.down * scores.left * scores.right
}

var scoreGrid = [[Int]]()
var maxScore = -1
for i in minX...maxX {
	var scoreRow = [Int]()
	for j in minY...maxY {
		let score = getScenicScore(x: i, y: j)
		scoreRow.append(score)
		maxScore = max(score, maxScore)
	}
	scoreGrid.append(scoreRow)
}
print(scoreGrid.map { $0.map { String($0) }.joined(separator: "") }.joined(separator: "\n"))
print("Bullshit part two but the answer it wants: \(maxScore)")

print(grid.count)
print(grid[0].count)
let partTwo = pow(Decimal((grid.count - 1))/2.0, 4) // highest possible score for any tree on map of given size
print("Part two as written: \(partTwo)")