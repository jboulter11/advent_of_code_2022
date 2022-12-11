#!/usr/bin/swift sh
import Foundation

enum FileType {
	case folder
	case file
}

class FileEntry {
	var parent: FileEntry?
	var children: [String:FileEntry] = [:]
	var fileType: FileType
	var name: String
	var size: Int?
	
	init(_ fileType: FileType, parent: FileEntry?, name: String, size: Int? = nil) {
		self.parent = parent
		self.fileType = fileType
		self.name = name
		self.size = size
	}
	
	lazy var recursiveSize: Int = {
		switch fileType {
			case .folder:
			return children.map { $0.value.recursiveSize }.reduce(0, +)
			case .file:
			return size!
		}
	}()
}

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let lines = rawInput.split(separator: "\n")

let cdRegex = try! Regex("cd (?<arg>.*)")
let fileRegex = try! Regex(#"(?<size>\d+) (?<fileName>.*)"#)

var root = FileEntry(.folder, parent: nil, name: "/")
var cwd = root
for line in lines[1...] {
	print(line)
	if let match = line.firstMatch(of: cdRegex) {
		let arg = String(match["arg"]!.substring!)
		if arg == ".." {
			cwd = cwd.parent!
		} else {
			if cwd.children[arg] == nil {
				cwd.children[arg] = FileEntry(.folder, parent: cwd, name: arg)
			}
			cwd = cwd.children[arg]!
		}
		continue
	}
	
	if let match = line.firstMatch(of: fileRegex) {
		let size = Int(String(match["size"]!.substring!))!
		let name = String(match["fileName"]!.substring!)
		cwd.children[name] = cwd.children[name] ?? FileEntry(.file, parent: cwd, name: name, size: size)
	}
}

func sumRecursiveSmallDirs(entry: FileEntry) -> Int {
	let childrenRecursiveSize = 
		entry.children
		.filter { $0.value.fileType == .folder }
		.map { sumRecursiveSmallDirs(entry: $0.value) }
		.reduce(0, +)
		
	if entry.recursiveSize <= 100_000 {
		return entry.recursiveSize + childrenRecursiveSize
	} else if entry.recursiveSize > 100_000 {
		return childrenRecursiveSize
	}
	fatalError("what")
}

let partOne = sumRecursiveSmallDirs(entry: root)
print("Part one: \(partOne)")

func findSmallestDirectory(largerThan minSize: Int, in entry: FileEntry) -> FileEntry? {
	if entry.fileType == .file { return nil }
	if entry.recursiveSize < minSize { return nil }
	
	let minChildDirLargerThanMinSize = 
		entry.children
			.map(\.value)
			.filter { $0.recursiveSize > minSize }
			.compactMap { findSmallestDirectory(largerThan: minSize, in: $0) }
			.min { $0.recursiveSize < $1.recursiveSize }
		
	if let minChildDirLargerThanMinSize = minChildDirLargerThanMinSize {
		return minChildDirLargerThanMinSize
	}
	return entry
}

let totalSpace = 70_000_000
let updateSize = 30_000_000
let usedSpace = root.recursiveSize
let freeSpace = totalSpace - usedSpace
let neededSpace = updateSize - freeSpace
let partTwo = findSmallestDirectory(largerThan: neededSpace, in: root)!
print("Part two: \(partTwo.name) \(partTwo.recursiveSize)")

// god this one was a mess...