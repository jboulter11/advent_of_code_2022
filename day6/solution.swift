#!/usr/bin/swift sh
import Foundation

extension Sequence where Element == Substring {
	func mapToString() -> [String] {
		return self.map { String($0) }
	}
}

let rawInput = try! String(contentsOf: URL(fileURLWithPath: "./input.txt"), encoding: .utf8)

var window = ""
for (i, char) in rawInput.enumerated() {
	print("window count \(window.count)")
	
	print("appending \(char)")
	window.append(char)
	if window.count < 14 {
		continue
	}
	
	print(window)
	if Set(window).count == 14 {
		print("Part one: \(i+1)")
		break
	}
	
	if window.count == 14 {
		window.removeFirst()
	}
}