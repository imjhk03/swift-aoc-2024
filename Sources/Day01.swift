import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    let rows = data.split(separator: "\n")
    let (leftList, rightList) = rows.reduce(into: ([Int](), [Int]())) { result, row in
      let parts = row.split(separator: "   ")
      if let first = parts.first.flatMap({ Int($0) }) {
        result.0.append(first)
      }
      if let last = parts.last.flatMap({ Int($0) }) {
        result.1.append(last)
      }
    }
    return [leftList, rightList]
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let leftList = entities.first?.sorted() ?? []
    let rightList = entities.last?.sorted() ?? []

    return zip(leftList, rightList)
      .reduce(0) { $0 + abs($1.0 - $1.1) }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let leftList = entities.first ?? []
    let rightList = entities.last ?? []

    let frequencyMap = rightList.reduce(into: [:]) { $0[$1, default: 0] += 1 }

    return leftList.reduce(0) { $0 + $1 * (frequencyMap[$1] ?? 0) }
  }
}
