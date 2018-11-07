//
//  ConfigurationMenu.swift
//  Racing
//
//  Created by paula on 2018-11-06.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class ConfigurationMenu: SKScene {
    
    var muteBtn = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        muteBtn = self.childNode(withName: "muteBtn") as! SKSpriteNode
        muteBtn.zPosition = 10
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches {
    //            let touchLocation = touch.location(in: self)
    //            if atPoint(touchLocation).name == "startGame" {
    //
    //            }
    //        }
    //    }
    
}
