//
//  ViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 10.03.2022.
//

import UIKit
import SceneKit
import ARKit

protocol TetrisView{
    func endGame(scope: Int, _ pos: SCNVector3)
    func editScore(str: String)
}

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    let koef: Float = 20
    
    var arr : [[SCNNode]] = [[]]
    
    var tetris: TetrisEngine?
    
    
    let configuration: ARWorldTrackingConfiguration = {
        let controll = ARWorldTrackingConfiguration()
        controll.planeDetection = .horizontal
        return controll
    }()
    



    @objc func swipeToRight(sender: UISwipeGestureRecognizer){
        print("right")
        tetris?.shiftToRight()
    }
    
    
    @objc func swipeToLeft(sender: UISwipeGestureRecognizer){
        print("left")
        tetris?.shiftToLeft()
    }
    
    @objc func swipeToDown(sender: UISwipeGestureRecognizer){
        print("down")
        tetris?.shiftDown()
    }
    
   
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        print("touch")
        if tetris != nil || arr == [[]] {
            return
        }
        scoreLabel.text = "0"
        gameOverLabel.removeFromSuperview()
        tetris = TetrisEngine(arr, view: self)
        tetris?.start()
    }
    
    @objc func swipeToUp(sender: UISwipeGestureRecognizer){
        print("up")
        tetris?.turn()
    }

    
    let scoreLabel : UILabel = {
        let control = UILabel()
        control.textColor = .white
        control.font = control.font.withSize(40)
        control.text = String(0)
        return control
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let swipeRight  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToRight))
        let swipeLeft  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToLeft))
        let swipeDown  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToDown))
        let swipeUp  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToUp))
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))

        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        
        sceneView.addGestureRecognizer(gesture)
        sceneView.addGestureRecognizer(swipeRight)
        sceneView.addGestureRecognizer(swipeLeft)
        sceneView.addGestureRecognizer(swipeDown)
        sceneView.addGestureRecognizer(swipeUp)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        let backgrond = UIView()
        backgrond.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        sceneView.addSubview(backgrond)
        backgrond.translatesAutoresizingMaskIntoConstraints = false
        backgrond.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 40).isActive = true
        backgrond.rightAnchor.constraint(equalTo: sceneView.rightAnchor, constant: -10).isActive = true
        backgrond.heightAnchor.constraint(equalToConstant: 100).isActive = true
        backgrond.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backgrond.layer.cornerRadius = 5
        
        backgrond.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: backgrond.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: backgrond.centerYAnchor).isActive = true
//        scoreLabel.topAnchor.constraint(equalTo: backgrond.topAnchor, constant: 25).isActive = true
//        scoreLabel.leftAnchor.constraint(equalTo: backgrond.leftAnchor, constant: 45).isActive = true
//        scoreLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        scoreLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
//        sceneView.debugOptions = [.showWorldOrigin]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        if arr != [[]] {return}
        let planeNode = createFloorNode(anchor: planeAnchor)
        for nodes in planeNode {
            node.addChildNode(nodes)
        }
        
    }
    
    
    var vec: SCNVector3?
    
    func createFloorNode(anchor: ARPlaneAnchor) -> [SCNNode]{
        var a : [SCNNode] = []
        var height: Float = 0
        var countHeight = 0
        while countHeight < 20 {
            var row : [SCNNode] = []
            countHeight += 1
            var length = anchor.center.x - ((Float(CGFloat(anchor.extent.x))/koef)*5)
            var count  = 0
            while count < 10{
                count += 1
                let geometry = SCNBox(width: CGFloat(anchor.extent.x)/CGFloat(koef), height: CGFloat(anchor.extent.x)/CGFloat(koef), length: CGFloat(anchor.extent.x)/CGFloat(koef), chamferRadius: 0)
                let floorNode = SCNNode(geometry: geometry)
                floorNode.position = SCNVector3(x: length, y: height, z: anchor.center.z)
                floorNode.geometry?.firstMaterial?.isDoubleSided = true
                floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                floorNode.geometry?.firstMaterial?.isDoubleSided = true
                floorNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
                floorNode.name = "Plane"
                a.append(floorNode)
                row.append(floorNode)
                length += Float(CGFloat(anchor.extent.x))/koef
            }
            arr.append(row)
            height += Float(CGFloat(anchor.extent.x))/koef
        }
        return a
    }
    
    let gameOverLabel: UILabel = {
        let control = UILabel()
        control.numberOfLines = 0
        control.font = control.font.withSize(70)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
}


extension ViewController: TetrisView{
    func editScore(str: String) {
        scoreLabel.text = str
    }
    
    
    
    func endGame(scope: Int, _ pos: SCNVector3) {
        print("func")
        
        gameOverLabel.text = "Game over\n Scope: " + String(scope)
       
        sceneView.addSubview(gameOverLabel)

        gameOverLabel.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        gameOverLabel.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor).isActive = true
        tetris = nil
    }
    
    
}



