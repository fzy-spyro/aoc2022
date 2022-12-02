//

import Foundation

struct Day2 {
    
    enum RockPaperScissor {
        case rock
        case paper
        case scissor
        
        var score: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissor: return 3
            }
        }
        
        static func fromString(_ str: String) -> RockPaperScissor {
            if str == "A" || str == "X" {
                return .rock
            }
            
            if str == "B" || str == "Y" {
                return .paper
            }
            
            if str == "C" || str == "Z" {
                return .scissor
            }
            
            fatalError("Invalid input: \(str)")
        }
        
    }
    
    enum ExpecredResult {
        case win
        case loss
        case draw
        
        static func fromString(_ str: String) -> ExpecredResult {
            if str == "X" {
                return .loss
            }
            
            if str == "Y" {
                return .draw
            }
            
            if str == "Z" {
                return .win
            }
            
            fatalError("Invalid input: \(str)")
        }
    }
    
    
    func solution1(_ input: String) -> Int {
        var score: Int = 0
        input.enumerateLines { line, _ in
            let choices = line.split(separator: " ")
            let their = RockPaperScissor.fromString(String(choices[0]))
            let mine = RockPaperScissor.fromString(String(choices[1]))
            
            score += calculateScore(their, mine)
        }
        
        return score
    }
    
    func solution2(_ input: String) -> Int {
        var score: Int = 0
        input.enumerateLines { line, _ in
            let choices = line.split(separator: " ")
            let their = RockPaperScissor.fromString(String(choices[0]))
            let result = ExpecredResult.fromString(String(choices[1]))
            
            score += calculateScoreSolution2(their, expected: result)
        }
        
        return score
    }
    
    private func calculateScore(_ their: RockPaperScissor , _ mine: RockPaperScissor) -> Int {
        let score: Int
        switch mine {
        case .rock:
            switch their {
            case .rock:
                score = 3
            case .paper:
                score = 0
            case .scissor:
                score = 6
            }
        case .paper:
            switch their {
            case .rock:
                score = 6
            case .paper:
                score = 3
            case .scissor:
                score = 0
            }
        case .scissor:
            switch their {
            case .rock:
                score = 0
            case .paper:
                score = 6
            case .scissor:
                score = 3
            }
        }
//        print(their, mine)
        return score + mine.score
    }
    
    private func calculateScoreSolution2(_ their: RockPaperScissor , expected: ExpecredResult) -> Int {
        let mine: RockPaperScissor
        switch their {
        case .rock:
            switch expected {
            case .win:
                mine = .paper
            case .loss:
                mine = .scissor
            case .draw:
                mine = .rock
            }
        case .paper:
            switch expected {
            case .win:
                mine = .scissor
            case .loss:
                mine = .rock
            case .draw:
                mine = .paper
            }
        case .scissor:
            switch expected {
            case .win:
                mine = .rock
            case .loss:
                mine = .paper
            case .draw:
                mine = .scissor
            }
        }
//        print(their, mine)
        return calculateScore(their, mine)
    }
    
}
