import Algorithms
import Foundation

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let regex = try! NSRegularExpression(pattern: #"mul\(\d+,\d+\)"#)
    let matches = regex.matches(in: data, range: NSRange(data.startIndex..., in: data))
    let entities = matches.compactMap { Range($0.range, in: data).map { String(data[$0]) } }

    var results: [(x: Int, y: Int, result: Int)] = []

    for pattern in entities {
      // Check for valid "mul(x,y)" pattern
      if pattern.hasPrefix("mul("), pattern.hasSuffix(")") {
        // Remove "mul(" and ")"
        let trimmedPattern = pattern.dropFirst(4).dropLast()

        // Split the string into components
        let components = trimmedPattern.split(separator: ",").compactMap { Int($0) }

        // Ensure we have exactly two valid integers
        if components.count == 2 {
          let x = components[0]
          let y = components[1]
          let product = x * y
          results.append((x: x, y: y, result: product))
        }
      }
    }

    // Calculate the sum of all results
    let sumOfResults = results.reduce(0) { partialSum, entry in
      partialSum + entry.result
    }

    return sumOfResults
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let regex = try! NSRegularExpression(pattern: #"(do\(\)|don't\(\)|mul\((\d+),(\d+)\))"#)
    let matches = regex.matches(in: data, range: NSRange(data.startIndex..., in: data))
    var mulEnabled = true
    var totalSum = 0

    for match in matches {
      guard let range = Range(match.range, in: data) else { continue }
      let token = String(data[range])

      if token == "do()" {
        mulEnabled = true
      } else if token == "don't()" {
        mulEnabled = false
      } else if mulEnabled, match.numberOfRanges == 4,
                let xRange = Range(match.range(at: 2), in: data),
                let yRange = Range(match.range(at: 3), in: data),
                let x = Int(data[xRange]), let y = Int(data[yRange]) {
        totalSum += x * y
      }
    }

    return totalSum
  }
}
