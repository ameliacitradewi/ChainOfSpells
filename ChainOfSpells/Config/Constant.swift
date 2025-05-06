//
//  Constant.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//


/// Enum
// MARK: enum untuk pilihan elemen di deck kartu
enum Element: String, CaseIterable, Codable {
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
}
/// String
var fontName : String = "AlmendraSC-Regular"
var cardFontName : String = "AlmendraSC-Regular"


var stages : [StageModel] =  [
    StageModel(id: 1,enemy: enemy1,background: "environtment-bg")
]


/// Enemy
var enemy1 = EnemyModel( name: "enemy_1", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 10)


