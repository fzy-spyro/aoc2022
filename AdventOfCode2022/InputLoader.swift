import Foundation


struct InputLoader {
    
    private let inputPath: String
    
    init(inputPath: String) {
        self.inputPath = inputPath
    }
    
    func loadFileAsData(_ path: String) -> Data {
        
        let filePath = inputPath + "/" + path

        guard let data = FileManager.default.contents(atPath: filePath) else {
            fatalError("cannot read file")
        }
        return data
    }
    
    
    func loadFileAsString(_ path: String) -> String {
        
        let filePath = inputPath + "/" + path

        guard let data = FileManager.default.contents(atPath: filePath) else {
            fatalError("cannot read file")
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("cannot load as string")
        }
        
        return string
    }
    
}
