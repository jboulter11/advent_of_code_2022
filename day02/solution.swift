#!/usr/bin/swift sh
import Foundation

enum Play: Int {
	case rock = 1
	case paper = 2
	case scissors = 3
	
	init(string: String) {
		switch string {
			case "A", "X":
				self = .rock
			case "B", "Y":
				self = .paper
			case "C", "Z":
				self = .scissors
			case _:
				fatalError("Play not rock, paper, or scissors")
		}
	}
	
	func matchPoints(against other: Play) -> Int {
		switch(self, other) {
			case (.paper, .rock), (.scissors, .paper), (.rock, .scissors):
				return 6
			case (.paper, .paper), (.rock, .rock), (.scissors, .scissors):
				return 3
			case (_,_):
				return 0
		}
	}
	
	func playThatBeats() -> Play {
		Play(rawValue: self.rawValue + 1) ?? Play(rawValue: 1)!
	}
	
	func playThatLoses() -> Play {
		Play(rawValue: self.rawValue - 1) ?? Play(rawValue: 3)!
	}
	
	func play(for outcome: Outcome) -> Play {
		switch outcome {
			case .lose:
			return self.playThatLoses()
			case .win:
			return self.playThatBeats()
			default:
			return self
		}
	}
}

enum Outcome: Int {
	case lose = 0
	case draw = 3
	case win = 6
	
	init(string: String) {
		switch string {
			case "X":
				self = .lose
			case "Y":
				self = .draw
			case "Z":
				self = .win
			case _:
				fatalError("Outcome invalid")
		}
	}
}

struct Match {
	let opponentPlay: Play
	let playerPlay: Play // part one only
	let outcome: Outcome // part two only
	
	init(stringArray: Array<String>) {
		opponentPlay = Play(string: stringArray.first!)
		playerPlay = Play(string: stringArray.last!)
		outcome = Outcome(string: stringArray.last!)
	}
}

let rawInput = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
let matches = rawInput.split(separator: "\n").map { match in
	let splitStrings = match.split(separator: " ").map { String($0) }
	return Match(stringArray: splitStrings)
}

let partOnePoints = matches.map {
	$0.playerPlay.matchPoints(against: $0.opponentPlay) + $0.playerPlay.rawValue
}.reduce(0, +)
print("Part one: \(partOnePoints)")

let partTwoPoints = matches.map {
	let a = $0.outcome.rawValue + $0.opponentPlay.play(for: $0.outcome).rawValue
	return a
}.reduce(0, +)
print("Part two: \(partTwoPoints)")