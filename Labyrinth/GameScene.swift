//
//  GameScene.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//

import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    let playerCategory: UInt32 = 0x1 << 0
    let priceCategory: UInt32 = 0x1 << 1
    let playerSpeed: CGFloat = 10
    var player: SKShapeNode!
    var price: SKSpriteNode!
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var startTime: Int = 0
    var gameManager: GameManager
    init(size: CGSize, gameManager: GameManager) {
          self.gameManager = gameManager
          super.init(size: size)
      }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        setupScene()
        setupPlayer()
        setupControls()
        setupPrice()
        physicsWorld.contactDelegate = self
    }
    
    func setupScene() {
        startTime = Int(Date().timeIntervalSince1970)
        let fieldSize = CGSize(width: 390 * sizeScreen(), height: 475 * sizeScreen())
        let field = SKShapeNode(rectOf: fieldSize)
        field.position = CGPoint(x: frame.midX, y: 400 * sizeScreen())
        let backgroundSize = CGSize(width: fieldSize.width, height: fieldSize.height)
          let background = SKShapeNode(rectOf: backgroundSize)
          background.position = field.position
          background.fillColor = UIColor.black.withAlphaComponent(0.5)
          background.zPosition = -1
          addChild(background)

        addChild(field)
        guard let currentLevel = gameManager.game?.currentLevel else { return }

        switch currentLevel {
        case 1:
            setupWallsForLevel1()
        case 2:
            setupWallsForLevel2()
        case 3:
            setupWallsForLevel3()
        case 4:
            setupWallsForLevel4()
        case 5:
            setupWallsForLevel5()
        case 6:
            setupWallsForLevel6()
        
        default:
            break
        }

    }
  
    func setupPlayer() {
        player = SKShapeNode(circleOfRadius: 12.5 * sizeScreen())
        player.fillColor = .red
           player.position = CGPoint(x: 40 * sizeScreen(), y: 590 * sizeScreen())
           addChild(player)
           
           // Add physics body to player
        player.physicsBody = SKPhysicsBody(circleOfRadius: 12.5 * sizeScreen())
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = priceCategory
        player.lineWidth = 0
           player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
       }
    func setupPrice() {
       
        price = SKSpriteNode(imageNamed: "price")
        price.size = CGSize(width: 41 * sizeScreen(), height: 43 * sizeScreen())
        
           price.position = CGPoint(x: 360 * sizeScreen(), y: 185 * sizeScreen())
           addChild(price)
           
           // Add physics body to player
        price.physicsBody = SKPhysicsBody(rectangleOf: price.size)
        price.physicsBody?.categoryBitMask = priceCategory
        price.physicsBody?.collisionBitMask = playerCategory
        price.physicsBody?.affectedByGravity = false
        price.physicsBody?.allowsRotation = false
        price.physicsBody?.isDynamic = false
       }
    
    func setupControls() {
        upButton = createHorButton(imageNamed: "upButton", position: CGPoint(x: frame.midX, y: frame.minY + 110 * sizeScreen()))
        downButton = createHorButton(imageNamed: "downButton", position: CGPoint(x: frame.midX, y: frame.minY + 40 * sizeScreen()))
        leftButton = createVerButton(imageNamed: "leftButton", position: CGPoint(x: frame.midX - 110 * sizeScreen(), y: frame.minY + 75 * sizeScreen()))
        rightButton = createVerButton(imageNamed: "rightButton", position: CGPoint(x: frame.midX + 110 * sizeScreen(), y: frame.minY + 75 * sizeScreen()))
        
        addChild(upButton)
        addChild(downButton)
        addChild(leftButton)
        addChild(rightButton)
    }
    
    func createHorButton(imageNamed: String, position: CGPoint) -> SKSpriteNode {
        let button = SKSpriteNode(imageNamed: imageNamed)
        button.position = position
        button.size = CGSize(width: 156 * sizeScreen(), height: 42 * sizeScreen())
        button.name = "button"
        return button
    }
    func createVerButton(imageNamed: String, position: CGPoint) -> SKSpriteNode {
        let button = SKSpriteNode(imageNamed: imageNamed)
        button.position = position
        button.size = CGSize(width: 42 * sizeScreen(), height: 111 * sizeScreen())
        button.name = "button"
        return button
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == priceCategory {
            endLevel()
        }
    }
    func refreshScene() {
        removeAllChildren()
        
        setupScene()
        setupPlayer()
        setupControls()
        setupPrice()
    }
    override func update(_ currentTime: TimeInterval) {
        let currentTimeInSeconds = Int(Date().timeIntervalSince1970)
        let gameTimeInSeconds = currentTimeInSeconds - startTime
       }
    func endLevel() {
            print("Level complete!")
        let currentTimeInSeconds = Int(Date().timeIntervalSince1970)
        let gameTimeInSeconds = currentTimeInSeconds - startTime
        gameManager.updateTimeIfNeeded(newTime: gameTimeInSeconds, forLevel: gameManager.game!.currentLevel)
        gameManager.nextLevel()
        refreshScene()
        print(gameManager.game!.currentLevel)
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        if upButton.contains(touchLocation) || downButton.contains(touchLocation) || leftButton.contains(touchLocation) || rightButton.contains(touchLocation) {
            movePlayer(touchLocation: touchLocation)
        }
    }


    
    func movePlayer(touchLocation: CGPoint) {
        var deltaPosition = CGPoint.zero
        
        if upButton.contains(touchLocation) {
            deltaPosition.y += 10
        } else if downButton.contains(touchLocation) {
            deltaPosition.y -= 10
        } else if leftButton.contains(touchLocation) {
            deltaPosition.x -= 10
        } else if rightButton.contains(touchLocation) {
            deltaPosition.x += 10
        }
        
        let newPosition = CGPoint(x: player.position.x + deltaPosition.x, y: player.position.y + deltaPosition.y)
        let moveAction = SKAction.move(to: newPosition, duration: 0.1)
        player.run(moveAction)
    }
    func setupWallsForLevel1() {
        let wallSize = CGSize(width: 150 * sizeScreen(), height: 20 * sizeScreen())
        let wall1 = SKShapeNode(rectOf: wallSize)
     wall1.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall1.position = CGPoint(x: 50 * sizeScreen(), y: 400 * sizeScreen())
     wall1.fillColor = UIColor(named: "yellowOne")!
     wall1.physicsBody?.affectedByGravity = false
     wall1.physicsBody?.isDynamic = false
     wall1.lineWidth = 0
        addChild(wall1)
     
     let wall2Size = CGSize(width: 20 * sizeScreen(), height: 150 * sizeScreen())
     let wall2 = SKShapeNode(rectOf: wall2Size)
     wall2.position = CGPoint(x: 83 * sizeScreen(), y: 560 * sizeScreen())
     wall2.fillColor = UIColor(named: "yellowOne")!
     wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2Size)
     wall2.physicsBody?.isDynamic = false
     wall2.physicsBody?.affectedByGravity = false
     wall2.lineWidth = 0
        addChild(wall2)
     let wall3Size = CGSize(width: 185 * sizeScreen(), height: 20 * sizeScreen())
     let wall3 = SKShapeNode(rectOf: wall3Size)
     wall3.position = CGPoint(x: 170 * sizeScreen(), y: 495 * sizeScreen())
     wall3.fillColor = UIColor(named: "yellowOne")!
     wall3.physicsBody = SKPhysicsBody(rectangleOf: wall3Size)
     wall3.physicsBody?.isDynamic = false
     wall3.physicsBody?.affectedByGravity = false
     wall3.lineWidth = 0
        addChild(wall3)
     let wall4Size = CGSize(width: 20 * sizeScreen(), height: 210 * sizeScreen())
     let wall4 = SKShapeNode(rectOf: wall4Size)
     wall4.position = CGPoint(x: 255 * sizeScreen(), y: 400 * sizeScreen())
     wall4.fillColor = UIColor(named: "yellowOne")!
     wall4.physicsBody = SKPhysicsBody(rectangleOf: wall4Size)
     wall4.physicsBody?.isDynamic = false
     wall4.physicsBody?.affectedByGravity = false
     wall4.lineWidth = 0
        addChild(wall4)
     let wall5Size = CGSize(width: 150 * sizeScreen(), height: 20 * sizeScreen())
     let wall5 = SKShapeNode(rectOf: wall5Size)
     wall5.position = CGPoint(x: 190 * sizeScreen(), y: 300 * sizeScreen())
     wall5.fillColor = UIColor(named: "yellowOne")!
     wall5.physicsBody = SKPhysicsBody(rectangleOf: wall5Size)
     wall5.physicsBody?.isDynamic = false
     wall5.physicsBody?.affectedByGravity = false
     wall5.lineWidth = 0
        addChild(wall5)
     let wall6Size = CGSize(width: 20 * sizeScreen(), height: 310 * sizeScreen())
     let wall6 = SKShapeNode(rectOf: wall6Size)
     wall6.position = CGPoint(x: 330 * sizeScreen(), y: 320 * sizeScreen())
     wall6.fillColor = UIColor(named: "yellowOne")!
     wall6.physicsBody = SKPhysicsBody(rectangleOf: wall6Size)
     wall6.physicsBody?.isDynamic = false
     wall6.physicsBody?.affectedByGravity = false
     wall6.lineWidth = 0
        addChild(wall6)
    }
    
    func setupWallsForLevel2() {
        let wallSize = CGSize(width: 186 * sizeScreen(), height: 20 * sizeScreen())
        let wall1 = SKShapeNode(rectOf: wallSize)
     wall1.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall1.position = CGPoint(x: 95 * sizeScreen(), y: 550 * sizeScreen())
     wall1.fillColor = UIColor(named: "yellowOne")!
     wall1.physicsBody?.affectedByGravity = false
     wall1.physicsBody?.isDynamic = false
     wall1.lineWidth = 0
        addChild(wall1)
     
     let wall2Size = CGSize(width: 20 * sizeScreen(), height: 112 * sizeScreen())
     let wall2 = SKShapeNode(rectOf: wall2Size)
     wall2.position = CGPoint(x: 178 * sizeScreen(), y: 500 * sizeScreen())
     wall2.fillColor = UIColor(named: "yellowOne")!
     wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2Size)
     wall2.physicsBody?.isDynamic = false
     wall2.physicsBody?.affectedByGravity = false
     wall2.lineWidth = 0
        addChild(wall2)
     let wall3Size = CGSize(width: 150 * sizeScreen(), height: 20 * sizeScreen())
     let wall3 = SKShapeNode(rectOf: wall3Size)
     wall3.position = CGPoint(x: 320 * sizeScreen(), y: 445 * sizeScreen())
     wall3.fillColor = UIColor(named: "yellowOne")!
     wall3.physicsBody = SKPhysicsBody(rectangleOf: wall3Size)
     wall3.physicsBody?.isDynamic = false
     wall3.physicsBody?.affectedByGravity = false
     wall3.lineWidth = 0
        addChild(wall3)
     let wall4Size = CGSize(width: 20 * sizeScreen(), height: 210 * sizeScreen())
     let wall4 = SKShapeNode(rectOf: wall4Size)
     wall4.position = CGPoint(x: 255 * sizeScreen(), y: 350 * sizeScreen())
     wall4.fillColor = UIColor(named: "yellowOne")!
     wall4.physicsBody = SKPhysicsBody(rectangleOf: wall4Size)
     wall4.physicsBody?.isDynamic = false
     wall4.physicsBody?.affectedByGravity = false
     wall4.lineWidth = 0
        addChild(wall4)
     let wall5Size = CGSize(width: 150 * sizeScreen(), height: 20 * sizeScreen())
     let wall5 = SKShapeNode(rectOf: wall5Size)
     wall5.position = CGPoint(x: 190 * sizeScreen(), y: 390 * sizeScreen())
     wall5.fillColor = UIColor(named: "yellowOne")!
     wall5.physicsBody = SKPhysicsBody(rectangleOf: wall5Size)
     wall5.physicsBody?.isDynamic = false
     wall5.physicsBody?.affectedByGravity = false
     wall5.lineWidth = 0
        addChild(wall5)
     let wall6Size = CGSize(width: 191 * sizeScreen(), height: 20 * sizeScreen())
     let wall6 = SKShapeNode(rectOf: wall6Size)
     wall6.position = CGPoint(x: 90 * sizeScreen(), y: 320 * sizeScreen())
     wall6.fillColor = UIColor(named: "yellowOne")!
     wall6.physicsBody = SKPhysicsBody(rectangleOf: wall6Size)
     wall6.physicsBody?.isDynamic = false
     wall6.physicsBody?.affectedByGravity = false
     wall6.lineWidth = 0
        addChild(wall6)
    }
    func setupWallsForLevel3() {
        let wallSize = CGSize(width: 106 * sizeScreen(), height: 20 * sizeScreen())
        let wall1 = SKShapeNode(rectOf: wallSize)
     wall1.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall1.position = CGPoint(x: 50 * sizeScreen(), y: 560 * sizeScreen())
     wall1.fillColor = UIColor(named: "yellowOne")!
     wall1.physicsBody?.affectedByGravity = false
     wall1.physicsBody?.isDynamic = false
     wall1.lineWidth = 0
        addChild(wall1)
     
     let wall2Size = CGSize(width: 20 * sizeScreen(), height: 138 * sizeScreen())
     let wall2 = SKShapeNode(rectOf: wall2Size)
     wall2.position = CGPoint(x: 176 * sizeScreen(), y: 570 * sizeScreen())
     wall2.fillColor = UIColor(named: "yellowOne")!
     wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2Size)
     wall2.physicsBody?.isDynamic = false
     wall2.physicsBody?.affectedByGravity = false
     wall2.lineWidth = 0
        addChild(wall2)
     let wall3Size = CGSize(width: 106 * sizeScreen(), height: 20 * sizeScreen())
     let wall3 = SKShapeNode(rectOf: wall3Size)
     wall3.position = CGPoint(x: 133 * sizeScreen(), y: 495 * sizeScreen())
     wall3.fillColor = UIColor(named: "yellowOne")!
     wall3.physicsBody = SKPhysicsBody(rectangleOf: wall3Size)
     wall3.physicsBody?.isDynamic = false
     wall3.physicsBody?.affectedByGravity = false
     wall3.lineWidth = 0
        addChild(wall3)
     let wall4Size = CGSize(width: 301 * sizeScreen(), height: 20 * sizeScreen())
     let wall4 = SKShapeNode(rectOf: wall4Size)
     wall4.position = CGPoint(x: 145 * sizeScreen(), y: 430 * sizeScreen())
     wall4.fillColor = UIColor(named: "yellowOne")!
     wall4.physicsBody = SKPhysicsBody(rectangleOf: wall4Size)
     wall4.physicsBody?.isDynamic = false
     wall4.physicsBody?.affectedByGravity = false
     wall4.lineWidth = 0
        addChild(wall4)
     let wall5Size = CGSize(width: 20 * sizeScreen(), height: 138 * sizeScreen())
     let wall5 = SKShapeNode(rectOf: wall5Size)
     wall5.position = CGPoint(x: 240 * sizeScreen(), y: 490 * sizeScreen())
     wall5.fillColor = UIColor(named: "yellowOne")!
     wall5.physicsBody = SKPhysicsBody(rectangleOf: wall5Size)
     wall5.physicsBody?.isDynamic = false
     wall5.physicsBody?.affectedByGravity = false
     wall5.lineWidth = 0
        addChild(wall5)
     let wall6Size = CGSize(width: 340 * sizeScreen(), height: 20 * sizeScreen())
     let wall6 = SKShapeNode(rectOf: wall6Size)
     wall6.position = CGPoint(x: 230 * sizeScreen(), y: 260 * sizeScreen())
     wall6.fillColor = UIColor(named: "yellowOne")!
     wall6.physicsBody = SKPhysicsBody(rectangleOf: wall6Size)
     wall6.physicsBody?.isDynamic = false
     wall6.physicsBody?.affectedByGravity = false
     wall6.lineWidth = 0
        addChild(wall6)
        let wall7Size = CGSize(width: 20 * sizeScreen(), height: 138 * sizeScreen())
        let wall7 = SKShapeNode(rectOf: wall7Size)
        wall7.position = CGPoint(x: 296 * sizeScreen(), y: 570 * sizeScreen())
        wall7.fillColor = UIColor(named: "yellowOne")!
        wall7.physicsBody = SKPhysicsBody(rectangleOf: wall7Size)
        wall7.physicsBody?.isDynamic = false
        wall7.physicsBody?.affectedByGravity = false
        wall7.lineWidth = 0
           addChild(wall7)
        let wall8Size = CGSize(width: 20 * sizeScreen(), height: 120 * sizeScreen())
        let wall8 = SKShapeNode(rectOf: wall8Size)
        wall8.position = CGPoint(x: 120 * sizeScreen(), y: 310 * sizeScreen())
        wall8.fillColor = UIColor(named: "yellowOne")!
        wall8.physicsBody = SKPhysicsBody(rectangleOf: wall8Size)
        wall8.physicsBody?.isDynamic = false
        wall8.physicsBody?.affectedByGravity = false
        wall8.lineWidth = 0
           addChild(wall8)
        let wall9Size = CGSize(width: 20 * sizeScreen(), height: 120 * sizeScreen())
        let wall9 = SKShapeNode(rectOf: wall9Size)
        wall9.position = CGPoint(x: 180 * sizeScreen(), y: 310 * sizeScreen())
        wall9.fillColor = UIColor(named: "yellowOne")!
        wall9.physicsBody = SKPhysicsBody(rectangleOf: wall9Size)
        wall9.physicsBody?.isDynamic = false
        wall9.physicsBody?.affectedByGravity = false
        wall9.lineWidth = 0
           addChild(wall9)
        let wall10Size = CGSize(width: 20 * sizeScreen(), height: 120 * sizeScreen())
        let wall10 = SKShapeNode(rectOf: wall10Size)
        wall10.position = CGPoint(x: 240 * sizeScreen(), y: 310 * sizeScreen())
        wall10.fillColor = UIColor(named: "yellowOne")!
        wall10.physicsBody = SKPhysicsBody(rectangleOf: wall10Size)
        wall10.physicsBody?.isDynamic = false
        wall10.physicsBody?.affectedByGravity = false
        wall10.lineWidth = 0
           addChild(wall10)
    }
    func setupWallsForLevel4() {
        let wallSize = CGSize(width: 20 * sizeScreen(), height: 420 * sizeScreen())
        let wall1 = SKShapeNode(rectOf: wallSize)
     wall1.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall1.position = CGPoint(x: 60 * sizeScreen(), y: 430 * sizeScreen())
     wall1.fillColor = UIColor(named: "yellowOne")!
     wall1.physicsBody?.affectedByGravity = false
     wall1.physicsBody?.isDynamic = false
     wall1.lineWidth = 0
        addChild(wall1)
        let wall2Size = CGSize(width: 20 * sizeScreen(), height: 420 * sizeScreen())
        let wall2 = SKShapeNode(rectOf: wall2Size)
     wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2Size)
        wall2.position = CGPoint(x: 125 * sizeScreen(), y: 370 * sizeScreen())
     wall2.fillColor = UIColor(named: "yellowOne")!
     wall2.physicsBody?.affectedByGravity = false
     wall2.physicsBody?.isDynamic = false
     wall2.lineWidth = 0
        addChild(wall2)
        let wall3Size = CGSize(width: 20 * sizeScreen(), height: 420 * sizeScreen())
        let wall3 = SKShapeNode(rectOf: wall3Size)
     wall3.physicsBody = SKPhysicsBody(rectangleOf: wall3Size)
        wall3.position = CGPoint(x: 190 * sizeScreen(), y: 430 * sizeScreen())
     wall3.fillColor = UIColor(named: "yellowOne")!
     wall3.physicsBody?.affectedByGravity = false
     wall3.physicsBody?.isDynamic = false
     wall3.lineWidth = 0
        addChild(wall3)
        let wall4Size = CGSize(width: 20 * sizeScreen(), height: 420 * sizeScreen())
        let wall4 = SKShapeNode(rectOf: wall4Size)
     wall4.physicsBody = SKPhysicsBody(rectangleOf: wall4Size)
        wall4.position = CGPoint(x: 255 * sizeScreen(), y: 370 * sizeScreen())
     wall4.fillColor = UIColor(named: "yellowOne")!
     wall4.physicsBody?.affectedByGravity = false
     wall4.physicsBody?.isDynamic = false
     wall4.lineWidth = 0
        addChild(wall4)
        let wall5Size = CGSize(width: 20 * sizeScreen(), height: 420 * sizeScreen())
        let wall5 = SKShapeNode(rectOf: wall5Size)
     wall5.physicsBody = SKPhysicsBody(rectangleOf: wall5Size)
        wall5.position = CGPoint(x: 320 * sizeScreen(), y: 430 * sizeScreen())
     wall5.fillColor = UIColor(named: "yellowOne")!
     wall5.physicsBody?.affectedByGravity = false
     wall5.physicsBody?.isDynamic = false
     wall5.lineWidth = 0
        addChild(wall5)
     
    
    }
    func setupWallsForLevel5() {
        let wallSize = CGSize(width: 350 * sizeScreen(), height: 20 * sizeScreen())
        let wall1 = SKShapeNode(rectOf: wallSize)
     wall1.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall1.position = CGPoint(x: 160 * sizeScreen(), y: 560 * sizeScreen())
     wall1.fillColor = UIColor(named: "yellowOne")!
     wall1.physicsBody?.affectedByGravity = false
     wall1.physicsBody?.isDynamic = false
     wall1.lineWidth = 0
        addChild(wall1)
        let wall2Size = CGSize(width: 350 * sizeScreen(), height: 20 * sizeScreen())
        let wall2 = SKShapeNode(rectOf: wall2Size)
     wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2Size)
        wall2.position = CGPoint(x: 250 * sizeScreen(), y: 500 * sizeScreen())
     wall2.fillColor = UIColor(named: "yellowOne")!
     wall2.physicsBody?.affectedByGravity = false
     wall2.physicsBody?.isDynamic = false
     wall2.lineWidth = 0
        addChild(wall2)
        let wall3Size = CGSize(width: 350 * sizeScreen(), height: 20 * sizeScreen())
        let wall3 = SKShapeNode(rectOf: wall3Size)
     wall3.physicsBody = SKPhysicsBody(rectangleOf: wall3Size)
        wall3.position = CGPoint(x: 160 * sizeScreen(), y: 440 * sizeScreen())
     wall3.fillColor = UIColor(named: "yellowOne")!
     wall3.physicsBody?.affectedByGravity = false
     wall3.physicsBody?.isDynamic = false
     wall3.lineWidth = 0
        addChild(wall3)
        let wall4Size = CGSize(width: 350 * sizeScreen(), height: 20 * sizeScreen())
        let wall4 = SKShapeNode(rectOf: wall4Size)
     wall4.physicsBody = SKPhysicsBody(rectangleOf: wall4Size)
        wall4.position = CGPoint(x: 250 * sizeScreen(), y: 380 * sizeScreen())
     wall4.fillColor = UIColor(named: "yellowOne")!
     wall4.physicsBody?.affectedByGravity = false
     wall4.physicsBody?.isDynamic = false
     wall4.lineWidth = 0
        addChild(wall4)
        let wall5Size = CGSize(width: 350 * sizeScreen(), height: 20 * sizeScreen())
        let wall5 = SKShapeNode(rectOf: wall5Size)
     wall5.physicsBody = SKPhysicsBody(rectangleOf: wall5Size)
        wall5.position = CGPoint(x: 160 * sizeScreen(), y: 320 * sizeScreen())
     wall5.fillColor = UIColor(named: "yellowOne")!
     wall5.physicsBody?.affectedByGravity = false
     wall5.physicsBody?.isDynamic = false
     wall5.lineWidth = 0
        addChild(wall5)
        let wall6Size = CGSize(width: 350 * sizeScreen(), height: 20 * sizeScreen())
        let wall6 = SKShapeNode(rectOf: wall6Size)
     wall6.physicsBody = SKPhysicsBody(rectangleOf: wall6Size)
        wall6.position = CGPoint(x: 250 * sizeScreen(), y: 260 * sizeScreen())
     wall6.fillColor = UIColor(named: "yellowOne")!
     wall6.physicsBody?.affectedByGravity = false
     wall6.physicsBody?.isDynamic = false
     wall6.lineWidth = 0
        addChild(wall6)
    }
    func setupWallsForLevel6() {
        let wallSize = CGSize(width: 136 * sizeScreen(), height: 20 * sizeScreen())
        let wall1 = SKShapeNode(rectOf: wallSize)
     wall1.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall1.position = CGPoint(x: 70 * sizeScreen(), y: 450 * sizeScreen())
     wall1.fillColor = UIColor(named: "yellowOne")!
     wall1.physicsBody?.affectedByGravity = false
     wall1.physicsBody?.isDynamic = false
     wall1.lineWidth = 0
        addChild(wall1)
     
     let wall2Size = CGSize(width: 20 * sizeScreen(), height: 115 * sizeScreen())
     let wall2 = SKShapeNode(rectOf: wall2Size)
     wall2.position = CGPoint(x: 83 * sizeScreen(), y: 580 * sizeScreen())
     wall2.fillColor = UIColor(named: "yellowOne")!
     wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2Size)
     wall2.physicsBody?.isDynamic = false
     wall2.physicsBody?.affectedByGravity = false
     wall2.lineWidth = 0
        addChild(wall2)
     let wall3Size = CGSize(width: 115 * sizeScreen(), height: 20 * sizeScreen())
     let wall3 = SKShapeNode(rectOf: wall3Size)
     wall3.position = CGPoint(x: 195 * sizeScreen(), y: 545 * sizeScreen())
     wall3.fillColor = UIColor(named: "yellowOne")!
     wall3.physicsBody = SKPhysicsBody(rectangleOf: wall3Size)
     wall3.physicsBody?.isDynamic = false
     wall3.physicsBody?.affectedByGravity = false
     wall3.lineWidth = 0
        addChild(wall3)
     let wall4Size = CGSize(width: 20 * sizeScreen(), height: 250 * sizeScreen())
     let wall4 = SKShapeNode(rectOf: wall4Size)
     wall4.position = CGPoint(x: 145 * sizeScreen(), y: 430 * sizeScreen())
     wall4.fillColor = UIColor(named: "yellowOne")!
     wall4.physicsBody = SKPhysicsBody(rectangleOf: wall4Size)
     wall4.physicsBody?.isDynamic = false
     wall4.physicsBody?.affectedByGravity = false
     wall4.lineWidth = 0
        addChild(wall4)
     let wall5Size = CGSize(width: 20 * sizeScreen(), height: 65 * sizeScreen())
     let wall5 = SKShapeNode(rectOf: wall5Size)
     wall5.position = CGPoint(x: 245 * sizeScreen(), y: 520 * sizeScreen())
     wall5.fillColor = UIColor(named: "yellowOne")!
     wall5.physicsBody = SKPhysicsBody(rectangleOf: wall5Size)
     wall5.physicsBody?.isDynamic = false
     wall5.physicsBody?.affectedByGravity = false
     wall5.lineWidth = 0
        addChild(wall5)
     let wall6Size = CGSize(width: 310 * sizeScreen(), height: 20 * sizeScreen())
     let wall6 = SKShapeNode(rectOf: wall6Size)
     wall6.position = CGPoint(x: 250 * sizeScreen(), y: 220 * sizeScreen())
     wall6.fillColor = UIColor(named: "yellowOne")!
     wall6.physicsBody = SKPhysicsBody(rectangleOf: wall6Size)
     wall6.physicsBody?.isDynamic = false
     wall6.physicsBody?.affectedByGravity = false
     wall6.lineWidth = 0
        addChild(wall6)
        let wall7Size = CGSize(width: 20 * sizeScreen(), height: 200 * sizeScreen())
        let wall7 = SKShapeNode(rectOf: wall7Size)
        wall7.position = CGPoint(x: 260 * sizeScreen(), y: 320 * sizeScreen())
        wall7.fillColor = UIColor(named: "yellowOne")!
        wall7.physicsBody = SKPhysicsBody(rectangleOf: wall7Size)
        wall7.physicsBody?.isDynamic = false
        wall7.physicsBody?.affectedByGravity = false
        wall7.lineWidth = 0
           addChild(wall7)
        let wall8Size = CGSize(width: 80 * sizeScreen(), height: 20 * sizeScreen())
        let wall8 = SKShapeNode(rectOf: wall8Size)
        wall8.position = CGPoint(x: 230 * sizeScreen(), y: 280 * sizeScreen())
        wall8.fillColor = UIColor(named: "yellowOne")!
        wall8.physicsBody = SKPhysicsBody(rectangleOf: wall8Size)
        wall8.physicsBody?.isDynamic = false
        wall8.physicsBody?.affectedByGravity = false
        wall8.lineWidth = 0
           addChild(wall8)
    }

}
