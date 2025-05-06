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
var fontName : String = "Arial Bold"
var cardFontName : String = "AlmendraSC-Regular"


var stages : [StageModel] =  [
    StageModel(id: 1,enemy: EnemyModel( name: "enemy_1", hp: 10),background: "environtment-bg")
]


