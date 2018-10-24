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
    
    var canMove = false
    var whaleToMove = true
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.createLakeWave), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        showLakeWave()
        removeItems()
    }
    
    func setUp() {
        whalePlayer = self.childNode(withName: "whalePlayer") as! SKSpriteNode
    }
    
    @objc func createLakeWave() {
        let lakeWave = SKShapeNode(ellipseOf: CGSize(width: 40, height: 10))
        lakeWave.strokeColor = SKColor.white
        lakeWave.fillColor = SKColor.white
        lakeWave.alpha = 0.5
        lakeWave.name = "lakeWave"
        //lakeWave.zPosition = 10
        lakeWave.position.x = 0
        lakeWave.position.y = 700
        addChild(lakeWave)
    }
    
    func showLakeWave() {
        enumerateChildNodes(withName: "lakeWave", using: { (lakeWave, stop) in
          let wave = lakeWave as! SKShapeNode
            wave.position.y -= 70
            
            let randomNum = Int.random(in: 1...3)
            if randomNum == 1 {
                wave.position.x -= 50
            }
            if randomNum == 2 {
                wave.position.x += 5
            }
            if randomNum == 3 {
                wave.position.x += 50
            }
            
        })
    }
    
    func removeItems() {
        for child in children {
            if child.position.y < -self.size.height - 100 {
                child.removeFromParent()
            }
        }
    }
}
