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
var enemy1 = EnemyModel( name: "enemy_1", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 10)

var enemy2 = EnemyModel( name: "enemy_2", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 20)

var enemy3 = EnemyModel( name: "enemy_3", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 30)

var enemy4 = EnemyModel( name: "enemy_4", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 40)

var enemy5 = EnemyModel( name: "enemy_5", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 50)

var enemy6 = EnemyModel( name: "enemy_6", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 70)

var enemy7 = EnemyModel( name: "enemy_7", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 100)

var enemy8 = EnemyModel( name: "enemy_8", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 150)

var enemy9 = EnemyModel( name: "enemy_9", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 200)

var enemy10 = EnemyModel( name: "enemy_10", idleAnimations:  ["boss1","boss2","boss3","boss4","boss5","boss6","boss7"], hp: 300)



