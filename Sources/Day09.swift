import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [Character] {
    Array(data.trimmingCharacters(in: .whitespacesAndNewlines))
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let formatted = generateFormattedArray(entities)
    var blocks = formatted
    var lastIndex = blocks.count - 1

    for i in blocks.indices {
      guard i < lastIndex else { break }
      if blocks[i] == "." {
        // Find the last non-dot to swap
        while lastIndex > i && blocks[lastIndex] == "." {
          lastIndex -= 1
        }
        if i < lastIndex {
          blocks.swapAt(i, lastIndex)
          lastIndex -= 1
        }
      }
    }

    // Calculate the checksum
    var checksum = 0
    for (i, char) in blocks.enumerated() {
      guard char != "." else { continue }
      if let value = Int(String(char)) {
        checksum += i * value
      }
    }

    return checksum
  }

  // Create the `formatted` array
  private func generateFormattedArray(_ input: [Character]) -> [String] {
    var flag = true
    var id = 0
    var formatted: [String] = []

    for char in input {
      if let count = char.wholeNumberValue {
        if flag {
          // Add file identifiers
          formatted.append(contentsOf: Array(repeating: "\(id)", count: count))
          id += 1
        } else {
          // Add discs (".")
          formatted.append(contentsOf: Array(repeating: ".", count: count))
        }
        flag.toggle()
      }
    }
    return formatted
  }

  struct File {
    let id: String
    let index: (start: Int, end: Int)
    let size: Int
  }

  func part2() -> Any {
    let formatted = generateFormattedArray(entities)
    let files = generateFileArray(formatted)
      .sorted { Int($0.id)! > Int($1.id)! } // Sorting by file ID numerically descending
    var blocks = formatted

    for file in files {
      var i = 0
      while i < blocks.count {
        guard blocks[i] == "." else {
          i += 1
          continue
        }

        let start = i
        while i < blocks.count && blocks[i] == "." {
          i += 1
        }

        let size = i - start
        // Check if we have a suitable run of free space
        if size >= file.size && (start + file.size) <= file.index.start {
          // Clear old file location
          for oldPos in file.index.start...file.index.end {
            blocks[oldPos] = "."
          }
          // Place the file
          for newPos in start..<start+file.size {
            blocks[newPos] = file.id
          }
          break
        }

        // If we passed the file's start, no further suitable space to the left
        if start + size > file.index.start {
          break
        }
      }
    }

    // Calculate checksum
    var checksum = 0
    for (i, char) in blocks.enumerated() {
      guard char != "." else { continue }
      if let value = Int(char) {
        checksum += i * value
      }
    }

    return checksum
  }

  private func generateFileArray(_ input: [String]) -> [File] {
    var files = [File]()
    var currentChar = "."
    var start = 0
    var id = currentChar

    for (index, char) in input.enumerated() {
      if char != currentChar {
        // If we were tracking a file (not "."), close it off
        if currentChar != "." {
          files.append(File(id: id, index: (start, index - 1), size: index - start))
        }

        // Start a new segment
        id = char
        start = index
        currentChar = char
      }

      // if we reach the end, close off the last segment
      if index == input.count - 1 {
        files.append(File(id: id, index: (start, index), size: index - start + 1))
      }
    }

    return files
  }
}
