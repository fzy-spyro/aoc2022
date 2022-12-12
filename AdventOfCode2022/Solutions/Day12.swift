import Foundation


struct Day12 {
    
    func solution1(_ input: String) -> Int {
        
        let heightMap = parse(input)
        let startNode = heightMap.startNode
        let endNode = heightMap.endNode
        
        let distance = heightMap.findShortestPath(from: startNode, to: endNode)
        return distance
    }
    
    
    func solution2(_ input: String) -> Int {
        
        let heightMap = parse(input)
        let endNode = heightMap.endNode
        
        var paths: [MapNode: Int] = [:]
        
        for startNode in heightMap.lowestNodes {
            let dist = heightMap.findShortestPath(from: startNode, to: endNode)
            paths[startNode] = dist
        }
        
        return paths.values.filter { $0 != -1 }.sorted().first!
        
    }
    
    func parse(_ input: String) -> HeightMap {
        var mapRows = [[MapNode]]()

        let map = input.split(separator: "\n").map { String($0).split(separator: "").map { String($0) } }
        
        for (i, row) in map.enumerated() {
            var nodeRow = [MapNode]()
            for (j, val) in row.enumerated() {
                let id = row.count * i + j
                nodeRow.append(MapNode(height: val, x: i, y: j, id: id))
            }
            mapRows.append(nodeRow)
        }
        
        return HeightMap(nodes: mapRows)

    }
    
}


struct HeightMap {
    let nodes: [[MapNode]]
    
    var startNode: MapNode {
        for nodeRow in nodes {
            for node in nodeRow {
                if node.isStartNode {
                    return node
                }
            }
        }
        
        fatalError("no start node!")
    }
    
    var endNode: MapNode {
        for nodeRow in nodes {
            for node in nodeRow {
                if node.isEndNode {
                    return node
                }
            }
        }
        
        fatalError("no end node!")
    }
    
    var lowestNodes: [MapNode] {
        var lowNodes = [MapNode]()
        for nodeRow in nodes {
            for node in nodeRow {
                if node.isStartNode || node.height == "a" {
                    lowNodes.append(node)
                }
            }
        }
        return lowNodes
    }
    
    func findShortestPath(from fromNode: MapNode, to toNode: MapNode) -> Int {
        
        var nodesToVisit: Queue<MapNode> = Queue()
        var distances = Array(repeating: -1, count: nodes.count * nodes[0].count)
        
        nodesToVisit.enqueue(fromNode)
        distances[fromNode.id] = 0
        
        while !nodesToVisit.isEmpty {
            
            let node = nodesToVisit.dequeue()!
            
            for neighbour in getAllowedNodesFor(node) {
                if distances[neighbour.id] == -1 {
                    distances[neighbour.id] = distances[node.id] + 1
                    nodesToVisit.enqueue(neighbour)
                }
            }
            
        }
        
        return distances[toNode.id]
    }
    
    
    func getAllowedNodesFor(_ node: MapNode) -> [MapNode] {
        var neighbours = [MapNode]()
        let x = node.x
        let y = node.y
        
        //up
        let prevRow = x-1
        
        if prevRow >= 0, nodes[prevRow][y].intrinsicHeight - nodes[x][y].intrinsicHeight <= 1 {
            neighbours.append(nodes[prevRow][y])
        }
        
        //down
        let nextRow = x+1
        if nextRow < nodes.count, nodes[nextRow][y].intrinsicHeight - nodes[x][y].intrinsicHeight <= 1 {
            neighbours.append(nodes[nextRow][y])
        }
        
        // left
        let prevCol = y-1
        if prevCol >= 0, nodes[x][prevCol].intrinsicHeight - nodes[x][y].intrinsicHeight <= 1 {
            neighbours.append(nodes[x][prevCol])
        }
        
        //right
        let nextCol = y+1
        if nextCol < nodes[x].count, nodes[x][nextCol].intrinsicHeight - nodes[x][y].intrinsicHeight <= 1 {
            neighbours.append(nodes[x][nextCol])
        }
        
        return neighbours
    }
}


struct MapNode: Hashable, Identifiable {
    let height: String
    let x: Int
    let y: Int
    let id: Int

    var isStartNode: Bool {
        height == "S"
    }
    
    var isEndNode: Bool {
        height == "E"
    }
    
    var intrinsicHeight: Int {
        if height == "S" {
            return Int("a"[0].asciiValue!)
        }
        
        if height == "E" {
            return Int("z"[0].asciiValue!)
        }
        
        return Int(height[0].asciiValue!)
    }
}


extension Queue {
    var isEmpty: Bool {
        count == 0
    }
}
