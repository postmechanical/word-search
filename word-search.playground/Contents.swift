import Foundation

let dictionary = ["geeks", "for", "quiz", "go", "seek"];

let board = [
    ["g","i","z"],
    ["u","e","k"],
    ["q","s","e"]
];

let boardMaxColumnIndex = 2
let boardMaxRowIndex = 2

struct Index: Equatable, CustomStringConvertible {
    let row: Int
    let column: Int
    
    var description: String {
        return "(row: \(row), column: \(column))"
    }
}

typealias FindResult = (found: Bool, searchIndices: [Index])

func find(idx: Index, letter: String, foundIndexes: inout [Index]) -> FindResult {
    var potentialIndices = [Index]()
    if idx.column > 0 {
        potentialIndices.append(Index(row: idx.row, column: idx.column - 1))
    }
    if idx.row > 0 {
        potentialIndices.append(Index(row: idx.row - 1, column: idx.column))
    }
    if idx.column > 0, idx.row > 0 {
        potentialIndices.append(Index(row: idx.row - 1, column: idx.column - 1))
    }
    if idx.row < boardMaxRowIndex, idx.column > 0 {
        potentialIndices.append(Index(row: idx.row + 1, column: idx.column - 1))
    }
    if idx.column < boardMaxColumnIndex {
        potentialIndices.append(Index(row: idx.row, column: idx.column + 1))
    }
    if idx.row < boardMaxRowIndex {
        potentialIndices.append(Index(row: idx.row + 1, column: idx.column))
    }
    if idx.column < boardMaxColumnIndex, idx.row < boardMaxRowIndex {
        potentialIndices.append(Index(row: idx.row + 1, column: idx.column + 1))
    }
    if idx.row > 0, idx.column < boardMaxColumnIndex {
        potentialIndices.append(Index(row: idx.row - 1, column: idx.column + 1))
    }
    guard potentialIndices.count > 0 else {
        return (false, [])
    }
    var found = false
    if idx.row >= 0, idx.column >= 0, idx.row < board.count && idx.column < board[idx.row].count {
        found = (board[idx.row][idx.column] == letter)
    }
    return (found, potentialIndices.filter { !foundIndexes.contains($0) })
}

func findLetter(from position: String.Index, in word: String, with idx: Index, foundIndexes: inout [Index]) -> Bool {
    guard position < word.endIndex else { return false }
    let letter = String(word[position])
    let result = find(idx: idx, letter: letter, foundIndexes: &foundIndexes)
    guard result.found else { return false }
    foundIndexes.append(idx)
    print("Found: \(letter) at index: \(idx)")
    let nextPosition = word.index(position, offsetBy: 1)
    if nextPosition == word.endIndex {
        return true
    }
    for anIndex in result.searchIndices {
        let found = findLetter(from: nextPosition, in: word, with: anIndex, foundIndexes: &foundIndexes)
        if found {
            foundIndexes.append(anIndex)
            return true
        }
    }
    return false
}

dictionary.forEach { word in
    var foundIndexes = [Index]()
    print("Finding: \(word)")
    var result = false
    var row = 0
    while row <= boardMaxRowIndex {
        var column = 0
        while column <= boardMaxColumnIndex {
            result = findLetter(from: word.startIndex, in: word, with: Index(row: row, column: column), foundIndexes: &foundIndexes)
            if result {
                break
            }
            column += 1
        }
        if result {
            break
        }
        row += 1
    }
    print(result ? "Found 😂" : "Not found 😭")
}
