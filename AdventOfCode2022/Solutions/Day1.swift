import Foundation
import Combine

enum AdventError: Error {
    case error
}

struct Day1 {
    func solution2(_ data: Data) -> Int {
        let string = String(data: data, encoding: .utf8)
        
        var mostCalories = [Int]()
        var current = 0
        
        string?.enumerateLines { line, _ in
            if line.isEmpty {
                mostCalories.append(current)
                current = 0
            } else {
                let cal = Int(line)!
                current += cal
            }
        }
        
        mostCalories = mostCalories.sorted(by: { $0 > $1 })
        return mostCalories[0] + mostCalories[1] + mostCalories[2]
        
    }
    
    func solution1(_ data: Data) -> Int {
        let string = String(data: data, encoding: .utf8)
        
        var mostCalories = -1
        var current = 0
        string?.enumerateLines { line, _ in
            if line.isEmpty {
                mostCalories = max(mostCalories, current)
                current = 0
            } else {
                let cal = Int(line)!
                current += cal
            }
        }
        return mostCalories
    }

}
