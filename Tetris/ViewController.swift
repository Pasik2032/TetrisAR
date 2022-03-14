//
//  ViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 10.03.2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Fields
    
    @IBOutlet var sceneView: ARSCNView!
    // the size of the field depends (inversely proportional)
    let koef: Float = 20
    
    // array with cubes
    var arr : [[SCNNode]] = [[]]
    
    // Game Engine
    var tetris: TetrisEngine?
    
    // Configuration for plane search
    let configuration: ARWorldTrackingConfiguration = {
        let controll = ARWorldTrackingConfiguration()
        controll.planeDetection = .horizontal
        return controll
    }()
    
    // Shows score
    let scoreLabel : UILabel = {
        let control = UILabel()
        control.textColor = .white
        control.font = control.font.withSize(40)
        control.text = String(0)
        return control
    }()
    
    // Label Game Over
    let gameOverLabel: UILabel = {
        let control = UILabel()
        control.numberOfLines = 0
        control.font = control.font.withSize(70)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ConfigSwipes()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        ConfigScoreLabel()
    }
    
    // MARK: - Swipes
    
    fileprivate func ConfigSwipes() {
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
    }
    
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
    
    // MARK: - Config label
    
    fileprivate func ConfigScoreLabel() {
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
    }
    
    //MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //sceneView.debugOptions = [.showWorldOrigin]
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
    
    // MARK: - Create boxes
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
    
    
}
