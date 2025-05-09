//
//  Constant.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//


/// Enum
// MARK: enum untuk pilihan elemen di deck kartu
enum Element: String, CaseIterable, Codable,Comparable {
    case fire, water, earth, wind
    var cardAsset : String {
        switch self {
        case .fire:
            return "card_fire"
        case .water:
            return "card_water"
        case .earth:
            return "card_earth"
        case .wind:
            return "card_wind"
        }
    }
    static func < (lhs: Element, rhs: Element) -> Bool {
          return lhs.rawValue < rhs.rawValue
      }
}


enum ChainEffectType : String, Codable,CaseIterable {
    case burn, explosion, mist, critical, regeneration, damageReduction
}

enum ChainEffectLevel : String, Codable {
    case base, strong, enemy
}

/// String
var fontName : String = "AlmendraSC-Regular"
var cardFontName : String = "AlmendraSC-Regular"


var stages : [StageModel] =  [
    StageModel(id: 1,enemy: enemy1,background: "environtment-bg")
    ,StageModel(id: 2,enemy: enemy2,background: "environtment-bg")
    ,StageModel(id: 3,enemy: enemy3,background: "environtment-bg")
    ,StageModel(id: 4,enemy: enemy4,background: "environtment-bg")
    ,StageModel(id: 5,enemy: enemy5,background: "environtment-bg")
    ,StageModel(id: 6,enemy: enemy6,background: "environtment-bg")
    ,StageModel(id: 7,enemy: enemy7,background: "environtment-bg")
    ,StageModel(id: 8,enemy: enemy8,background: "environtment-bg")
    ,StageModel(id: 9,enemy: enemy9,background: "environtment-bg")
    ,StageModel(id: 10,enemy: enemy10,background: "environtment-bg")
]



/// Enemy
var enemy1 = EnemyModel( name: "enemy_1", folderName: "enemy_skeleton", idleAnimations:  ["skeleton_1","skeleton_2","skeleton_3","skeleton_4"], hp: 10, initialChainEffect: ChainEffectModel(type: .damageReduction, remainingTurn: 1, level: .enemy), loseImage: "skeleton_1")

var enemy2 = EnemyModel( name: "enemy_2", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 50, initialChainEffect: ChainEffectModel(type: .burn, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy3 = EnemyModel( name: "enemy_3", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 70, initialChainEffect: ChainEffectModel(type: .critical, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy4 = EnemyModel( name: "enemy_4", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 1000, initialChainEffect: ChainEffectModel(type: .damageReduction, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy5 = EnemyModel( name: "enemy_5", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 90, initialChainEffect: ChainEffectModel(type: .explosion, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy6 = EnemyModel( name: "enemy_6", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 120, initialChainEffect: ChainEffectModel(type: .mist, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy7 = EnemyModel( name: "enemy_7", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 150, initialChainEffect: ChainEffectModel(type: .regeneration, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy8 = EnemyModel( name: "enemy_8", folderName: "BossIdle",idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 200, initialChainEffect: ChainEffectModel(type: .burn, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy9 = EnemyModel( name: "enemy_9", folderName: "BossIdle", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 250, initialChainEffect: ChainEffectModel(type: .explosion, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")

var enemy10 = EnemyModel( name: "enemy_10", folderName: "BossIdle",idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 400, initialChainEffect: ChainEffectModel(type: .mist, remainingTurn: 1, level: .enemy), loseImage: "boss-lose")



