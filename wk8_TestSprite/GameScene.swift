//
//  GameScene.swift
//  wk8_TestSprite
//
//  Created by Jean on 2019-10-31.
//  Copyright © 2019 Jean. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTime: Double = 0
    var currTime: Double = 0
    var gameStarted: Bool = false
    var score: Double = 0
    
    var pepes: SKNode?
    var labelTime: SKLabelNode?
    var labelScore: SKLabelNode?
    var labelStart: SKLabelNode?
    var labelMessage: SKLabelNode?
    var shapeTap: SKShapeNode?
    
    
    override func didMove(to view: SKView) {
        //get nodes in the scene
        self.labelTime = self.childNode(withName: "time") as? SKLabelNode
        self.labelScore = self.childNode(withName: "score") as? SKLabelNode
        self.labelStart = self.childNode(withName: "start") as? SKLabelNode
        self.pepes = self.childNode(withName: "pepes")
        
        //create circle node for tap event with fadeout animation
        self.shapeTap = SKShapeNode(circleOfRadius: 50)
        self.shapeTap?.lineWidth = 6
        self.shapeTap?.strokeColor = .red
        self.shapeTap?.run(SKAction.scale(to: 2, duration: 0.5))
        self.shapeTap?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),SKAction.removeFromParent()]))
    }
    
    func startGame() {
        //init score and time
        self.gameStarted = true
        self.gameTime = 0
        self.score = 0
        self.labelTime?.text = "Time: 0"
        self.labelScore?.text = "Score: \(score)"
        
        //start downfall animation for pepes
        guard let actionFall = SKAction(named: "fall")
            else {
                return
        }
        self.pepes?.run(actionFall)
    }
    
    func endGame() {
        //reset game state
        self.gameStarted = false
        self.labelStart?.text = "Restart"
        self.labelStart?.setScale(1)
        self.labelStart?.alpha = 1 //make visible
        
        var message: String
        if self.score >= 90 {
            message = "You passed: A+"
        } else if self.score >= 80 {
            message = "You passed: A"
        } else if self.score >= 70 {
            message = "You passed: B"
        } else if self.score >= 60 {
            message = "You passed: C"
        } else if self.score >= 50 {
            message = "You passed: D"
        } else {
            message = "You failed this course!"
        }
        
        self.labelMessage?.text = message
        self.labelMessage?.isHidden = false  //make visible
        
        self.pepes?.position = CGPoint(x: 0, y: 0) //reset position
        self.pepes?.enumerateChildNodes(withName: "pepe", using: {
            node, stop in node.alpha = 1
        })
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch node and its name
        //NOTE: if no touch, do nothing
        guard let touch = touches.first else {
            return
        }
        let touchPos = touch.location(in: self)
        
        //HitTest: atPoint() returns a non-optional SKNode
        let node = self.atPoint(touchPos)
        
        //hit on start label
        if node.name == "start" {
            //start game
            self.labelMessage?.isHidden = true //hide message label
            if let action = SKAction(named: "scalefade") {
                node.run(action, completion: {
                    self.startGame()
                })
            }
        } else if node.name == "pepe" {
            //add score
            self.score += 10
            self.labelScore?.text = "score: \(self.score)"
            
            //hide node
            node.alpha = 0
        }
        
        //display a circle where user taps on
        if let tap = self.shapeTap?.copy() as? SKShapeNode {
            tap.position = touchPos //set circle position
            self.addChild(tap)
        }
    }
    
    /*
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
     }
     
     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     
     }
     */
    
    
    override func update(_ currentTime: TimeInterval) {
        //update game time
        let deltaTime = currentTime - self.currTime
        self.currTime = currentTime
        if self.gameStarted {
            self.gameTime += deltaTime
            self.labelTime?.text = String(format: "Time: %.1f", self.gameTime)
            
            //stop the game
            if self.gameTime >= 5.0 {
                endGame()
            }
        }
    }
}
