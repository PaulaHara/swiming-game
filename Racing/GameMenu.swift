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
    
    var startGame = SKSpriteNode()
    var highScore = SKLabelNode()
    
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKSpriteNode
        highScore = self.childNode(withName: "highscore") as! SKLabelNode
        highScore.text = "High Score: \(ScoreType.highScore)"
        
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
        }
    }
}
