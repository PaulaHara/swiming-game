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
    var velocity = CGFloat(10)
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
        
        calcScore += (5 * timePassed)
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
            tree.position.y -= self.velocity + CGFloat(self.timePassed/10)
        })
        
        enumerateChildNodes(withName: "smallTreeL", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= self.velocity
        })
        
        enumerateChildNodes(withName: "mediumTreeR", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= self.velocity
        })
        
        enumerateChildNodes(withName: "mediumTreeL", using: { (treeSmall, stop) in
            let tree = treeSmall as! SKSpriteNode
            tree.position.y -= self.velocity
        })
    }
    
    @objc func treeObstacles() {
        let randomNumber = Int.random(in: 1...45)
        
        switch randomNumber {
        case 1...5:
            createTree(treeName: "smallTreeR", treeImgName: "treeShortRight", widthSize: CGFloat(110), positionX: nil, calcPositionX: true)
            break
        case 6...10:
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: nil, calcPositionX: true)
            break
        case 11...15:
            createTree(treeName: "mediumTreeR", treeImgName: "treeMediumRight", widthSize: CGFloat(300), positionX: nil, calcPositionX: true)
            break
        case 16...20:
            createTree(treeName: "smallTreeR", treeImgName: "treeShortRight", widthSize: CGFloat(110), positionX: lakeMaxX - CGFloat(110)/2, calcPositionX: false)
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: lakeMinX + CGFloat(110)/2, calcPositionX: false)
            break
        case 21...25:
            createTree(treeName: "smallTreeR", treeImgName: "treeShortRight", widthSize: CGFloat(110), positionX: lakeMaxX - CGFloat(110)/2, calcPositionX: false)
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: 0, calcPositionX: false)
            break
        case 22...30:
            createTree(treeName: "smallTreeR", treeImgName: "treeShortRight", widthSize: CGFloat(110), positionX: 0, calcPositionX: false)
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: lakeMinX + CGFloat(110)/2, calcPositionX: false)
            break
        case 31...35:
            createTree(treeName: "smallTreeR", treeImgName: "treeShortRight", widthSize: CGFloat(110), positionX: lakeMaxX - CGFloat(110)/2, calcPositionX: false)
            createTree(treeName: "mediumTreeL", treeImgName: "treeMediumLeft", widthSize: CGFloat(300), positionX: lakeMinX + CGFloat(300)/2, calcPositionX: false)
            break
        case 36...40:
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: lakeMinX + CGFloat(110)/2, calcPositionX: false)
            createTree(treeName: "mediumTreeR", treeImgName: "treeMediumRight", widthSize: CGFloat(300), positionX: lakeMaxX - CGFloat(300)/2, calcPositionX: false)
            break
        default:
            createTree(treeName: "mediumTreeL", treeImgName: "treeMediumLeft", widthSize: CGFloat(300), positionX: nil, calcPositionX: true)
            break
        }
    }
    
    func createTree(treeName: String, treeImgName: String, widthSize: CGFloat, positionX: CGFloat?, calcPositionX: Bool){
        let tree: SKSpriteNode!
        
        tree = SKSpriteNode(texture: SKTexture.init(imageNamed: treeImgName))
        tree.name = treeName
        tree.size.height = 60
        tree.size.width = widthSize
        
        if calcPositionX {
            let randomN = Int.random(in: 1...15)
            switch randomN {
            case 1...5:
                if treeName.range(of: "R") != nil {
                    tree.position.x = lakeMaxX - widthSize/2
                } else if treeName.range(of: "L") != nil {
                    tree.position.x = lakeMinX + widthSize/2
                }
            case 6...10:
                if treeName.range(of: "R") != nil && treeName.range(of: "small") != nil {
                    tree.position.x = lakeMaxX - widthSize/2 - whalePlayer.size.width - CGFloat(randomN)*10
                } else if treeName.range(of: "L") != nil && treeName.range(of: "small") != nil {
                    tree.position.x = lakeMinX + widthSize/2 + whalePlayer.size.width + CGFloat(randomN)*10
                } else {
                    fallthrough
                }
            default:
                tree.position.x = 0
            }
        } else {
            tree.position.x = positionX!
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
