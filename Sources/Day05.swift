import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    return data.split(separator: "\n").map({ String($0) })
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let pagesMap = entities
      .filter { $0.contains("|") }
      .reduce(into: [String: Set<String>]()) { result, line in
        let parts = line.split(separator: "|").map(String.init)
        result[parts[0], default: []].insert(parts[1])
      }

    let updates = entities
      .filter { !$0.contains("|") }
      .map { $0.split(separator: ",").map(String.init) }

    let correctUpdates = updates.filter { update in
      validateUpdate(update, with: pagesMap)
    }

    return correctUpdates.reduce(0) { total, update in
      let middleIndex = (update.count - 1) / 2
      return total + Int(update[middleIndex])!
    }
  }

  private func validateUpdate(_ update: [String], with pagesMap: [String: Set<String>]) -> Bool {
    for (index, num) in update.enumerated() {
      let remainingNumbers = Set(update[(index + 1)...])

      if num == update.last {
        continue
      }

      guard let allowedValues = pagesMap[num] else {
        return false
      }

      if !remainingNumbers.isSubset(of: allowedValues) {
        return false
      }
    }
    return true
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let pagesMap = entities
      .filter { $0.contains("|") }
      .reduce(into: [String: Set<String>]()) { result, line in
        let parts = line.split(separator: "|").map(String.init)
        result[parts[0], default: []].insert(parts[1])
      }

    let updates = entities
      .filter { !$0.contains("|") }
      .map { $0.split(separator: ",").map(String.init) }

    let correctUpdates = updates.filter { update in
      validateUpdate(update, with: pagesMap)
    }

    let sortedIncorrectUpdates = updates
      .filter { !correctUpdates.contains($0) }
      .map { incorrectUpdate in
        incorrectUpdate.sorted {
          let set1 = Set(pagesMap[$0, default: []]).intersection(incorrectUpdate)
          let set2 = Set(pagesMap[$1, default: []]).intersection(incorrectUpdate)
          return set1.count > set2.count
        }
      }

    return sortedIncorrectUpdates.reduce(0) { total, update in
      let middleIndex = (update.count - 1) / 2
      return total + Int(update[middleIndex])!
    }
  }
}
