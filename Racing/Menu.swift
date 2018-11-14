//
//  Menu.swift
//  Racing
//
//  Created by Paula on 11/7/18.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

class Menu {
    
    var continueBtn = SKShapeNode()
    var pauseText = SKLabelNode()
    var unpauseBtn = SKShapeNode()
    
    let gameObjects = ObjectsTimer()
    
    var gameIsPaused = true
    
    func createButtons(scene: SKScene, configuration: inout SKSpriteNode, pauseBtn: inout SKSpriteNode) {
        configuration = scene.childNode(withName: "configuration") as! SKSpriteNode
        pauseBtn = scene.childNode(withName: "pause") as! SKSpriteNode
        
        configuration.position.x = UIScreen.main.bounds.maxX - CGFloat(110)
        configuration.position.y = -(UIScreen.main.bounds.maxY - CGFloat(200))
        configuration.zPosition = 10
        
        pauseBtn.position.x = UIScreen.main.bounds.maxX - CGFloat(110)
        pauseBtn.position.y = UIScreen.main.bounds.maxY - CGFloat(200)
        pauseBtn.zPosition = 10
    }
    
    func createContinueButton() {
        continueBtn = SKShapeNode(rectOf: CGSize(width: 200, height: 80), cornerRadius: 10)
        continueBtn.name = "continueBtn"
        continueBtn.fillColor = .black
        continueBtn.zPosition = 20
        
        let btnText = SKLabelNode(text: "Continue")
        btnText.fontSize = 40
        btnText.fontColor = .white
        btnText.zPosition = 20
        
        continueBtn.addChild(btnText)
    }
    
    func createUnpauseButton() {
        unpauseBtn = SKShapeNode(rectOf: CGSize(width: 200, height: 80), cornerRadius: 10)
        unpauseBtn.name = "unpauseBtn"
        unpauseBtn.fillColor = .black
        unpauseBtn.zPosition = 20
        
        let btnText = SKLabelNode(text: "Continue")
        btnText.fontSize = 40
        btnText.fontColor = .white
        btnText.zPosition = 20
        btnText.position.x = 0
        btnText.position.y = 0
        
        unpauseBtn.addChild(btnText)
    }
    
    func pauseGame(scene: SKScene, mainNode: SKNode, pauseScreen: SKSpriteNode) {
//        createUnpauseButton()
//
//        pauseText = SKLabelNode(text: "Paused")
//        pauseText.name = "pauseText"
//        pauseText.fontSize = 70
//        pauseText.fontColor = .red
//        pauseText.position.x = 0
//        pauseText.position.y = 0
//        pauseText.zPosition = 20
//
//        unpauseBtn.position.x = 0
//        unpauseBtn.position.y = -80
//        unpauseBtn.zPosition = 20
//
//        scene.addChild(pauseText)
//        scene.addChild(unpauseBtn)
        
        pauseScreen.alpha = 0.7
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            scene.isPaused = true
        }
    }
    
    func unpauseGame(scene: SKScene, objectsTimeInterval: Double, mainNode: SKNode, pauseScreen: SKSpriteNode) {
//        pauseText.removeFromParent()
//        unpauseBtn.removeFromParent()
        
//        scene.childNode(withName: "pauseText")?.removeFromParent()
        
        //pauseText.alpha = 0
//        print("here")
        scene.isPaused = false
        pauseScreen.alpha = 0
    }
    
    func openConfig(scene: SKScene, gameLayer: SKNode) {
        createContinueButton()
        
        let configMenu = SKShapeNode(rectOf: CGSize(width: 700, height: 500), cornerRadius: 10)
        configMenu.name = "configMenu"
        configMenu.addChild(continueBtn)
        configMenu.fillColor = .gray
        configMenu.position.x = 0
        configMenu.position.y = 0
        configMenu.zPosition = 20
        
        continueBtn.position.x = 0
        continueBtn.position.y = 0
        
        scene.addChild(configMenu)
        
        //gameObjects.invalidateAllTimers(invalidateTime: true)
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            gameLayer.isPaused = true
        //}
    }
    
    func closeConfig(gameLayer: SKNode) {
        if let configMenu = gameLayer.childNode(withName: "configMenu") {
            configMenu.removeFromParent()
        }
        gameLayer.isPaused = false
    }
}
