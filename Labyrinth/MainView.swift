//
//  MainView.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var game = GameManager()
    var body: some View {
        NavigationView{
            ZStack{
                BackgroundView()
                VStack{
                    Rectangle()
                        .frame(width: 296 * sizeScreen(), height: 89 * sizeScreen())
                        .foregroundColor(.black.opacity(0.5))
                        .overlay(
                        Text("APP NAME")
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.custom("Inter-ExtraBold", size: 25 * sizeScreen()))
                            
                        )
                        .padding(.bottom, 300 * sizeScreen())
                    NavigationLink(destination: GameView(gameManager: game).navigationBarBackButtonHidden()) {
                        ButtonView(text: "play")
                    }
                    .onTapGesture {
                            game.refreshLevel()
                    }
                    NavigationLink(destination: ProfileView(gameManager: game).navigationBarBackButtonHidden()) {
                        ButtonView(text: "profile")
                    }
                }
            }
            .onAppear{
                game.loadGame()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ButtonView: View {
    var text: String
    var body: some View {
       RoundedRectangle(cornerRadius: 20 * sizeScreen())
            .frame(width: 281 * sizeScreen(), height: 126 * sizeScreen())
            .foregroundColor(Color("yellowOne"))
            .overlay(
            Text(text)
                .textCase(.uppercase)
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 25 * sizeScreen()))
            )
    }
}

#Preview {
    MainView()
}
