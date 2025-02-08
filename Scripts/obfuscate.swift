import Foundation

guard CommandLine.arguments.count >= 2 else {
    fputs("Usage: \(CommandLine.arguments[0]) \"input_string\"\n", stderr)
    exit(1)
}

let credentials = CommandLine.arguments[1]
let originalLength = credentials.count
let rawLength = originalLength * 10

var indexSet: Set<Int> = []
while indexSet.count < originalLength {
    indexSet.insert(Int.random(in: 0 ..< rawLength))
}

let indexes = Array(indexSet).sorted()

let pool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,."
var rawChars = (0 ..< rawLength).map { _ in pool.randomElement()! }

for (offset, char) in credentials.enumerated() {
    let pos = indexes[offset]
    rawChars[pos] = char
}

let rawString = String(rawChars)

let generatedCode = """
enum Secrets {
    static func get() -> String {
        var result = ""
        for i in indexes {
            let index = rawString.index(rawString.startIndex, offsetBy: i)
            result.append(rawString[index])
        }
        return result
    }

    private static let indexes: [Int] = \(indexes)

    private static let rawString = "\(rawString)"
}
"""

print(generatedCode)
