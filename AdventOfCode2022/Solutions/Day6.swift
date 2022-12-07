//

import Foundation


struct Day6 {
    
    func solution1(_ input: String) -> Int {
        
        let chars = Array(input).map { String($0) }
        
        var result = 0
        for i in 0..<chars.count - 3 {
            var diffSet = Set<String>()
            diffSet.insert(chars[i])
            diffSet.insert(chars[i+1])
            diffSet.insert(chars[i+2])
            diffSet.insert(chars[i+3])
            
            if diffSet.count == 4 {
                // we have a sequence
                result += 4
                break
            } else {
                result += 1
            }
        }
        return result
        
    }
    
    func solution2(_ input: String) -> Int {
        let diffCharCount = 14
        let chars = Array(input).map { String($0) }
        
        var result = 0
        for i in 0..<(chars.count - diffCharCount - 1) {
            var diffSet = Set<String>()
            
            for j in i..<i+diffCharCount {
                diffSet.insert(chars[j])
            }
        
            if diffSet.count == diffCharCount {
                // we have a sequence
                result += diffCharCount
                break
            } else {
                result += 1
            }
        }
        return result
        
    }

    
}
