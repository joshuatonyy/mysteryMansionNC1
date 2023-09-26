//
//  GameScene.swift
//  hiddenObjectGameSpriteKitManual
//
//  Created by Joshua on 26/03/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var objectsToFind = ["object1", "object2", "object3", "object4"]
    var (photoState, napkinState, foodState, syringeState) = (true, true, true, true)
    var photoLabel = SKLabelNode(fontNamed: "Groteska-Bold")
    var foodLabel = SKLabelNode(fontNamed: "Groteska-Bold")
    var syringeLabel = SKLabelNode(fontNamed: "Groteska-Bold")
    var napkinLabel = SKLabelNode(fontNamed: "Groteska-Bold")
    var backgroundMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        //Background Image
        let backgroundImage = SKSpriteNode(imageNamed: "Main Game Scene (Blank)")
        backgroundImage.name = "backgroundImage"
        backgroundImage.size = CGSize(width: 390, height: 844)
        backgroundImage.position = CGPoint(x: 200, y: 430)
        backgroundImage.zPosition = -3
        addChild(backgroundImage)
        
        //Object Photo
        let objectPhoto = SKSpriteNode(imageNamed: "Item 1_ Photo")
        objectPhoto.name = "object1"
        objectPhoto.size = CGSize(width: 32.7, height: 21.5)
        objectPhoto.position = CGPoint(x: 51, y: 191)
        addChild(objectPhoto)
        
        //Object Napkin
        let objectNapkin = SKSpriteNode(imageNamed: "Item 2_ Napkin")
        objectNapkin.name = "object2"
        objectNapkin.size = CGSize(width: 71.933, height: 24.59)
        objectNapkin.position = CGPoint(x: 117.966, y: 319)
        addChild(objectNapkin)
        
        //Object Food
        let objectFood = SKSpriteNode(imageNamed: "Item 3_ Food")
        objectFood.name = "object3"
        objectFood.size = CGSize(width: 59.813 , height: 15.955)
        objectFood.position = CGPoint(x: 263.217, y: 365.6)
        addChild(objectFood)

        //Object Syringe
        let objectSyringe = SKSpriteNode(imageNamed: "Item 4_ Syringe")
        objectSyringe.name = "object4"
        objectSyringe.size = CGSize(width: 59.813, height: 16.396)
        objectSyringe.position = CGPoint(x: 355.907, y: 215.437)
        addChild(objectSyringe)
        
        //Dialog Box
        let dialogBox = SKSpriteNode(imageNamed: "Dialog Box Example2")
        dialogBox.name = "dialogBox"
        dialogBox.size = CGSize(width: 396.435 , height: 99.931)
        dialogBox.position = CGPoint(x: 203.217, y: 57.965)
        dialogBox.zPosition = -2
        addChild(dialogBox)
        
        //Label Item

        photoLabel.text = "Memories"
        photoLabel.fontSize = 13
        photoLabel.position = CGPoint(x: 92.359 , y: 68.021)
        addChild(photoLabel)
        

        foodLabel.text = "To Serve Food"
        foodLabel.fontSize = 13
        foodLabel.position = CGPoint(x: 92.854, y: 33)
        addChild(foodLabel)
        

        syringeLabel.text = "Medical Instrument"
        syringeLabel.fontSize = 13
        syringeLabel.position = CGPoint(x: 282, y: 66.439)
        addChild(syringeLabel)
        

        napkinLabel.text = "Small Piece of Cloth"
        napkinLabel.fontSize = 13
        napkinLabel.position = CGPoint(x: 282.005, y: 32.769)
        addChild(napkinLabel)
        
        //Play Background Music Function
        if let musicURL = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer.numberOfLoops = -1 // Set to -1 to loop indefinitely
                backgroundMusicPlayer.prepareToPlay()
            } catch {
                print("Error loading music file")
            }
        }
        
        backgroundMusicPlayer.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtTouch = nodes(at: location)
            for node in nodesAtTouch {
                if objectsToFind.contains(node.name!) {
                    
                    // Remove the hidden object from the scene
                    node.removeFromParent()
                    run(SKAction.playSoundFileNamed("itemfound.mp3", waitForCompletion: false))
                    
                    // Update the objects to be found
                    if let index = objectsToFind.firstIndex(of: node.name!) {
                        if node.name! == "object1" {
                            photoState = false
                            photoLabel.text = "Affair Photo"
                            photoLabel.position = CGPoint(x: 92.359 , y: 68.021)
                            photoLabel.fontColor = UIColor.red
                        }
                        else if node.name! == "object2" {
                            napkinState = false
                            napkinLabel.text = "Napkin"
                            napkinLabel.fontColor = UIColor.red
                            napkinLabel.position = CGPoint(x: 282.005, y: 32.769)
                        }
                        else if node.name! == "object3" {
                            foodState = false
                            foodLabel.text = "Poisoned Food Plate"
                            foodLabel.position = CGPoint(x: 92.854, y: 33)
                            foodLabel.fontColor = UIColor.red
                        }
                        else if node.name! == "object4" {
                            syringeState = false
                            syringeLabel.text = "Syringe"
                            syringeLabel.position = CGPoint(x: 282.52, y: 66.439)
                            syringeLabel.fontColor = UIColor.red
                        }
                        objectsToFind.remove(at: index)
                    }
                    
                    
                    // Check if the game is over
                    func checkAllItemsFound() {
                        if objectsToFind.isEmpty{ //or if object in array is null or 0
                        
                             //let popupview = PopUpView(isAllItemsFound = true)
                            } else {
                           //PopUpView(isAllItemsFound = false)
                            }
                        }
                }

                }

            }
        }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
