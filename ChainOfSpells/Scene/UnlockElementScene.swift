//
//  UnlockElementScene.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 06/05/25.
//

import SpriteKit

class UnlockElementScene: SKScene {
	private var selectedElement: Element!
	
	private let fireCard = SKSpriteNode(imageNamed: Element.fire.cardAsset)
	private let waterCard = SKSpriteNode(imageNamed: Element.water.cardAsset)
	private let windCard = SKSpriteNode(imageNamed: Element.wind.cardAsset)
	private let earthCard = SKSpriteNode(imageNamed: Element.earth.cardAsset)
	
	private let bookBackground = SKSpriteNode(imageNamed: "book_background.png")
	private let environmentBackground = SKSpriteNode(imageNamed: "environtment-bg.png")
	
	override func didMove(to view: SKView) {
		environmentBackground.position = CGPoint(x: frame.midX, y: frame.midY)
		environmentBackground.zPosition = -10
		environmentBackground.size = frame.size
		addChild(environmentBackground)
		
		let instructionLabel = SKLabelNode(text: "Unlock New Element:")
		instructionLabel.fontName = "AlmendraSC-Regular"
		instructionLabel.fontSize = 20
		instructionLabel.fontColor = .white
		instructionLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 65)
		instructionLabel.zPosition = 10
		instructionLabel.horizontalAlignmentMode = .center
		addChild(instructionLabel)
		
		setupBackground()
		setupCards()
	}
	
	private func setupBackground() {
		bookBackground.position = CGPoint(x: frame.midX, y: frame.midY - 45)
		bookBackground.zPosition = -1
		bookBackground.scale(to: frame.size, width: true, multiplier: 0.80)
		addChild(bookBackground)
	}
	
	private func setupCards() {
		let positions: [CGPoint] = [
			CGPoint(x: self.frame.midX - 70, y: self.frame.midY + 15),
			CGPoint(x: self.frame.midX + 70, y: self.frame.midY + 15),
			CGPoint(x: self.frame.midX - 70, y: self.frame.midY - 100),
			CGPoint(x: self.frame.midX + 70, y: self.frame.midY - 100)
		]

		let cardsWithElements: [(card: SKSpriteNode, element: Element)] = [
			(fireCard, .fire),
			(waterCard, .water),
			(windCard, .wind),
			(earthCard, .earth)
		]

		let currentElements = UserDefaults.standard.playerModel.elements

		for (i, pair) in cardsWithElements.enumerated() {
			let card = pair.card
			let element = pair.element

			card.scale(to: bookBackground.size, width: false, multiplier: 0.25)
			card.position = positions[i]
			card.zPosition = 1

			if currentElements.contains(element) {
				card.alpha = 0.3
			} else {
				applyFloatingEffect(to: card)
				addShadow(to: card)
			}

			addChild(card)
		}
	}

	
	
	private func applyFloatingEffect(to node: SKNode, distance: CGFloat = 10, duration: TimeInterval = 1.2) {
		let moveUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
		let moveDown = SKAction.moveBy(x: 0, y: -distance, duration: duration)
		let floatSequence = SKAction.sequence([moveUp, moveDown])
		node.run(SKAction.repeatForever(floatSequence))
	}
	
	private func addShadow(to card: SKSpriteNode) {
		let shadow = SKSpriteNode(imageNamed: "shadow_blur")
		shadow.size = CGSize(width: card.size.width * 1.5, height: card.size.height * 0.50)
		shadow.position = CGPoint(x: 0, y: -card.size.height / 2.5)
		shadow.zPosition = -1
		shadow.alpha = 0.3
		
		card.addChild(shadow) // 👈 shadow jadi child dari kartu, bukan scene
		
		let fadeIn = SKAction.fadeAlpha(to: 0.4, duration: 1.2)
		let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 1.2)
		shadow.run(.repeatForever(.sequence([fadeIn, fadeOut])))
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let location = touches.first?.location(in: self) else { return }
		let currentElements = UserDefaults.standard.playerModel.elements
		
		let cardsWithElements: [(node: SKSpriteNode, element: Element)] = [
			(fireCard, .fire),
			(waterCard, .water),
			(windCard, .wind),
			(earthCard, .earth)
		]
		
		for (card, element) in cardsWithElements {
			if card.contains(location) && !currentElements.contains(element) {
				selectedElement = element
				
				// Simpan elemen dan transisi ke game scene
				UserDefaults.standard.playerModel.elements.append(selectedElement)
				let gameScene = NewGameScene(size: self.view!.bounds.size)
				gameScene.stageInfo = stages[UserDefaults.standard.playerModel.currentStage]
				gameScene.scaleMode = .aspectFill
				self.view!.presentScene(gameScene, transition: .fade(withDuration: 0.5))
				break
			}
		}
	}
	
}
