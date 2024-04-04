//
//  GameView.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
   @ObservedObject var gameManager: GameManager
    var body: some View {
        ZStack{
            BackgroundView()
            VStack {
                VStack {
                    HStack {
                        Text("BACK")
                            .foregroundColor(.white)
                            .font(.custom("Inter-ExtraBold", size: 15 * sizeScreen()))
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top,40 * sizeScreen())
                .padding(.leading,20 * sizeScreen())
                RoundedRectangle(cornerRadius: 10 * sizeScreen())
                    .foregroundColor(Color("yellowOne"))
                    .frame(width: 295 * sizeScreen(), height: 90 * sizeScreen())
                    .overlay(
                        Text("\(gameManager.game!.currentLevel)")
                        .foregroundColor(.black)
                        .font(.custom("Inter-ExtraBold", size: 35 * sizeScreen()))
                    )
                SKViewContainer(scene: GameScene(size: CGSize(width: 390 * sizeScreen(), height: 650 * sizeScreen()), gameManager: gameManager))
                    .frame(width: 390 * sizeScreen(), height: 650 * sizeScreen())
                   .padding(.bottom, 40 * sizeScreen())
            }
           
            
               
            
        }
    }
}

struct SKViewContainer: UIViewRepresentable {
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = true
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        
    }
}
