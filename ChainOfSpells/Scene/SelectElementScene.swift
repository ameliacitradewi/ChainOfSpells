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

	private let bookBackground = SKSpriteNode(imageNamed: "book_background.png")
	private let environmentBackground = SKSpriteNode(imageNamed: "environtment-bg.png")


    
    
    // UI
//    private let selectButton = SKSpriteNode(imageNamed: "attack_button")
//    private var selectionHighlight : SKShapeNode!


    
    
    override func didMove(to view: SKView) {
//		self.backgroundColor = UIColor(named: "CardGlow") ?? .red
		environmentBackground.position = CGPoint(x: frame.midX, y: frame.midY)
		environmentBackground.zPosition = -10
		environmentBackground.size = frame.size
		addChild(environmentBackground)

		
		// Tambahkan label instruksi di atas
		let instructionLabel = SKLabelNode(text: "Unlocked Your First Element:")
		instructionLabel.fontName = "AlmendraSC-Regular"
		instructionLabel.fontSize = 20
		instructionLabel.fontColor = .white
		instructionLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 65)
		instructionLabel.zPosition = 10
		instructionLabel.horizontalAlignmentMode = .center
		addChild(instructionLabel)
		
		resetProgression()
		setupBackground()
        setupCards()
        setupButtons()
    }
    
    private func resetProgression() {
        UserDefaults.standard.playerModel.currentStage = 0
        UserDefaults.standard.playerModel.elements.removeAll()
    }
	
	// MARK: - Background Setup
	private func setupBackground() {
			bookBackground.position = CGPoint(x: frame.midX, y: frame.midY - 45)
			bookBackground.zPosition = -1
		bookBackground.scale(to: frame.size, width: true, multiplier: 0.80)
			addChild(bookBackground)
		}
    
    // MARK: - Buttons Setup
    private func setupButtons() {
//        selectButton.scale(to: frame.size, width: false, multiplier: 0.1)
//        selectButton.name = "select"
//        selectButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 160)
    
    }
	
	// MARK: - Floating Card Effect
	private func applyFloatingEffect(to node: SKNode, distance: CGFloat = 10, duration: TimeInterval = 1.2) {
		let moveUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
		let moveDown = SKAction.moveBy(x: 0, y: -distance, duration: duration)
		let floatSequence = SKAction.sequence([moveUp, moveDown])
		let floatForever = SKAction.repeatForever(floatSequence)
		node.run(floatForever)
	}

	// MARK: - Shadow Effect for Cards
	private func addShadow(to card: SKSpriteNode) {
		let shadow = SKSpriteNode(imageNamed: "shadow_blur") // atau pakai nama asli file dengan .png
		
		// Ukuran shadow disesuaikan agar cukup lebar dan rendah
		shadow.size = CGSize(width: card.size.width * 1.5, height: card.size.height * 0.50)
		shadow.position = CGPoint(x: card.position.x, y: card.position.y - card.size.height / 2.5)
		shadow.zPosition = card.zPosition - 1
		//			shadow.alpha = 0.8
		
		addChild(shadow)
		
		// Efek fade mengikuti floating agar terasa hidup
		let fadeIn = SKAction.fadeAlpha(to: 0.4, duration: 1.2)
		let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 1.2)
		shadow.run(.repeatForever(.sequence([fadeIn, fadeOut])))
	}

    
    // MARK: - Cards Setup
    private func setupCards() {
		fireCard.scale(to: bookBackground.size, width: false, multiplier: 0.25)
        fireCard.position = CGPoint(x: self.frame.midX - 70, y: self.frame.midY + 15)
		fireCard.zPosition = 1
        self.addChild(fireCard)
		applyFloatingEffect(to: fireCard)
		addShadow(to: fireCard)
        
        waterCard.scale(to: bookBackground.size, width: false, multiplier: 0.25)
        waterCard.position = CGPoint(x: self.frame.midX + 70, y: self.frame.midY + 15)
		waterCard.zPosition = 1
        self.addChild(waterCard)
		applyFloatingEffect(to: waterCard)
		addShadow(to: waterCard)
        
		windCard.scale(to: bookBackground.size, width: false, multiplier: 0.25)
        windCard.position = CGPoint(x: self.frame.midX - 70, y: self.frame.midY - 100)
		windCard.zPosition = 1
        self.addChild(windCard)
		applyFloatingEffect(to: windCard)
		addShadow(to: windCard)
        
		earthCard.scale(to: bookBackground.size, width: false, multiplier: 0.25)
        earthCard.position = CGPoint(x: self.frame.midX + 70, y: self.frame.midY - 100)
		earthCard.zPosition = 1
        self.addChild(earthCard)
		applyFloatingEffect(to: earthCard)
		addShadow(to: earthCard)
		
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
        self.view!.presentScene(gameScene)
        
  

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


