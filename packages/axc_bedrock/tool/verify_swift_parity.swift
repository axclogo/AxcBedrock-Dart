// 使用 Swift 仓库构建产物执行同一份 JSON 行为用例；不修改 Swift 仓库。
import Foundation
import AxcBedrockCore

struct Fixture: Decodable {
    struct Prefix: Decodable { let value: String; let count: Int; let suffix: String; let expected: String }
    struct Suffix: Decodable { let value: String; let count: Int; let expected: String }
    struct Element: Decodable { let values: [Int]; let index: Int; let expected: Int? }
    struct Chunk: Decodable { let values: [Int]; let size: Int; let expected: [[Int]] }
    struct Clamp: Decodable { let value: Double?; let kind: String?; let min: Double; let max: Double; let expected: Double? }
    let stringPrefix: [Prefix]
    let stringSuffix: [Suffix]
    let listObject: [Element]
    let listChunked: [Chunk]
    let clamped: [Clamp]
}

guard CommandLine.arguments.count == 2 else {
    print("用法: verify_swift_parity <parity.json>")
    exit(2)
}
let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))
let fixture = try JSONDecoder().decode(Fixture.self, from: data)
var count = 0
func check(_ condition: Bool) {
    precondition(condition, "Swift 行为用例不匹配，索引 \(count)")
    count += 1
}
for item in fixture.stringPrefix { check(item.value.axc.keepPrefix(count: item.count, suffix: item.suffix) == item.expected) }
for item in fixture.stringSuffix { check(item.value.axc.keepSuffix(count: item.count) == item.expected) }
for item in fixture.listObject { check(item.values.axc.object(at: item.index) == item.expected) }
for item in fixture.listChunked { check(item.values.axc.chunked(by: item.size) == item.expected) }
for item in fixture.clamped {
    let value: Double
    switch item.kind {
    case "nan": value = .nan
    case "infinity": value = .infinity
    case "negativeInfinity": value = -.infinity
    default:
        guard let number = item.value else { preconditionFailure("用例缺少数值") }
        value = number
    }
    let result = value.axc.clamped(to: item.min...item.max)
    check(item.kind == "nan" ? result.isNaN : result == item.expected)
}
print("PASS: \(count) shared Swift/Dart cases")
