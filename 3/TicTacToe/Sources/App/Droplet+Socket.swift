//
//  Droplet+Socket.swift
//  TicTacToePackageDescription
//
//  Created by Alexander Danilyak on 02/12/2017.
//

@_exported import Vapor
import Foundation

extension Droplet {
    public func addSockets() {
        socket("ws") { [weak self] req, ws in
            print("New WebSocket connected: \(ws)")

            background {
                while ws.state == .open {
                    try? ws.ping()
                    self?.console.wait(seconds: 10)
                }
            }
            
            ws.onText = { ws, text in
                let parsedData: [String] = text.split(separator: ";").map({ String($0) })
                
                // Bind
                if parsedData.count == 2, parsedData[0] == "bind", let userId = Int(parsedData[1]) {
                    Game.shared.bind(playerId: userId, ws: ws)
                    return
                }
                
                // Move
                if parsedData.count == 4, parsedData[0] == "move" {
                    let data: [Int] = parsedData[1...3].flatMap { Int($0) }
                    guard data.count == 3 else {
                        print("Error, wrong number of incoming args")
                        return
                    }
                    
                    Game.shared.add(playerId: data[0], row: data[1], col: data[2])
                    return
                }
                
                
                // Restart
                if parsedData.count == 1, parsedData[0] == "restart" {
                    Game.shared.restart()
                    return
                }
            
            }
            
            ws.onClose = { ws, code, reason, clean in
                print("Closed.")
            }
        }
    }
}
