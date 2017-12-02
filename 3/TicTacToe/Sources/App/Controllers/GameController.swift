//
//  GameController.swift
//  TicTacToePackageDescription
//
//  Created by Alexander Danilyak on 02/12/2017.
//

import Vapor
import HTTP

final class GameController: ResourceRepresentable {
    
    let view: ViewRenderer
    
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    /// GET /game/:string
    func game(_ req: Request, _ string: String) throws -> ResponseRepresentable {
        guard let userId: Int = Int(string), (0..<Game.shared.maxPlayersCount).contains(userId) else {
            throw Abort(.badRequest, reason: "Wrong user ID")
        }
        
        let board = Game.shared.board.cells.map { try? $0.makeNode(in: nil) }
        return try view.make("game", Node(node: ["board": board, "user": string]))
    }
    
    func makeResource() -> Resource<String> {
        return Resource(
            show: game
        )
    }
    
}
