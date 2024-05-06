//
//  PandoraGameSceneSpriteView.swift
//  CupGame
//
//  Created by Yongye Tan on 5/1/24.
//

import SwiftUI
import SpriteKit

struct PandoraGameSpriteView: View {
    
    @State private var isGameStarted: Bool = false
    
    @State private var isAnimating: Bool = false
    
    @State private var winCount: Int = 0
    
    @State private var lostCont: Int = 0
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            SpriteView(scene: PandoraGameScene($isGameStarted, $isAnimating, $winCount, $lostCont))
                .frame(width: 1000, height: 600)
                .ignoresSafeArea()
            
            Text(isGameStarted ? "Pick one box" : "Tap on screen..")
                .font(.system(size: 30))
                .font(.footnote)
            
            VStack {
                HStack {
                    Text("# of Win: \(winCount)")
                }
                
                HStack {
                    Text("# of Lost: \(lostCont)")
                }
            }
            .font(.system(size: 40))
            .font(.headline)
            
        }
    }
}

#Preview {
    PandoraGameSpriteView()
}
