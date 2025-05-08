//
//  SKNodeExtension.swift
//  cardPrototype
//
//  Created by Wito Irawan on 24/04/25.
//

import SpriteKit

extension SKNode{
    
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat){
        let scale = width ? (
            screenSize.width * multiplier
        ) / self.frame.size.width : (
            screenSize.height * multiplier
        ) / self.frame.size.height
        self.setScale(scale)
    }
    
    func typeTextWithLineBreaks(_ text: String,
                                fontName: String = fontName,
                                   fontSize: CGFloat = 12,
                                   fontColor: SKColor = .white,
                                   characterDelay: TimeInterval = 0.02,
                                   lineSpacing: CGFloat = 28,
                                   backgroundNode: SKSpriteNode? = nil,
                                   horizontalPadding: CGFloat = 20,
                                   verticalPadding: CGFloat = 10,
                                   completion: (() -> Void)? = nil) {
           
           self.removeAllChildren()
           
           let lines = text.components(separatedBy: "\n")
           var totalDelay: TimeInterval = 0
           var maxWidth: CGFloat = 0
           
           for (i, lineText) in lines.enumerated() {
               let label = SKLabelNode(fontNamed: fontName)
               label.text = ""
               label.fontSize = fontSize
               label.fontColor = fontColor
               label.horizontalAlignmentMode = .left
               label.verticalAlignmentMode = .top
               label.position = CGPoint(x: horizontalPadding / 2, y: -CGFloat(i) * lineSpacing)
               
               self.addChild(label)
               
               var actions: [SKAction] = []
               let characters = Array(lineText)
               
               for char in characters {
                   let addChar = SKAction.run {
                       label.text? += String(char)
                       
                       // Dynamically resize background
                       if let bg = backgroundNode {
                           let totalBounds = self.calculateAccumulatedFrame()
                           let newSize = CGSize(
                               width: totalBounds.width + horizontalPadding,
                               height: totalBounds.height + verticalPadding
                           )
                           let resize = SKAction.resize(toWidth: newSize.width, height: newSize.height, duration: 0.05)
                           bg.run(resize)
                       }
                   }
                   actions.append(addChar)
                   actions.append(SKAction.wait(forDuration: characterDelay))
               }
               
               let typing = SKAction.sequence(actions)
               label.run(SKAction.sequence([
                   SKAction.wait(forDuration: totalDelay),
                   typing
               ]))
               
               totalDelay += characterDelay * Double(characters.count)
           }
           
           if let completion = completion {
               self.run(SKAction.sequence([
                   SKAction.wait(forDuration: totalDelay + 0.1),
                   SKAction.run(completion)
               ]))
           }
       }
}
