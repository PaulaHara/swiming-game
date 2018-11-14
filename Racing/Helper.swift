//
//  Helper.swift
//  Racing
//
//  Created by paula on 2018-10-25.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

struct LakeBorder {
    static var lakeMinX = CGFloat()
    static var lakeMaxX = CGFloat()
    static var lakeMaxY = CGFloat()
    static var lakeMinY = CGFloat()
    static var lakeBorderR = CGFloat()
    static var lakeBorderL = CGFloat()
    static var lakeBorderBottom = CGFloat()
    static var lakeBorderUp = CGFloat()
}

struct ColliderType {
    static let PLAYER_COLLIDER : UInt32 = 0
    static let ITEM_COLLIDER : UInt32 = 1
    static let ITEM_COLLIDER_1 : UInt32 = 2
}

struct ScoreType {
    static var highScore = 0
    static var currentScore = 0
}
