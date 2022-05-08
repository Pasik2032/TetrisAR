//
//  TetrisViewProtocol.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.03.2022.
//

import Foundation

protocol TetrisView {
    func endGame(scope: Int)
    func editScore(str: String)
}
