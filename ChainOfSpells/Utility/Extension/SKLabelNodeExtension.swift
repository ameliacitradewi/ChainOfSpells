//
//  SKLabelNodeExtension.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 06/05/25.
//

import SpriteKit

extension SKLabelNode {
    func addOutline(strokeColor: SKColor, strokeWidth: CGFloat) {
        // Offsets to simulate the stroke around the label
        let outlineOffsets: [CGPoint] = [
            CGPoint(x: -strokeWidth, y: -strokeWidth),
            CGPoint(x: -strokeWidth, y:  strokeWidth),
            CGPoint(x:  strokeWidth, y: -strokeWidth),
            CGPoint(x:  strokeWidth, y:  strokeWidth),
            CGPoint(x: -strokeWidth, y: 0),
            CGPoint(x: strokeWidth, y: 0),
            CGPoint(x: 0, y: -strokeWidth),
            CGPoint(x: 0, y: strokeWidth)
        ]
        
        for offset in outlineOffsets {
            let outline = SKLabelNode(text: self.text)
            outline.fontName = self.fontName
            outline.fontSize = self.fontSize
            outline.fontColor = strokeColor
            outline.verticalAlignmentMode = self.verticalAlignmentMode
            outline.horizontalAlignmentMode = self.horizontalAlignmentMode
            outline.position = offset
            outline.zPosition = self.zPosition - 1
            outline.alpha = self.alpha
            self.addChild(outline)
        }
    }
}
