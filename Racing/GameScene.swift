//
//  GameScene.swift
//  Racing
//
//  Created by paula on 2018-10-23.
//  Copyright © 2018 paula. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var whalePlayer = SKSpriteNode()
    var landRight = SKSpriteNode()
    var landLeft = SKSpriteNode()
    
    var location = CGPoint(x: 0, y: 0)
    
    var lakeMinX = CGFloat()
    var lakeMaxX = CGFloat()
    
    var timePassed = Int()
    var calcScore = Int()
    var score = SKLabelNode()
    //var maxScore = Int()
        
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        physicsWorld.contactDelegate = self
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.createLakeWave), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.treeObstacles), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(GameScene.updateTimer)), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        showLakeWave()
        removeItems()
    }
    
    @objc func updateTimer() {
        timePassed += 1
        
        calcScore += (10 * timePassed)
        score.text = "Score: \(calcScore)"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        //var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "whalePlayer" {
            firstBody = contact.bodyA
            //secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            //secondBody = contact.bodyA
        }
        firstBody.node?.removeFromParent()
        
//        if maxScore < calcScore {
//            maxScore = calcScore
//        }
        
        afterCollision()
    }
    
    func setUp() {
        whalePlayer = self.childNode(withName: "whalePlayer") as! SKSpriteNode
        landRight = self.childNode(withName: "landRight") as! SKSpriteNode
        landLeft = self.childNode(withName: "landLeft") as! SKSpriteNode
        
        score = self.childNode(withName: "score") as! SKLabelNode
        score.position.x = -(UIScreen.main.bounds.maxX - CGFloat(180))
        score.position.y = UIScreen.main.bounds.maxY - CGFloat(250)
        score.zPosition = 20
        
        landRight.zPosition = 10
        landLeft.zPosition = 10
        
        lakeMaxX = UIScreen.main.bounds.maxX - landRight.size.width
        lakeMinX = -lakeMaxX
        
        whalePlayer.physicsBody?.categoryBitMask = ColliderType.PLAYER_COLLIDER
        whalePlayer.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        whalePlayer.physicsBody?.collisionBitMask = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.x <= (lakeMaxX - whalePlayer.size.width/2) && location.x >= (lakeMinX + whalePlayer.size.width/2) {
                whalePlayer.position.x = location.x
            }
            
            whalePlayer.position.y = location.y
        }
    }
    
    @objc func createLakeWave() {
        let lakeWave = SKShapeNode(ellipseOf: CGSize(width: 80, height: 10))
        lakeWave.strokeColor = SKColor.white
        lakeWave.fillColor = SKColor.white
        lakeWave.alpha = 0.5
        lakeWave.name = "lakeWave"
        
        let randomNum = Int.random(in: 1...3)
        switch randomNum {
        case 1:
            lakeWave.position.x = 50
        case 2:
            lakeWave.position.x = -50
        case 3:
            lakeWave.position.x = 0
        default:
            lakeWave.position.x = 0
        }
        
        lakeWave.position.y = 700
        addChild(lakeWave)
    }
    
    func showLakeWave() {
        enumerateChildNodes(withName: "lakeWave", using: { (lakeWave, stop) in
          let wave = lakeWave as! SKShapeNode
            wave.position.y -= 20
            
            let randomNum = Int.random(in: 1...2)
            if randomNum == 1 {
                wave.position.x -= 5
            }
            if randomNum == 2 {
                wave.position.x += 5
            }
            
        })
        
        enumerateChildNodes(withName: "smallTreeR", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= 10
        })
        
        enumerateChildNodes(withName: "smallTreeL", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= 10
        })
        
        enumerateChildNodes(withName: "mediumTreeR", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= 10
        })
        
        enumerateChildNodes(withName: "mediumTreeL", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= 10
        })
    }
    
    @objc func treeObstacles() {
        let tree : SKSpriteNode!
        let randomNumber = Int.random(in: 1...16)
        
        switch randomNumber {
        case 1...4:
            tree = SKSpriteNode(texture: SKTexture.init(imageNamed: "treeShortRight"))
            tree.name = "smallTreeR"
            tree.size.width = 110
            tree.size.height = 60
            
            let randomN = Int.random(in: 1...8)
            switch randomN {
            case 1...4:
                tree.position.x = lakeMaxX - tree.size.width/2
            default:
                tree.position.x = 0
            }
            
            break
        case 5...8:
            tree = SKSpriteNode(texture: SKTexture.init(imageNamed: "treeShortLeft"))
            tree.name = "smallTreeL"
            tree.size.width = 110
            tree.size.height = 60
            
            let randomN = Int.random(in: 1...8)
            switch randomN {
            case 1...4:
                tree.position.x = lakeMinX + tree.size.width/2
            default:
                tree.position.x = 0
            }
            
            break
        case 9...12:
            tree = SKSpriteNode(texture: SKTexture.init(imageNamed: "treeMediumLeft"))
            tree.name = "mediumTreeL"
            tree.size.width = 300
            tree.size.height = 60
            
            let randomN = Int.random(in: 1...8)
            switch randomN {
            case 1...4:
                tree.position.x = lakeMinX + tree.size.width/2
            default:
                tree.position.x = 0
            }
            
            break
        default:
            tree = SKSpriteNode(texture: SKTexture.init(imageNamed: "treeMediumRight"))
            tree.name = "mediumTreeR"
            tree.size.width = 300
            tree.size.height = 60
            
            let randomN = Int.random(in: 1...8)
            switch randomN {
            case 1...4:
                tree.position.x = lakeMaxX - tree.size.width/2
            default:
                tree.position.x = 0
            }
            
            break
        }
        tree.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree.zPosition = 10
        tree.position.y = 700
        tree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tree.size.width - 20), height: (tree.size.height - 20)))
        tree.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        tree.physicsBody?.collisionBitMask = 0
        tree.physicsBody?.affectedByGravity = false
        addChild(tree)
    }
    
    func removeItems() {
        for child in children {
            if child.position.y < -self.size.height - 100 {
                child.removeFromParent()
            }
        }
    }
    
    func afterCollision() {
        if let menuScene = SKScene(fileNamed: "GameMenu") {
            menuScene.scaleMode = .aspectFill
            view?.presentScene(menuScene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: TimeInterval(1)))
        }
    }
}
