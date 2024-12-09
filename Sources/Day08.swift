import Algorithms
import Foundation

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map { Array(String($0)) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Step 1: Parse entities into a list of frequencies with positions
    let parsedEntities = parseEntities()

    // Step 2: Group positions by frequency
    var map = [String: [Position]]()
    for entity in parsedEntities {
      let frequency = entity.frequency
      let position = entity.position
      if map[frequency] == nil {
        map[frequency] = []
      }
      map[frequency]?.append(position)
    }

    // Step 3: Initialize a set to store unique antinodes
    var uniqueAntinodes = Set<String>()

    // Step 4: For each frequency, calculate antinodes
    for frequency in map.keys {
      guard let positions = map[frequency] else { continue }
      let pairs = generatePairs(from: positions)

      for pair in pairs {
        let left = pair.0
        let right = pair.1

        // Calculate vector between the two points
        let vector = (
          row: right.row - left.row,
          col: right.col - left.col
        )

        // Calculate the two potential antinode positions
        let antinode1 = Position(
          row: left.row - vector.row,
          col: left.col - vector.col
        )
        let antinode2 = Position(
          row: right.row + vector.row,
          col: right.col + vector.col
        )

        // Check if antinode1 is valid and unique
        addAntinode(antinode1, in: entities, to: &uniqueAntinodes)
        addAntinode(antinode2, in: entities, to: &uniqueAntinodes)
      }
    }

    // Step 5: Return the count of unique antinodes
    return uniqueAntinodes.count
  }

  // Struct to represent a grid position
  struct Position: Hashable {
      let row: Int
      let col: Int
  }

  // Function to parse entities into positions
  private func parseEntities() -> [(frequency: String, position: Position)] {
      var parsedEntities: [(frequency: String, position: Position)] = []
      for (row, line) in entities.enumerated() {
          for (col, char) in line.enumerated() {
              if char != "." {
                  parsedEntities.append((String(char), Position(row: row, col: col)))
              }
          }
      }
      return parsedEntities
  }

  // Function to generate all unique pairs of positions
  private func generatePairs(from positions: [Position]) -> [(Position, Position)] {
      var pairs: [(Position, Position)] = []
      for i in 0..<positions.count {
          for j in i + 1..<positions.count {
              pairs.append((positions[i], positions[j]))
          }
      }
      return pairs
  }

  // Function to check if a position is within grid bounds
  private func isInBound(_ position: Position, in grid: [[Character]]) -> Bool {
    guard position.row >= 0 && position.col >= 0 && position.row < grid.count && position.col < grid[0].count else {
      return false
    }
    return true
  }

  private func addAntinode(_ antinode: Position, in grid: [[Character]], to uniqueAntinodes: inout Set<String>) {
    if isInBound(antinode, in: grid) {
      let key = "(row: \(antinode.row), col: \(antinode.col))"
      uniqueAntinodes.insert(key)
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Step 1: Generate antenna positions and group by frequency
    let parsedEntities = parseEntities()
    let map = groupByFrequency(parsedEntities)

    // Step 2: Initialize a set to store unique antinodes
    var uniqueAntinodes = Set<Position>()

    // Step 3: Process each frequency
    for (_, positions) in map {
      // Add antennas themselves as antinodes
      for position in positions {
        uniqueAntinodes.insert(position)
      }

      // Generate pairs of antennas and calculate antinodes
      let pairs = generatePairs(from: positions)

      for pair in pairs {
        let left = pair.0
        let right = pair.1

        // Calculate the vector between the two points
        let vector = Position(
          row: right.row - left.row,
          col: right.col - left.col
        )

        let reversedVector = Position(
          row: -vector.row,
          col: -vector.col
        )

        // Add all antinodes along the line in both directions
        addAntinodesAlongLine(from: left, with: reversedVector, to: &uniqueAntinodes)
        addAntinodesAlongLine(from: right, with: vector, to: &uniqueAntinodes)
      }
    }

    // Step 4: Return the total count of unique antinodes
    return uniqueAntinodes.count
  }

  // Group positions by frequency
  private func groupByFrequency(_ parsedEntities: [(frequency: String, position: Position)]) -> [String: [Position]] {
      var map = [String: [Position]]()
      for entity in parsedEntities {
          let frequency = entity.frequency
          let position = entity.position
          map[frequency, default: []].append(position)
      }
      return map
  }

  // Add all antinodes along a line until out of bounds
  private func addAntinodesAlongLine(from start: Position, with vector: Position, to antinodes: inout Set<Position>) {
      var current = Position(row: start.row + vector.row, col: start.col + vector.col)
      while isInBound(current, in: entities) {
          antinodes.insert(current)
          current = Position(row: current.row + vector.row, col: current.col + vector.col)
      }
  }

}
