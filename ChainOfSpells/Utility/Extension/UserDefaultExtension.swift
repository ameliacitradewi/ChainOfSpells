//
//  UserDefaultExtension.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//

import Foundation

extension UserDefaults {
    var playerModel: PlayerModel {
        get {
            if let data = data(forKey: "playerModel"),
               let model = try? JSONDecoder().decode(PlayerModel.self, from: data) {
                return model
            }
            return PlayerModel()
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                set(data, forKey: "playerModel")
            }
        }
    }
}
