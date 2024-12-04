import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map { Array($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let directions: [(dx: Int, dy: Int)] = [
      (1, 0), (-1, 0), // Horizontal
      (0, 1), (0, -1), // Vertical
      (1, 1), (-1, -1), // Diagonal (top-left to bottom-right)
      (1, -1), (-1, 1)  // Diagonal (top-right to bottom-left)
    ]

    let rows = entities.count
    let columns = entities[0].count
    var counts = 0

    for i in 0..<rows {
      for j in 0..<columns {
        if entities[i][j] == "X" {
          for direction in directions {
            if matchesWord(from: i, j, direction: direction, in: entities) {
              counts += 1
            }
          }
        }
      }
    }

    return counts
  }

  private func matchesWord(from x: Int, _ y: Int, direction: (dx: Int, dy: Int), in grid: [[Character]]) -> Bool {
    let word: [Character] = ["X", "M", "A", "S"]
    for k in 0..<word.count {
      let nx = x + k * direction.dx
      let ny = y + k * direction.dy
      if !isInBounds(nx, ny, in: grid) || grid[nx][ny] != word[k] {
        return false
      }
    }
    return true
  }

  private func isInBounds(_ x: Int, _ y: Int, in grid: [[Character]]) -> Bool {
    x >= 0 && x < grid.count && y >= 0 && y < grid[0].count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let rows = entities.count
    let columns = entities[0].count
    var counts = 0

    for i in 0..<rows {
      for j in 0..<columns {
        if entities[i][j] == "A" {
          if isXMAS(centerX: i, centerY: j, in: entities) {
            counts += 1
          }
        }
      }
    }

    return counts
  }

  private func isXMAS(centerX x: Int, centerY y: Int, in grid: [[Character]]) -> Bool {
    // Define the valid patterns for the diagonals
    let validPatterns: Set<[Character]> = [["M", "A", "S"], ["S", "A", "M"]]

    // Check both diagonals for valid patterns
    let diagonal1 = getDiagonal(centerX: x, centerY: y, direction1: (-1, -1), direction2: (1, 1), in: grid)
    let diagonal2 = getDiagonal(centerX: x, centerY: y, direction1: (-1, 1), direction2: (1, -1), in: grid)

    // Return true only if both diagonals match one of the valid patterns
    return validPatterns.contains(diagonal1) && validPatterns.contains(diagonal2)
  }

  private func getDiagonal(
    centerX x: Int,
    centerY y: Int,
    direction1: (dx: Int, dy: Int),
    direction2: (dx: Int, dy: Int),
    in grid: [[Character]]
  ) -> [Character] {
    var sequence: [Character] = []

    // Collect character to the left of the center along the diagonal
    let leftX = x + direction1.dx
    let leftY = y + direction1.dy
    if isInBounds(leftX, leftY, in: grid) {
      sequence.append(grid[leftX][leftY])
    } else {
      return [] // Return empty if out of bounds
    }

    // Add the center character
    sequence.append(grid[x][y])

    // Collect character to the right of the center along the diagonal
    let rightX = x + direction2.dx
    let rightY = y + direction2.dy
    if isInBounds(rightX, rightY, in: grid) {
      sequence.append(grid[rightX][rightY])
    } else {
      return [] // Return empty if out of bounds
    }

    return sequence
  }

}
