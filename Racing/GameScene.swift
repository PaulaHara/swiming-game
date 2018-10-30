//
//  GameScene.swift
//  Racing
//
//  Created by paula on 2018-10-23.
//  Copyright © 2018 paula. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var whalePlayer = SKSpriteNode()
    var landRight = SKSpriteNode()
    var landLeft = SKSpriteNode()
    var donut = SKSpriteNode()
    
    var location = CGPoint(x: 0, y: 0)
    
    var lakeMinX = CGFloat()
    var lakeMaxX = CGFloat()
    var lakeMaxY = CGFloat()
    
    var timePassed = Int()
    var calcScore = Int()
    var score = SKLabelNode()
    var velocity = CGFloat(10)
    var maxScore = Int()
    var obstaclesPassed = Int()
    
    var audioPlayer: AVAudioPlayer?
    var soundEffects: AVAudioPlayer?
        
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        physicsWorld.contactDelegate = self
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.createLakeWave), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.treeObstacles), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(GameScene.createDonut), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: (#selector(GameScene.updateTimer)), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Will delay for 1 second the starting of the music
            if let path = Bundle.main.path(forResource: "Gameplay-Music", ofType: ".mp3") {
                let url = URL(fileURLWithPath: path)
                self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
                
                if let player = self.audioPlayer {
                    player.play()
                    player.numberOfLoops = -1
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        showGameObjects()
        removeItems()
    }
    
    @objc func updateTimer() {
        timePassed += 1
        
        calcScore += 5
        updateScoreText()
    }
    
    func updateScoreText() {
        score.text = "Score: \(calcScore)"
    }
    
    func playSoundEffects(soundName: String, type: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: type) {
            let url = URL(fileURLWithPath: path)
            soundEffects = try? AVAudioPlayer(contentsOf: url)
            
            if let sfx = soundEffects {
                sfx.volume = Float(5)
                sfx.play()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var gotADonut = false
        
        if contact.bodyA.node?.name == "whalePlayer" && contact.bodyB.node?.name == "donut" {
            firstBody = contact.bodyB
            gotADonut = true
        } else if contact.bodyA.node?.name == "donut" && contact.bodyB.node?.name == "whalePlayer" {
            firstBody = contact.bodyA
            gotADonut = true
        } else if contact.bodyA.node?.name == "whalePlayer" {
            firstBody = contact.bodyA
        } else {
            firstBody = contact.bodyB
        }
        firstBody.node?.removeFromParent()
        
        if !gotADonut { // Player hit a tree
            playSoundEffects(soundName: "demage-sound", type: ".mp3")
            
            maxScore = ScoreType.highScore
            if maxScore < calcScore {
                ScoreType.highScore = calcScore
            }
            
            if let player = audioPlayer {
                player.stop()
            }
            afterCollision()
        } else { // Player got a donut
            playSoundEffects(soundName: "coin-sound", type: ".mp3")
            
            calcScore += 50
            updateScoreText()
        }
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
        lakeMaxY = UIScreen.main.bounds.maxY
        
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
        
        lakeWave.position.y = lakeMaxY
        addChild(lakeWave)
    }
    
    func showGameObjects() {
        enumerateChildNodes(withName: "lakeWave", using: { (lakeWave, stop) in
          let wave = lakeWave as! SKShapeNode
            wave.position.y -= 20 + CGFloat(self.timePassed/10)
            
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
            tree.position.y -= self.velocity + CGFloat(self.timePassed/10)
        })
        
        enumerateChildNodes(withName: "mediumTreeR", using: { (treeMedium, stop) in
            let tree = treeMedium as! SKSpriteNode
            tree.position.y -= self.velocity + CGFloat(self.timePassed/10)
        })
        
        enumerateChildNodes(withName: "mediumTreeL", using: { (treeMedium, stop) in
            let tree = treeMedium as! SKSpriteNode
            tree.position.y -= self.velocity + CGFloat(self.timePassed/10)
        })
        
        enumerateChildNodes(withName: "donut", using: { (prize, stop) in
            let donut = prize as! SKSpriteNode
            donut.position.y -= self.velocity + CGFloat(self.timePassed/10)
        })
    }
    
    @objc func treeObstacles() {
        let randomNumber = Int.random(in: 1...50)
        
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
        case 41...45:
            createTree(treeName: "smallTreeR", treeImgName: "treeShortRight", widthSize: CGFloat(110), positionX: lakeMaxX - CGFloat(110)/2, calcPositionX: false)
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: 0, calcPositionX: false)
            createTree(treeName: "smallTreeL", treeImgName: "treeShortLeft", widthSize: CGFloat(110), positionX: lakeMinX + CGFloat(110)/2, calcPositionX: false)
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
        tree.position.y = lakeMaxY
        
        tree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tree.size.width - 20), height: (tree.size.height - 20)))
        tree.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        tree.physicsBody?.collisionBitMask = 0
        tree.physicsBody?.affectedByGravity = false
        
        addChild(tree)
    }
    
    @objc func createDonut() {
        let donutPrize = SKSpriteNode(texture: SKTexture(imageNamed: "donut"))
        donutPrize.size.width = 50
        donutPrize.size.height = 50
        donutPrize.name = "donut"
        
        let randomN = Int.random(in: 1...15)
        switch randomN {
        case 1...5:
            donutPrize.position.x = lakeMinX + donutPrize.size.width
        case 6...10:
            donutPrize.position.x = lakeMaxX - donutPrize.size.width
        default:
            donutPrize.position.x = 0
        }
        
        donutPrize.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        donutPrize.zPosition = 10
        donutPrize.position.y = lakeMaxY + donutPrize.size.height + 10
        
        donutPrize.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (donutPrize.size.width - 20), height: (donutPrize.size.height - 20)))
        donutPrize.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        donutPrize.physicsBody?.collisionBitMask = 0
        donutPrize.physicsBody?.affectedByGravity = false
        
        addChild(donutPrize)
    }
    
    func removeItems() {
        for child in children {
            if child.position.y < -self.size.height - 100 {
                child.removeFromParent()
                calcScore += 1
            }
        }
    }
    
    func afterCollision() {
        if let menuScene = SKScene(fileNamed: "GameMenu") {
            menuScene.scaleMode = .aspectFill
            view?.presentScene(menuScene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: TimeInterval(0.5)))
        }
    }
}
