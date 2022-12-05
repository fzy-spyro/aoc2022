//

import Foundation
import Combine

struct Day3 {
    
    func solution1(_ input: String) -> Int {
        
        var sum = 0
        input.enumerateLines { line, _ in
            
            let common = findCommonElement(in: line)
            let priority = findPriority(of: common)
            sum += priority
            
        }
        
        return sum
    }
    
    
    func solution2(_ input: String) -> Int {
        let lines = input.split(separator: "\n").map { String($0) }
        
        var res = 0
        for i in stride(from: 0, to: lines.count, by: 3) {
            let set1 = Set(lines[i])
            let set2 = Set(lines[i+1])
            let set3 = Set(lines[i+2])
            
            let common = set1.intersection(set2).intersection(set3)
            let p = findPriority(of: String(common.first!))
            res += p
        }
        
        return res
        
    }
    
    private func findPriority(of element: String) -> Int {
        let const: Int
        if element[0].isUppercase {
            const = 38
        } else {
            const = 96
        }
        let asciiValue = element[0].unicodeScalars.first!.value
        let prio = Int(asciiValue) - const
        return prio
    }
    
    private func findCommonElement(in line: String) -> String {
        let start = line.startIndex
        let middle = line.index(line.startIndex, offsetBy: line.count/2)
        
        let _1stcompartment = line[start..<middle]
        let _2ndcompartment = line[middle..<line.endIndex]
        
        let charSet = Set(_1stcompartment)
        
        for c in _2ndcompartment {
            if charSet.contains(String(c)) {
                return String(c)
            }
        }
        
        fatalError("no common element")
    }
    
}


extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
