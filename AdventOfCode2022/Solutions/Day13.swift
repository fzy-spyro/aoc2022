//

import Foundation


struct Day13 {
    
    func solution1(_ input: String) throws -> Int {
        
        let inputPairs = parse(input)
        
        var sum = 0
//        print("no of pairs: ", inputPairs.count)
        print(inputPairs.last!)
        for (index, pair) in inputPairs.enumerated() {
            let lhs = try Packet.createFrom(pair.0)
            let rhs = try Packet.createFrom(pair.1)
            
            if lhs < rhs {
                sum += (index+1)
            }
            
        }
        
        return sum
    }
    
    func solution2(_ input: String) throws -> Int {
        
        var inputPairs = try parse(input)
            .flatMap { [$0.0, $0.1] }
            .map(Packet.createFrom)

        let twoPacket = try Packet.createFrom("[[2]]")
        let sixPacket = try Packet.createFrom("[[6]]")
        
        print("num of paris", inputPairs.count)
        
        inputPairs.append(twoPacket)
        inputPairs.append(sixPacket)
        
        let sorted = inputPairs.sorted()
                
                
        return (sorted.firstIndex(of: twoPacket)!+1) * (sorted.firstIndex(of: sixPacket)!+1)
    }
    
    
    func parse(_ input: String) -> [(String, String)] {
        var pairs = [(String, String)]()
        
        var l1 = ""
        var l2 = ""
        
        input.enumerateLines(invoking: { line, _ in
            if line.isEmpty {
                pairs.append((l1, l2))
                l1 = ""
                l2 = ""
            } else {
                if l1.isEmpty {
                    l1 = line
                } else {
                    l2 = line
                }
            }
        })
        
        pairs.append((l1, l2)) // FUUUU......
        
        return pairs
    }
}

func isInOrder(_ lhs: Any, _ rhs: Any) -> Int {
    
    if let left = lhs as? Int, let right = rhs as? Int {
        return left - right
    } else if let left = lhs as? [Any], let right = rhs as? [Any] {
        
        let min = min(left.count, right.count)
        
        for i in 0..<min {
            let l = left[i]
            let r = right[i]
            
            let res = isInOrder(l, r)
            if res != 0 {
                return res
            }
        }
        
        return left.count - right.count
        
    } else if let left = lhs as? Int, let right = rhs as? [Any]  {
        return isInOrder([left], right)
    } else {
        return isInOrder(lhs as! [Any], [rhs])
    }
    
}

struct Packet: Comparable {

    static func == (lhs: Packet, rhs: Packet) -> Bool {
        return lhs.str == rhs.str
    }
    
    let data: [Any]
    let str: String
    
    static func createFrom(_ string: String) throws -> Packet {
        let array = try JSONSerialization.jsonObject(with: string.data(using: .utf8)!)
        return Packet(data: array as! [Any], str: string)
    }
    
    static func < (lhs: Packet, rhs: Packet) -> Bool {
        return isInOrder(lhs.data, rhs.data) < 0
    }

}
