//

import Foundation

struct Instruction {
    let count: Int
    let fromStack: Int
    let toStack: Int
}


struct Day5 {
        
    func solution1(_ input: String) -> String {
        
        let emptyLineIndex = findFirstEmptyLine(input)
        let stacksStr = String(input[input.startIndex..<emptyLineIndex])
        let instructionsStr = String(input[emptyLineIndex..<input.endIndex])
        
        let stacks = parseStacks(stacksStr)
        let instructions = parseInstructions(instructionsStr)
        
        let result = process(stacks, using: instructions)
        
        return result
    }
    
    func solution2(_ input: String) -> String {
        
        let emptyLineIndex = findFirstEmptyLine(input)
        let stacksStr = String(input[input.startIndex..<emptyLineIndex])
        let instructionsStr = String(input[emptyLineIndex..<input.endIndex])
        
        let stacks = parseStacks(stacksStr)
        let instructions = parseInstructions(instructionsStr)
        
        let result = processMultiple(stacks, using: instructions)
        
        return result
    }
    
    func process(_ stacks: [Stack<String>], using instructions: [Instruction]) -> String {
        
        var stacks = stacks
        
        for instr in instructions {
            for _ in 0..<instr.count {
                stacks[instr.toStack].push(stacks[instr.fromStack].pop())
            }
        }
        
        
        var str = ""
        for stack in stacks {
            str += stack.peek()
        }
        
        return str
        
    }
    
    
    func processMultiple(_ stacks: [Stack<String>], using instructions: [Instruction]) -> String {
        
        var stacks = stacks
//        print(stacks)
        for instr in instructions {
            var tmpStack = Stack<String>()
            for _ in 0..<instr.count {
                tmpStack.push(stacks[instr.fromStack].pop())
            }
            for _ in 0..<instr.count {
                stacks[instr.toStack].push(tmpStack.pop())
            }
            
//            print(stacks)
        }
        
        
        var str = ""
        for stack in stacks {
            str += stack.peek()
        }
        
        return str
        
    }
                                 
                                
    func parseStacks(_ string: String) -> [Stack<String>] {
        
        let inputLines = string.split(separator: "\n").dropLast(1).map { String ($0) } // remove line with numbers
        
        var stacks: [Stack<String>] = []
        
        for line in inputLines {
            var currentIdx = line.startIndex
            var stackIndex = 0
            while currentIdx < line.endIndex {
                let nextIndex = line.index(currentIdx, offsetBy: 3)
                let crate = String(line[currentIdx..<nextIndex])
                
                if stacks.count == stackIndex {
                    stacks.append(Stack())
                }
                
                if crate != "   " {
                    let elem = crate.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                    stacks[stackIndex].add(elem)
                }
                
                if nextIndex != line.endIndex {
                    currentIdx = line.index(nextIndex, offsetBy: 1)
                    stackIndex += 1
                } else {
                    currentIdx = nextIndex // or break?
                }
            }
            
        }
        
        return stacks
    }
    
    func findFirstEmptyLine(_ input: String) -> String.Index {
        var emptyLine: String? = nil
        input.enumerateLines { line, _ in
            if line.isEmpty {
                return
            }
            emptyLine = line
        }
        
        return input.firstIndex(of: emptyLine!.first!)!
    }
    
    func parseInstructions(_ lines: String) -> [Instruction] {
        var instructions = [Instruction]()
        
        lines.enumerateLines { line, _ in
            do {
                let matches = line.matches(of: try Regex(#"\d+"#))
                let instr = Instruction(count: Int(String(line[matches[0].range]))!,
                                        fromStack: Int(String(line[matches[1].range]))!-1,
                                        toStack: Int(String(line[matches[2].range]))!-1)
//                print(instr)
                instructions.append(instr)
            } catch {
                fatalError("error parsing instructions")
            }
        }
        return instructions
    }
    
}

struct Stack<T>: CustomDebugStringConvertible {
    private var items: [T] = []
    
    var count: Int {
        items.count
    }
    
    func peek() -> T {
        guard let topElement = items.first else { fatalError("This stack is empty.") }
        return topElement
    }
    
    mutating func pop() -> T {
        return items.removeFirst()
    }
    
    mutating func push(_ element: T) {
        items.insert(element, at: 0)
    }
    
    mutating func add(_ element: T) {
        items.append(element)
    }
    
    var debugDescription: String {
        items.debugDescription
    }
}
