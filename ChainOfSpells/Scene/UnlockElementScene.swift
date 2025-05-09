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

		let cards = [fireCard, waterCard, windCard, earthCard]
		let currentElements = UserDefaults.standard.playerModel.elements

		for (i, card) in cards.enumerated() {
			card.scale(to: bookBackground.size, width: false, multiplier: 0.25)
			card.position = positions[i]
			card.zPosition = 1

			if currentElements.contains(Element.allCases[i]) {
				card.alpha = 0.3 // show as disabled
				card.isUserInteractionEnabled = false
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
		shadow.position = CGPoint(x: card.position.x, y: card.position.y - card.size.height / 2.5)
		shadow.zPosition = card.zPosition - 1

		addChild(shadow)

		let fadeIn = SKAction.fadeAlpha(to: 0.4, duration: 1.2)
		let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 1.2)
		shadow.run(.repeatForever(.sequence([fadeIn, fadeOut])))
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let location = touches.first?.location(in: self) else { return }
		let currentElements = UserDefaults.standard.playerModel.elements

		if fireCard.contains(location), !currentElements.contains(.fire) {
			selectedElement = .fire
		} else if waterCard.contains(location), !currentElements.contains(.water) {
			selectedElement = .water
		} else if windCard.contains(location), !currentElements.contains(.wind) {
			selectedElement = .wind
		} else if earthCard.contains(location), !currentElements.contains(.earth) {
			selectedElement = .earth
		} else {
			return
		}

		let gameScene = NewGameScene(size: self.view!.bounds.size)
		gameScene.stageInfo = stages[UserDefaults.standard.playerModel.currentStage]
		gameScene.scaleMode = .aspectFill
		UserDefaults.standard.playerModel.elements.append(selectedElement)
		self.view!.presentScene(gameScene, transition: .fade(withDuration: 0.5))
	}
}
