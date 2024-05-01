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
    let ballUnderCup = SKShapeNode(circleOfRadius: 15)
    
    @Binding var isGameStarted: Bool
    
    
    init(_ isGameStarted: Binding<Bool>) {
        _isGameStarted = isGameStarted
        super.init(size: CGSize(width: 1000, height: 600))
        self.scaleMode = .aspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        _isGameStarted = .constant(false)
        super.init(coder: aDecoder)
    }
    
}

extension CupGameScene {
    
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
        
        let x = cups[randomIndex].position.x - 4
        let y = cups[randomIndex].position.y - 60
        ballUnderCup.position = CGPoint(x: x, y: y)
        
        ballUnderCup.fillColor = .green
        
        addChild(ballUnderCup)
    }
}

extension CupGameScene {
    
    override func didMove(to view: SKView) {
        resetGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameStarted {
            print("shuffle")
            shuffleCups()
            isGameStarted = true
        } else {
//            resetGame()
//            isGameStarted = false
        }
    }
    
}

extension CupGameScene {
    
    func resetGame() {
        
        for cup in cups {
            cup.removeFromParent()
        }
        ballUnderCup.removeFromParent()
    
        backgroundColor = .white
        setupCups()
        addBallUnderCup()
        
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
        let hide = SKAction.move(by: CGVectorMake(CGFloat(0), -25), duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        let moveUp = SKAction.move(by: CGVectorMake(CGFloat(0), 100), duration: 1)
        let moveDown = SKAction.move(by: CGVectorMake(0, -100), duration: 1)
        let sequence = SKAction.sequence([hide, wait, moveUp, moveDown])
        
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
        
        let hide = SKAction.move(by: CGVectorMake(CGFloat(0), -25), duration: 0.5)
        
        let wait = SKAction.wait(forDuration: 0.5)
        
        let sequence = SKAction.sequence([hide, wait, curve, curve2])
        
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
        
        let hide = SKAction.move(by: CGVectorMake(CGFloat(0), -25), duration: 0.5)
        
        let wait = SKAction.wait(forDuration: 0.5)
        
        let sequence = SKAction.sequence([hide, wait, curve, curve2])
        
        return sequence
        
    }
}

struct CupGameSpriteView: View {
    
    @State private var isGameStarted: Bool = false
        
    var body: some View {
        
        VStack {
            
            SpriteView(scene: CupGameScene($isGameStarted))
                .frame(width: 1000, height: 600)
                .ignoresSafeArea()
            
            Text(isGameStarted ? "Pick one" : "")
                .fontWeight(.bold)
                .font(.system(size: 50))
            
            Spacer()
        }
    }
}

#Preview {
    CupGameSpriteView()
}
