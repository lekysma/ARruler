//
//  ViewController.swift
//  ARruler
//
//  Created by Jean martin Kyssama on 25/03/2020.
//  Copyright © 2020 Jean martin Kyssama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: - RELEVANT VARIABLES
    // array of scnNodes
    var arrayOfDotNodes = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //debug option so I can visualize better
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    //MARK: - Handles touch recognition
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // endroit ou on touche
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            //ce qui se passe si on touche un point
            if let hitResult = hitTestResults.first {
                //on affiche un cercle pour visualiser cela
                cercleRouge(at: hitResult)
                
            }
        }
     
    }
    
    //MARK: - Fonction creant un cercle
    func cercleRouge(at hitLocation: ARHitTestResult) {
        // on cree une sphere et on lui donne 1 rayon
        let dotGeometry = SCNSphere(radius: 0.005)
        // on cree un material
        let material = SCNMaterial()
        // on donne des valeurs au material
        material.diffuse.contents = UIColor.systemPurple
        
        // on affecte ces valeurs a la sphere
        dotGeometry.materials = [material]
        //positions sur l'endroit ou on a cliqué
        let dotNode = SCNNode()
        dotNode.position = SCNVector3(hitLocation.worldTransform.columns.3.x, hitLocation.worldTransform.columns.3.y, hitLocation.worldTransform.columns.3.z)
        
        //On place la sphere sur l'axe
        dotNode.geometry = dotGeometry
        // on place le node dans le sceneview
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        //PS : Chaque fois qu'on cree un node on l'ajoute au tableau de node
        arrayOfDotNodes.append(dotNode)
        //ensuite si on a au moins 2 point cliqués on peut calculer la distance soit
        if arrayOfDotNodes.count >= 2 {
            calculDeDistance()
        }
        // PS: meilleure visualisation
        sceneView.autoenablesDefaultLighting = true
    }
    
    //MARK: - Fonction qui permet de calculer la distance entre deux points sur lesquels on a cliqué
    func calculDeDistance() {
        let start = arrayOfDotNodes[0]
        let finish = arrayOfDotNodes[1]
        
        // pour calculer la distance on a besoin de 3 variables et d'une formule
        let a = finish.position.x - start.position.x
        let b = finish.position.y - start.position.y
        let c = finish.position.z - start.position.z
        
        // ensuite la formule: on additionne chaque element a qui on donne une exposant 2
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        //texteEn3D(texte: "\(distance)")
        
        // on imprime la distance en valeur absolue, pour ne pas prendre en compte les nombres negatifs x 100
        print("La distance est \(abs(distance * 100)) cm.")
        afficherLeTexteEn3D(text: "\(abs(distance * 100))cm")
      


    }
    
    //MARK: - Fonction qui gere le texte en 3D qui est la distance
    func afficherLeTexteEn3D(text: String) {
        // on cree un texte en 3d
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        //material
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.systemPurple
        textGeometry.materials = [textMaterial]
        //1 seul material affecté
        //textGeometry.firstMaterial?.diffuse.contents = UIColor.systemPurple
        
        //node
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(0, 0.01, -0.1)
        // taille de la figure
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
 
}
