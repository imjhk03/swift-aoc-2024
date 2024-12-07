import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map({ Array($0) })
  }

  enum Direction {
    case up, right, down, left

    var offset: (dx: Int, dy: Int) {
      switch self {
      case .up: return (0, -1)
      case .right: return (1, 0)
      case .down: return (0, 1)
      case .left: return (-1, 0)
      }
    }

    mutating func turnRight() {
      self = [.up, .right, .down, .left][(self.index + 1) % 4]
    }

    private var index: Int {
      switch self {
      case .up: return 0
      case .right: return 1
      case .down: return 2
      case .left: return 3
      }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let rows = entities.count
    let columns = entities[0].count

    // Find the starting position and direction
    var (x, y) = (0, 0)
    var direction = Direction.up

    outer: for (rowIndex, row) in entities.enumerated() {
      if let colIndex = row.firstIndex(of: "^") {
        x = colIndex
        y = rowIndex
        break outer
      }
    }

    var visited = Set<String>()
    visited.insert("\(x), \(y)")

    var grid = entities
    grid[y][x] = "X"

    while x >= 0, y >= 0, x < columns, y < rows {
      let nextX = x + direction.offset.dx
      let nextY = y + direction.offset.dy

      if nextX >= 0, nextY >= 0, nextX < columns, nextY < rows {
        if grid[nextY][nextX] != "#" {
          // Move forward
          x = nextX
          y = nextY
          visited.insert("\(x), \(y)")
          grid[y][x] = "X"
        } else {
          // Turn right
          direction.turnRight()
        }
      } else {
        break
      }
    }

    return visited.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var startX = 0
    var startY = 0

    outer: for (rowIndex, row) in entities.enumerated() {
      if let colIndex = row.firstIndex(of: "^") {
        startX = colIndex
        startY = rowIndex
        break outer
      }
    }

    var validPositions: Set<String> = []

    for (y, row) in entities.enumerated() {
      for (x, cell) in row.enumerated() {
        if cell == "." {
          // Simulate the patrol with an obstruction at (x, y)
          let isLoop = simulateWithObstruction(at: (y, x), start: (startY, startX), entities)
          if isLoop {
            validPositions.insert("\(y), \(x)")
          }
        }
      }
    }

    return validPositions.count
  }

  func simulateWithObstruction(at obstruction: (y: Int, x: Int), start: (y: Int, x: Int), _ grid: [[Character]]) -> Bool {
    var grid = grid
    let rows = grid.count
    let columns = grid[0].count
    var visitedStates = Set<String>()
    var x = start.x
    var y = start.y
    var direction: Direction = .up

    // Place the obstruction
    grid[obstruction.y][obstruction.x] = "#"

    while x >= 0, y >= 0, x < columns, y < rows {
      let state = "\(y), \(x), \(direction)"
      if visitedStates.contains(state) {
        return true // Loop detected
      }

      visitedStates.insert(state)

      let nextX = x + direction.offset.dx
      let nextY = y + direction.offset.dy

      if nextX >= 0, nextY >= 0, nextX < columns, nextY < rows {
        if grid[nextY][nextX] != "#" {
          // Move forward
          x = nextX
          y = nextY
        } else {
          // Turn right
          direction.turnRight()
        }
      } else {
        break
      }
    }

    return false // No loop detected
  }
}
