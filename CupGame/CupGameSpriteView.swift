//
//  CupGameSpriteView.swift
//  CupGame
//
//  Created by Yongye Tan on 5/1/24.
//

import SwiftUI
import SpriteKit

class CupGameScene: SKScene {
    
    var cups = [SKSpriteNode]()
    let ballUnderCup = SKShapeNode(circleOfRadius: 10)
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        setupCups()
        addBallUnderCup()
        shuffleCups()
    }
    
    func setupCups() {
        
        let cupPositions = [
            CGPoint(x: 300, y: 200),
            CGPoint(x: 500, y: 200),
            CGPoint(x: 700, y: 200)
        ]
        
        for position in cupPositions {
            let cup = SKSpriteNode(imageNamed: "cup")
            cup.size = CGSize(width: 200, height: 100)
            cup.position = position
            addChild(cup)
            cups.append(cup)
        }
        
    }
    
    func addBallUnderCup() {
        let randomIndex = Int.random(in: 0 ..< cups.count)
        
        let x = cups[randomIndex].position.x - 4
        let y = cups[randomIndex].position.y - 45
        ballUnderCup.position = CGPoint(x: x, y: y)
        
        ballUnderCup.fillColor = .green
        
        addChild(ballUnderCup)
    }
    
    func shuffleCups() {
        
        guard cups.count >= 3 else { return }
        
        let leftCup = cups[0]
        let middleCup = cups[1]
        let rightCup = cups[2]
        
        // middle cup moves up and then back down
        let moveUp = SKAction.move(by: CGVectorMake(CGFloat(0), 100), duration: 1)
        let moveDown = SKAction.move(by: CGVectorMake(0, -100), duration: 1)
        let middleCupSequence = SKAction.sequence([moveUp, moveDown])
        
        // left and right cup move
        let moveRight = SKAction.move(by: CGVectorMake(400, 0), duration: 1)
        let moveLeft = SKAction.move(by: CGVectorMake(-400, 0), duration: 1)
        
        let leftSequence = SKAction.sequence([moveRight, moveLeft])
        let rightSequence = SKAction.sequence([moveLeft, moveRight])
        
        middleCup.run(middleCupSequence)
        leftCup.run(leftSequence)
        rightCup.run(rightSequence)
        
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //    }
    
}

struct CupGameSpriteView: View {
    
    @State private var isGameStarted: Bool = false
    
    var scene: SKScene {
        let scene = CupGameScene()
        scene.size = CGSize(width: 1000, height: 600)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        
        VStack {
            
            SpriteView(scene: scene)
                .frame(width: 1000, height: 600)
                .ignoresSafeArea()
            
            Button {
                isGameStarted.toggle()
            } label: {
                Text("Start game")
            }
            .buttonStyle(.borderedProminent)
            
            
            Spacer()
        }
    }
}

#Preview {
    CupGameSpriteView()
}
