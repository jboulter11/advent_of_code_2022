#!/usr/bin/swift sh
import Foundation

extension Sequence where Element == Substring {
	func mapToString() -> [String] {
		return self.map { String($0) }
	}
}

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let rawInstructions = try! String(contentsOf: URL(filePath: "./input_inst.txt"), encoding: .utf8)

var towers = rawInput.split(separator: "\n").mapToString().map { $0.split(separator: "").mapToString() }
var towersPt2 = towers

let instructions = rawInstructions.split(separator: "\n").mapToString().map {
	let line = $0.split(separator: " ")
	return (count: Int(line[1])!, from: Int(line[3])!-1, to: Int(line[5])!-1)
}

for instruction in instructions {
	// part one
	var i = 0
	for crate in towers[instruction.from].reversed() {
		towers[instruction.to].append(crate)
		i += 1
		if i == instruction.count { break }
	}
	towers[instruction.from].removeLast(instruction.count)
	
	// part two
	let crates = Array(towersPt2[instruction.from][(towersPt2[instruction.from].count - instruction.count)..<towersPt2[instruction.from].count])
	towersPt2[instruction.from].removeLast(instruction.count)
	towersPt2[instruction.to].append(contentsOf: crates)
}


let partOne = towers.map { $0.last! }.joined()
print("Part one: \(partOne)")

let partTwo = towersPt2.map { $0.last! }.joined()
print("Part two: \(partTwo)")