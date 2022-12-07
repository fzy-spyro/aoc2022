//

import Foundation


struct Day7 {
    
    
    func solution1(_ input: String) -> Int {
        
        let root = createInputFileSystem(input)
        
        
        return -1
    }
    
    func createInputFileSystem(_ input: String) -> FileSystemNode {
        return FileSystemNode(name: "/", type: .dir, parent: nil)
    }
    
}




class FileSystemNode {
    let name: String
    let type: NodeType
    let parent: FileSystemNode?
    
    var children: [FileSystemNode]
    var size: Int?
    
    convenience init(name: String, type: NodeType, parent: FileSystemNode?) {
        self.init(name: name, type: type, parent: parent, children: [], size: nil)
    }
    
    init(name: String, type: NodeType, parent: FileSystemNode?, children: [FileSystemNode], size: Int?) {
        self.name = name
        self.type = type
        self.parent = parent
        self.children = children
        self.size = size
    }
}

enum NodeType {
    case file
    case dir
}
