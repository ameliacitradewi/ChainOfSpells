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
}
/// String
var fontName : String = "Arial Bold"

var stages : [StageModel] =  [
    StageModel(id: 1,enemy: EnemyModel( name: "enemy_1", hp: 10),background: "environtment-bg")
]


