//

import Foundation

struct Day8 {
    
    func solution1(_ input: String) -> Int {
        let forest = plantForest(using: input)
        let rows = forest.count
        let cols = forest.first!.count
        var visibleCount = 0
        for i in 0..<rows {
            for j in 0..<cols {
                if isVisible(forest, i, j, rows, cols) {
                    visibleCount += 1
                }
            }
        }
        
        return visibleCount
    }
    
    
    func solution2(_ input: String) -> Int {
        let forest = plantForest(using: input)
    
        let scenicMap = createScenicMap(for: forest)
        
        print(input)
        dump(forest: scenicMap)
        
        let max = scenicMap.map {
            $0.max()!
        }.max()!
        
        return max
    }
    
    func createScenicMap(for forest: [[Int]]) ->[[Int]] {
        let rows = forest.count
        let cols = forest.first!.count
        
        var map = Array(repeating: Array(repeating: 0, count: cols), count: rows)
        
        for i in 1..<rows-1 {
            for j in 1..<cols-1 {
                let beforeTrees = Array(forest[i][0..<j].reversed())
                let afterTrees = Array(forest[i][j+1..<cols])
                let aboveTrees = Array(collectTreesVertically(forest, column: j, start: 0, end: i).reversed())
                let belowTrees = collectTreesVertically(forest, column: j, start: i+1, end: rows)
                
                
                let tree = forest[i][j]
                
                let a: Int
                if let idx = beforeTrees.firstIndex(where: { $0 >= tree }) {
                    a = idx + 1
                } else {
                    a = beforeTrees.count
                }
                
                let b: Int
                if let idx = afterTrees.firstIndex(where: { $0 >= tree }) {
                    b = idx + 1
                } else {
                    b = afterTrees.count
                }
                
                let c: Int
                if let idx = aboveTrees.firstIndex(where: { $0 >= tree }) {
                    c = idx + 1
                } else {
                    c = aboveTrees.count
                }
                
                let d: Int
                if let idx = belowTrees.firstIndex(where: { $0 >= tree }) {
                    d = idx + 1
                } else {
                    d = belowTrees.count
                }
                
                map[i][j] = a*b*c*d
            }
        }
            
        return map
        
    }
    
    func isVisible(_ forest: [[Int]], _ i: Int, _ j: Int, _ rows: Int, _ cols: Int) -> Bool {
        
        if isVisibleHorizontally(forest, i, j, cols) {
            return true
        }
        
        if isVisibleVertically(forest, i, j, rows) {
            return true
        }
        
        return false
        
    }
    
    
    func isVisibleHorizontally(_ forest: [[Int]], _ i: Int, _ j: Int, _ cols: Int) -> Bool {
        let tree = forest[i][j]
        let beforeTreeMax = Array(forest[i][0..<j]).max() ?? -1
        let afterTreeMax = Array(forest[i][j+1..<cols]).max() ?? -1
        
        return tree > beforeTreeMax || tree > afterTreeMax
    }
    
    func isVisibleVertically(_ forest: [[Int]], _ i: Int, _ j: Int, _ rows: Int) -> Bool {
        let tree = forest[i][j]
        let beforeTreeMax = collectTreesVertically(forest, column: j, start: 0, end: i).max() ?? -1
        let afterTreeMax = collectTreesVertically(forest, column: j, start: i+1, end: rows).max() ?? -1
        
        return tree > beforeTreeMax || tree > afterTreeMax
    }
    
    
    func collectTreesVertically(_ forest: [[Int]], column: Int, start: Int, end: Int) -> [Int] {
        
        var trees = [Int]()
        
        for i in start..<end {
            trees.append(forest[i][column])
        }
        
        return trees
        
    }
    
    func plantForest(using input: String) -> [[Int]] {
        return input.split(separator: "\n")
            .map { $0
                .split(separator: "")
            }
            .map {
                $0.map {
                    Int(String($0))!
                }
            }
    }
    
    func dump(forest: [[Int]]) {
        let str = forest.map {
            $0.map { String($0) }.joined()
        }.joined(separator: "\n")
        
        print(str)
    }
}
