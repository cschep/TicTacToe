//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Christopher Schepman on 9/10/20.
//  Copyright © 2020 Christopher Schepman. All rights reserved.
//

import Foundation

class TicTacToeGame {
    public static let sideLength = 3

    enum Player {
        case xPlayer
        case oPlayer

        var marker: Marker {
            switch self {
            case .xPlayer:
                return .x
            case .oPlayer:
                return .o
            }
        }
    }

    enum Marker {
        case x
        case o
        case empty
    }

    enum GameState: Equatable {
        case inProgress
        case tie
        case xWin([Int])
        case oWin([Int])
    }

    init() {
        self.reset()
    }

    private var gameState: GameState = .inProgress {
        didSet {
            if oldValue != gameState {
                onGameStateChange?(gameState)
            }
        }
    }

    var onGameStateChange: ((GameState) -> ())?

    var numSquares: Int {
        Self.sideLength * Self.sideLength
    }

    private(set) var board = [Marker]()
    private var currentPlayer: Player = .xPlayer

    func index(x: Int, y: Int) -> Int {
        (x * Self.sideLength) + (y % Self.sideLength)
    }

    private func checkGameState() {
        //check x's, check o's
        for marker in [Marker.x, Marker.o] {
            // check rows
            for x in (0..<Self.sideLength) {
                var fullRow = true
                var winners = [Int]()
                for y in (0..<Self.sideLength) {
                    let index = self.index(x: x, y: y)
                    if self.board[index] != marker {
                        fullRow = false
                    } else {
                        winners.append(index)
                    }
                }

                if fullRow {
                    print("row win", marker)
                    gameState = marker == .x ? .xWin(winners) : .oWin(winners)
                }
            }

            // check columns
            for y in (0..<Self.sideLength) {
                var fullCol = true
                var winners = [Int]()
                for x in (0..<Self.sideLength) {
                    let index = self.index(x: x, y: y)
                    if self.board[index] != marker {
                        fullCol = false
                    } else {
                        winners.append(index)
                    }
                }

                if fullCol {
                    print("column win", marker)
                    gameState = marker == .x ? .xWin(winners) : .oWin(winners)
                }
            }

            //check diagonals
            //00 11 22
            var fullDiag = true
            var winners = [Int]()
            for x in (0..<Self.sideLength) {
                let index = self.index(x: x, y: x)
                if self.board[index] != marker {
                    fullDiag = false
                } else {
                    winners.append(index)
                }
            }
            if fullDiag {
                print("diag win", marker)
                gameState = marker == .x ? .xWin(winners) : .oWin(winners)
            }

            //02 11 20
            fullDiag = true
            winners = [Int]()
            for x in (0..<Self.sideLength) {
                let y = Self.sideLength - 1 - x
                let index = self.index(x: x, y: y)
                if self.board[index] != marker {
                    fullDiag = false
                } else {
                    winners.append(index)
                }
            }
            if fullDiag {
                print("diag win", marker)
                gameState = marker == .x ? .xWin(winners) : .oWin(winners)
            }
        }

        //check tie
        if !board.contains(.empty) {
            gameState = .tie
        }
    }

    func reset() {
        board = (1...numSquares).map { _ in .empty }
        gameState = .inProgress
        currentPlayer = .xPlayer
    }

    func makeMove(index: Int) -> Marker? {
        guard gameState == .inProgress else {
            return nil
        }

        if board[index] == .empty {
            board[index] = currentPlayer.marker

            //check the game's state
            checkGameState()

            let result = currentPlayer.marker
            if gameState == .inProgress {
                //if the game is still in progress -> switch players
                currentPlayer = currentPlayer == .xPlayer ? .oPlayer : .xPlayer
            }

            return result
        }

        return nil
    }
}

