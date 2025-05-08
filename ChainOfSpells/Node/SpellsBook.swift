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

		// Data comboData1 saja
		let comboData1: [(SKSpriteNode, SKSpriteNode, SKSpriteNode, String)] = [
			(fireCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, "Burn musuh 5% selama 2 turn."),
			(fireCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, "Explosive Damage x2."),
			(fireCard.copy() as! SKSpriteNode, waterCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, "20% chance musuh miss."),
			(waterCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, "Regen HP 10%."),
			(waterCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, "20% critical hit."),
			(windCard.copy() as! SKSpriteNode, fireCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, "Damage reduction 50%.")
		]

		// Buat satu halaman langsung
		let page = createPage(content: comboData1, size: bg.size)
		page.position = .zero
		page.zPosition = 2
		bg.addChild(page)
	}

	private func createPage(content: [(SKSpriteNode, SKSpriteNode, SKSpriteNode, String)], size: CGSize) -> SKNode {
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
