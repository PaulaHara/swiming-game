//
//  Credits.swift
//  Racing
//
//  Created by paula on 2018-10-23.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Credits: SKScene {
    let userDefaults = UserDefaults()
    
    var backBtn = SKSpriteNode()
    
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if !self.userDefaults.bool(forKey: "muteMusic") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playBackgroundMusic()
            }
        }
    }
    
    fileprivate func playBackgroundMusic() {
        if let path = Bundle.main.path(forResource: "sett-cred-music", ofType: ".mp3") {
            let url = URL(fileURLWithPath: path)
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            
            if let player = audioPlayer {
                player.play()
                player.numberOfLoops = -1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)

            if atPoint(touchLocation).name == "backBtn" {
                if let menuScene = SKScene(fileNamed: "GameMenu") {
                    menuScene.scaleMode = .aspectFill
                    view?.presentScene(menuScene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: TimeInterval(0.5)))
                }
            }
        }
    }
}

// whale -> www.kenney.nl
// tree -> https://opengameart.org/content/trunks-for-platform-game
// musics and sound effects -> https://soundimage.org/
// buttons -> https://payhip.com/fakigame



// pause -> https://opengameart.org/content/play-pause-mute-and-unmute-buttons
// mute -> https://opengameart.org/content/play-pause-mute-and-unmute-buttons
// unmute -> https://opengameart.org/content/play-pause-mute-and-unmute-buttons

