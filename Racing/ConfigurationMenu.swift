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
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        muteMusicBtn = self.childNode(withName: "muteMusicBtn") as! SKSpriteNode
        muteSoundBtn = self.childNode(withName: "muteSoundBtn") as! SKSpriteNode
        backBtn = self.childNode(withName: "backBtn") as! SKSpriteNode
        
        updateMusicButton()
        updateSoundButton()
    }
    
    fileprivate func updateButtonTexture(button: SKSpriteNode, buttonKey: String, textureNameMute: String, textureNameUmute: String) -> Bool {
        let muteMusic = userDefaults.bool(forKey: buttonKey)
        
        if muteMusic {
            // Mute
            button.texture = SKTexture(imageNamed: textureNameMute)
        } else {
            // With music
            button.texture = SKTexture(imageNamed: textureNameUmute)
        }
        return muteMusic
    }
    
    fileprivate func updateMusicButton() -> Bool {
        return updateButtonTexture(button: muteMusicBtn, buttonKey: "muteMusic", textureNameMute: "mute", textureNameUmute: "unmute")
    }
    
    fileprivate func updateSoundButton() -> Bool {
        return updateButtonTexture(button: muteSoundBtn, buttonKey: "muteSound", textureNameMute: "soundEffectMute", textureNameUmute: "soundEffectUnmute")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            if atPoint(touchLocation).name == "muteMusicBtn" {
//                var muteMusic = userDefaults.bool(forKey: "muteMusic")
//                print("MuteMusic antes: \(muteMusic)")
                
                var muteMusic = userDefaults.bool(forKey: "muteMusic")
                
                if muteMusic {
                    userDefaults.set(false, forKey: "muteMusic")
                    muteMusicBtn.texture = SKTexture(imageNamed: "unmute")
                }else{
                    userDefaults.set(true, forKey: "muteMusic")
                    muteMusicBtn.texture = SKTexture(imageNamed: "mute")
                }
                
//                userDefaults.set(!updateMusicButton(), forKey: "muteMusic")
//
//                muteMusic = userDefaults.bool(forKey: "muteMusic")
//                print("MuteMusic depois: \(muteMusic)")
            }
            
            if atPoint(touchLocation).name == "muteSoundBtn" {
//                userDefaults.set(!updateSoundButton(), forKey: "muteSound")
                
                var muteMusic = userDefaults.bool(forKey: "muteSound")
                
                if muteMusic {
                    userDefaults.set(false, forKey: "muteSound")
                    muteSoundBtn.texture = SKTexture(imageNamed: "soundEffectUnmute")
                }else{
                    userDefaults.set(true, forKey: "muteSound")
                    muteSoundBtn.texture = SKTexture(imageNamed: "soundEffectMute")
                }
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
