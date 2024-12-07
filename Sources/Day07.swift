import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [(target: Int, numbers: [Int])] {
    let lines = data.split(separator: "\n").map { String($0) }
    var parsedEntities: [(target: Int, numbers: [Int])] = []

    for line in lines {
      let parts = line.split(separator: ":").map { String($0) }
      guard let target = Int(parts[0]) else { continue }
      let numbers = parts[1].split(separator: " ").compactMap { Int($0) }
      parsedEntities.append((target: target, numbers: numbers))
    }

    return parsedEntities
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var totalSum = 0

    for entity in entities {
      let count = entity.numbers.count
      let operatorCombinations = generateOperatorCombinations(slots: count - 1)

      // Check all combinations of operators
      for operators in operatorCombinations {
        let result = evaluateExpression(operators, entity.numbers)
        if result == entity.target {
          totalSum += entity.target
          break
        }
      }
    }

    return totalSum
  }

  // Generate all combinations of operators for the given number of slots
  private func generateOperatorCombinations(slots: Int, withConcatenationOperator: Bool = false) -> [[String]] {
    let operators = ["+", "*"] + (withConcatenationOperator ? ["||"] : [])
    if slots == 0 {
      return [[]]
    }

    var combinations: [[String]] = []
    for op in operators {
      let subCombinations = generateOperatorCombinations(
        slots: slots - 1,
        withConcatenationOperator: withConcatenationOperator
      )
      for sub in subCombinations {
        combinations.append([op] + sub)
      }
    }
    return combinations
  }

  // Evaluate a mathematical expression given operators and numbers
  private func evaluateExpression(_ operators: [String], _ numbers: [Int]) -> Int {
    var result = numbers[0]

    for (index, op) in operators.enumerated() {
      switch op {
      case "+":
        result += numbers[index + 1]
      case "*":
        result *= numbers[index + 1]
      case "||":
        let concatenated = Int(String(result) + String(numbers[index + 1]))!
        result = concatenated
      default:
        continue
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var totalSum = 0

    for entity in entities {
      let count = entity.numbers.count
      let operatorCombinations = generateOperatorCombinations(slots: count - 1, withConcatenationOperator: true)

      // Check all combinations of operators
      for operators in operatorCombinations {
        let result = evaluateExpression(operators, entity.numbers)
        if result == entity.target {
          totalSum += entity.target
          break
        }
      }
    }

    return totalSum
  }
}
