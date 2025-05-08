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
    
    /// Shows text with a typing effect, revealing one character at a time.
       /// - Parameters:
       ///   - text: The full string to display.
       ///   - characterDelay: Time interval between each character.
       ///   - completion: Optional closure called when typing is finished.
    func typeText(_ text: String,
                  characterDelay: TimeInterval = 0.02,
                  backgroundNode: SKSpriteNode? = nil,
                  horizontalPadding: CGFloat = 80,
                  verticalPadding: CGFloat = 10,
                  completion: (() -> Void)? = nil) {
        
        self.removeAllActions()
        self.text = ""
        
        let characters = Array(text)
        var actions: [SKAction] = []
        
        for char in characters {
            let addChar = SKAction.run { [weak self] in
                guard let self = self else { return }
                self.text? += String(char)
                
                if let bg = backgroundNode {
                    let size = self.frame.size
                    bg.size = CGSize(
                        width: size.width + horizontalPadding,
                        height: size.height + verticalPadding
                    )
                }
            }
            let wait = SKAction.wait(forDuration: characterDelay)
            actions.append(addChar)
            actions.append(wait)
        }
        
        if let completion = completion {
            actions.append(SKAction.run(completion))
        }
        
        self.run(SKAction.sequence(actions), withKey: "typingEffect")
    }
    
    func typeStyledText(_ words: [StyledWord],
                        parent: SKNode,
                        startPosition: CGPoint,
                        backgroundNode: SKSpriteNode? = nil,
                        horizontalPadding: CGFloat = 20,
                        verticalPadding: CGFloat = 10,
                        characterDelay: TimeInterval = 0.02,
                        completion: (() -> Void)? = nil) {
        
        parent.removeAllChildren()
        
        var currentX = startPosition.x
        var totalDelay: TimeInterval = 0
        var totalWidth: CGFloat = 0
        
        for word in words {
            let label = SKLabelNode(fontNamed: fontName)
            label.text = ""
            label.fontColor = word.color
            label.horizontalAlignmentMode = .left
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: currentX, y: startPosition.y)
            
            parent.addChild(label)
            
            // Estimate width for spacing & resizing
            let estimatedWidth = CGFloat(word.text.count) * 12
            totalWidth += estimatedWidth
            
            // Typing action
            let characters = Array(word.text)
            var actions: [SKAction] = []
            
            for char in characters {
                let addChar = SKAction.run {
                    label.text? += String(char)
                    
                    if let bg = backgroundNode {
                        let labelBounds = parent.calculateAccumulatedFrame()
                        let newWidth = labelBounds.width + horizontalPadding
                        let newHeight = labelBounds.height + verticalPadding
                        let resize = SKAction.resize(toWidth: newWidth, duration: 0.05)
                        bg.run(resize)
                    }
                }
                let wait = SKAction.wait(forDuration: characterDelay)
                actions.append(SKAction.sequence([addChar, wait]))
            }
            
            // Schedule with total delay
            label.run(SKAction.sequence([
                SKAction.wait(forDuration: totalDelay),
                SKAction.sequence(actions)
            ]))
            
            totalDelay += characterDelay * Double(characters.count)
            currentX += estimatedWidth + 6  // spacing between words
        }
        
        if let completion = completion {
            parent.run(SKAction.sequence([
                SKAction.wait(forDuration: totalDelay + 0.1),
                SKAction.run(completion)
            ]))
        }
    }


       /// Instantly completes the typing effect and shows full text.
       /// - Parameter text: The full text to display.
       func skipTyping(to text: String) {
           self.removeAction(forKey: "typingEffect")
           self.text = text
       }
}
