import Foundation

let inputsPath = "/Users/fzy/Development/src/AdventOfCode2022/AdventOfCode2022/Input"
let inputLoader = InputLoader(inputPath: inputsPath)

//Day1
//let result = Day1().solution1(inputLoader.loadFileAsData("day_1_1.txt"))
//let result = Day1().solution2(inputLoader.loadFileAsData("day_1_1.txt"))

//Day2
//let result = Day2().solution1(inputLoader.loadFileAsString("day_2_2.txt"))
//let result = Day2().solution2(inputLoader.loadFileAsString("day_2_2.txt"))
//let result = Day3().solution2(inputLoader.loadFileAsString("day_3_3.txt"))

let result = Day4().solution2(inputLoader.loadFileAsString("day_4.txt"))
print(result)
