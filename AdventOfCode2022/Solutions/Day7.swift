//

import Foundation


struct Day7 {
    
    
    func solution1(_ input: String) -> Int {
        
        let root = createInputFileSystem(input)
        
        var sizes = [Int]()
        findSmallDirs(root, dirs: &sizes)
        
        let total = sizes.reduce(0, {$0+$1})
        
        return total
    }
    
    func findSmallDirs(_ dir: FileSystemNode, dirs: inout [Int]) {
        
        let dirSize = dir.calculatedSize!
        if dirSize < 100000 {
            dirs.append(dirSize)
        }
        
        let childDirs = dir.children.values.filter { $0.type == .dir }
        for child in childDirs {
            findSmallDirs(child, dirs: &dirs)
        }
        
    }
    
    func createInputFileSystem(_ input: String) -> FileSystemNode {
        let root = FileSystemNode(name: "/", type: .dir, parent: nil)
        
        
        let instructions = input.split(separator: "\n").dropFirst(1).map {String($0)}
        
        
        var currentDir: FileSystemNode? = root
        for instruction in instructions {
            let params = instruction.split(separator: " ").map { String($0) }
            
            if params[0] == "$" { // process command
                switch params[1] {
                case "cd":
                    if params[2] == ".." {
                        currentDir = currentDir?.parent
                    } else {
                        guard let dir = currentDir?.children[params[2]] else {
                            fatalError("dir: \(params[2]) does not exist in \(String(describing: currentDir?.name))")
                        }
                        currentDir = dir
                    }
                case "ls":
                    break
                default:
                    fatalError("unknown command: \(params[1])")
                }
                
            } else if params[0] == "dir" {
                let newDir = FileSystemNode(name: params[1], type: .dir, parent: nil)
                currentDir?.addChild(newDir)
                
            } else {
                let newFile = FileSystemNode(name: params[1], type: .file, parent: nil)
                newFile.size = Int(params[0])
                currentDir?.addChild(newFile)
            }
        }
        return root
    }
    
}




class FileSystemNode: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String {
        "[\(type)] \(name) - \(String(describing: type == .file ? size : nil))"
    }
    
    var description: String {
        debugDescription
    }
    
    let name: String
    let type: NodeType
    var parent: FileSystemNode?
    
    var children: [String: FileSystemNode] = [:]
    var size: Int?
    
    var calculatedSize: Int? {
        if type == .file {
            return size
        }
        
        var totalSize = 0
        for (_, child) in children {
            totalSize += child.calculatedSize ?? 0
        }
        
        return totalSize
    }
    
    var isRoot: Bool {
        parent != nil
    }
    
    
    convenience init(name: String, type: NodeType, parent: FileSystemNode?) {
        self.init(name: name, type: type, parent: parent, children: [:], size: nil)
    }
    
    init(name: String, type: NodeType, parent: FileSystemNode?, children: [String: FileSystemNode], size: Int?) {
        self.name = name
        self.type = type
        self.parent = parent
        self.children = children
        self.size = size
    }
    
    func addChild(_ node: FileSystemNode) {
        node.parent = self
        children[node.name] = node
    }
}

enum NodeType {
    case file
    case dir
}
