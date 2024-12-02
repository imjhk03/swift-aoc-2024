import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n")
      .map { $0.split(separator: " ").compactMap { Int($0) } }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var safeReportCount = 0

    for report in entities {
      if isReportSafe(report) {
        safeReportCount += 1
      }
    }

    return safeReportCount
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var safeReportCount = 0

    for report in entities {
      if isReportSafe(report) {
        safeReportCount += 1
      } else if problemDampener(report) {
        safeReportCount += 1
      }
    }

    return safeReportCount
  }

  private func isReportSafe(_ report: [Int]) -> Bool {
    // Check if report is strictly increasing or decreasing
    return isStrictlyIncreasing(report) || isStrictlyDecreasing(report)
  }

  private func isStrictlyIncreasing(_ report: [Int]) -> Bool {
    guard report.count > 1 else { return true }

    for i in 0..<report.count - 1 {
      let diff = report[i + 1] - report[i]
      if diff < 1 || diff > 3 {
        return false
      }
    }
    return true
  }

  private func isStrictlyDecreasing(_ report: [Int]) -> Bool {
    guard report.count > 1 else { return true }

    for i in 0..<report.count - 1 {
      let diff = report[i] - report[i + 1]
      if diff < 1 || diff > 3 {
        return false
      }
    }
    return true
  }

  private func problemDampener(_ input: [Int]) -> Bool {
    for i in 0..<input.count {
      // Create a copy of the report without the i-th element
      var modifiedReport = input
      modifiedReport.remove(at: i)

      // Check if the modified report is safe
      if isReportSafe(modifiedReport) {
        return true
      }
    }
    return false
  }
}
