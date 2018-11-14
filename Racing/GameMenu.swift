//
//  GameMenu.swift
//  Racing
//
//  Created by paula on 2018-10-25.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameMenu: SKScene {
    
    let userDefaults = UserDefaults()
    
    var startGame = SKSpriteNode()
    var settings = SKSpriteNode()
    var highScore = SKLabelNode()
    var currentScore = SKLabelNode()
    
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        startGame = self.childNode(withName: "startGame") as! SKSpriteNode
        highScore = self.childNode(withName: "highscore") as! SKLabelNode
        currentScore = self.childNode(withName: "currentScore") as! SKLabelNode
        highScore.text = "High Score: \(userDefaults.integer(forKey: "highscore"))"
        currentScore.text = "Your Score: \(ScoreType.currentScore)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Will delay for 1 second the starting of the music
            if let path = Bundle.main.path(forResource: "Game-Menu-Music", ofType: ".mp3") {
                let url = URL(fileURLWithPath: path)
                self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
                
                if let player = self.audioPlayer {
                    player.play()
                    player.numberOfLoops = -1
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            if atPoint(touchLocation).name == "startGame" {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(1)))
            }
            
            if atPoint(touchLocation).name == "settings" {
                let settingsScene = SKScene(fileNamed: "ConfigurationMenu")!
                settingsScene.scaleMode = .aspectFill
                view?.presentScene(settingsScene, transition: SKTransition.fade(withDuration: TimeInterval(1)))
            }
        }
    }
}
