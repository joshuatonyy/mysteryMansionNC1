////
////  exampleCode.swift
////  testHiddenObject
////
////  Created by Joshua on 23/03/23.
////
//
//import Foundation
//import SpriteKit
//
//class GameScene: SKScene {
//    
//    // Initialize the objects to be found
//    var objectsToFind = ["object1", "object2", "object3"]
//    
//    override func didMove(to view: SKView) {
//        // Add the background image
//        let background = SKSpriteNode(imageNamed: "background")
//        background.position = CGPoint(x: size.width/2, y: size.height/2)
//        addChild(background)
//        
//        // Add the objects to be found
//        for object in objectsToFind {
//            let hiddenObject = SKSpriteNode(imageNamed: object)
//            // Randomize the position of the hidden objects
//            hiddenObject.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
//            addChild(hiddenObject)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // Check if the user has tapped on a hidden object
//        for touch in touches {
//            let location = touch.location(in: self)
//            let nodesAtTouch = nodes(at: location)
//            for node in nodesAtTouch {
//                if objectsToFind.contains(node.name!) {
//                    // Remove the hidden object from the scene
//                    node.removeFromParent()
//                    // Update the objects to be found
//                    if let index = objectsToFind.firstIndex(of: node.name!) {
//                        objectsToFind.remove(at: index)
//                    }
//                    // Check if the game is over
//                    if objectsToFind.isEmpty {
//                        gameOver()
//                    }
//                }
//            }
//        }
//    }
//    
//    func gameOver() {
//        // Display a game over message
//        let gameOverLabel = SKLabelNode(text: "You found all the objects!")
//        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
//        addChild(gameOverLabel)
//        // Add a delay and then restart the game
//        let delay = SKAction.wait(forDuration: 2.0)
//        let restart = SKAction.run {
//            let newScene = GameScene(size: self.size)
//            newScene.scaleMode = self.scaleMode
//            self.view?.presentScene(newScene)
//        }
//        run(SKAction.sequence([delay, restart]))
//    }
//}
