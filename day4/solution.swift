#!/usr/bin/swift sh
import Foundation

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let lines = rawInput.split(separator: "\n").map {String($0)}
let pairLines = lines.map { $0.split(separator: ",").map { String($0) } }

var counter = 0
var counterPartTwo = 0
for pair in pairLines {
	let pairA = pair[0].split(separator: "-").map { String($0) }
	let rangeA: ClosedRange = Int(pairA.first!)!...Int(pairA.last!)!
	
	let pairB = pair[1].split(separator: "-").map { String($0) }
	let rangeB: ClosedRange = Int(pairB.first!)!...Int(pairB.last!)!
	
	print(rangeA)
	print(rangeB)
	print()
	if rangeA.contains(rangeB) || rangeB.contains(rangeA) {
		counter += 1
	}
	
	if rangeA.contains(rangeB.first!) || rangeA.contains(rangeB.last!) || rangeB.contains(rangeA.first!) || rangeB.contains(rangeA.last!) {
		counterPartTwo += 1
	}
}

print(counter)
print(counterPartTwo)