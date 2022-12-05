//

import Foundation

struct Day4 {
    
    func solution1(_ input: String) -> Int {
        
        var result = 0
        input.enumerateLines { line, _ in
            let ranges = line.split(separator: ",", maxSplits: 1)
            let lRange = createRange(String(ranges[0]))
            let rRange = createRange(String(ranges[1]))
            
            if (lRange.lowerBound <= rRange.lowerBound && lRange.upperBound >= rRange.upperBound) ||
                (rRange.lowerBound <= lRange.lowerBound && rRange.upperBound >= lRange.upperBound) {
                result += 1
            }
        }
        
        return result
    }
    
    func solution2(_ input: String) -> Int {
        
        var result = 0
        input.enumerateLines { line, _ in
            let ranges = line.split(separator: ",", maxSplits: 1)
            let lRange = createRange(String(ranges[0]))
            let rRange = createRange(String(ranges[1]))
            
            if lRange.contains(rRange.lowerBound) || rRange.contains(lRange.lowerBound) {
                result += 1
            }
            
        }
        
        return result
    }
    
    private func createRange(_ input: String) -> ClosedRange<Int> {
        let ranges = input.split(separator: "-", maxSplits: 1)
        let lower = Int(ranges[0])!
        let upper = Int(ranges[1])!
        return lower...upper
    }
    
}
