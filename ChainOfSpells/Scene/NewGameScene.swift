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
    private let cardBackTexture = SKTexture(imageNamed: "card_back")
    private let spellBookTexture = SKTexture(imageNamed: "spell_book")

    private var deckNode: SKSpriteNode!
    private let deckCountLabel = SKLabelNode(fontNamed: fontName)

    // MARK: Buttons & Selection
    private let attackButton = SKSpriteNode(imageNamed: "btn-attack")
    private let discardButton = SKSpriteNode(imageNamed: "btn-discard")
    private var playAreaCards = [CardNode]()
    private var selectedCards = [CardNode]()

    private let playAreaPadding: CGFloat = 4
    private var playAreaPosition: CGPoint { CGPoint(x: frame.midX, y: frame.midY - 130) }

    // MARK: Boss Properties
    private var bossSprite = SKSpriteNode(imageNamed: "boss")
    private var bossHealth: Int = 10
    private var bossMaxHealth: Int = 10
    private var bossHealthBar = SKNode()
    private var bossHealthLabel = SKLabelNode()
    
    // MARK: Player Progression
    private var maxSelection = 1
    private var cardInHand = 3

    // MARK: Labels & State
    private let victoryLabel = SKLabelNode(fontNamed: fontName)
    private var attackChances = 4
    private let chancesLabel = SKLabelNode(fontNamed: fontName)
    private var discardLeft = 3
    private let discardLeftLabel = SKLabelNode(fontNamed: fontName)
    private let comboBackground = SKSpriteNode(imageNamed: "combo-bg")
    private let comboInfoLabel = SKLabelNode(fontNamed: fontName)
    private let gameOverLabel = SKLabelNode(fontNamed: fontName)
    private var isAnimating = false
    
    // UI
    private var background = SKSpriteNode(imageNamed: "")
    private let playerHp = SKSpriteNode(imageNamed: "player_hp")
    private let playerDiscard = SKSpriteNode(imageNamed: "player_discard")

    
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
    }
    
    // MARK: UPDATE ON PLAYER PROGRESSION
    private func setGameRules() {
        maxSelection = UserDefaults.standard.playerModel.elements.count
        cardInHand = UserDefaults.standard.playerModel.elements.count + 2

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
        deckNode.position = CGPoint(x: frame.midX + 350, y: frame.midY - 130)
        deckNode.scale(to: frame.size, width: false, multiplier: 0.3)
//        scaleCard(deckNode)
        addChild(deckNode)

        deckCountLabel.fontSize = 24
        deckCountLabel.fontColor = .white
        deckCountLabel.position = CGPoint(x: deckNode.position.x, y: deckNode.position.y + 50)
        addChild(deckCountLabel)
    }

    // MARK: - Buttons Setup
    private func setupButtons() {
        let buttonY: CGFloat = frame.midY - 40
        attackButton.name = "attack"
        discardButton.name = "discard"

        [attackButton, discardButton].forEach { button in
            button.zPosition = 10
            button.scale(to: frame.size, width: false, multiplier: 0.09)
            button.isHidden = true
            addChild(button)
        }
        attackButton.position = CGPoint(x: frame.midX - 50, y: buttonY)
        discardButton.position = CGPoint(x: frame.midX + 50, y: buttonY)
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
        // 2) Bar container
        bossHealthBar = SKNode()
        bossHealthBar.position =  CGPoint(x: frame.midX, y: frame.maxY)
        addChild(bossHealthBar)
        
        // 3) Create the HP‑bar using slicing:
        let fullBarWidth: CGFloat = 200
        let barHeight:    CGFloat = 30
        let hpYPosition: CGFloat = -30

        let hpBar = SKSpriteNode(imageNamed: "hp-bar")
        hpBar.name = "healthBar"

        // → anchor at left so size changes grow/shrink to the right
        hpBar.anchorPoint = CGPoint(x: 0, y: 0.5)

        // → tell SpriteKit which portion of the texture is *stretchable*:
        //   if your end‑caps are, say, 16px wide in a 128px‑wide texture:
        let tex = hpBar.texture!
        let cap: CGFloat = 4 / tex.size().width   // 16px / textureWidth
        hpBar.centerRect = CGRect(x:   cap,
                                  y:   0,
                                  width: 1 - 2*cap,
                                  height: 1)

        // 4) Set its starting size and position
        hpBar.size = CGSize(width: fullBarWidth, height: barHeight)
        hpBar.position = CGPoint(x: -fullBarWidth/2, y: hpYPosition)
        bossHealthBar.addChild(hpBar)
        
        // 5) (Optional) If you have a separate background frame:
        let hpBg = SKSpriteNode(imageNamed: "hpbackground")
        hpBg.scale(to: CGSize(width: fullBarWidth, height: barHeight), width: true, multiplier: 1)
        hpBg.position = CGPoint(x: 0, y: hpYPosition)
        hpBg.zPosition = -1
        bossHealthBar.addChild(hpBg)

        // 5) (Optional) If you have a separate background frame:
        let bg = SKSpriteNode(imageNamed: "hp-bar-background")
        bg.scale(to: CGSize(width: fullBarWidth, height: barHeight), width: true, multiplier: 1)
        bg.position = CGPoint(x: 0, y: hpYPosition)
        bg.zPosition = 3
        bossHealthBar.addChild(bg)

        // 6) Health label
        bossHealthLabel.text      = "\(bossHealth)/\(bossMaxHealth)"
        bossHealthLabel.fontName = fontName
        bossHealthLabel.fontSize  = 12
        bossHealthLabel.fontColor = .white
        bossHealthLabel.position  = CGPoint(x: 0, y: hpYPosition - 4)
        bossHealthLabel.zPosition = 10
        bossHealthBar.addChild(bossHealthLabel)
    }
    
    // MARK: – Boss Setup (using centerRect for slicing)
    private func setupBoss() {
        // 1) Usual boss sprite
        bossSprite = SKSpriteNode(imageNamed: stageInfo?.enemy.name ?? "")
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
        bossSprite.run(repeatIdle, withKey: "bossIdle")
    }



    // MARK: - Labels Setup
    private func setupLabels() {
        chancesLabel.text = "x\(attackChances)"
        chancesLabel.fontSize = 24
        chancesLabel.fontColor = .white
        chancesLabel.horizontalAlignmentMode = .left
        chancesLabel.position = CGPoint(x: 70, y: frame.height/2 - 130)
        playerHp.position = CGPoint(x: 50, y: frame.height/2 - 120)
        playerHp.scale(to: frame.size, width: false, multiplier: 0.1)
        addChild(chancesLabel)
        addChild(playerHp)
        
        // Discard left label below chances
        discardLeftLabel.text = "x\(discardLeft)"
        discardLeftLabel.fontSize = 24
        discardLeftLabel.fontColor = .white
        discardLeftLabel.horizontalAlignmentMode = .left
        discardLeftLabel.position = CGPoint(x: 70, y: chancesLabel.position.y - 40)
        playerDiscard.position = CGPoint(x: 50, y: chancesLabel.position.y - 30)
        playerDiscard.scale(to: frame.size, width: false, multiplier: 0.1)
        addChild(playerDiscard)
        addChild(discardLeftLabel)
        
//        comboBackground.position = CGPoint(x: 70, y: chancesLabel.position.y + 50)
//        comboBackground.scale(to: frame.size, width: true, multiplier: 0.15)
//        addChild(comboBackground)
        
        comboInfoLabel.text = ""
        comboInfoLabel.fontSize = 20
        comboInfoLabel.fontColor = .yellow
        comboInfoLabel.horizontalAlignmentMode = .left
		comboInfoLabel.position = CGPoint(x: 50, y: chancesLabel.position.y + 40)
        addChild(comboInfoLabel)
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if !selectedCards.isEmpty {
            if attackButton.contains(location) { handleAttack(); return }
            if discardButton.contains(location) {
                // only allow if still have discards left
                guard discardLeft > 0 else { return }
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
        playAreaCards.append(card)

        // Animate move/flip/pop, then recurse—no glow here any more
        animateCard(card, to: stagingPositions[index]) { [weak self] in
            guard let self = self else { return }
            self.animateDrawing(from: stagingPositions,
                                to: finalPositions,
                                index: index + 1)
        }
    }

    private func replaceSelectedCards() {
        guard !selectedCards.isEmpty else { return }
        let positions = selectedCards.map { $0.originalPosition }
        selectedCards.forEach { card in
            discardPile.append(CardModel(element: card.element, value: card.attackValue))
            let move = SKAction.group([.moveBy(x: 1000, y: 0, duration: 0.5), .fadeOut(withDuration: 0.3)])
            card.run(.sequence([move, .removeFromParent()]))
        }
        playAreaCards.removeAll(where: { selectedCards.contains($0) })
        selectedCards.removeAll()
        animateReplacement(at: positions, remaining: positions.count)
    }

//    private func animateReplacement(at positions: [CGPoint], remaining: Int) {
//        var left = remaining
//        for pos in positions {
//            guard !currentDeck.isEmpty else {
//                left -= 1
//                if left == 0 { isAnimating = false; updateDeckCount() }
//                continue
//            }
//            let def = currentDeck.removeFirst()
//            updateDeckCount()
//            let card = CardNode(texture: cardBackTexture)
//            card.position = deckNode.position
//            card.originalPosition = pos
//            card.attackValue = def.value
//            card.element = def.element
//            card.valueLabel.text = "\(def.value)"
//            card.valueLabel.isHidden = true
//            scaleCard(card)
//            addChild(card)
//            playAreaCards.append(card)
//
//            animateCard(card, to: pos) {
//                left -= 1
//                if left == 0 { self.isAnimating = false }
//            }
//        }
//    }
    
    private func animateReplacement(at positions: [CGPoint], remaining: Int) {
        var left = remaining

        for pos in positions {
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
            card.originalPosition = pos
            card.attackValue = def.value
            card.element = def.element
            card.valueLabel.text = "\(def.value)"
            card.valueLabel.isHidden = true
            scaleCard(card)
            addChild(card)
            playAreaCards.append(card)

            // Animate flip/move/pop into place…
            animateCard(card, to: pos) {
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

        let base = selectedCards.reduce(0) { $0 + $1.attackValue }
        let (name, mult) = evaluateCombo(for: selectedCards)
        let total = Int(Double(base) * mult)
        print("Attack: \(name) ×\(mult) → Base = \(base), Damage = \(total)")
        
        updateBossHealth(damage: total)
        
        guard bossHealth > 0 else { return }
        
        animateHandTransitionAfterAttack()

        if attackChances <= 0 && bossHealth > 0 { showGameOver() }
    }

    private func handleDiscard() {
        guard !selectedCards.isEmpty else { return }
        
        discardLeft = max(0, discardLeft - 1)
        discardLeftLabel.text = "x\(discardLeft)"
        if discardLeft == 0 {
            discardButton.color = .gray
            discardButton.colorBlendFactor = 0.7
        }
        
        replaceSelectedCards()
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
    }
    
    // MARK: - Combo Info Update
    private func updateComboInfo() {
        guard !selectedCards.isEmpty else {
            comboInfoLabel.text = ""
            return
        }
        let base = selectedCards.reduce(0) { $0 + $1.attackValue }
        let (name, mult) = evaluateCombo(for: selectedCards)
        let damage = Int(Double(base) * mult)
        comboInfoLabel.text = "\(name): \(damage)"
    }

    // MARK: - Evaluate Combo
    private func evaluateCombo(for cards: [CardNode]) -> (String, Double) {
        let n = cards.count
        let values = cards.map { $0.attackValue }
        let elements = cards.map { $0.element }
        let valueCounts = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
        let elementCounts = Dictionary(grouping: elements, by: { $0 }).mapValues { $0.count }
        let isSameValue = valueCounts.values.contains(n)

        switch n {
        case 1:
            return ("Basic Spell", 1.0)
        case 2:
            if isSameValue { return ("Double Spell", 1.5) }
            let set = Set(elements)
            switch set {
            case Set([Element.fire,Element.water]): return ("Steam", 1.1)
            case Set([Element.earth,Element.wind]): return ("Sandstorm", 1.1)
            case Set([Element.fire,Element.wind]): return ("Heat", 1.2)
            case Set([Element.fire,Element.earth]): return ("Lava", 1.2)
            case Set([Element.water,Element.wind]): return ("Storm", 1.2)
            case Set([Element.water,Element.earth]): return ("Nature", 1.2)
            default: return ("Basic Spell", 1.0)
            }
        case 3:
            if elementCounts.values.contains(3) { return ("Triple Spell", 2.0) }
            if Set(elements).count == 3 && isSameValue { return ("Synergy", 2.2) }
            return ("Basic Spell", 1.0)
        case 4:
            if elementCounts.values.contains(4) { return ("Quad Spell", 2.5) }
            if Set(elements).count == 4 && isSameValue { return ("Harmony", 2.0) }
            let doubles = elementCounts.filter { $0.value == 2 }.map { $0.key }
            if doubles.count == 2 {
                let combo = Set(doubles)
                switch combo {
                case Set([Element.fire,Element.water]): return ("Double Steam", 1.5)
                case Set([Element.earth,Element.wind]): return ("Double Sandstorm", 1.5)
                case Set([Element.fire,Element.wind]): return ("Double Heat", 2.0)
                case Set([Element.fire,Element.earth]): return ("Double Lava", 2.0)
                case Set([Element.water,Element.wind]): return ("Double Storm", 2.0)
                case Set([Element.water,Element.earth]): return ("Double Nature", 2.0)
                default: break
                }
            }
            return ("Basic Spell", 1.0)
        default:
            return ("Basic Spell", 1.0)
        }
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

        let move = SKAction.move(to: position, duration: moveDuration)
        let flip = SKAction.sequence([
            .wait(forDuration: half - flipDuration/2),
            .scaleX(to: 0, duration: flipDuration/2),
            .run { card.texture = SKTexture(imageNamed: card.element.cardAsset); card.valueLabel.isHidden = false },
            .scaleX(to: originalScale, duration: flipDuration/2)
        ])
        let pop = SKAction.sequence([.scale(to: originalScale * 1.1, duration: 0.1), .scale(to: originalScale, duration: 0.1)])

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
        let moveDur: TimeInterval     = 0.5
        let buffer: TimeInterval      = 0.05
        let shakeDur: TimeInterval    = 0.6    // match your shakeBackground duration
        let replacementDur: TimeInterval = 0.8
        let postReplaceBuffer: TimeInterval = 0.1

        run(.sequence([

            // 1) Slide all cards down to staging
            .run { [weak self] in
                guard let self = self else { return }
                for (card, target) in zip(self.playAreaCards, stagingPositions) {
                    let m = SKAction.move(to: target, duration: moveDur)
                    m.timingMode = .easeInEaseOut
                    card.run(m)
                }
            },
            .wait(forDuration: moveDur + buffer),

            // 2) Boss attack shake & decrement chance
            .run { [weak self] in
                guard let self = self else { return }
                self.shakeBackground(duration: shakeDur)
                self.attackChances -= 1
                self.chancesLabel.text = "x\(self.attackChances)"
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
            },
            .wait(forDuration: moveDur + buffer),

            // 4) Replace played cards
            .run { [weak self] in
                self?.replaceSelectedCards()
            },
            .wait(forDuration: replacementDur + postReplaceBuffer),

            // 5) Glow & restore UI
            .run { [weak self] in
                guard let self = self else { return }
                self.playAreaCards.forEach { self.addTemporaryGlow(to: $0) }
                self.updateDeckCount()
                self.updateButtonVisibility()
                self.isAnimating = false
            }

        ]))
    }

}

