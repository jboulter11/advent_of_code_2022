#!/usr/bin/swift sh
import Foundation

struct Command {
	let cmd: String
	let arg: String
}

extension Sequence where Element == Substring {
	func mapToCommands() -> [Command] {
		self.map { $0.split(separator: " ") }.map { line in
			Command(cmd: String(line[0]), arg: String(line[1]))
		}
	}
}

class Monkey {
	var items: [Int]
	let operation: (Int) -> Int
	let testDivisor: Int
	let trueId: Int
	let falseId: Int
	var count: Int = 0
	
	init(items: [Int], operation: @escaping (Int) -> Int, testDivisor: Int, trueId: Int, falseId: Int) {
		self.items = items
		self.operation = operation
		self.testDivisor = testDivisor
		self.trueId = trueId
		self.falseId = falseId
	}
	
	func test(_ i: Int) -> Bool {
		i % testDivisor == 0
	}
}

func parse(operation: String) -> (Int) -> Int {
	let arr = operation.split(separator: " ")
	switch (arr[0], Int(arr[1])) {
		case ("+", .some(let i)):
		    return { $0 + i }
		case ("*", .some(let i)):
		    return { $0 * i }
		default:
		return { ($0 * $0) }
	}
}


let regex = try! Regex(#".*items: (?<items>[^\n]*).*\n.*Operation: new = old (?<operation>[^\n]*).*\n.*by (?<test>\d*).*\n.*true: throw to monkey (?<trueId>\d*).*\n.*false: throw to monkey (?<falseId>\d*)"#)
let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let monkeys: [Monkey] = rawInput.split(separator: "\n\n").map { 
	let match = $0.firstMatch(of: regex)!
	return Monkey(
		items: (match["items"]!.substring!).split(separator: ", ").map { Int(String($0))! },
		operation: parse(operation: String(match["operation"]!.substring!)),
		testDivisor: Int(match["test"]!.substring!)!,
		trueId: Int(match["trueId"]!.substring!)!,
		falseId: Int(match["falseId"]!.substring!)!
	)
}
let commonDivisor = monkeys.map(\.testDivisor).reduce(1, *)

for round in 1...10_000 {
	print("Start round \(round)")
	for monkey in monkeys {
		while var item = monkey.items.first {
			monkey.items.removeFirst()
			monkey.count += 1
			item = monkey.operation(item)
			item = item % commonDivisor
			if monkey.test(item) {
				monkeys[monkey.trueId].items.append(item)
			} else {
				monkeys[monkey.falseId].items.append(item)
			}
		}
	}
}

print(monkeys.map(\.count))
let partOne = monkeys.map(\.count).sorted(by: >)[0...1].reduce(1, *)
print("Part one: \(partOne)")

// I hate math