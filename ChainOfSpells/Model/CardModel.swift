//
//  CardModel.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//


// MARK: enum untuk pilihan elemen di deck kartu
enum Element: String, CaseIterable {
    case fire, water, earth, wind
}

struct CardModel {
    let element: Element
    let value: Int
    
}
