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
    
    @IBOutlet var sceneView: ARSCNView!
    let koef: Float = 10
    
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
    
   
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        print("touch")
        if tetris != nil || arr == [[]] {
            return
        }
        tetris = TetrisEngine(arr)
        tetris?.start()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToRight))
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        sceneView.addGestureRecognizer(gesture)
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        sceneView.addGestureRecognizer(swipeRight)
        sceneView.addGestureRecognizer(swipeLeft)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        sceneView.debugOptions = [.showWorldOrigin]
        
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

