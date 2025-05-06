//
//  GameViewController.swift
//  ChainOfSpells
//
//  Created by Amelia Citra on 03/05/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Pastikan view bisa dikonversi ke SKView
		if let view = self.view as? SKView {
			// Buat scene menggunakan ukuran view
            let scene = SelectElementScene(size: view.bounds.size)
			scene.scaleMode = .aspectFill
			
			// Tampilkan scene
			view.presentScene(scene)
			
			view.ignoresSiblingOrder = true
			view.showsFPS = true
			view.showsNodeCount = true
		}
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}
