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
        valueLabel.fontSize = 40
        valueLabel.fontColor = .white
        valueLabel.position = CGPoint(x: 0, y: -40)
        valueLabel.zPosition = 1
        addChild(valueLabel)
    }
}
