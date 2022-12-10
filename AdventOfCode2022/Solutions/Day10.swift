//

import Foundation


struct Day10 {
    
    enum Instruction: CustomStringConvertible {
        case noop
        case addx(val: Int)
        
        var cycles: Int {
            switch self {
            case .noop:
                return 1
            case .addx:
                return 2
            }
        }
        
        var description: String {
            switch self {
            case .noop:
                return "noop"
            case .addx(let v):
                return "addx \(v)"
            }
        }
        
        static func from(string: String) -> Instruction {
            let args = string.split(separator: " ")
            switch args[0] {
            case "noop": return .noop
            case "addx": return .addx(val: Int(String(args[1]))!)
            default:
                fatalError("Invalid instruction \(args[0])")
            }
        }
    }
    
    struct Computer: CustomStringConvertible {
        
        var description: String {
            "C: \(cycleCount), X: \(X)"
        }
        
        var X: Int = 1
        var cycleCount: Int = 1
        
        mutating func execute(_ instruction: Instruction) {
            if case .addx(let val) = instruction {
                X += val
            }
        }
        
        mutating func tick() {
            cycleCount += 1
        }
    }
    
    struct CRT: CustomStringConvertible {
        var rows: [[String]]
        
        var cycleCount: Int = 0 {
            didSet {
                pixel = cycleCount % 40
                if pixel == 0 {
                    row += 1
                }
            }
        }
        
        var description: String {
            return rows.map {
                "|"+$0.joined()+"|"
            }.joined(separator: "\n")
        }
        
        private var spriteCenter = 1
        private var row = 0
        private var pixel = 0
        
        init() {
            rows = Array(repeating: Array(repeating: " ", count: 40), count: 6)
        }
        
        mutating func tick() {
            cycleCount += 1
        }
        
        mutating func draw() {
            if [spriteCenter-1, spriteCenter, spriteCenter+1].contains(pixel) {
                rows[row][pixel] = "#"
            } else {
                rows[row][pixel] = "."
            }
        }
        
        mutating func updateSprite(_ computer: Computer) {
            spriteCenter = computer.X
        }
        
    }

    
    func solution1(_ input: String) -> Int {
        
        var computer = Computer()
        var instructions = [Instruction]()
        
        input.enumerateLines(invoking: { line, _ in
            instructions.append(.from(string: line))
        })
        
        var nextExecutionTick = computer.cycleCount + instructions[0].cycles
        var instrCounter = 0
        
        var sum = 0
        
        while true {
//            print(computer)
            if [20, 60, 100, 140, 180, 220].contains(computer.cycleCount) {
                sum += computer.cycleCount * computer.X
            }
            
            computer.tick()
            
            if nextExecutionTick == computer.cycleCount {
//                print("executing \(instructions[instrCounter])")
                computer.execute(instructions[instrCounter])
                instrCounter += 1
                
                if instrCounter < instructions.count {
                    nextExecutionTick = computer.cycleCount + instructions[instrCounter].cycles
                } else {
//                    print("all finished")
                    break
                }
            }
            
            
        }
//        print(computer)
        
        return sum
        
    }
    
    func solution2(_ input: String) -> String {
        var computer = Computer()
        var crt = CRT()
        var instructions = [Instruction]()
        
        input.enumerateLines(invoking: { line, _ in
            instructions.append(.from(string: line))
        })
        
        var nextExecutionTick = computer.cycleCount + instructions[0].cycles
        var instrCounter = 0
        
        
        while true {
//            print(crt)
//            print("")
            computer.tick()
            crt.draw()
            crt.tick()
            
            if nextExecutionTick == computer.cycleCount {
                computer.execute(instructions[instrCounter])
                crt.updateSprite(computer)
                instrCounter += 1
                
                if instrCounter < instructions.count {
                    nextExecutionTick = computer.cycleCount + instructions[instrCounter].cycles
                } else {
                    break
                }
            }
        }
        
//        print(" --- final --- ")
//        print(crt)
        
        return crt.description
    }
    
}



