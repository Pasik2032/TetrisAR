//
//  TetrisView+VC.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 14.03.2022.
//

import Foundation


extension ViewController: TetrisView {
    
    func editScore(str: String) {
        scoreLabel.text = str
    }
    

    func endGame(scope: Int) {
        print("func")
        
        gameOverLabel.text = "Game over\n Scope: " + String(scope)
       
        sceneView.addSubview(gameOverLabel)

        gameOverLabel.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        gameOverLabel.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor).isActive = true
        tetris = nil
    }
}
