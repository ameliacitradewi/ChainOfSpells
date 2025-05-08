//
//  SpellsBook.swift
//  ChainOfSpells
//
//  Created by Amelia Citra on 08/05/25.
//

import SpriteKit

class SpellsBook: SKNode {
	private let fireCard = SKSpriteNode(imageNamed: Element.fire.cardAsset)
	private let waterCard = SKSpriteNode(imageNamed: Element.water.cardAsset)
	private let windCard = SKSpriteNode(imageNamed: Element.wind.cardAsset)
	private let earthCard = SKSpriteNode(imageNamed: Element.earth.cardAsset)

	private let chainBurn = SKSpriteNode(imageNamed: "chain_burn")
	private let chainCritical = SKSpriteNode(imageNamed: "chain_critical")
	private let chainDamageReduction = SKSpriteNode(imageNamed: "chain_damage_reduction")
	private let chainExplosion = SKSpriteNode(imageNamed: "chain_explosion")
	private let chainMist = SKSpriteNode(imageNamed: "chain_mist")
	private let chainRegerenation = SKSpriteNode(imageNamed: "chain_regeneration")

	private var bg: SKSpriteNode!

	init(size: CGSize, elements: [Element]) {
		super.init()

		// Background utama
		bg = SKSpriteNode(color: .brown, size: size)
		bg.name = "bookBackground"
		bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
		bg.zPosition = 300
		addChild(bg)

		// Tombol close
		let close = SKLabelNode(text: "Close")
		close.name = "closeSpellbook"
		close.fontName = fontName
		close.fontSize = 18
		close.fontColor = .yellow
		close.horizontalAlignmentMode = .right
		close.verticalAlignmentMode = .top
		close.position = CGPoint(x: bg.size.width / 2 - 20, y: bg.size.height / 2 - 20)
		close.zPosition = 2
		bg.addChild(close)

		// Data Combo
		let comboData1: [(SKSpriteNode, SKSpriteNode, SKSpriteNode, String)] = [
			(fireCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, chainBurn, "Extra 5% Damage (2 Turns)"),
			(fireCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, chainExplosion, "Attack Damage ×2"),
			(fireCard.copy() as! SKSpriteNode, waterCard.copy() as! SKSpriteNode, chainMist, "Enemy Miss Chance +20%"),
			(waterCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, chainRegerenation, "Restore 10% HP"),
			(waterCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, chainCritical, "20% Critical Hit"),
			(windCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, chainDamageReduction, "50% Damage Reduction")
		]

		let comboData2: [Any] = [
			(fireCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, "x1.5 Damage"),
			(fireCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, "x2 Damage"),
			(fireCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, "x3 Damage")
		]

		// Halaman kiri: comboData1
		let page1 = createPage1(content: comboData1, size: bg.size)
		page1.position = .zero
		page1.zPosition = 2
		bg.addChild(page1)

		// Halaman kanan: comboData2
		let page2 = createPage2(content: comboData2, size: bg.size)
		page2.position = CGPoint(x: 260, y: 0)
		page2.zPosition = 2
		bg.addChild(page2)
	}

	private func createPage1(content: [(SKSpriteNode, SKSpriteNode, SKSpriteNode, String)], size: CGSize) -> SKNode {
		let pageNode = SKNode()

		let iconSize = CGSize(width: 32, height: 42)
		let spacing: CGFloat = 6
		var startY = size.height / 2 - 40

		for (icon1, icon2, icon3, desc) in content {
			let lineNode = SKNode()
			lineNode.position = CGPoint(x: -size.width / 2 + 100, y: startY)
			lineNode.zPosition = 2

			let plus = SKLabelNode(text: "+")
			let equal = SKLabelNode(text: "=")
			for label in [plus, equal] {
				label.fontName = fontName
				label.fontSize = 20
				label.fontColor = .white
				label.horizontalAlignmentMode = .center
				label.verticalAlignmentMode = .center
			}

			let totalWidth = iconSize.width * 3 + plus.frame.width + equal.frame.width + spacing * 4
			let startX = -totalWidth / 2

			icon1.size = iconSize
			icon1.position = CGPoint(x: startX + iconSize.width / 2, y: 0)
			lineNode.addChild(icon1)

			plus.position = CGPoint(x: icon1.position.x + iconSize.width / 2 + spacing + plus.frame.width / 2, y: 0)
			lineNode.addChild(plus)

			icon2.size = iconSize
			icon2.position = CGPoint(x: plus.position.x + plus.frame.width / 2 + spacing + iconSize.width / 2, y: 0)
			lineNode.addChild(icon2)

			equal.position = CGPoint(x: icon2.position.x + iconSize.width / 2 + spacing + equal.frame.width / 2, y: 0)
			lineNode.addChild(equal)

			icon3.size = iconSize
			icon3.position = CGPoint(x: equal.position.x + equal.frame.width / 2 + spacing + iconSize.width / 2, y: 0)
			lineNode.addChild(icon3)

			let label = SKLabelNode(text: desc)
			label.fontName = fontName
			label.fontSize = 14
			label.fontColor = .white
			label.horizontalAlignmentMode = .left
			label.verticalAlignmentMode = .center
			label.position = CGPoint(x: icon3.position.x + iconSize.width / 2 + spacing, y: 0)
			lineNode.addChild(label)

			pageNode.addChild(lineNode)
			startY -= 64
		}

		return pageNode
	}

	private func createPage2(content: [Any], size: CGSize) -> SKNode {
		let pageNode = SKNode()

		let iconSize = CGSize(width: 32, height: 42)
		let spacing: CGFloat = 6
		var startY = size.height / 2 - 40

		for data in content {
			let lineNode = SKNode()
			lineNode.zPosition = 2

			var iconNodes: [SKSpriteNode] = []
			var labelText = ""

			if let tuple2 = data as? (SKSpriteNode, SKSpriteNode, String) {
				iconNodes = [tuple2.0, tuple2.1]
				labelText = tuple2.2
			} else if let tuple3 = data as? (SKSpriteNode, SKSpriteNode, SKSpriteNode, String) {
				iconNodes = [tuple3.0, tuple3.1, tuple3.2]
				labelText = tuple3.3
			} else if let tuple4 = data as? (SKSpriteNode, SKSpriteNode, SKSpriteNode, SKSpriteNode, String) {
				iconNodes = [tuple4.0, tuple4.1, tuple4.2, tuple4.3]
				labelText = tuple4.4
			}

			// Hitung total lebar konten (ikon + plus + equal + teks)
			let plusWidth = CGFloat(iconNodes.count - 1) * 12 // perkiraan lebar tanda "+"
			let equalWidth: CGFloat = 14
			let textWidth: CGFloat = CGFloat(labelText.count) * 10
			let totalIconsWidth = CGFloat(iconNodes.count) * iconSize.width
			let totalSpacing = CGFloat(iconNodes.count - 1) * spacing

			let totalContentWidth = totalIconsWidth + plusWidth + equalWidth + textWidth + totalSpacing + spacing * 3

			var currentX = -totalContentWidth / 2

			for (index, icon) in iconNodes.enumerated() {
				icon.size = iconSize
				icon.position = CGPoint(x: currentX + iconSize.width / 2, y: 0)
				lineNode.addChild(icon)
				currentX += iconSize.width + spacing

				if index < iconNodes.count - 1 {
					let plus = SKLabelNode(text: "+")
					plus.fontName = fontName
					plus.fontSize = 20
					plus.fontColor = .white
					plus.verticalAlignmentMode = .center
					plus.position = CGPoint(x: currentX, y: 0)
					lineNode.addChild(plus)
					currentX += plus.frame.width + spacing
				}
			}

			let equal = SKLabelNode(text: "=")
			equal.fontName = fontName
			equal.fontSize = 20
			equal.fontColor = .white
			equal.verticalAlignmentMode = .center
			equal.position = CGPoint(x: currentX, y: 0)
			lineNode.addChild(equal)
			currentX += equal.frame.width + spacing

			let label = SKLabelNode(text: labelText)
			label.fontName = fontName
			label.fontSize = 14
			label.fontColor = .white
			label.horizontalAlignmentMode = .left
			label.verticalAlignmentMode = .center
			label.position = CGPoint(x: currentX, y: 0)
			lineNode.addChild(label)

			lineNode.position = CGPoint(x: -size.width / 2 + 300, y: startY)
			pageNode.addChild(lineNode)
			startY -= 64
		}

		return pageNode
	}


	func handleTouch(_ location: CGPoint) {
		let nodes = self.nodes(at: location)
		for node in nodes {
			if node.name == "closeSpellbook" {
				self.removeFromParent()
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
