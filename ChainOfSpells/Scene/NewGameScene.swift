//
//  NewGameScene.swift
//  ChainOfSpells
//
//  Created by Mushafa Fadzan Andira on 05/05/25.
//

import SpriteKit
import SwiftUICore

// MARK: - GameScene
class NewGameScene: SKScene {
    var stageInfo : StageModel?
    // MARK: Deck Properties
    private var deck: [CardModel] = []
    private var discardPile: [CardModel] = []
    private var currentDeck: [CardModel] = []
    private let cardBackTexture = SKTexture(imageNamed: "back-card")
    private let spellBookTexture = SKTexture(imageNamed: "spell_book")
    private var chainEffectNodes: [SKNode] = []
	private let remainingLabel = SKLabelNode(fontNamed: fontName)


    private var deckNode: SKSpriteNode!
    private let deckCountLabel = SKLabelNode(fontNamed: fontName)

    // MARK: Buttons & Selection
    private let attackButton = SKSpriteNode(imageNamed: "btn-attack")
    private let discardButton = SKSpriteNode(imageNamed: "btn-discard")
    private var playAreaCards = [CardNode]()
    private var selectedCards = [CardNode]()
    private var playedCards = [CardNode]()

    private let playAreaPadding: CGFloat = 4
    private var playAreaPosition: CGPoint { CGPoint(x: frame.midX, y: frame.midY - 130) }

    // MARK: Boss Properties
    private var bossSprite = SKSpriteNode(imageNamed: "boss")
    private var bossHealth: Int = 10
    private var bossMaxHealth: Int = 10
    private var bossHealthBar: SKSpriteNode!
    private var fullTexture: SKTexture!
    private let fullBarWidth: CGFloat = 200
    private let barHeight: CGFloat   = 30
    private var bossHealthLabel = SKLabelNode()
    private var enemyChainEffectNode = SKSpriteNode(imageNamed: "momentum")
    private var enemyChainEffecTypeNode = SKSpriteNode(imageNamed: "chain_burn")

    
    // MARK: Player Progression
    private var maxSelection = 1
    private var cardInHand = 3
	
	// MARK: Player Properties
    private var playerHp = 10
    private var playerMaxHp = 10
	private var playerDamageTaken: Int = 0
	
	private let momentumLabel = SKLabelNode(fontNamed: fontName)
    private let momentumMultiplierLabel = SKLabelNode(fontNamed: fontName)

    // MARK: Labels & State
    private let victoryLabel = SKLabelNode(fontNamed: fontName)
   

    private let playerHpLabel = SKLabelNode(fontNamed: fontName)
    private var discardLeft = 3
    private let discardLeftLabel = SKLabelNode(fontNamed: fontName)
    private let comboBackground = SKSpriteNode(imageNamed: "combo-bg")
    private let comboInfoLabel = SKLabelNode(fontNamed: fontName)
    private let gameOverLabel = SKLabelNode(fontNamed: fontName)
    private var isAnimating = false
    
    // MARK: – Sound Effects
    private let attackSound = SKAction.playSoundFileNamed("attack.mp3", waitForCompletion: false)
    private let enemyAttackSound = SKAction.playSoundFileNamed("attack.mp3", waitForCompletion: false)
    private let clickSound = SKAction.playSoundFileNamed("button-click.mp3", waitForCompletion: false)
    private let cardDrawSound = SKAction.playSoundFileNamed("card-draw.mp3", waitForCompletion: false)
    private var backgroundMusicNode: SKAudioNode!
    
    // UI
    private var background = SKSpriteNode(imageNamed: "")
    private let playerHpNode = SKSpriteNode(imageNamed: "player-hp")
    private let playerDiscard = SKSpriteNode(imageNamed: "discard-card")
    private let statusLabel = SKLabelNode(fontNamed: fontName)
    private let momentumBar = SKSpriteNode(imageNamed: "momentum")

    // Chain Effect
    private var playerChainEffects : [ChainEffectModel] = []
    private var enemyChainEffect : ChainEffectModel?
    // Add momentum variables
    private var momentum: Int = 0
    private var momentumMultiplier: Int = 1
    private var lastMomentumElement: Element? = nil
    
    //rework attack
    private var currentAttackDamage: Int = 0
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        setGameRules()
        setBackgroundImage()
        initializeDeck()
        setupDeckNode()
        setupButtons()
        setupBoss()
        setupBossHealthBar()
        setupLabels()
        updateButtonVisibility()
        drawCardsFromDeck()

        let cameraNode = SKCameraNode()
        self.camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(cameraNode)
        
        if let path = Bundle.main.path(forResource: "forest-bg-music", ofType: "mp3") {
            // Initialize from that path
            let url = URL(fileURLWithPath: path)
            backgroundMusicNode = SKAudioNode(url: url)
            backgroundMusicNode?.autoplayLooped = true
            addChild(backgroundMusicNode!)
        } else {
            print("⚠️ backgroundMusic.mp3 not found in bundle!")
        }
    }
    
  
    
    // MARK: UPDATE ON PLAYER PROGRESSION
    private func setGameRules() {
        maxSelection = UserDefaults.standard.playerModel.elements.count
        cardInHand = UserDefaults.standard.playerModel.elements.count + 2
        playerChainEffects = []
        enemyChainEffect = stageInfo?.enemy.initialChainEffect

    }
    
    private func setBackgroundImage() {
        background = SKSpriteNode(imageNamed: stageInfo?.background ?? "")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = -100
        background.scale(to: frame.size, width: true, multiplier: 1)
        addChild(background)
    }
    
    // MARK: - Deck Management
    private func initializeDeck() {
        deck.removeAll()
        let elements = UserDefaults.standard.playerModel.elements
        for element in elements {
            for value in 1...10 {
                deck.append(CardModel(element: element, value: value))
            }
        }
        currentDeck = deck.shuffled()
        updateDeckCount()
    }

    private func updateDeckCount() {
        deckCountLabel.text = "\(currentDeck.count)/\(deck.count)"
    }

    private func setupDeckNode() {
        deckNode = SKSpriteNode(texture: spellBookTexture)
        deckNode.position = CGPoint(x: frame.midX + 350, y: frame.midY - 115)
        deckNode.scale(to: frame.size, width: false, multiplier: 0.3)
//        scaleCard(deckNode)
        addChild(deckNode)

        deckCountLabel.fontSize = 20
        deckCountLabel.fontColor = .white
        deckCountLabel.position = CGPoint(x: deckNode.position.x, y: deckNode.position.y - 50)
        addChild(deckCountLabel)
		
		remainingLabel.text = "Remaining Spells"
		remainingLabel.fontSize = 14
		remainingLabel.fontColor = .white
		remainingLabel.position = CGPoint(x: deckNode.position.x, y: deckCountLabel.position.y - 14)
		addChild(remainingLabel)
    }

    // MARK: - Buttons Setup
    private func setupButtons() {
        let buttonY: CGFloat = frame.midY - 30
        attackButton.name = "attack"
        discardButton.name = "discard"

        [attackButton, discardButton].forEach { button in
            button.zPosition = 10
            button.scale(to: frame.size, width: false, multiplier: 0.09)
            button.isHidden = true
            addChild(button)
        }
        attackButton.position = CGPoint(x: frame.midX - 40, y: buttonY)
        discardButton.position = CGPoint(x: frame.midX + 40, y: buttonY)
    }

    // MARK: - Button Visibility
    private func updateButtonVisibility() {
        let hasSelection = !selectedCards.isEmpty

        // Attack button only when you have a selection
        attackButton.isHidden = !hasSelection

        // Discard button also only when you have a selection…
        discardButton.isHidden = !hasSelection

        if discardLeft == 0 {
            discardButton.color = .gray
            discardButton.colorBlendFactor = 0.7
        } else {
            discardButton.colorBlendFactor = 0
        }
    }
    
    private func setupBossHealthBar() {
        // 1) Enemy Chain Effect
        enemyChainEffectNode.position =  CGPoint(x: frame.midX - 115, y: frame.maxY - 30)
        enemyChainEffectNode.size = CGSize(width: 30, height: 30)
        enemyChainEffecTypeNode.size = CGSize(width: 20, height: 20)
      
        if enemyChainEffect != nil{
            switch enemyChainEffect!.type   {
            case .burn: enemyChainEffecTypeNode.texture = SKTexture(imageNamed: "chain_burn")
            case .explosion: enemyChainEffecTypeNode.texture = SKTexture(imageNamed: "chain_explosion")
            case .mist: enemyChainEffecTypeNode.texture = SKTexture(imageNamed: "chain_mist")
            case .critical: enemyChainEffecTypeNode.texture = SKTexture(imageNamed: "chain_critical")
            case .regeneration: enemyChainEffecTypeNode.texture = SKTexture(imageNamed: "chain_regeneration")
            case .damageReduction:enemyChainEffecTypeNode.texture = SKTexture(imageNamed: "chain_damage_reduction")
            }
        }
        addChild(enemyChainEffectNode)
        enemyChainEffectNode.addChild(enemyChainEffecTypeNode)
        if enemyChainEffect == nil{
            enemyChainEffecTypeNode.isHidden = true
        }
        
        // 2) Bar container
        bossHealthBar = SKSpriteNode()
        bossHealthBar.position =  CGPoint(x: frame.midX, y: frame.maxY)
        // 1) Load the full-size texture once
        fullTexture = SKTexture(imageNamed: "enemy-hp-bar")

        // 2) Create your bar sprite, anchored to the left
        //    Initially show the full 100%
        let initialRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let tex = SKTexture(rect: initialRect, in: fullTexture)
        bossHealthBar = SKSpriteNode(texture: tex)
        bossHealthBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        bossHealthBar.size = CGSize(width: fullBarWidth, height: barHeight)

        // 3) Position it in your scene
        bossHealthBar.position = CGPoint(x: frame.midX - fullBarWidth/2,
                                         y: frame.maxY - 30)
        addChild(bossHealthBar)
        
        // 3) Add the HP background behind the fill
        let hpBg = SKSpriteNode(imageNamed: "enemy-hp-bar-bg")
        hpBg.size = CGSize(width: fullBarWidth, height: barHeight)
        hpBg.position = CGPoint(x: frame.midX,
                               y: bossHealthBar.position.y)
        hpBg.zPosition = bossHealthBar.zPosition - 1
        addChild(hpBg)

        // 4) Configure and add the label on top
        bossHealthLabel.text      = "\(bossHealth)/\(bossMaxHealth)"
        bossHealthLabel.fontName  = fontName
        bossHealthLabel.fontSize  = 14
        bossHealthLabel.fontColor = .white
        bossHealthLabel.position  = CGPoint(x: frame.midX,
                                            y: bossHealthBar.position.y - 5)
        bossHealthLabel.zPosition = bossHealthBar.zPosition + 1
        addChild(bossHealthLabel)
        
    }
    
    private func updateBossHealthBar() {
        // 1) Compute your health ratio (0…1)
        let ratio = max(0, min(1, CGFloat(bossHealth) / CGFloat(bossMaxHealth)))

        // 2) Build a new rect sampling only [0…ratio] horizontally
        let cropRect = CGRect(x: 0, y: 0, width: ratio, height: 1)

        // 3) Create the sub-texture and assign it
        let cropped = SKTexture(rect: cropRect, in: fullTexture)
        bossHealthBar.texture = cropped

        // 4) Animate the sprite’s width to match the new texture
        let newWidth = fullBarWidth * ratio
        let resize   = SKAction.resize(toWidth: newWidth, duration: 0.15)
        bossHealthBar.run(resize)

        // 5) (Optional) update your health label
        bossHealthLabel.text = "\(bossHealth)/\(bossMaxHealth)"
    }
    
    // MARK: – Boss Setup (using centerRect for slicing)
    private func setupBoss() {
        // 1) Usual boss sprite
        bossSprite = SKSpriteNode(imageNamed: stageInfo?.enemy.idleAnimations.first ?? "")
        bossHealth    = stageInfo?.enemy.hp ?? 0
        bossMaxHealth = stageInfo?.enemy.hp ?? 0
        bossSprite.position = CGPoint(x: frame.midX, y: frame.height - 150)
        bossSprite.zPosition = -3
        bossSprite.scale(to: frame.size, width: false, multiplier: 0.5)
        addChild(bossSprite)
        startBossIdleAnimation()

    }
    
    private func startBossIdleAnimation() {
        var idleFrames: [SKTexture] = []
        let idleAtlas = SKTextureAtlas(named: "BossIdle")
        stageInfo?.enemy.idleAnimations.forEach {
            let textureName = $0
            let texture = idleAtlas.textureNamed(textureName)
            idleFrames.append(texture)
        }
        
        let idleAnimation = SKAction.animate(with: idleFrames, timePerFrame: 0.15, resize: false, restore: true)
        let repeatIdle = SKAction.repeatForever(idleAnimation)
//        let flashAnimation = SKAction.repeatForever(createBossFlashAction())
        bossSprite.run(repeatIdle, withKey: "bossIdle")
//        bossSprite.run(flashAnimation, withKey: "hit")

    }



    // MARK: - Labels Setup
    private func setupLabels() {
        // Momentum Bar - top
        momentumLabel.text = "x\(momentumMultiplier)"
        momentumLabel.fontSize = 18
        momentumLabel.fontColor = .white
        momentumLabel.horizontalAlignmentMode = .left
        momentumLabel.position = CGPoint(x: momentumBar.position.x + 35, y: frame.minY + 117)
        
        momentumBar.position = CGPoint(x: 18, y: frame.minY + 120)
        momentumBar.scale(to: frame.size, width: false, multiplier: 0.07)
        addChild(momentumLabel)
        addChild(momentumBar)
        
        // Discard left label below chances - middle
        discardLeftLabel.text = "x\(discardLeft)"
        discardLeftLabel.fontSize = 18
        discardLeftLabel.fontColor = .white
        discardLeftLabel.horizontalAlignmentMode = .left
        discardLeftLabel.position = CGPoint(x: playerDiscard.position.x + 35, y: frame.minY + 80)
        
        playerDiscard.position = CGPoint(x: 18, y: frame.minY + 85)
        playerDiscard.scale(to: frame.size, width: false, multiplier: 0.09)
        addChild(playerDiscard)
        addChild(discardLeftLabel)

        // HP Player Bar - bottom
        playerHpLabel.text = "\(playerHp)/\(playerMaxHp)"
        playerHpLabel.fontSize = 18
        playerHpLabel.fontColor = .white
        playerHpLabel.horizontalAlignmentMode = .left
        playerHpLabel.position = CGPoint(x: playerHpNode.position.x + 35, y: frame.minY + 43)
        
        playerHpNode.position = CGPoint(x: 18, y: frame.minY + 50)
        playerHpNode.scale(to: frame.size, width: false, multiplier: 0.06)
        addChild(playerHpLabel)
        addChild(playerHpNode)
		
		
		// Momentum Bar
        momentumLabel.text = "\(momentum)"
		momentumLabel.fontSize = 18
		momentumLabel.fontColor = .white
		momentumLabel.horizontalAlignmentMode = .center
		momentumLabel.position = CGPoint(x: 100, y: frame.midY - 180)
        
        comboBackground.position =  CGPoint(x: frame.midX, y: attackButton.position.y + 40)
        comboBackground.scale(to: frame.size, width: true, multiplier: 0.20)
        comboBackground.zPosition = -1
        addChild(comboBackground)
        comboBackground.isHidden = true
        comboInfoLabel.text = ""
        comboInfoLabel.fontSize = 16
        comboInfoLabel.fontColor = UIColor(named: "CardTextColor")
//        comboInfoLabel.horizontalAlignmentMode = .left
        comboInfoLabel.position = CGPoint(x: comboBackground.position.x, y: comboBackground.position.y - 5)
        addChild(comboInfoLabel)
        
        statusLabel.text = ""
        statusLabel.fontSize = 100
        statusLabel.fontColor = .green
        statusLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        statusLabel.zPosition = 20
        statusLabel.setScale(0)

        addChild(statusLabel)
        statusLabel.isHidden = true
       
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if childNode(withName: "restartWindow") != nil {
              // Block background interaction while popup is up
              return
          }
		
		if deckNode.contains(location) && !isAnimating {
			run(clickSound)
			showSpellbookOverlay()
			return
		}
		
		func showSpellbookOverlay() {
			guard childNode(withName: "spellbookOverlay") == nil else { return }

			let dim = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: self.size)
			dim.name = "spellbookOverlay"
			dim.zPosition = 250
			dim.position = CGPoint(x: size.width / 2, y: size.height / 2)
			addChild(dim)

			let bookNode = SpellsBook(size: self.size, elements: UserDefaults.standard.playerModel.elements)
			bookNode.zPosition = 251
			addChild(bookNode)
		}


        if !selectedCards.isEmpty {
            if attackButton.contains(location) {
                run(clickSound)
                handleAttack(); return }
            if discardButton.contains(location) {
                // only allow if still have discards left
                guard discardLeft > 0 else { return }
                run(clickSound)
                handleDiscard(); return
            }
        }
        for card in playAreaCards where card.contains(location) && !card.isAnimating && !isAnimating {
            handleCardSelection(card); return
        }
        
//        if !isAnimating && deckNode.contains(location) {
//            drawCardsFromDeck()
//        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)

        // If the popup is showing, allow interaction only with the popup
        if childNode(withName: "restartWindow") != nil {
            if node.name == "restartButton" {
                restartGame()
            }
            // Ignore all other touches while popup is visible
            return
        }
		
		if node.name == "closeSpellbook" {
			childNode(withName: "spellbookOverlay")?.removeFromParent()
			node.parent?.parent?.removeFromParent() // remove SpellsBook node
			return
		}

        // Your regular gameplay touch logic here
    }
    
    func restartGame() {
        let scene = NewGameScene(size: self.frame.size)
        scene.scaleMode = .aspectFill
        scene.stageInfo = self.stageInfo
        self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))

    }

    // MARK: - Card Selection
    private func handleCardSelection(_ card: CardNode) {
        let moveDur: TimeInterval = 0.2
        if card.isSelected {
            deselect(card, duration: moveDur)
        } else {
            select(card, duration: moveDur)
        }
    }

    private func select(_ card: CardNode, duration: TimeInterval) {
        guard selectedCards.count < maxSelection else { return }
        card.isAnimating = true
        run(clickSound)
        let up = CGPoint(x: card.position.x, y: card.originalPosition.y + 20)
        let move = SKAction.move(to: up, duration: duration)
        move.timingMode = .easeInEaseOut
        card.run(move) {
            card.isAnimating = false
            card.isSelected = true
            self.addGlow(to: card)
            
            self.selectedCards.append(card)
            self.updateButtonVisibility()
            self.updateComboInfo()
        }
    }

    private func deselect(_ card: CardNode, duration: TimeInterval) {
        card.isAnimating = true
        let move = SKAction.move(to: card.originalPosition, duration: duration)
        move.timingMode = .easeInEaseOut
        card.run(move) {
            card.isAnimating = false
            card.isSelected = false
            
            card.childNode(withName: "glow")?.removeFromParent()
            
            self.selectedCards.removeAll { $0 == card }
            self.updateButtonVisibility()
            self.updateComboInfo()
        }
    }

    // MARK: - Draw & Replace Cards
    private func drawCardsFromDeck() {
        attackButton.isHidden = true
        discardButton.isHidden = true
        isAnimating = true

        playAreaCards.forEach { $0.removeFromParent() }
        playAreaCards.removeAll()
        selectedCards.removeAll()

        let count = min(cardInHand, currentDeck.count)
        guard count > 0 else { isAnimating = false; return }

        let cardWidth : Double = 70
        let totalWidth = (cardWidth * CGFloat(count)) + (playAreaPadding * CGFloat(count - 1))
        var x = playAreaPosition.x - (totalWidth / 2) + (cardWidth / 2)
        var finalPositions = [CGPoint]()
        for _ in 0..<count {
            finalPositions.append(CGPoint(x: x, y: playAreaPosition.y))
            x += cardWidth + playAreaPadding
        }
        
        // Staging line below play area:
        let stagingOffset: CGFloat = -55
        let stagingPositions = finalPositions.map { CGPoint(x: $0.x, y: $0.y + stagingOffset) }

        animateDrawing(from: stagingPositions, to: finalPositions, index: 0)
    }

    private func animateDrawing(from stagingPositions: [CGPoint], to finalPositions: [CGPoint], index: Int) {
        guard index < finalPositions.count else {
            isAnimating = false
            // add glow after all cards drawing
            let moveDuration: TimeInterval = 0.6
            run(.sequence([
                .wait(forDuration: 0.1),
                .run { [weak self] in
                    guard let self = self else { return }
                    for card in self.playAreaCards {
                        let moveUp = SKAction.move(to: card.originalPosition,
                                                   duration: moveDuration)
                        moveUp.timingMode = .easeInEaseOut
                        card.run(moveUp)
                    }
                },
                .wait(forDuration: moveDuration + 0.05),
                .run { [weak self] in
                    guard let self = self else { return }
                    self.playAreaCards.forEach { self.addTemporaryGlow(to: $0) }
                }
            ]))
            ; return
        }
        let def = currentDeck.removeFirst()
        updateDeckCount()
        let card = CardNode(texture: cardBackTexture)
        card.position = deckNode.position
        card.originalPosition = finalPositions[index]
        card.attackValue = def.value
        card.element = def.element
        card.valueLabel.text = "\(def.value)"
        card.valueLabel.isHidden = true
        scaleCard(card)
//        addGlow(to: card)
        addChild(card)
        
        run(cardDrawSound)
        
        playAreaCards.append(card)

        // Animate move/flip/pop, then recurse—no glow here any more
        animateCard(card, to: stagingPositions[index]) { [weak self] in
            guard let self = self else { return }
            self.animateDrawing(from: stagingPositions,
                                to: finalPositions,
                                index: index + 1)
        }
    }
    
    
    private func cardAttackAnimation() {
        guard !selectedCards.isEmpty else { return }
        let unusedCards  = selectedCards.filter{ !playedCards.contains($0) }
        let positions = selectedCards.map { $0.originalPosition }
        unusedCards.forEach { card in
            discardPile.append(CardModel(element: card.element, value: card.attackValue))
            let move = SKAction.group([.moveBy(x: 0, y: -500, duration: 0.5), .fadeOut(withDuration: 0.3)])
            card.run(.sequence([move, .removeFromParent()]))
        }
        playedCards.forEach { card in
            discardPile.append(CardModel(element: card.element, value: card.attackValue))
            let move = SKAction.group([.moveBy(x: 0, y: 500, duration: 0.5), .fadeOut(withDuration: 0.3)])
            card.run(.sequence([move, .removeFromParent()]))
        }
        
     


    }
    
    private func handleDiscardAnimation() {
                guard !selectedCards.isEmpty else { return }
                let positions = selectedCards.map { $0.originalPosition }
                selectedCards.forEach { card in
                    discardPile.append(CardModel(element: card.element, value: card.attackValue))
                    let move = SKAction.group([.moveBy(x: 0, y: -1000, duration: 0.5), .fadeOut(withDuration: 0.3)])
                    card.run(.sequence([move, .removeFromParent()]))
                }
                playAreaCards.removeAll(where: { selectedCards.contains($0) })
                selectedCards.removeAll()
        animateReplacement(at: positions, remaining: positions.count,targetPositions : positions)
    }

    private func replaceSelectedCards() {
       let positions = selectedCards.map { $0.originalPosition }
        playAreaCards.removeAll(where: { selectedCards.contains($0) })
        selectedCards.removeAll()
        animateReplacement(at: positions, remaining: positions.count,targetPositions : positions)
    }
    
    private func replaceSelectedCardsAfterAttack() {
        let originalPosition = selectedCards.map { $0.originalPosition }
        let positions = selectedCards.map { $0.stagingPosition }
        animateReplacement(at: originalPosition, remaining: positions.count,targetPositions: positions)
    }

    
    private func animateReplacement(at originalPositions: [CGPoint], remaining: Int,targetPositions: [CGPoint]) {
        var left = remaining

        for index in targetPositions.indices {
            // If the deck is empty, just count down
            guard !currentDeck.isEmpty else {
                left -= 1
                if left == 0 {
                    self.isAnimating = false
                    self.updateDeckCount()
                }
                continue
            }

            // Pull next card, create node, add to play area
            let def = currentDeck.removeFirst()
            updateDeckCount()

            let card = CardNode(texture: cardBackTexture)
            card.position = deckNode.position
            card.originalPosition = originalPositions[index]
            card.attackValue = def.value
            card.element = def.element
            card.valueLabel.text = "\(def.value)"
            card.valueLabel.isHidden = true
            scaleCard(card)
            addChild(card)
            
            run(cardDrawSound)
            
            playAreaCards.append(card)

            // Animate flip/move/pop into place…
            animateCard(card, to: targetPositions[index]) {
                left -= 1
                if left == 0 {
                    // All replacements done
                    self.isAnimating = false
                }
            }
        }
    }


    // MARK: - Attack & Discard
	private func shakeBackground(duration: TimeInterval = 0.6, amplitude: CGFloat = 15) {
        guard let cam = camera else { return }
        let originalPosition = cam.position

        // How many small shakes?
        let shakeCount = Int(duration / 0.02)
        var actions = [SKAction]()

        for _ in 0..<shakeCount {
            // random offset in ±amplitude
            let dx = CGFloat.random(in: -amplitude...amplitude)
            let dy = CGFloat.random(in: -amplitude...amplitude)
            let shake = SKAction.move(to: CGPoint(x: originalPosition.x + dx,
                                                   y: originalPosition.y + dy),
                                      duration: 0.02)
            shake.timingMode = .easeOut
            actions.append(shake)
        }

        // then return to the original spot
        actions.append(SKAction.move(to: originalPosition, duration: 0.02))

        cam.run(SKAction.sequence(actions))
	}

    
	
    private func handleAttack() {
        guard !selectedCards.isEmpty else { return }

        let (name, mult, comboCards) = evaluateCombo(for: selectedCards,addChainEffect: true)
        playedCards = comboCards
        let base = comboCards.reduce(0) { $0 + $1.attackValue }
        
        // Momentum Logic
        let selectedElements = playedCards.map { $0.element }
        guard let firstElement = selectedElements.first else { return }
        let allSame = selectedElements.allSatisfy { $0 == firstElement }
        
        if allSame {
            let currentElement = selectedElements[0]
            
            if lastMomentumElement == nil {
                // FIRST ELEMENT EVER - Always add 25
                momentum = 25 * playedCards.count
            }
            else if currentElement == lastMomentumElement {
                // SAME ELEMENT - Accumulate
                momentum += 25 * playedCards.count
            }
            else {
                // DIFFERENT ELEMENT - Reset to 0
                momentum = 0
                momentumMultiplier = 1
            }
            
            lastMomentumElement = currentElement
        } else {
            momentum = 0
            momentumMultiplier = 1
            lastMomentumElement = nil
        }
        
        let levelsGained = momentum / 100
        if levelsGained > 0 {
            momentumMultiplier += levelsGained
            momentum %= 100  // Carry over excess momentum
            print("Momentum Multiplier: \(momentumMultiplier)")
        }
        
        print("Current Momentum: \(momentum)")
        momentumLabel.text = "\(momentum)"
        momentumMultiplierLabel.text = "x\(momentumMultiplier)"
        
        currentAttackDamage = Int(Double(base) * mult * (Double(momentumMultiplier)))
        print("Attack: \(name) ×\(mult) → Combo Cards: \(comboCards.map { $0.attackValue }), Damage = \(currentAttackDamage)")
        
        // Player Chain Effect Calculation
        if !playerChainEffects.isEmpty{
            playerChainEffects.forEach {
                switch $0.type {
                case .burn: do {
                    
                }
                case .explosion: do {
                    switch $0.level {
                    case .base: do {
                        currentAttackDamage = Int(Double(currentAttackDamage) * 1.2)
                        
                    }
                    case .strong: do {
                        currentAttackDamage = Int(Double(currentAttackDamage) * 1.4)
                    }
                    case .enemy: do {
                        currentAttackDamage = Int(Double(currentAttackDamage) * 1.2)
                    }
                    }
                    statusLabel.isHidden = false
                    statusLabel.text = "EXPLOSION!"
                    statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                }
                case .mist: do {
                    
                }
                case .critical: do {
                    switch $0.level {
                    case .base: do {
                        let randomNumber = Int.random(in: 1...100)
                        switch randomNumber {
                        case 1...20: do {
                            currentAttackDamage *= 2
                            statusLabel.text = "CRITICAL!"
                            statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                        }
                        default:
                            break
                        }
                    }
                        
                    case .strong: do {
                        let randomNumber = Int.random(in: 1...100)
                        switch randomNumber {
                        case 1...40: do {
                            currentAttackDamage *= 2
                            statusLabel.text = "CRITICAL!"
                            statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                        }
                        default:
                            break
                        }
                    }
                    case .enemy: do {
                        let randomNumber = Int.random(in: 1...100)
                        switch randomNumber {
                        case 1...20: do {
                            currentAttackDamage *= 2
                            statusLabel.text = "CRITICAL!"
                            statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                        }
                        default:
                            break
                        }
                    }
                    }
                }
                case .regeneration: do {
                    switch $0.level {
                    case .base: do {
                        let regen = Int(Double(playerMaxHp) * 0.1)
                        playerHp += regen
                    }
                        
                    case .strong: do {
                        let regen = Int(Double(playerMaxHp) * 0.15)
                        playerHp += regen
                    }
                    case .enemy: do {
                        let regen = Int(Double(playerMaxHp) * 0.1)
                        playerHp += regen
                    }
                    }
                    playerHpLabel.text = "\(playerHp)/\(playerMaxHp)"
                }
                case .damageReduction: do {
                    
                }
                }            }
           
        }
        updatePlayerChainEffects()
        
        guard bossHealth > 0 else { return }
        
        let delay = SKAction.wait(forDuration: 1.0)
        let callTransition = SKAction.run { [weak self] in
            self?.animateHandTransitionAfterAttack()
        }
        run(.sequence([delay, callTransition]))

    }

    private func handleDiscard() {
        guard !selectedCards.isEmpty else { return }
        comboBackground.isHidden = true
        comboInfoLabel.text = ""
        discardLeft = max(0, discardLeft - 1)
        discardLeftLabel.text = "x\(discardLeft)"
        if discardLeft == 0 {
            discardButton.color = .gray
            discardButton.colorBlendFactor = 0.7
        }
        
        handleDiscardAnimation()
        updateDeckCount()
        updateButtonVisibility()
    }

    // MARK: - Boss & Endgame
    private func showGameOver() {
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 100
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 20
        gameOverLabel.setScale(0)

        addChild(gameOverLabel)
        gameOverLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.3), .scale(to: 1.0, duration: 0.2)]))
        isUserInteractionEnabled = false
        // Delay the call to gotoNextLevel by 3 seconds
           run(SKAction.sequence([
               SKAction.wait(forDuration: 2.0),
               SKAction.run { [weak self] in
                   self?.showRestartWindow()
                   self?.isUserInteractionEnabled = true

               }
           ]))
    }
    
    // MARK: - Boss Shake Animation
    private func createBossShakeAnimation() -> SKAction {
        let shakeDistance: CGFloat = 15
        let duration: TimeInterval = 0.05
        
        let shakeLeft = SKAction.moveBy(x: -shakeDistance, y: 0, duration: duration)
        let shakeRight = SKAction.moveBy(x: shakeDistance * 2, y: 0, duration: duration)
        let shakeLeft2 = SKAction.moveBy(x: -shakeDistance * 2, y: 0, duration: duration)
        let shakeRight2 = SKAction.moveBy(x: shakeDistance * 2, y: 0, duration: duration)
        let reset = SKAction.moveBy(x: -shakeDistance, y: 0, duration: duration)
        
        return SKAction.sequence([shakeLeft, shakeRight, shakeLeft2, shakeRight2, reset])
    }
    
    // MARK: – Update Boss Health (using resize action)
    private func updateBossHealth(damage: Int) {
        bossHealth = max(0, bossHealth - damage)
        let ratio = CGFloat(bossHealth) / CGFloat(bossMaxHealth)

        // Find the sliced bar by name:
        if let hpBar = bossHealthBar.childNode(withName: "healthBar") as? SKSpriteNode {
            let fullBarWidth: CGFloat = 200
            let newWidth = fullBarWidth * ratio

            // Animate width change; corners stay intact
            hpBar.run(.resize(toWidth: newWidth, duration: 0.2))
        }

        bossHealthLabel.text = "\(bossHealth)/\(bossMaxHealth)"
        
        // Trigger shake when damage is taken
        if damage > 0 {
            bossSprite.run(createBossShakeAnimation())
            //hit effect
            bossSprite.run(createBossFlashAction())
        }
        
        if bossHealth <= 0 { bossDefeated() }
    }


    private func bossDefeated() {
        // Stop idle animation
        bossSprite.removeAction(forKey: "bossIdle")
        
        bossSprite.texture = SKTexture(imageNamed: "boss-lose")
        
        // 2. Create fade-out animation
        let fadeOut = SKAction.fadeOut(withDuration: 2.0) // 2-second fade
        let removeNode = SKAction.removeFromParent()
        
        // Optional: Combine with sinking movement
        let sink = SKAction.moveBy(x: 0, y: -30, duration: 2.0)
        let fadeAndMove = SKAction.group([fadeOut, sink])
        
        // 3. Run sequence
        bossSprite.run(.sequence([fadeAndMove, removeNode])) {
            // Completion handler if needed
        }
        
        victoryLabel.text = "Enemy Defeated!"
        victoryLabel.fontSize = 100
        victoryLabel.fontColor = .yellow
        victoryLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        victoryLabel.zPosition = 20
        victoryLabel.setScale(0)

        addChild(victoryLabel)
        victoryLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2)]))
        isUserInteractionEnabled = false
        // Delay the call to gotoNextLevel by 3 seconds
           run(SKAction.sequence([
               SKAction.wait(forDuration: 3.0),
               SKAction.run { [weak self] in
                   self?.gotoNextLevel()
               }
           ]))
    }
    
    //MARK: New combo function
    // MARK: - Evaluate Combo (returns combo name, multiplier, and relevant cards)
    private func evaluateCombo(for cards: [CardNode], addChainEffect : Bool) -> (name: String, multiplier: Double, comboCards: [CardNode]) {
        let allElements = cards.map { $0.element }
        let allValues = cards.map { $0.attackValue }

        // 4-card combos
        if cards.count >= 4 {
            for combo in combinations(of: cards, size: 4) {
                let elements = combo.map { $0.element }
                let elementCounts = Dictionary(grouping: elements, by: { $0 }).mapValues { $0.count }

                if elementCounts.values.contains(4) {
                    return ("Chain of Spells", 3, combo)
                }

                // Check for two 2-card pairs forming a known combo twice
                let sortedElements = elements.sorted()
                if sortedElements == [.fire, .fire, .wind, .wind] || sortedElements == [.wind, .wind, .fire, .fire] {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .burn }) {
                            playerChainEffects[index] = ChainEffectModel(type: .burn, remainingTurn: 2, level: .strong)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .burn, remainingTurn: 2, level: .strong))
                        }
                    }
                    
                    return ("Strong Burn", 1, combo)
                } else if sortedElements == [.fire, .fire, .water, .water] || sortedElements == [.water, .water, .fire, .fire] {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .mist }) {
                            playerChainEffects[index] = ChainEffectModel(type: .mist, remainingTurn: 2, level: .strong)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .mist, remainingTurn: 2, level: .strong))
                        }
                        
                    }
                    
                    return ("Strong Mist", 1, combo)
                } else if sortedElements == [.earth, .earth, .wind, .wind] || sortedElements == [.wind, .wind, .earth, .earth] {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .damageReduction }) {
                            playerChainEffects[index] = ChainEffectModel(type: .damageReduction, remainingTurn: 2, level: .strong)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .damageReduction, remainingTurn: 2, level: .strong))
                        }
                    }
               
                    return ("Strong Sandstorm", 1, combo)
                } else if sortedElements == [.fire, .fire, .earth, .earth] || sortedElements == [.earth, .earth, .fire, .fire] {
                    if(addChainEffect){
                        playerChainEffects.append(ChainEffectModel(type: .explosion, remainingTurn: 1, level: .strong))
                    }
                
                    return ("Strong Explosion", 1, combo)
                } else if sortedElements == [.water, .water, .wind, .wind] || sortedElements == [.wind, .wind, .water, .water] {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .critical }) {
                            playerChainEffects[index] = ChainEffectModel(type: .critical, remainingTurn: 2, level: .strong)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .critical, remainingTurn: 2, level: .strong))
                        }
                        
                    }
                    
                    return ("Strong Storm", 1, combo)
                } else if sortedElements == [.water, .water, .earth, .earth] || sortedElements == [.earth, .earth, .water, .water] {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .regeneration }) {
                            playerChainEffects[index] = ChainEffectModel(type: .regeneration, remainingTurn: 2, level: .strong)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .regeneration, remainingTurn: 2, level: .strong))
                        }
                    }
                    return ("Strong Nature", 1, combo)
                }
            }
        }

        // 3-card combos
        if cards.count >= 3 {
            for combo in combinations(of: cards, size: 3) {
                let elements = combo.map { $0.element }
                let elementCounts = Dictionary(grouping: elements, by: { $0 }).mapValues { $0.count }
                if elementCounts.values.contains(3) {
                    return ("Chain of Spells", 2.0, combo)
                }
            }
        }

        // Reject 4-card hands with no duplicates (no possible combo)
        if cards.count >= 4 {
            let uniqueElements = Set(allElements)
            if uniqueElements.count == cards.count {
                let highestCard = cards.max(by: { $0.attackValue < $1.attackValue })!
                return ("Basic Spell", 1.0, [highestCard])
            }
        }
        // Reject 3-card hands with no duplicates (no possible combo)
        if cards.count >= 3 {
            let uniqueElements = Set(allElements)
            if uniqueElements.count == cards.count {
                let highestCard = cards.max(by: { $0.attackValue < $1.attackValue })!
                return ("Basic Spell", 1.0, [highestCard])
            }
        }
        
        // 2-card combos
        if cards.count >= 2 {
            for combo in combinations(of: cards, size: 2) {
                let elements = combo.map { $0.element }

                // Prioritize same-element pair (Chain of Spells)
                if elements[0] == elements[1] {
                    return ("Chain of Spells", 1.5, combo)
                }
            }

            // If no same-element pairs found, then check mixed-element combos
            for combo in combinations(of: cards, size: 2) {
                let elements = combo.map { $0.element }
                let elementSet = Set(elements)

                switch elementSet {
                case [.fire, .water], [.water, .fire]: do {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .mist }) {
                            playerChainEffects[index] = ChainEffectModel(type: .mist, remainingTurn: 2, level: .base)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .mist, remainingTurn: 2, level: .base))
                        }
                    }
                
                    return ("Mist", 1, combo)
                }
                case [.earth, .wind], [.wind, .earth]: do {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .damageReduction }) {
                            playerChainEffects[index] = ChainEffectModel(type: .damageReduction, remainingTurn: 2, level: .base)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .damageReduction, remainingTurn: 2, level: .base))
                        }
                        
                    }
                   
                    return ("Sandstorm", 1, combo)
                }
                case [.fire, .wind], [.wind, .fire]: do {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .burn }) {
                            playerChainEffects[index] = ChainEffectModel(type: .burn, remainingTurn: 2, level: .base)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .burn, remainingTurn: 2, level: .base))
                        }
                    }
                    
                    return ("Burn", 1, combo)
                }
                case [.fire, .earth], [.earth, .fire]: do {
                    if(addChainEffect){
                        playerChainEffects.append( ChainEffectModel(type: .explosion, remainingTurn: 1, level: .base))
                    }
                   
                    return ("Explosion", 1, combo)
                }
                case [.water, .wind], [.wind, .water]: do {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .critical }) {
                            playerChainEffects[index] = ChainEffectModel(type: .critical, remainingTurn: 2, level: .base)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .critical, remainingTurn: 2, level: .base))
                        }
                    }
                    return ("Storm", 1, combo)
                }
                case [.water, .earth], [.earth, .water]: do {
                    if(addChainEffect){
                        if let index = playerChainEffects.firstIndex(where: { $0.type == .critical }) {
                            playerChainEffects[index] = ChainEffectModel(type: .regeneration, remainingTurn: 1, level: .base)
                        } else{
                            playerChainEffects.append(ChainEffectModel(type: .regeneration, remainingTurn: 1, level: .base))
                        }
                    }
                  
                    return ("Nature", 1, combo)
                }
                default: break
                }
            }
        }

        // No combo found → Basic Spell (highest single card)
        let highestCard = cards.max(by: { $0.attackValue < $1.attackValue })!
        return ("Basic Spell", 1.0, [highestCard])
    }

    // Helper: Generate combinations of a specific size
    private func combinations<T>(of array: [T], size: Int) -> [[T]] {
        guard array.count >= size else { return [] }
        guard size > 0 else { return [[]] }
        
        return array.indices.flatMap { index -> [[T]] in
            let element = array[index]
            let subArray = Array(array[(index + 1)...])
            return combinations(of: subArray, size: size - 1).map { [element] + $0 }
        }
    }
    
    func updatePlayerChainEffectsCountdown(){
        playerChainEffects = playerChainEffects.compactMap { effect in
            var updatedEffect = effect
            updatedEffect.remainingTurn -= 1
            return updatedEffect.remainingTurn > 0 ? updatedEffect : nil
        }
    }
    
    func updatePlayerChainEffects() {
        chainEffectNodes.forEach { $0.removeFromParent() }
        chainEffectNodes = []
        for (index, effect) in playerChainEffects.enumerated() {
            let containerNode = SKSpriteNode(imageNamed: "momentum")
            let yPostion = (momentumBar.position.y + CGFloat((index + 1)) * 35)
            containerNode.position = CGPoint(x: 18, y: yPostion)

            containerNode.size = CGSize(width: 30, height: 30)
            containerNode.zPosition = 12

            var chainAsset = ""
            switch effect.type {
            case .burn: chainAsset = "chain_burn"
            case .explosion:chainAsset = "chain_explosion"
            case .mist:chainAsset = "chain_mist"
            case .critical:chainAsset = "chain_critical"
            case .regeneration:chainAsset = "chain_regeneration"
            case .damageReduction:chainAsset = "chain_damage_reduction"
            }
            print("CHAIN ASSET \(chainAsset)")
            let chainNode = SKSpriteNode(imageNamed: chainAsset)
            chainNode.size = CGSize(width: 20, height: 20)
            chainNode.position = CGPoint(x: 0, y: 0)
            chainNode.zPosition = 13
            containerNode.addChild(chainNode)
            chainEffectNodes.append(containerNode)
            addChild(containerNode)
        }
       
        
    }
    
    // MARK: - Combo Info Update
    private func updateComboInfo() {
        guard !selectedCards.isEmpty else {
            comboInfoLabel.text = ""
            comboBackground.isHidden = true
            return
        }
        let (name, mult, comboCards) = evaluateCombo(for: selectedCards,addChainEffect: false)
        
        // Convert sum to Double first, multiply, then cast to Int
        let damage = Int(Double(comboCards.reduce(0) { $0 + $1.attackValue }) * mult)
        
        comboInfoLabel.text = "\(name): \(damage)"
        comboBackground.isHidden = false


    }

    private func scaleCard(_ card: SKSpriteNode) {
        card.scale(to: frame.size, width: false, multiplier: 0.25)
        card.texture?.filteringMode = .nearest
        if let cardNode = card as? CardNode {
            cardNode.valueLabel.fontSize = 5.2 * (card.xScale / 0.25)
        }
    }

    private func animateCard(_ card: CardNode, to position: CGPoint, completion: @escaping () -> Void) {
		let moveDuration: TimeInterval = 0.6
		let half = moveDuration / 2
		let flipDuration: TimeInterval = 0.3
		let originalScale = card.xScale

		// Set initial small scale
		card.setScale(originalScale * 0.4)

		let move = SKAction.move(to: position, duration: moveDuration)

		let scaleUp = SKAction.scale(to: originalScale, duration: moveDuration)
			scaleUp.timingMode = .easeInEaseOut

		let flip = SKAction.sequence([
			.wait(forDuration: half - flipDuration/2),
			.scaleX(to: 0, duration: flipDuration/2),
			.run { card.texture = SKTexture(imageNamed: card.element.cardAsset); card.valueLabel.isHidden = false },
			.scaleX(to: originalScale, duration: flipDuration/2)
		])
		let pop = SKAction.sequence([.scale(to: originalScale * 1.1, duration: 0.1), .scale(to: originalScale, duration: 0.1)])

		//		// Group movement and scale animation
		//		let moveAndScale = SKAction.group([move, scaleUp])
		//
		card.run(.group([move, flip])) {
			card.run(pop) { completion() }
		}

    }
    
    // MARK: Temporary glow
    private func addTemporaryGlow(to card: SKSpriteNode, duration: TimeInterval = 0.5) {
        let size = CGSize(width: card.frame.width + 30, height: card.frame.height + 40)
        let glow = SKShapeNode(rectOf: size, cornerRadius: 0)
        glow.name = "tempGlow"
        glow.strokeColor = UIColor(red: 0.82, green: 0.59, blue: 0.20, alpha: 1)
        glow.lineWidth = 4
        glow.glowWidth = 4
        glow.alpha = 0
        glow.zPosition = card.zPosition - 1
        card.addChild(glow)

        let action = SKAction.sequence([
            .fadeAlpha(to: 1.0, duration: 0.2),
            .wait(forDuration: duration),
            .fadeAlpha(to: 0.0, duration: 0.2),
            .removeFromParent()
        ])
        glow.run(action)
    }
    
    private func addGlow(to card: SKSpriteNode) {
        // 1) compute the real, scaled size of the card
        let targetSize = CGSize(width: card.frame.width + 30,
                                height: card.frame.height + 40)

        // 2) make a rectangular shape with sharp corners
        let glow = SKShapeNode(rectOf: targetSize, cornerRadius: 0)
        glow.name = "glow"
        glow.strokeColor = UIColor(cgColor: CGColor(red: 0.820, green: 0.592, blue: 0.196, alpha: 1))
        glow.lineWidth = 4
        glow.glowWidth = 4
        glow.zPosition = card.zPosition - 1

        // 3) center it on the card
        glow.position = CGPoint.zero
        card.addChild(glow)
        
        // Animate alpha for pulsing glow effect
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.8)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        let pulse = SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
        glow.run(pulse)
    }
    
    // Enemy Attack
    private func enemyAttack() {
        let attackValue = Int.random(in: 20...40)
        var damage : Double = Double(playerMaxHp) * Double(attackValue) / 100
        print("ATTACK VALUE : \(attackValue)")
        print("DAMAGE VALUE : \(damage)")
        // Check if Dodge
        if let mistChainEffect = playerChainEffects.first(where: { $0.type == .mist }) {
            switch mistChainEffect.level {
                
            case .base: do {
                let randomNumber = Int.random(in: 1...100)
                switch randomNumber {
                case 1...20: do {
                    statusLabel.text = "MISS!"
                    statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                    damage = 0
                }
                default:
                    break
                }
            }
            case .strong: do {
                let randomNumber = Int.random(in: 1...100)
                switch randomNumber {
                case 1...40: do {
                    statusLabel.text = "MISS!"
                    statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                    damage = 0
                }
                default:
                    break
                }
            }
            case .enemy: do {
                let randomNumber = Int.random(in: 1...100)
                switch randomNumber {
                case 1...20: do {
                    statusLabel.text = "MISS!"
                    statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.5), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
                    damage = 0
                }
                default:
                    break
                }
            }
            }
        }
        
        // Check if damage reduction
        if let mistChainEffect = playerChainEffects.first(where: { $0.type == .damageReduction }) {
            switch mistChainEffect.level {
                
            case .base: do {
                damage *= 0.8
            }
            case .strong: do {
                damage *= 0.5

            }
            case .enemy: do {
                damage *= 0.8
            }
            }
        }
        
        playerHp = playerHp - Int(damage)
    }
    
    // MARK: – Animate Hand Transition after Attack
    private func animateHandTransitionAfterAttack() {
        isAnimating = true
        attackButton.isHidden = true
        discardButton.isHidden = true

        // Precompute positions
        let stagingOffset: CGFloat    = -55
        let finalPositions            = playAreaCards.map { $0.originalPosition }
        let stagingPositions          = finalPositions.map { CGPoint(x: $0.x, y: $0.y + stagingOffset) }

        // Timings
        let enemyAttackDelay: TimeInterval     = 1.5
        let moveDur: TimeInterval     = 0.5
        let buffer: TimeInterval      = 0.05
        let shakeDur: TimeInterval    = 0.6    // match your shakeBackground duration
        let replacementDur: TimeInterval = 0.8
        let postReplaceBuffer: TimeInterval = 0.1
        var burnTimer: TimeInterval = 0

        run(.sequence([

            // 1) Slide all cards down to staging
            .run { [weak self] in
                guard let self = self else { return }
                for (card, target) in zip(self.playAreaCards, stagingPositions) {
                    card.stagingPosition = target
                    let m = SKAction.move(to: target, duration: moveDur)
                    m.timingMode = .easeInEaseOut
                    // Only play animation on card that are not selected
                    if !self.selectedCards.contains(card){
                        card.run(m)
                    }
                }
            },
            .wait(forDuration: moveDur + buffer),
            
            .run { [weak self] in
                guard let self = self else { return }
                cardAttackAnimation()
                comboBackground.isHidden = true
                comboInfoLabel.text = ""
//                let base = selectedCards.reduce(0) { $0 + $1.attackValue }
//                let (name, mult, comboCards) = evaluateCombo(for: selectedCards)
//                let total = Int(Double(base) * mult)
//                print("Attack: \(name) ×\(mult) → Base = \(base), Damage = \(total)")
                print(currentAttackDamage)
                run(attackSound)
                guard bossHealth > 0 else { return }
                updateBossHealth(damage: currentAttackDamage)
                updateBossHealthBar()
                self.replaceSelectedCardsAfterAttack()
                
            },
            .wait(forDuration: enemyAttackDelay + buffer),
            
           .run { [weak self] in
                    guard let self = self else { return }
               if self.bossHealth <= 0 {
                   return
               }
               if let burnChainEffect = playerChainEffects.first(where: { $0.type == .burn }) {
                   switch burnChainEffect.level {
                       
                   case .base: do {
                       let burnDamage : Double = Double(bossMaxHealth) * 0.1
                       updateBossHealth(damage: Int(burnDamage))
                   }
                   case .strong: do {
                       let burnDamage : Double = Double(bossMaxHealth) * 0.2
                       updateBossHealth(damage: Int(burnDamage))
                   }
                   case .enemy: do {
                       let burnDamage : Double = Double(bossMaxHealth) * 0.1
                       updateBossHealth(damage: Int(burnDamage))
                   }
                   }
                   
                   statusLabel.isHidden = false
                   statusLabel.text = "BURN!"
                   statusLabel.run(.sequence([.unhide(), .scale(to: 1.2, duration: 0.2), .scale(to: 0.9, duration: 0.2), .scale(to: 1.0, duration: 0.2),.hide()]))
               }
           },

            
       
            // MARK: 2) Boss attack shake & decrement chance
            .run { [weak self] in
                guard let self = self else { return }
                if(self.bossHealth <= 0) {
                    return
                }
                self.shakeBackground(duration: shakeDur)
                enemyAttack()
                self.playerHpLabel.text = "\(self.playerHp)/\(self.playerMaxHp)"
                run(enemyAttackSound)
                if self.playerHp <= 0 && self.bossHealth > 0 {
                    showGameOver()
                }

            },
            .wait(forDuration: shakeDur + buffer),
            
            
            // 3) Slide cards back up into play area
            .run { [weak self] in
                guard let self = self else { return }
                for card in self.playAreaCards {
                    let m = SKAction.move(to: card.originalPosition, duration: moveDur)
                    m.timingMode = .easeInEaseOut
                    card.run(m)
                }
                playAreaCards.removeAll(where: { self.selectedCards.contains($0) })
                selectedCards.removeAll()
            },
            .wait(forDuration: moveDur + buffer),

//            // 4) Replace played cards
//            .run { [weak self] in
//                self?.replaceSelectedCards()
//            },
//            .wait(forDuration: replacementDur + postReplaceBuffer),

            // 5) Glow & restore UI
            .run { [weak self] in
                guard let self = self else { return }
                self.playAreaCards.forEach { self.addTemporaryGlow(to: $0) }
                self.updateDeckCount()
                self.updateButtonVisibility()
                self.isAnimating = false
                updatePlayerChainEffectsCountdown()
                updatePlayerChainEffects()

            }
        ]))
    }
    
    func showRestartWindow() {
        // Dim background
        let dimBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: self.size)
        dimBackground.name = "dimBackground"
        dimBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        dimBackground.zPosition = 100
        addChild(dimBackground)

        // Popup window
        let window = SKSpriteNode(color: .white, size: CGSize(width: 300, height: 200))
        window.name = "restartWindow"
        window.zPosition = 101
        window.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(window)

        // Restart button
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.name = "restartButton"
        restartButton.fontName = "AvenirNext-Bold"
        restartButton.fontSize = 24
        restartButton.fontColor = .blue
        restartButton.position = CGPoint(x: 0, y: -50)
        restartButton.zPosition = 102
        window.addChild(restartButton)
    }
    
    
    private func gotoNextLevel() {
        UserDefaults.standard.playerModel.currentStage += 1
        
        // All element is not unlocked
        if(UserDefaults.standard.playerModel.elements.count != Element.allCases.count){
            let gameScene = UnlockElementScene(size: self.view!.bounds.size)
            gameScene.scaleMode = .aspectFill
            // Tampilkan scene
            self.view!.presentScene(gameScene,transition: SKTransition.fade(withDuration: 0.5))
            return
        }
     
        // Set game scene info
        let gameScene = NewGameScene(size: self.view!.bounds.size)
        gameScene.stageInfo = stages[UserDefaults.standard.playerModel.currentStage]
        gameScene.scaleMode = .aspectFill
        // Tampilkan scene
        self.view!.presentScene(gameScene,transition: SKTransition.fade(withDuration: 0.5))
    }
    
  

    private func createBossFlashAction() -> SKAction {
        // hit effect colorize to white (full blend), then back to normal
//        let flashOn  = SKAction.colorize(with: UIColor(named: "HitEffectColor")!, colorBlendFactor: 1.0, duration: 0.25)
        let flashOn  = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.25)
        let flashOff = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.25)
        return .sequence([flashOn, flashOff])
        
        
    }
}

// Helper: Check if all values in an array are equal
extension Array where Element == Int {
    func allEqual() -> Bool {
        guard let first = self.first else { return true }
        return allSatisfy { $0 == first }
    }
}
