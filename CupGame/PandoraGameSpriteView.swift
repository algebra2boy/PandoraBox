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
    
    @State private var isSkeletonPicked = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
                        
            SpriteView(scene: PandoraGameScene($isGameStarted, $isAnimating, $isSkeletonPicked))
                .frame(width: 1000, height: 600)
                .ignoresSafeArea()
            
        }
    }
}

#Preview {
    PandoraGameSpriteView()
}
