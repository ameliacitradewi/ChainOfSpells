//
//  CardNode.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//

import SpriteKit

// MARK: - CardNode
class CardNode: SKSpriteNode {
    // MARK: Properties
    var isSelected = false
    var originalPosition = CGPoint.zero
    var isAnimating = false
    var attackValue: Int = 0
    var element: Element = Element.fire
    let valueLabel = SKLabelNode(fontNamed: "Arial Bold")  // Made internal for access

    // MARK: Initialization
    init(texture: SKTexture?) {
        super.init(texture: texture, color: .clear, size: texture?.size() ?? .zero)
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Label Setup
    private func setupLabel() {
        valueLabel.fontSize = 10
        valueLabel.fontName = cardFontName
//        valueLabel.fontColor = UIColor(named: "CardTextColor")
        valueLabel.fontColor = .white
//        valueLabel.addOutline(strokeColor: .red, strokeWidth: 2)
        valueLabel.position = CGPoint(x: -29, y: 48)
        valueLabel.zPosition = 1
        addChild(valueLabel)
    }
}
