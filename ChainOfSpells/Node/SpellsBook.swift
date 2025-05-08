//
//  SpellsBook.swift
//  ChainOfSpells
//
//  Created by Amelia Citra on 08/05/25.
//

import SpriteKit

class SpellsBook: SKNode {
	// Element cards
	private let fireCard = SKSpriteNode(imageNamed: Element.fire.cardAsset)
	private let waterCard = SKSpriteNode(imageNamed: Element.water.cardAsset)
	private let windCard = SKSpriteNode(imageNamed: Element.wind.cardAsset)
	private let earthCard = SKSpriteNode(imageNamed: Element.earth.cardAsset)

	private let bookBackground = SKSpriteNode(imageNamed: "book_background.png")
	private let environmentBackground = SKSpriteNode(imageNamed: "environtment-bg.png")

	init(size: CGSize, elements: [Element]) {
		super.init()

		// Background cokelat utama
		let bg = SKSpriteNode(color: .brown, size: CGSize(width: size.width, height: size.height))
		bg.name = "bookBackground"
		bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
		bg.zPosition = 300
		addChild(bg)

		// Gambar latar belakang buku
		let spellBookImage = SKSpriteNode(imageNamed: "book_background")
		spellBookImage.size = CGSize(width: bg.size.width + 100, height: bg.size.height + 50)
		spellBookImage.position = CGPoint(x: 0, y: 0)
		spellBookImage.zPosition = 1
		bg.addChild(spellBookImage)

		// Tombol "Close"
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

		// Combo elemen: ikon + "+" + ikon + teks
		let comboData: [(SKSpriteNode, SKSpriteNode, String)] = [
			(fireCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, "Burn musuh 5% dari total damage selama 2 turn."),
			(fireCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, "Explosive Damage x2 total damage."),
			(fireCard.copy() as! SKSpriteNode, waterCard.copy() as! SKSpriteNode, "20% chance musuh miss saat menyerang."),
			(waterCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, "Regen HP 10% dari total HP kamu."),
			(waterCard.copy() as! SKSpriteNode, windCard.copy() as! SKSpriteNode, "20% chance critical hit (x2 damage)."),
			(windCard.copy() as! SKSpriteNode, earthCard.copy() as! SKSpriteNode, "Damage reduction 50% di turn selanjutnya.")
		]

		let iconSize = CGSize(width: 24, height: 32)
		let spacing: CGFloat = 4
		var startY = bg.size.height / 2 - 80

		for (icon1, icon2, desc) in comboData {
			let lineNode = SKNode()
			lineNode.position = CGPoint(x: -bg.size.width / 2 + 30, y: startY)
			lineNode.zPosition = 2

			icon1.size = iconSize
			icon2.size = iconSize

			// Ikon 1
			icon1.position = CGPoint(x: 0, y: 0)
			lineNode.addChild(icon1)

			// Simbol +
			let plus = SKLabelNode(text: "+")
			plus.fontName = fontName
			plus.fontSize = 18
			plus.fontColor = .white
			plus.horizontalAlignmentMode = .center
			plus.verticalAlignmentMode = .center

			let plusX = icon1.position.x + iconSize.width / 2 + spacing + plus.frame.width / 2
			plus.position = CGPoint(x: plusX, y: 0)
			lineNode.addChild(plus)

			// Ikon 2
			let icon2X = plus.position.x + plus.frame.width / 2 + spacing + iconSize.width / 2
			icon2.position = CGPoint(x: icon2X, y: 0)
			lineNode.addChild(icon2)

			// Label deskripsi
			let labelX = icon2.position.x + iconSize.width / 2 + 12
			let label = SKLabelNode(text: desc)
			label.fontName = fontName
			label.fontSize = 14
			label.fontColor = .white
			label.horizontalAlignmentMode = .left
			label.verticalAlignmentMode = .center
			label.position = CGPoint(x: labelX, y: 0)
			lineNode.addChild(label)

			bg.addChild(lineNode)
			startY -= 36
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
