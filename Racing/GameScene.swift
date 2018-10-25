//
//  GameScene.swift
//  Racing
//
//  Created by paula on 2018-10-23.
//  Copyright © 2018 paula. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var whalePlayer = SKSpriteNode()
    var landRight = SKSpriteNode()
    var landLeft = SKSpriteNode()
    
    var location = CGPoint(x: 0, y: 0)
    
    var lakeMinX = CGFloat()
    var lakeMaxX = CGFloat()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.createLakeWave), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.treeObstacles), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        showLakeWave()
        //showTrees()
        removeItems()
    }
    
    func setUp() {
        whalePlayer = self.childNode(withName: "whalePlayer") as! SKSpriteNode
        landRight = self.childNode(withName: "landRight") as! SKSpriteNode
        landLeft = self.childNode(withName: "landLeft") as! SKSpriteNode
        
        landRight.zPosition = 10
        landLeft.zPosition = 10
        
        lakeMaxX = UIScreen.main.bounds.maxX - landRight.size.width
        lakeMinX = -lakeMaxX
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
            tree.name = "mediumTreeR"
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
        
//        let randomN = Int.random(in: 1...12)
//        switch randomN {
//        case 1...4:
//            tree.position.x = lakeMaxX - tree.size.width/2
//        case 5...8:
//            tree.position.x = lakeMinX + tree.size.width/2
//        default:
//            tree.position.x = 0
//        }
        
        tree.position.y = 700
        addChild(tree)
    }
    
    func removeItems() {
        for child in children {
            if child.position.y < -self.size.height - 100 {
                child.removeFromParent()
            }
        }
    }
}
