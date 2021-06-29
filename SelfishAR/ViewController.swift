//
//  ViewController.swift
//  SelfishAR
//
//  Created by Mauricio Dias on 29/6/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let numberOfARObjectsToShow = 1
    var locationObjectDetected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //adding brightness to the scene
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Zombie Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = numberOfARObjectsToShow
            
            print("Images succesfully added.")
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    //Delegate method that detects the objects.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            //Create a plane of the same size of the image added in the project.
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //set the plane to be a bit transparent
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            //creates a plane node with the size of the image
            let planeNode = SCNNode(geometry: plane)
            
            //set the plane Node to be horizontally
            planeNode.eulerAngles.x = -.pi / 2
    
            node.addChildNode(planeNode)
            
            switch imageAnchor.referenceImage.name {
            case "zombie":
                locationObjectDetected = "art.scnassets/Zombie.scn"
                //add more cases for another objects
            default:
                locationObjectDetected = "art.scnassets/Zombie.scn"
            }

            
            if let zombieScene = SCNScene(named: locationObjectDetected) {
                
                if let zombieNode = zombieScene.rootNode.childNodes.first {
                    zombieNode.geometry = planeNode.geometry
                    zombieNode.eulerAngles.x = .pi / 2
                    // scaling the scene manually due to XCode does not permit scale less than 0.001
                    zombieNode.scale.x = 0.0005
                    zombieNode.scale.z = 0.0005
                    zombieNode.scale.y = 0.0005
                    planeNode.addChildNode(zombieNode)
                }
            }
        }
        
        return node
    }
}
