//
//  PandoraGameSceneSpriteView.swift
//  CupGame
//
//  Created by Yongye Tan on 5/1/24.
//

import SwiftUI
import SpriteKit

class PandoraGameScene: SKScene {
    
    private var boxes: [SKSpriteNode] = []
    private var skeleton = SKShapeNode(circleOfRadius: 15)
    
    @Binding var isGameStarted: Bool
    
    @Binding var isAnimating: Bool
    
    init(_ isGameStarted: Binding<Bool>, _ isAnimating: Binding<Bool>) {
        _isGameStarted = isGameStarted
        _isAnimating = isAnimating
        super.init(size: CGSize(width: 1000, height: 600))
        self.scaleMode = .aspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        _isGameStarted = .constant(false)
        _isAnimating = .constant(false)
        super.init(coder: aDecoder)
    }
    
}

extension PandoraGameScene {
    
    func setupBoxes() {
    
        // the cup positions in the x and y coordinate
        let boxPositions = [
            CGPoint(x: 300, y: 200),
            CGPoint(x: 500, y: 200),
            CGPoint(x: 700, y: 200)
        ]
        
        // adding the cup to each position on the scene
        for position in boxPositions {
            let box = SKSpriteNode(imageNamed: "boxOpen")
            box.size = CGSize(width: 200, height: 150)
            box.position = position
            addChild(box)
            boxes.append(box)
        }
        
    }
    
    
    func addSkletonUnderCup() {
        
        // the skeleton will be at either at index 0, or 1, or 2
        let randomIndex = Int.random(in: 0 ..< boxes.count)
        
        // the ball position will be underneath the cup
        let x = boxes[randomIndex].position.x - 4
        let y = boxes[randomIndex].position.y - 60
        
        skeleton.position = CGPoint(x: x, y: y)
        skeleton.fillColor = .green
        
        addChild(skeleton)
    }
}

extension PandoraGameScene {
    
    override func didMove(to view: SKView) {
        resetGameDefault()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // if game has not started, then start shuffling the cups
        if !isGameStarted {
            
            shuffleBoxes()
            isGameStarted = true
            
        } else { // game has started, then start picking the cup
                
            // get the first touch of the user
            guard let touch = touches.first else { return }
            
            // get the location of the touch
            let location = touch.location(in: self)
            

            // loop through the cups to see if the location match
            
            for (index, box) in boxes.enumerated() {
                
                let y_dist = abs(box.position.y - location.y)
                let x_dist = abs(box.position.x - location.x)
                
                if x_dist <= 80 && y_dist <= 100 {
                    print("box \(index + 1) is being tapped")
                }
                                
            }
            
            
        }
    }
    
}

extension PandoraGameScene {
    
    func resetGameDefault() {
        
        for box in boxes {
            box.removeFromParent()
        }
        skeleton.removeFromParent()
        
        backgroundColor = .white
        setupBoxes()
        addSkletonUnderCup()
        
    }
    
    func shuffleBoxes() {
        
        guard boxes.count >= 3 else { return }
        
        let leftBox = boxes[0]
        let middleBox = boxes[1]
        let rightBox = boxes[2]
        
        let nodes = [boxes[0], boxes[1], boxes[2]]
                
        let group = [
            getLeftCupAction(box: leftBox),
            getMiddleCupAction(box: middleBox),
            getRightCupAction(box: rightBox)
        ]
        
        var completedAction = 0
        var totalAction = nodes.count
        
        for (index, node) in nodes.enumerated() {
            node.run(group[index]) {
                
                completedAction += 1
                
                if completedAction == totalAction {
                    print("done")
                }
            }
        }
        
    }
    
    func getMiddleCupAction(box: SKSpriteNode) -> SKAction {
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeated_seq = SKAction.repeat(sequence, count: 1)
        
        return repeated_seq
    }
    
    
    func getLeftCupAction(box: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
        
        let startPoint = CGPoint(x: 300, y: 200)
        let endPoint = CGPoint(x: 700, y: 200)
        
        let control1 = CGPoint(x: 500, y: 400)
        let control2 = CGPoint(x: 700, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 700, y: 200)
        let endPoint2 = CGPoint(x: 300, y: 200)
        
        let control3 = CGPoint(x: 500, y: 0)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 299, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 0.5)
        
        let sequence = SKAction.sequence([curve, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: 1)
        
        return repeated_seq
        
    }
    
    func getRightCupAction(box: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
        
        let startPoint = CGPoint(x: 699, y: 200)
        let endPoint = CGPoint(x: 300, y: 200)
        
        let control1 = CGPoint(x: 500, y: 0)
        let control2 = CGPoint(x: 300, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 300, y: 200)
        let endPoint2 = CGPoint(x: 700, y: 200)
        
        let control3 = CGPoint(x: 500, y: 420)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 699, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: 1)
        
        return repeated_seq
        
    }
}

struct PandoraGameSpriteView: View {
    
    @State private var isGameStarted: Bool = false
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        
        VStack {
            
            SpriteView(scene: PandoraGameScene($isGameStarted, $isAnimating))
                .frame(width: 1000, height: 600)
                .ignoresSafeArea()
            
            Text(isGameStarted ? "Pick one box" : "Tap on screen..")
                .font(.system(size: 30))
                .font(.footnote)
            
            Spacer()
        }
    }
}

#Preview {
    PandoraGameSpriteView()
}
