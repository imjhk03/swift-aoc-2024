import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data
      .split(separator: "\n")
      .map { $0.compactMap(\.wholeNumberValue) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let trailheads = identifyTrailheads()
    var memo = initializeMemoGrid()

    var totalScore = 0

    for trailhead in trailheads {
      var reachableNines = Set<Position>()
      findReachableNines(from: trailhead, in: entities, memo: &memo, reachableNines: &reachableNines)
      totalScore += reachableNines.count
    }

    return totalScore
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let trailheads = identifyTrailheads()
    var memo = initializeMemoGrid()

    var totalRating = 0

    for trailhead in trailheads {
      totalRating += findTrails(num: entities[trailhead.row][trailhead.col],
                                at: trailhead,
                                in: entities,
                                memo: &memo)
    }

    return totalRating
  }

  struct Position: Hashable {
    let row: Int
    let col: Int
  }

  enum Direction: CaseIterable {
    case up
    case right
    case down
    case left

    var offset: (dx: Int, dy: Int) {
      switch self {
      case .up: return (-1, 0)
      case .right: return (0, 1)
      case .down: return (1, 0)
      case .left: return (0, -1)
      }
    }
  }

  private func identifyTrailheads() -> [Position] {
    return entities.enumerated().flatMap { (row, rowValues) in
      rowValues.enumerated().compactMap { (col, height) in
        height == 0 ? Position(row: row, col: col) : nil
      }
    }
  }

  private func initializeMemoGrid() -> [[Int?]] {
    return Array(repeating: Array(repeating: nil, count: entities[0].count), count: entities.count)
  }

  // Part 1: Collect reachable '9's
  private func findReachableNines(from trailhead: Position,
                                  in grid: [[Int]],
                                  memo: inout [[Int?]],
                                  reachableNines: inout Set<Position>) {
    collectNines(num: grid[trailhead.row][trailhead.col],
                 at: trailhead,
                 in: grid,
                 memo: &memo,
                 reachableNines: &reachableNines)
  }

  private func collectNines(num: Int,
                            at position: Position,
                            in grid: [[Int]],
                            memo: inout [[Int?]],
                            reachableNines: inout Set<Position>) {
    if num == 9 {
      reachableNines.insert(position)
      return
    }

    // No need to cache for Part 1
    for direction in Direction.allCases {
      let newRow = position.row + direction.offset.dx
      let newCol = position.col + direction.offset.dy

      guard newRow >= 0, newRow < grid.count,
            newCol >= 0, newCol < grid[newRow].count else { continue }

      if grid[newRow][newCol] == num + 1 {
        let newPosition = Position(row: newRow, col: newCol)
        collectNines(num: num + 1, at: newPosition, in: grid, memo: &memo, reachableNines: &reachableNines)
      }
    }
  }

  // Part 2: Count distinct trails
  private func findTrails(num: Int,
                          at position: Position,
                          in grid: [[Int]],
                          memo: inout [[Int?]]) -> Int {
    // Base Case: Reached height 9
    if num == 9 {
      return 1
    }

    // Return cached result if available
    if let cached = memo[position.row][position.col] {
      return cached
    }

    var totalTrails = 0

    // Explore all four directions
    for direction in Direction.allCases {
      let newRow = position.row + direction.offset.dx
      let newCol = position.col + direction.offset.dy

      // Boundary Check
      guard newRow >= 0, newRow < grid.count,
            newCol >= 0, newCol < grid[newRow].count else { continue }

      // Valid Move: Next height must be exactly one greater
      if grid[newRow][newCol] == num + 1 {
        let newPosition = Position(row: newRow, col: newCol)
        totalTrails += findTrails(num: num + 1, at: newPosition, in: grid, memo: &memo)
      }
    }

    // Cache the computed number of trails from this position
    memo[position.row][position.col] = totalTrails
    return totalTrails
  }
}
