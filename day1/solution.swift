#!/usr/bin/swift sh
import Foundation

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let inventories = rawInput.split(separator: "\n\n")
let itemizedInventories = inventories.map {
    $0.split(separator: "\n").map { Int($0)! }.reduce(0, +)
}.sorted(by: >)

let mostCaloriesCount = itemizedInventories.first!
print("Part one: \(mostCaloriesCount)")

let threeMostCaloriesCount = itemizedInventories[0...2].reduce(0, +)
print("Part two: \(threeMostCaloriesCount)")