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
            cup.size = CGSize(width: 280, height: 120)
            cup.position = position
            addChild(cup)
            cups.append(cup)
        }
        
    }
    
    func addBallUnderCup() {
        let randomIndex = Int.random(in: 0 ..< cups.count)
        
        let x = cups[randomIndex].position.x - 5
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
        
        let middleAction = getMiddleCupAction(cup: middleCup)
        let leftAction = getLeftCupAction(cup: leftCup)
        let rightAction = getRightCupAction(cup: rightCup)
        
        middleCup.run(middleAction)
        leftCup.run(leftAction)
        rightCup.run(rightAction)
        
                
    }
    
    func getMiddleCupAction(cup: SKSpriteNode) -> SKAction {
        let moveUp = SKAction.move(by: CGVectorMake(CGFloat(0), 100), duration: 1)
        let moveDown = SKAction.move(by: CGVectorMake(0, -100), duration: 1)
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        return sequence
    }
    
    func getLeftCupAction(cup: SKSpriteNode) -> SKAction {

        let path = CGMutablePath()
        let startPoint = CGPoint(x: cup.position.x,
                                 y: cup.position.y)
        let endPoint = CGPoint(x: cup.position.x + 400,
                               y: cup.position.y)
        
        let control1 = CGPoint(x: cup.position.x + 200,
                              y: cup.position.y - 200)
        
        let control2 = CGPoint(x: cup.position.x + 400,
                              y: cup.position.y)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: cup.position.x + 400,
                                 y: cup.position.y)
        let endPoint2 = CGPoint(x: cup.position.x,
                               y: cup.position.y)
        
        let control3 = CGPoint(x: cup.position.x + 200,
                              y: cup.position.y + 200)
        
        let control4 = CGPoint(x: cup.position.x,
                              y: cup.position.y)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        
        return sequence
        
    }
    
    func getRightCupAction(cup: SKSpriteNode) -> SKAction {
        let path = CGMutablePath()
        let startPoint = CGPoint(x: cup.position.x,
                                 y: cup.position.y)
        let endPoint = CGPoint(x: cup.position.x - 400,
                               y: cup.position.y)
        
        let control1 = CGPoint(x: cup.position.x - 200,
                              y: cup.position.y - 200)
        
        let control2 = CGPoint(x: cup.position.x - 400,
                              y: cup.position.y)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: cup.position.x - 400,
                                 y: cup.position.y)
        let endPoint2 = CGPoint(x: cup.position.x,
                               y: cup.position.y)
        
        let control3 = CGPoint(x: cup.position.x - 200,
                              y: cup.position.y + 200)
        
        let control4 = CGPoint(x: cup.position.x,
                              y: cup.position.y)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        
        return sequence
        
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
