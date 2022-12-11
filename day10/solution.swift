#!/usr/bin/swift sh
import Foundation

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
var lines = rawInput.split(separator: "\n")


let readCycles = [20, 60, 100, 140, 180, 220]
var readValues = [Int]()
func isReadCycle(n: Int) -> Bool {
	return (n - 20) % 40 == 0
}

var instruction: (cmd: String, arg: Int)?
var clock = 1
var reg = 1
var wait = 0
while lines.count > 0 || instruction != nil {
//	print("beginning clock cycle \(clock)")
	if instruction == nil {
		instruction = parseNextInstruction()
		prep(instruction: instruction!)
	}
	
	// reading during cycle
	renderPixel()
	if readCycles.contains(clock) {
//		print("reading \(clock) * \(reg) == \(clock*reg)")
		readValues.append(clock * reg)
	}
	
//	print("cycle \(clock) ends")
	wait -= 1
	clock += 1
	if wait == 0 {
//		print("completing instruction \(instruction!)")
		complete(instruction: instruction!)
		instruction = nil
	}
	
}

func parseNextInstruction() -> (cmd: String, arg: Int) {
	let line = lines.removeFirst().split(separator: " ")
	return (String(line[0]), line.count == 2 ? Int(String(line[1]))! : 0)
}

func prep(instruction: (cmd: String, arg: Int)) {
	if instruction.cmd == "addx" {
		wait = 2
	} else {
		wait = 1
	}
}

func renderPixel() {
	let charToPrint: String
	let modifiedClock = clock % 40
	if abs(modifiedClock - reg) <= 2 && modifiedClock - reg >= 0 {
		charToPrint = "#"
	} else {
		charToPrint = "."
	}
	print(charToPrint, terminator: modifiedClock == 0  ? "\n" : "")
}

func complete(instruction: (cmd: String, arg: Int)) {
	if instruction.cmd == "addx" {
		reg += instruction.arg
	} else {
		// no op
	}
}

let partOne = readValues.reduce(0, +)
print("Part one: \(partOne)")