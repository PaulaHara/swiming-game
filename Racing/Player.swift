//
//  Player.swift
//  Racing
//
//  Created by Paula on 11/7/18.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    func setUpPlayer(playerName: String) -> SKSpriteNode {
        let player = self.childNode(withName: playerName) as! SKSpriteNode
        
        player.zPosition = 10
        
        player.physicsBody?.categoryBitMask = ColliderType.PLAYER_COLLIDER
        player.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        player.physicsBody?.collisionBitMask = 0
        
        return player
    }
    
}
