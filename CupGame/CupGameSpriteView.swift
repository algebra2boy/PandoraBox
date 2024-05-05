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
    
    var isAnimating: Bool = false
    
    
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
        
        // the cup positions in the x and y coordinate
        let cupPositions = [
            CGPoint(x: 300, y: 200),
            CGPoint(x: 500, y: 200),
            CGPoint(x: 700, y: 200)
        ]
        
        // adding the cup to each position on the scene
        for position in cupPositions {
            let cup = SKSpriteNode(imageNamed: "cup")
            cup.size = CGSize(width: 280, height: 120)
            cup.position = position
            addChild(cup)
            cups.append(cup)
        }
        
    }
    
    
    func addBallUnderCup() {
        
        // the ball will be at either at index 0, or 1, or 2
        let randomIndex = Int.random(in: 0 ..< cups.count)
        
        // the ball position will be underneath the cup
        let x = cups[randomIndex].position.x - 4
        let y = cups[randomIndex].position.y - 60
        
        ballUnderCup.position = CGPoint(x: x, y: y)
        ballUnderCup.fillColor = .green
        
        addChild(ballUnderCup)
    }
}

extension CupGameScene {
    
    override func didMove(to view: SKView) {
        resetGameDefault()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        shuffleCups()
    }
    
}

extension CupGameScene {
    
    func resetGameDefault() {
        
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
        
//        let nodes = [
//            cups[0],
//            cups[1],
//            cups[2]
//        ]
        
        middleCup.run(middleAction)
        leftCup.run(leftAction)
        rightCup.run(rightAction)
        
        //        let group = [
        //                getLeftCupAction(cup: leftCup),
        //                getMiddleCupAction(cup: middleCup),
        //                getRightCupAction(cup: rightCup)
        //        ]
        
        //        for (index, node) in nodes.enumerated() {
        //            node.run(group[index]) {
        //                print("hello")
        //            }
        //        }
        
    }
    
    func getMiddleCupAction(cup: SKSpriteNode) -> SKAction {
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        return sequence
    }
    
    
    func getLeftCupAction(cup: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
                
        let startPoint = CGPoint(x: 300, y: 200)
        let endPoint = CGPoint(x: 700, y: 200)
        
        let control1 = CGPoint(x: 450, y: 150)
        let control2 = CGPoint(x: 700, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 700, y: 200)
        let endPoint2 = CGPoint(x: 300, y: 200)
        
        let control3 = CGPoint(x: 500, y: 400)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 300, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        
        return sequence
        
    }
    
    func getRightCupAction(cup: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
                
        let startPoint = CGPoint(x: 700, y: 200)
        let endPoint = CGPoint(x: 300, y: 200)
        
        let control1 = CGPoint(x: 500, y: 0)
        let control2 = CGPoint(x: 300, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 300, y: 200 )
        let endPoint2 = CGPoint(x: 700, y: 200)
        
        let control3 = CGPoint(x: 500, y: 400)
        let control4 = CGPoint(x: 300, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        
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
            
            Text(isGameStarted ? "Pick one cup.." : "Tap on screen..")
                .font(.system(size: 50))
                .font(.headline)
            
            Spacer()
        }
    }
}

#Preview {
    CupGameSpriteView()
}
