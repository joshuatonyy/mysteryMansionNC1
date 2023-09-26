//import UIKit
//import SpriteKit
//class SpriteScene: SKScene {
//
//    //change the code below to whatever you want to happen on skscene
//
//    override func didMove(to view: SKView) {
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        let location = touch.location(in: self)
//        let box = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
//        box.position = location
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
//        addChild(box)
//    }
//}
//
//
//  GameScene.swift
//  testHiddenObject
//
//  Created by Joshua on 23/03/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

class SpriteScene: SKScene {
    
    var objectsToFind = ["object1", "object2"]
    
    var knifeState = true
    var apronState = true
    

    var backgroundMusicPlayer: AVAudioPlayer!
    
//    func playBackgroundMusic(filename: String) {
//        if let path = Bundle.main.path(forResource: filename, ofType: "mp3") {
//            let url = URL(fileURLWithPath: path)
//            do {
//                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
//                backgroundMusicPlayer.numberOfLoops = -1
//                backgroundMusicPlayer.prepareToPlay()
//                backgroundMusicPlayer.play()
//            } catch {
//                print("Error playing background music: \(error.localizedDescription)")
//            }
//        } else {
//            print("Could not find file: \(filename)")
//        }
//    }
    
    override func didMove(to view: SKView) {
        for node in self.children {
            print(node.name ?? "No Name")
        }
        let knifeObject = SKSpriteNode(imageNamed: "let_s_draw_a_knife__by_halanlore_dchx9su-fullview")
        knifeObject.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(knifeObject)
       let apronObject = SKSpriteNode()
        let knifeLabel = SKLabelNode(text: "Knife")
        let apronLabel = SKLabelNode(text: "apron")
        var background = SKSpriteNode(imageNamed: "_")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
               addChild(background)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
         
                let location = touch.location(in: self)
                let box = SKSpriteNode(imageNamed: "knife")
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
                addChild(box)   }
    
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

