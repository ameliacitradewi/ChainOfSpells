//
//  MainMenu.swift
//  ChainOfSpells
//
//  Created by Amelia Citra on 08/05/25.
//

import SpriteKit
import AVFoundation

class MainMenu: SKScene {
	private var background: SKSpriteNode!
	private var playButton: SKSpriteNode!
	private var backgroundMusic: SKAudioNode!

	override func didMove(to view: SKView) {
		setupBackground()
		setupPlayButton()
		playBackgroundMusic()
	}

	private func setupBackground() {
		background = SKSpriteNode(imageNamed: "background_1")
		background.position = CGPoint(x: frame.midX, y: frame.midY)
		background.zPosition = -1
		background.size = self.size
		addChild(background)
	}

	private func setupPlayButton() {
		playButton = SKSpriteNode(imageNamed: "discard_button")
		playButton.name = "play"
		playButton.position = CGPoint(x: frame.midX, y: frame.midY)
		playButton.zPosition = 1
		playButton.setScale(0.3)
		addChild(playButton)
	}

	private func playBackgroundMusic() {
		if let path = Bundle.main.path(forResource: "forest-bg-music", ofType: "mp3") {
			let url = URL(fileURLWithPath: path)
			backgroundMusic = SKAudioNode(url: url)
			backgroundMusic.autoplayLooped = true
			addChild(backgroundMusic)
		} else {
			print("⚠️ forest-bg-music.mp3 not found!")
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let location = touches.first?.location(in: self) else { return }
		let touchedNode = atPoint(location)

		if touchedNode.name == "play" {
			let nextScene = SelectElementScene(size: self.size)
			nextScene.scaleMode = .aspectFill
			self.view?.presentScene(nextScene, transition: .fade(withDuration: 0.5))
		}
	}
}
