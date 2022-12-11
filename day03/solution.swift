#!/usr/bin/swift sh
import Foundation

extension Int {
	func convertToPriority() -> Int {
		return self > 90 ? self - 96 : self - 64 + 26
	}
}

extension String {
	func splitInHalf() -> (String, String) {
		let firstHalfRange = self.startIndex..<self.index(self.startIndex, offsetBy: self.count / 2)
		let secondHalfRange = self.index(self.startIndex, offsetBy: self.count / 2)..<self.endIndex
		return (String(self[firstHalfRange]), String(self[secondHalfRange]))
	}
}

extension Array {
	func grouped(size: Int) -> Array<Array<Element>> {
		var groups = [[Element]]()
		for i in stride(from: 0, to: self.count, by: size) {
			groups.append(Array(self[i..<i+size]))
		}
		return groups
	}
}

extension Sequence where Element == Character {
	func reduceToPrioritySum() -> Int {
		self.map { Int($0.asciiValue!).convertToPriority() }.reduce(0, +)
	}
}

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let rucksacks = rawInput.split(separator: "\n")

let intersectingPrioritySum = rucksacks.map { sack -> Int in
	let (firstHalf, secondHalf) = String(sack).splitInHalf()
	
	let intersection = Set<Character>(firstHalf).intersection(Set<Character>(secondHalf))
	
	return intersection.reduceToPrioritySum()
}.reduce(0, +)

print("Part one: \(intersectingPrioritySum)")

let intersectingTripletPrioriySum = rucksacks.grouped(size: 3).map { triplet -> Int in
	let a = Set<Character>(triplet[0])
	let b = Set<Character>(triplet[1])
	let c = Set<Character>(triplet[2])
	
	let intersection = a.intersection(b).intersection(c)
	return intersection.reduceToPrioritySum()
}.reduce(0, +)

print("Part two: \(intersectingTripletPrioriySum)")