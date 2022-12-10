#!/usr/bin/swift sh
import Foundation

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let lines = rawInput.split(separator: "\n")

struct Point: Hashable {
	var x: Int
	var y: Int
}



let partOne = ""
print("Part one: \(partOne)")
