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
    
    let userDefaults = UserDefaults()
    
    var muteMusicBtn = SKSpriteNode()
    var muteSoundBtn = SKSpriteNode()
    var backBtn = SKSpriteNode()
    
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        muteMusicBtn = self.childNode(withName: "muteMusicBtn") as! SKSpriteNode
        muteSoundBtn = self.childNode(withName: "muteSoundBtn") as! SKSpriteNode
        backBtn = self.childNode(withName: "backBtn") as! SKSpriteNode
        
        updateButtonTexture(button: muteMusicBtn, buttonKey: "muteMusic", textureNameMute: "mute", textureNameUmute: "unmute")
        updateButtonTexture(button: muteSoundBtn, buttonKey: "muteSound", textureNameMute: "soundEffectMute", textureNameUmute: "soundEffectUnmute")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playOrStopBackgroundMusic()
        }
    }
    
    fileprivate func updateButtonTexture(button: SKSpriteNode, buttonKey: String, textureNameMute: String, textureNameUmute: String) {
        let muteMusic = userDefaults.bool(forKey: buttonKey)
        
        if muteMusic {
            // Mute
            button.texture = SKTexture(imageNamed: textureNameMute)
        } else {
            // With music or sound
            button.texture = SKTexture(imageNamed: textureNameUmute)
        }
    }
    
    fileprivate func playOrStopBackgroundMusic() {
        if let path = Bundle.main.path(forResource: "sett-cred-music", ofType: ".mp3") {
            let url = URL(fileURLWithPath: path)
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            
            if let player = audioPlayer {
                if !self.userDefaults.bool(forKey: "muteMusic") {
                    player.play()
                    player.numberOfLoops = -1
                } else {
                    player.stop()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            if atPoint(touchLocation).name == "muteMusicBtn" {
                let muteMusic = userDefaults.bool(forKey: "muteMusic")
                
                userDefaults.set(!muteMusic, forKey: "muteMusic")
                updateButtonTexture(button: muteMusicBtn, buttonKey: "muteMusic", textureNameMute: "mute", textureNameUmute: "unmute")
                
                playOrStopBackgroundMusic()
            }
            
            if atPoint(touchLocation).name == "muteSoundBtn" {
                let muteSound = userDefaults.bool(forKey: "muteSound")
                
                userDefaults.set(!muteSound, forKey: "muteSound")
                updateButtonTexture(button: muteSoundBtn, buttonKey: "muteSound", textureNameMute: "soundEffectMute", textureNameUmute: "soundEffectUnmute")
            }
            
            if atPoint(touchLocation).name == "backBtn" {
                if let menuScene = SKScene(fileNamed: "GameMenu") {
                    menuScene.scaleMode = .aspectFill
                    view?.presentScene(menuScene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: TimeInterval(0.5)))
                }
            }
        }
    }
}
