//
//  TetrisEngine.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 12.03.2022.
//

import Foundation
import ARKit

class TetrisEngine {
    
    let boxes: [[SCNNode]]
    var figure: [(Int, Int)]
    var color: UIColor = .yellow
    var speed: Float
    
    init(_ boxes: [[SCNNode]] ) {
        self.boxes = boxes
        figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
        speed = 2.0
    }
    
    public func shiftToLeft(){
        if figure[0].1 == 0 || figure[2].1 == 0{
            return
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        for i in 0..<4 {
            figure[i].1 -= 1
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }
    
    public func shiftToRight(){
        if figure[1].1 == 9 || figure[3].1 == 9{
            return
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        for i in 0..<4 {
            figure[i].1 += 1
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }
    
    let semaphore = DispatchSemaphore(value: 1)

    public func start(){
        let shap = randomShapes()

        switch shap {
        case .O:
            print("OK")
            figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
            color = .yellow
        case .I:
            figure = [(20, 4),(19, 4), (18, 4), (17, 4)]
            color = .blue
        case .S:
            figure = [(19, 4),(19, 5), (18, 3), (18, 4)]
            color = .red
        case .Z:
            figure = [(19, 3),(19, 4), (18, 4), (18, 5)]
            color = .green
        case .L:
            figure = [(20, 4),(19, 4), (18, 4), (18, 5)]
            color = .orange
        case .J:
            figure = [(20, 4),(19, 4), (18, 4), (18, 3)]
            color = .systemPink
        case .T:
            figure = [(20, 4),(20, 5), (20, 6), (19, 5)]
            color = .purple
        }
        if boxes[figure[0].0][figure[0].1].name == "full" || boxes[figure[1].0][figure[1].1].name == "full" || boxes[figure[2].0][figure[2].1].name == "full" || boxes[figure[3].0][figure[3].1].name == "full"{
            print("Game over")
            return
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
        }
        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(fall), userInfo: nil, repeats: true)
        print("test")
        
    }
    
    let colors = [UIColor.red, UIColor.blue, UIColor.cyan, UIColor.black, UIColor.yellow]
    
    @objc func fall(timer: Timer){
        print("Timer")
        for cordinate in figure {
            if (cordinate.0 - 1 == 0 || boxes[cordinate.0 - 1][cordinate.1].name == "full"){
                
                timer.invalidate()
                print("new")
                for cor in figure {
                    boxes[cor.0][cor.1].name = "full"
                }
                start()
                return
            }
        }
        
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        for i in 0..<4 {
            figure[i].0 -= 1
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }
    
    private func randomShapes() -> Shapes{
        let a = Int.random(in: 1...6)
        return Shapes(rawValue: a)!
    }
}
