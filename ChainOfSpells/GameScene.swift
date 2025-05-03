//
//  GameScene.swift
//  ChainOfSpells
//
//  Created by Amelia Citra on 03/05/25.
//

import SpriteKit

class GameScene: SKScene {
	// MARK: enum untuk pilihan elemen di deck kartu
	enum Element: String, CaseIterable {
		case fire, water, earth, air
	}
	
	struct CardData {
		let element: Element
		let power: Int
	}
	
	var selectedElement: Element = .fire // ini akan diganti jika dengan userinput
	var deck: [CardData] = []
	var handCards: [SKSpriteNode] = []
	
	// MARK: tampilan sisa kartu yang belum dikeluarkan
	var playedCount = 0 {
		didSet {
			let remaining = max(0, 10 - playedCount)
			cardCountLabel.text = "\(remaining)/10"
		}
	}
	
	let cardCountLabel = SKLabelNode(fontNamed: "Avenir")
	var selectedCard: SKSpriteNode?
	var attackButton: SKLabelNode!
	var discardButton: SKLabelNode!
	var enemyHP = 10 {
		didSet {
			hpLabel.text = "\(enemyHP)/10"
			//			hpBar.xScale = CGFloat(enemyHP) / 100.0
			// MARK: ganti hp bar wizard agar berkurang dan berubah warna sesuai health
			let ratio = CGFloat(enemyHP) / 10.0
			hpBar.xScale = ratio
			
			if ratio <= 0.3 {
				hpBar.color = .red
			} else if ratio <= 0.6 {
				hpBar.color = .yellow
			} else {
				hpBar.color = .green
			}
		}
	}
	let hpLabel = SKLabelNode(fontNamed: "Avenir")
	let hpBar = SKSpriteNode(color: .green, size: CGSize(width: 200, height: 10))
	//	let hpBarBackground = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 10))
	let hpBarBackground = SKShapeNode(rectOf: CGSize(width: 200, height: 10))
	
	
	override func didMove(to view: SKView) {
		backgroundColor = .black
		setupUI()
		generateDeck(for: selectedElement)
		drawInitialCards()
	}
	
	func setupUI() {
		// MARK: tampilan spells card
		let deckImage = SKSpriteNode(imageNamed: "card_earth")
		deckImage.size = CGSize(width: 80, height: 120)
		deckImage.position = CGPoint(x: size.width - 100, y: 100)
		addChild(deckImage)
		
		// MARK: Wizard's HP Bar
		hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
		hpBar.position = CGPoint(x: size.width/2 - 100, y: size.height - 50)
		//		hpBarBackground.position = hpBar.position
		//		addChild(hpBarBackground)
		addChild(hpBar)
		
		// HP Bar background (frame putih)
		hpBarBackground.strokeColor = .white     // garis luar
		hpBarBackground.lineWidth = 2
		hpBarBackground.fillColor = .clear       // tanpa isi
		hpBarBackground.position = CGPoint(x: size.width / 2, y: size.height - 50)
		addChild(hpBarBackground)
		
		hpLabel.fontSize = 20
		hpLabel.position = CGPoint(x: size.width / 2, y: size.height - 70)
		hpLabel.text = "\(enemyHP)/10"
		addChild(hpLabel)
		
		// Card Count Label
		cardCountLabel.fontSize = 18
		cardCountLabel.position = CGPoint(x: size.width - 100, y: 160)
		cardCountLabel.text = "10/10"
		addChild(cardCountLabel)
		
		// Action Buttons
		attackButton = SKLabelNode(text: "Attack")
		attackButton.fontName = "Avenir"
		attackButton.fontSize = 24
		attackButton.position = CGPoint(x: size.width / 2 - 60, y: 180)
		attackButton.name = "attackButton"
		attackButton.isHidden = true
		addChild(attackButton)
		
		discardButton = SKLabelNode(text: "Discard")
		discardButton.fontName = "Avenir"
		discardButton.fontSize = 24
		discardButton.position = CGPoint(x: size.width / 2 + 60, y: 180)
		discardButton.name = "discardButton"
		discardButton.isHidden = true
		addChild(discardButton)
	}
	
	// MARK: nominal attack untuk kartu
	func generateDeck(for element: Element) {
		let uniquePowers = Array(1...10).shuffled()
		for power in uniquePowers {
			deck.append(CardData(element: element, power: power))
		}
	}
	
	func drawInitialCards() {
		for i in 0..<5 {
			drawCard(at: i)
		}
	}
	
	func drawCard(at index: Int) {
		guard playedCount < 10, !deck.isEmpty else { return }
		let card = deck.removeFirst()
		playedCount += 1
		let cardNode = SKSpriteNode(texture: SKTexture(imageNamed: "card_\(card.element)")) // show card based on element
		cardNode.size = CGSize(width: 80, height: 120) // Tambahkan ini
		cardNode.name = "card"
		cardNode.position = CGPoint(x: CGFloat(150 + (index * 130)), y: 100)
		cardNode.userData = ["power": card.power, "originalY": 100.0]
		
		let label = SKLabelNode(text: "\(card.power)")
		label.fontSize = 16
		label.fontName = "Avenir"
		label.position = CGPoint(x: -40, y: 40)
		label.zPosition = 2
		cardNode.addChild(label)
		
		handCards.insert(cardNode, at: index)
		addChild(cardNode)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let nodes = nodes(at: location)
		
		if let node = nodes.first(where: { $0.name == "card" }) as? SKSpriteNode {
			if selectedCard == node {
				// Tap ulang kartu yang sama: batalkan pilihan
				node.run(SKAction.moveTo(y: 100, duration: 0.1))
				selectedCard = nil
				attackButton.isHidden = true
				discardButton.isHidden = true
			} else {
				// Turunkan kartu sebelumnya jika ada
				if let previous = selectedCard {
					previous.run(SKAction.moveTo(y: 100, duration: 0.1))
				}
				// Angkat kartu yang baru dipilih
				selectedCard = node
				node.run(SKAction.moveTo(y: 130, duration: 0.1))
				attackButton.isHidden = false
				discardButton.isHidden = false
			}
		} else if nodes.contains(attackButton), let card = selectedCard {
			performAttack(with: card)
		} else if nodes.contains(discardButton), let card = selectedCard {
			discard(card: card)
		}
	}
	
	func performAttack(with card: SKSpriteNode) {
		guard let power = card.userData?["power"] as? Int else { return }
		guard let index = handCards.firstIndex(of: card) else { return }
		
		card.run(SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.3)) {
			card.removeFromParent()
			
			self.enemyHP = max(0, self.enemyHP - power)
			self.handCards.remove(at: index)
			
			// Tambahkan kartu pengganti jika masih bisa draw
			if self.playedCount < 10, !self.deck.isEmpty {
				self.drawCard(at: index)
			}
			
			self.cleanupAfterAction()
		}
	}
	
	func discard(card: SKSpriteNode) {
		card.removeFromParent()
		if let index = handCards.firstIndex(of: card) {
			handCards.remove(at: index)
			if playedCount < 10, !deck.isEmpty {
				drawCard(at: index)
			}
		}
		cleanupAfterAction()
	}
	
	func cleanupAfterAction() {
		selectedCard = nil
		attackButton.isHidden = true
		discardButton.isHidden = true
	}
}
