import Foundation


struct Day11 {
    
    func solution1(_ input: String) -> Int {
        let monkeyInputs = parse(input: input)
        
        var monkeys = monkeyInputs.map { Monkey(from: $0) }
        
        for round in 0..<20{
            for (i, _) in monkeys.enumerated() {
                
                while (monkeys[i].items.count > 0) {
                    let (item, nextMonkeyIndex) = monkeys[i].inspectNextItem()
                    guard let item = item, let index = nextMonkeyIndex else { continue }
                    monkeys[index].grabNewItem(item)
                }
            }
            
            print("After round \(round)")
            for (i, m) in monkeys.enumerated() {
                print("Monkey \(i): \(m.items)")
            }
        }
        
        
        let activeMonkeys = monkeys.sorted(by: {
            $0.inspectionCounter > $1.inspectionCounter
        })
        
        return activeMonkeys[0].inspectionCounter * activeMonkeys[1].inspectionCounter
    }
    
    func solution2(_ input: String) -> Int {
        // with help from reddit: https://www.reddit.com/r/adventofcode/comments/zihouc/comment/izrimjo/?utm_source=share&utm_medium=web2x&context=3
        let monkeyInputs = parse(input: input)
        
        var monkeys = monkeyInputs.map { Monkey(from: $0) }
        
        let commonNumber = monkeys.reduce(1, { $0 * $1.testNumber})
        for (i, _) in monkeys.enumerated() {
            monkeys[i].commonTestNumber = commonNumber
        }
        
        for round in 0..<10000{
            for (i, _) in monkeys.enumerated() {
                
                while (monkeys[i].items.count > 0) {
                    let (item, nextMonkeyIndex) = monkeys[i].ispectAndNotGetBored()
                    guard let item = item, let index = nextMonkeyIndex else { continue }
                    monkeys[index].grabNewItem(item)
                }
            }
        }
        
        
        let activeMonkeys = monkeys.sorted(by: {
            $0.inspectionCounter > $1.inspectionCounter
        })
        
        return activeMonkeys[0].inspectionCounter * activeMonkeys[1].inspectionCounter
    }
    
    func parse(input: String) -> [String] {
        
        var monkeys = [String]()
        
        var buffer = ""
        
        input.enumerateLines(invoking: { line, _ in
            if line.starts(with: "Monkey ") {
                if !buffer.isEmpty {
                    monkeys.append(String(buffer.split(separator: "\n").filter{!$0.isEmpty}.joined(separator: "\n")))
                }
                buffer = ""
            } else {
                buffer.append("\n")
                buffer.append(line.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        })
        
        monkeys.append(String(buffer.split(separator: "\n").filter{!$0.isEmpty}.joined(separator: "\n")))
        
        return monkeys
    }
    
}

struct Monkey {
    var items: Queue<Int>
    let testNumber: Int
    let monkeyWhenTrue: Int
    let monkeyWhenFalse: Int
    
    let operation: Operation
    let inputA: OperationInput
    let inputB: OperationInput
    
    var commonTestNumber: Int?
    
    var inspectionCounter:Int = 0
    
    init(from input: String) {
        // parse input
        let inputLines = input.split(separator: "\n").map { String($0) }
        
        let colonIndex = inputLines[0].firstIndex(of: ":")!
        let numbers = String(inputLines[0][inputLines[0].index(colonIndex, offsetBy: 2)..<inputLines[0].endIndex])
            .trimmingCharacters(in: .whitespaces)
            .split(separator: ", ")
            .map { Int(String($0))! }
        
        let equalsIndex = inputLines[1].firstIndex(of: "=")!
        let operationComponents = String(inputLines[1][inputLines[1].index(equalsIndex, offsetBy: 2)..<inputLines[1].endIndex])
            .trimmingCharacters(in: .whitespaces)
            .split(separator: " ")
            .map { String($0) }
        
        self.items = Queue(numbers)
        self.operation = Operation(rawValue: operationComponents[1])!
        self.inputA = operationComponents[0] == "old" ? .old : .cosnt(val: Int(operationComponents[0])!)
        self.inputB = operationComponents[2] == "old" ? .old : .cosnt(val: Int(operationComponents[2])!)
        self.testNumber = Int(inputLines[2].split(separator: " ").last!)!
        self.monkeyWhenTrue = Int(inputLines[3].split(separator: " ").last!)!
        self.monkeyWhenFalse = Int(inputLines[4].split(separator: " ").last!)!
    }
    
    mutating func grabNewItem(_ item: Int) {
        items.enqueue(item)
    }
    
    mutating func inspectNextItem() -> (Int?, Int?) {
        guard var inspectionItem = items.dequeue() else {
            //no items to play
            return (nil, nil)
        }
        inspectionCounter += 1
        
        inspectionItem = inspect(inspectionItem)
        inspectionItem = inspectionItem / 3
        
        if inspectionItem % testNumber == 0 {
            return (inspectionItem, monkeyWhenTrue)
        } else {
            return (inspectionItem, monkeyWhenFalse)
        }
    }
    
    
    mutating func ispectAndNotGetBored() -> (Int?, Int?) {
        guard let commonTestNumber = commonTestNumber else {
            fatalError("common test number not set!")
        }
        guard var inspectionItem = items.dequeue() else {
            //no items to play
            return (nil, nil)
        }
        inspectionCounter += 1
        
        inspectionItem = inspect(inspectionItem)
        inspectionItem = inspectionItem % commonTestNumber
        
        if inspectionItem % testNumber == 0 {
            return (inspectionItem, monkeyWhenTrue)
        } else {
            return (inspectionItem, monkeyWhenFalse)
        }
    }
    
    private func inspect(_ item: Int) -> Int {
        
        let a: Int
        switch inputA {
        case .cosnt(let val):
            a = val
        case .old:
            a = item
        }
        
        let b: Int
        switch inputB {
        case .cosnt(let val):
            b = val
        case .old:
            b = item
        }
        
        switch operation {
        case .add:
             return a + b
        case .multiply:
            return a * b
        }
        
    }
}

enum OperationInput {
    case cosnt(val: Int)
    case old
}

enum Operation: String {
    case add = "+"
    case multiply = "*"
}


struct Queue<T> {
    private var queue: [T] = []
    
    init() {
        
    }
    
    init(_ items: [T]) {
        for item in items {
            enqueue(item)
        }
    }
    
    mutating func enqueue(_ item: T) {
        queue.append(item)
    }
    
    mutating func dequeue() -> T? {
        
        guard !queue.isEmpty else {
            return nil
        }
        
        return queue.removeFirst()
    }
    
    var count: Int {
        queue.count
    }
}
