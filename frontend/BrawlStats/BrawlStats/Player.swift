//
//  Player.swift
//  BrawlStats
//
//  Created by Kunwar Sahni on 4/4/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import Foundation

struct Player {
    
    var tag: String = ""
    var name: String = ""
    var nameColor: String = ""
    var trophies: Int = 0
    var highestTrophies: Int = 0
    var expLevel: Int = 0
    var expPoints: Int = 0
    var isQualifiedFromChampionshipChallenge: Bool = false
    var ThreeVSThreeVictories: Int = 0
    var soloVictories: Int = 0
    var duoVictories: Int = 0
    var bestRoboRumbleTime: Int = 0
    var bestTimeAsBigBrawler: Int = 0
    var club: [String : String] = [:]
    var brawlers: [Brawler] = []
}
