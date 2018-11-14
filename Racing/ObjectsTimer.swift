//
//  GameObjects.swift
//  Racing
//
//  Created by Paula on 11/7/18.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

class ObjectsTimer: NSObject {
    
    func createActions(selector: Selector, duration: Double, mainNode: SKNode, target: SKScene) {
        let createObjects = SKAction.perform(selector, onTarget: target)
        let objects = SKAction.repeatForever(SKAction.sequence([createObjects, SKAction.wait(forDuration: duration)]))
        mainNode.run(objects)
    }
    
    func triggerAllTimers(objectsTimeInterval: Double, mainNode: SKNode, target: SKScene) {
        // Waves
        createActions(selector: #selector(GameScene.createLakeWave), duration: objectsTimeInterval/2, mainNode: mainNode, target: target)
        
        // Trees
        createActions(selector: #selector(GameScene.treeObstacles), duration: objectsTimeInterval, mainNode: mainNode, target: target)
        
        // Donuts
        createActions(selector: #selector(GameScene.createDonut), duration: objectsTimeInterval*4, mainNode: mainNode, target: target)
        
        // Time
        createActions(selector: #selector(GameScene.updateTimer), duration: 1, mainNode: mainNode, target: target)
    }
    
}
