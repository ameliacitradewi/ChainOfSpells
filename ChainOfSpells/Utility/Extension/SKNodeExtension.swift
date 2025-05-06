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
}
