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
    var timer: Timer?
    var scope : Int = 0 {
        didSet {
            speed -= 0.04
            print("new speed " + String(speed))
        }
    }
    var shap: Shapes
    
    init(_ boxes: [[SCNNode]] ) {
        self.boxes = boxes
        figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
        speed = 2
        shap = Shapes.O
    }
    
    public func shiftToLeft(){
        if figure[0].1 == 0 || figure[2].1 == 0 || figure[1].1 == 0 || figure[3].1 == 0{
            return
        }
        for cordinate in figure {
            if boxes[cordinate.0][cordinate.1 - 1].name == "full" {
                return
            }
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
        if figure[1].1 == 9 || figure[3].1 == 9 || figure[0].1 == 9 || figure[2].1 == 9 {
            return
        }
        for cordinate in figure {
            if boxes[cordinate.0][cordinate.1 + 1].name == "full" {
                return
            }
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
    
    public func turn(){

        var a, b, c, d : (Int, Int)
        a = figure[0]
        b = figure[1]
        c = figure[2]
        d = figure[3]
        switch shap {
        case .O:
            print("shap o turn")
        case .I:
            if figure[1].0 ==  figure[2].0 + 1{
                a.0 = b.0
                c.0 = b.0
                c.1 = b.1 + 1
                d.0 = b.0
                d.1 = b.1 + 2
                a.1 = b.1 - 1
            } else {
                a.1 = b.1
                c.1 = b.1
                d.1 = b.1
                a.0 = b.0 + 1
                c.0 = b.0 - 1
                d.0 = b.0 - 2
            }
        case .S:
            if figure[0].1 ==  figure[1].1 - 1{
                b.0 = a.0 + 1
                b.1 = a.1
                d.1 = a.1 + 1
                d.0 = a.0
                c.1 = d.1
                c.0 = d.0 - 1
            } else{
                b.0 = a.0
                b.1 = a.1 + 1
                d.1 = a.1
                d.0 = a.0 - 1
                c.1 = d.1 - 1
                c.0 = d.0 
            }
        case .Z:
            if figure[0].1 ==  figure[1].1 - 1{
                a.1 = b.1
                a.0 = b.0 - 1
                c.0 = b.0
                c.1 = b.1 + 1
                d.1 = c.1
                d.0 = c.0 + 1
            } else {
                a.1 = b.1 - 1
                a.0 = b.0
                c.1 = b.1
                c.0 = b.0 - 1
                d.0 = c.0
                d.1 = c.1 + 1
            }
        case .L:
            if figure[0].0 == figure[1].0 + 1 {
                a.0 = b.0
                c.0 = b.0
                a.1 = b.1 - 1
                c.1 = b.1 + 1
                d.1 = c.1
                d.0 = b.0 + 1
            } else {
                a.0 = b.0 + 1
                a.1 = b.1
                c.0 = b.0 - 1
                c.1 = b.1
                d.0 = c.0
                d.1 = c.1 + 1
            }
        case .J:
            if figure[0].0 == figure[1].0 + 1 {
                a.0 = b.0
                c.0 = b.0
                a.1 = b.1 - 1
                c.1 = b.1 + 1
                d.1 = c.1
                d.0 = b.0 - 1
            } else {
                a.0 = b.0 + 1
                a.1 = b.1
                c.0 = b.0 - 1
                c.1 = b.1
                d.0 = c.0
                d.1 = c.1 - 1
            }
        case .T:
            if c.0 - 1 == d.0 {
                a.1 = c.1
                a.0 = c.0 - 1
                b.1 = c.1
                b.0 = c.0 + 1
                d.0 = c.0
                d.1 = c.1 + 1
            } else if c.0  == d.0 {
                a.0 = c.0
                a.1 = c.1 + 1
                b.0 = c.0
                b.1 = c.1 - 1
                d.1 = c.1
                d.0 = c.0 + 1
            } else {
                a.0 = c.0
                a.1 = c.1 + 1
                b.0 = c.0
                b.1 = c.1 - 1
                d.1 = c.1
                d.0 = c.0 - 1
            }
        }
        for i in [a, b, c, d]{
            if i.1 < 0 || i.1 > 9 || i.0 > 20 || i.0 < 0 || boxes[i.0][i.1].name == "full"{
                return
            }
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        figure[0] = a
        figure[1] = b
        figure[2] = c
        figure[3] = d
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }
    
    public func shiftDown(){
       
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fall), userInfo: nil, repeats: true)
    }
    
    let semaphore = DispatchSemaphore(value: 1)

    public func start(){
        shap = randomShapes()

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
            print("Scope: " + String(scope))
            
            return
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(fall), userInfo: nil, repeats: true)
        print("test")
        
    }
    
    func deleteRow(){
        var i = 1
        while i <= 20 {
//        for i in 1...20{
            var flag = true
            for j in 0...9{
                if (boxes[i][j].name != "full") {
                    flag = false
                    break
                }
            }
            if flag {
                scope += 1
                for j in i...19{
                    for k in 0...9{
                        if boxes[j+1][k].name == "full"{
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.orange
                            boxes[j][k].name = "full"
                        } else {
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                            boxes[j][k].name = "empty"
                        }
                    }
                    
                }
                i -= 1
            }
            i += 1
        }
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
                deleteRow()
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
        let a = Int.random(in: 3...6)
        return Shapes(rawValue: a)!
    }
}
