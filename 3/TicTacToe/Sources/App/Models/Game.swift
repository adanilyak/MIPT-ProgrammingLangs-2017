//
//  Game.swift
//  TicTacToePackageDescription
//
//  Created by Alexander Danilyak on 02/12/2017.
//

import Foundation
import Vapor

extension Game {
    struct Config {
        let w: Int = 10
        let h: Int = 10
    }
}

extension Game {
    class Board {
        var cells: [[Cell]]
        init(w: Int, h: Int) {
            self.cells = []
            for r in 0..<h {
                var row = [Cell]()
                for c in 0..<w {
                    row.append(Cell(row: r, col: c))
                }
                cells.append(row)
            }
        }
        
        subscript(row: Int) -> [Cell] {
            return cells[row]
        }
    }
}

extension Game {
    class Cell: NodeRepresentable {
        enum Value {
            case empty
            case filled(Mark)
            
            var string: String {
                switch self {
                case .empty:
                    return ""
                case .filled(let mark):
                    return mark.rawValue
                }
            }
        }
        
        var value: Value
        let row: Int
        let col: Int
        
        init(value: Value = .empty, row: Int, col: Int) {
            self.value = value
            self.row = row
            self.col = col
        }
        
        func makeNode(in context: Context?) throws -> Node {
            return try Node(node: ["value": value.string,
                                   "row": "\(row)",
                                   "col": "\(col)"])
        }
    }
}

extension Game {
    enum Mark: String {
        case o = "O"
        case x = "X"
        
        static let all: [Mark] = [.o, .x]
    }
    
    class Player {
        let marker: Mark
        var ws: WebSocket?
        
        init(marker: Mark) {
            self.marker = marker
        }
    }
}

class Game {
    
    static let shared: Game = Game()
    private init(config: Config = Config()) {
        self.config = config
        self.board = Board(w: self.config.w, h: self.config.h)
        self.players = Game.Mark.all.map { Player(marker: $0) }
    }
    
    fileprivate let config: Config
    fileprivate(set) var board: Board
    fileprivate let players: [Player]
    fileprivate var currentModePlayerId: Int = 0
    
    var maxPlayersCount: Int {
        return players.count
    }
    
    func bind(playerId: Int, ws: WebSocket) {
        players[playerId].ws = ws
    }
    
    func add(playerId: Int, row: Int, col: Int) {
        guard playerId == currentModePlayerId else {
            return
        }
        
        let cell = board[row][col]
        guard case .empty = cell.value else {
            return
        }
        
        defer {
            currentModePlayerId = (playerId + 1) % maxPlayersCount
        }
        
        cell.value = .filled(players[playerId].marker)
        
        players.forEach { try? $0.ws?.send("move;\(cell.value.string);\(row);\(col)") }
        
        if let winner = checkWin() {
            for player in self.players {
                if player.marker == winner.marker {
                    try? player.ws?.send("winner;1")
                } else {
                    try? player.ws?.send("winner;0")
                }
            }
        }
    }
    
    func restart() {
        board = Board(w: config.w, h: config.h)
        currentModePlayerId = 0
        players.forEach { try? $0.ws?.send("restart") }
    }
    
    func checkWin() -> Player? {
        func checkHorizontal() -> Player? {
            let offsets: (l: Int, t: Int, r: Int, b: Int) = (2, 0, 2, 0)
            
            for p in players {
                for r in offsets.t..<board.cells.count-offsets.b {
                    for c in offsets.l..<board.cells[r].count-offsets.r {
                        let s = p.marker
                        if case .filled(let m1) = board[r][c-2].value,
                            case .filled(let m2) = board[r][c-1].value,
                            case .filled(let m3) = board[r][c].value,
                            case .filled(let m4) = board[r][c+1].value,
                            case .filled(let m5) = board[r][c+2].value,
                            m1 == s,
                            m2 == s,
                            m3 == s,
                            m4 == s,
                            m5 == s {
                            return p
                        }
                    }
                }
            }
            
            return nil
        }
        
        func checkVertical() -> Player? {
            let offsets: (l: Int, t: Int, r: Int, b: Int) = (0, 2, 0, 2)
            
            for p in players {
                for r in offsets.t..<board.cells.count-offsets.b {
                    for c in offsets.l..<board.cells[r].count-offsets.r {
                        let s = p.marker
                        if case .filled(let m1) = board[r-2][c].value,
                            case .filled(let m2) = board[r-1][c].value,
                            case .filled(let m3) = board[r][c].value,
                            case .filled(let m4) = board[r+1][c].value,
                            case .filled(let m5) = board[r+2][c].value,
                            m1 == s,
                            m2 == s,
                            m3 == s,
                            m4 == s,
                            m5 == s {
                            return p
                        }
                    }
                }
            }
            
            return nil
        }
        
        func checkDiagonal() -> Player? {
            let offsets: (l: Int, t: Int, r: Int, b: Int) = (2, 2, 2, 2)
            
            for p in players {
                for r in offsets.t..<board.cells.count-offsets.b {
                    for c in offsets.l..<board.cells[r].count-offsets.r {
                        let s = p.marker
                        if case .filled(let m1) = board[r-2][c-2].value,
                            case .filled(let m2) = board[r-1][c-1].value,
                            case .filled(let m3) = board[r][c].value,
                            case .filled(let m4) = board[r+1][c+1].value,
                            case .filled(let m5) = board[r+2][c+2].value,
                            m1 == s,
                            m2 == s,
                            m3 == s,
                            m4 == s,
                            m5 == s {
                            return p
                        }
                        
                        if case .filled(let m1) = board[r-2][c+2].value,
                            case .filled(let m2) = board[r-1][c+1].value,
                            case .filled(let m3) = board[r][c].value,
                            case .filled(let m4) = board[r+1][c-1].value,
                            case .filled(let m5) = board[r+2][c-2].value,
                            m1 == s,
                            m2 == s,
                            m3 == s,
                            m4 == s,
                            m5 == s {
                            return p
                        }
                    }
                }
            }
            
            return nil
        }
        
        if let p = checkHorizontal() {
            return p
        }
        
        if let p = checkVertical() {
            return p
        }
        
        if let p = checkDiagonal() {
            return p
        }
        
        return nil
    }
    
}
