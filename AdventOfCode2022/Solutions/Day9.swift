//

import Foundation


struct Day9 {
    
    func solution1(_ input: String) -> Int {
        
        var rope = Rope(startPosition: Position(x: 0, y: 0))
        
        var tailPositions = Set<Position>()
        tailPositions.insert(rope.tail)
        
        input.enumerateLines { line, _ in
            let args = line.split(separator: " ").map { String($0) }
            let direction = args[0]
            let count = Int(args[1])!
            
            for _ in 0..<count {
                switch direction {
                case "U":
                    rope.moveHeadTo(rope.head.up())
                case "D":
                    rope.moveHeadTo(rope.head.down())
                case "L":
                    rope.moveHeadTo(rope.head.left())
                case "R":
                    rope.moveHeadTo(rope.head.right())
                default:
                    fatalError("invalid direction \(direction)")
                }
                
                tailPositions.insert(rope.tail)
//                print(rope)
            }
            
        }
        
        return tailPositions.count
    }
    
    
    func solution2(_ input: String) -> Int {
        
        var rope = BigRope(startPosition: Position(x: 0, y: 0))
        
        var tailPositions = Set<Position>()
        tailPositions.insert(rope.tail)
        
        input.enumerateLines { line, _ in
            let args = line.split(separator: " ").map { String($0) }
            let direction = args[0]
            let count = Int(args[1])!
            
            for _ in 0..<count {
                switch direction {
                case "U":
                    rope.moveHeadTo(rope.head.up())
                case "D":
                    rope.moveHeadTo(rope.head.down())
                case "L":
                    rope.moveHeadTo(rope.head.left())
                case "R":
                    rope.moveHeadTo(rope.head.right())
                default:
                    fatalError("invalid direction \(direction)")
                }
                
                tailPositions.insert(rope.tail)
//                print(rope)
            }
            
        }
        
        return tailPositions.count
    }
    
}


struct Position: Hashable, Equatable, CustomStringConvertible {
    
    var description: String {
        "[\(x), \(y)]"
    }
    
    let x: Int
    let y: Int
    
    func isAdjacentTo(_ position: Position) -> Bool {
        return (x == position.x && y == position.y) || (abs(x - position.x) <= 1 && abs(y - position.y) <= 1)
    }
    
    func up() -> Position {
        return Position(x:x,y:y+1)
    }
    
    func down() -> Position {
        return Position(x: x, y: y-1)
    }
    
    func left() -> Position {
        return Position(x: x-1,y: y)
    }
    func right() -> Position {
        return Position(x: x+1,y: y)
    }
}

struct Rope: CustomStringConvertible {
    
    var description: String {
        "{\(head),\(tail)}"
    }
    
    var head: Position {
        didSet {
            updateTailPosition()
        }
    }
    var tail: Position
    
    init(startPosition: Position) {
        head = startPosition
        tail = startPosition
    }
    
    mutating func moveHeadTo(_ position: Position) {
        head = position
    }
    
    private mutating func updateTailPosition() {
        if tail.isAdjacentTo(head) {
            return
        }
        
        let newTailPosition: Position
        if head.x == tail.x {
            let signum = (head.y-tail.y).signum()
            newTailPosition = Position(x: tail.x, y: tail.y + signum)
        } else if head.y == tail.y {
            let signum = (head.x-tail.x).signum()
            newTailPosition = Position(x: tail.x + signum, y: tail.y)
        } else {
            let signumX = (head.x-tail.x).signum()
            let signumY = (head.y-tail.y).signum()
            newTailPosition = Position(x: tail.x + signumX, y: tail.y + signumY)
        }
        tail = newTailPosition
    }
}


struct BigRope {
    
    var knots: [Position]
    
    var tail: Position {
        knots.last!
    }
    
    var head: Position {
        knots.first!
    }
    
    init(startPosition: Position) {
        knots = Array(repeating: Position(x:0, y:0), count: 10)
    }
    
    mutating func moveHeadTo(_ position: Position) {
        knots[0] = position
        updateKnotsPosition()
    }
    
    private mutating func updateKnotsPosition() {
        
        for i in 1..<knots.count {
            if knots[i].isAdjacentTo(knots[i-1]) {
                return
            }
            
            let head = knots[i-1]
            let tail = knots[i]
            
            let newKnotPosition: Position
            if head.x == tail.x {
                let signum = (head.y-tail.y).signum()
                newKnotPosition = Position(x: tail.x, y: tail.y + signum)
            } else if head.y == tail.y {
                let signum = (head.x-tail.x).signum()
                newKnotPosition = Position(x: tail.x + signum, y: tail.y)
            } else {
                let signumX = (head.x-tail.x).signum()
                let signumY = (head.y-tail.y).signum()
                newKnotPosition = Position(x: tail.x + signumX, y: tail.y + signumY)
            }
            knots[i] = newKnotPosition
        }
        
        
        
        
    }
}
