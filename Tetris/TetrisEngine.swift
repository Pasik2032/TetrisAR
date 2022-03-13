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
    
    init(_ boxes: [[SCNNode]] ) {
        self.boxes = boxes
        a = (20, 4)
        b = (20, 5)
        c = (19, 4)
        d = (19, 5)
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    var a, b, c, d : (Int, Int)
    public func start(){
        let shap = randomShapes()

        switch shap {
        case .O:
            print("OK")
            a = (20, 4)
            b = (20, 5)
            c = (19, 4)
            d = (19, 5)
        case .I:
            print("error")
        case .S:
            print("error")
        case .Z:
            print("error")
        case .L:
            print("error")
        case .J:
            print("error")
        case .T:
            print("error")
        }
        if boxes[a.0][a.1].name == "full" || boxes[b.0][b.1].name == "full" || boxes[c.0][c.1].name == "full" || boxes[d.0][d.1].name == "full"{
            print("Game over")
            return
        }
        boxes[a.0][a.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[a.0][a.1].name = "full"
        print(String(a.0) + ":" + String(a.1) + " draw")
        boxes[b.0][b.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[b.0][b.1].name = "full"
        print(String(b.0) + ":" + String(b.1) + " draw")
        boxes[c.0][c.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[c.0][c.1].name = "full"
        print(String(c.0) + ":" + String(c.1) + " draw")
        boxes[d.0][d.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[d.0][d.1].name = "full"
        print(String(d.0) + ":" + String(d.1) + " draw")
        

//        while boxes[a.0][a.1].name != "full" && boxes[b.0][b.1].name != "full" && boxes[c.0][c.1].name != "full" && boxes[d.0][d.1].name != "full"{
            let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fall), userInfo: nil, repeats: true)
        print("test")
        
    }
    
    let color = [UIColor.red, UIColor.blue, UIColor.cyan, UIColor.black, UIColor.yellow]
    @objc func fall(timer: Timer){
        print("Timer")
        if d.0 - 1 == 0 || boxes[d.0 - 1][d.1].name == "full" {
            timer.invalidate()
            start()
            return
        }
        boxes[a.0][a.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[a.0][a.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        boxes[a.0][a.1].name = "empty"
        boxes[b.0][b.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[b.0][b.1].geometry?.firstMaterial?.diffuse.contents =  UIImage(named: "box")
        boxes[b.0][b.1].name = "empty"
        boxes[c.0][c.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[c.0][c.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        boxes[c.0][c.1].name = "empty"
        boxes[d.0][d.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        boxes[d.0][d.1].geometry?.firstMaterial?.diffuse.contents =  UIImage(named: "box")
        boxes[d.0][d.1].name = "empty"
        a.0 -= 1
        b.0 -= 1
        c.0 -= 1
        d.0 -= 1
        boxes[a.0][a.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[a.0][a.1].name = "full"
        print(String(a.0) + ":" + String(a.1) + " draw")
        boxes[b.0][b.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[b.0][b.1].name = "full"
        print(String(b.0) + ":" + String(b.1) + " draw")
        boxes[c.0][c.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[c.0][c.1].name = "full"
        print(String(c.0) + ":" + String(c.1) + " draw")
        boxes[d.0][d.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxes[d.0][d.1].name = "full"
        print(String(d.0) + ":" + String(d.1) + " draw")
    }
    
    private func randomShapes() -> Shapes{
        let a = Int.random(in: 1...6)
        return Shapes(rawValue: 0)!
    }
}
