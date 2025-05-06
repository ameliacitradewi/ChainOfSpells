//
//  SelectElementScene.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//

import SpriteKit



class SelectElementScene : SKScene {
    // User selected element
    private var selectedElement : Element!
    
    // Element cards selection
    private let fireCard = SKSpriteNode(imageNamed: Element.fire.cardAsset)
    private let waterCard = SKSpriteNode(imageNamed:  Element.water.cardAsset)
    private let windCard = SKSpriteNode(imageNamed:  Element.wind.cardAsset)
    private let earthCard = SKSpriteNode(imageNamed:  Element.earth.cardAsset)
    
    
    
    // UI
//    private let selectButton = SKSpriteNode(imageNamed: "attack_button")
//    private var selectionHighlight : SKShapeNode!


    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(named: "CardGlow") ?? .red
        resetProgression()
        setupCards()
        setupButtons()
    }
    
    private func resetProgression() {
        UserDefaults.standard.playerModel.currentStage = 0
        UserDefaults.standard.playerModel.elements.removeAll()
    }
    
    // MARK: - Buttons Setup
    private func setupButtons() {
//        selectButton.scale(to: frame.size, width: false, multiplier: 0.1)
//        selectButton.name = "select"
//        selectButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 160)
    
    }
    
    
    // MARK: - Cards Setup
    private func setupCards() {
        fireCard.scale(to: frame.size, width: false, multiplier: 0.4)
        fireCard.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY + 100)
        self.addChild(fireCard)
        
        waterCard.scale(to: frame.size, width: false, multiplier: 0.4)
        waterCard.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY + 100)
        self.addChild(waterCard)
        
        windCard.scale(to: frame.size, width: false, multiplier: 0.4)
        windCard.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY - 60)
        self.addChild(windCard)
        
        earthCard.scale(to: frame.size, width: false, multiplier: 0.4)
        earthCard.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY - 60)
        self.addChild(earthCard)
        let targetSize = CGSize(width: fireCard.frame.width + 30,
                                height: fireCard.frame.height + 40)
//        selectionHighlight =  SKShapeNode(rectOf: targetSize, cornerRadius: 0)
 
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if fireCard.contains(location){
            selectedElement = .fire
        } else if waterCard.contains(location){
            selectedElement = .water
        } else if windCard.contains(location){
            selectedElement = .wind
        } else if earthCard.contains(location){
            selectedElement = .earth
        }
//        else if selectButton.contains(location){
//            let gameScene = NewGameScene(size: self.view!.bounds.size)
//            gameScene.scaleMode = .aspectFill
//            UserDefaults.standard.playerModel.elements = [selectedElement]
//            // Tampilkan scene
//            self.view!.presentScene(gameScene)
//        }
//        
//        if selectedElement == nil{
//            return
//        }
        
        switch selectedElement {
        case .none: do {
            print("None Selected")
            return
        }
        case .fire: do {
            print("Fire Selected")
        }
        case .water: do {
            print("Water Selected")

        }
        case .earth: do {
            print("Earth Selected")

        }
        case .wind: do {
            print("Wind Selected")
        }

        }
        // Set game scene info
        let gameScene = NewGameScene(size: self.view!.bounds.size)
        gameScene.stageInfo = stages.first
        gameScene.scaleMode = .aspectFill
        UserDefaults.standard.playerModel.elements = [selectedElement]
        // Tampilkan scene
        self.view!.presentScene(gameScene,transition: SKTransition.fade(withDuration: 0.5))
        
  

//        if !selectedCards.isEmpty {
//            if attackButton.contains(location) { handleAttack(); return }
//            if discardButton.contains(location) {
//                // only allow if still have discards left
//                guard discardLeft > 0 else { return }
//                handleDiscard(); return
//            }
//        }
//        for card in playAreaCards where card.contains(location) && !card.isAnimating && !isAnimating {
//            handleCardSelection(card); return
//        }
//        if !isAnimating && deckNode.contains(location) {
//            drawCardsFromDeck()
//        }
    }
}


