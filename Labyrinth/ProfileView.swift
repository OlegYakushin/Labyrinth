//
//  ProfileView.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameManager: GameManager
    var body: some View {
        ZStack{
            BackgroundView()
            VStack{
                Rectangle()
                    .frame(width: 296 * sizeScreen(), height: 89 * sizeScreen())
                    .foregroundColor(.black.opacity(0.5))
                    .overlay(
                    Text("PROFILE")
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .font(.custom("Inter-ExtraBold", size: 25 * sizeScreen()))
                        
                    )
                ScrollView(showsIndicators: false){
                    if gameManager.game!.level1Time > 0 {
                        LevelTimeView(level: 1, time: gameManager.game!.level1Time)
                        if gameManager.game!.level2Time > 0 {
                            LevelTimeView(level: 2, time: gameManager.game!.level2Time)
                            if gameManager.game!.level3Time > 0 {
                                LevelTimeView(level: 3, time: gameManager.game!.level3Time)
                                if gameManager.game!.level4Time > 0 {
                                    LevelTimeView(level: 4, time: gameManager.game!.level4Time)
                                    if gameManager.game!.level5Time > 0 {
                                        LevelTimeView(level: 5, time: gameManager.game!.level5Time)
                                        if gameManager.game!.level6Time > 0 {
                                            LevelTimeView(level: 6, time: gameManager.game!.level6Time)
                                        }
                                        else{
                                            RoundedRectangle(cornerRadius: 12 * sizeScreen())
                                                .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
                                                .foregroundColor(Color("yellowOne"))
                                                .overlay(
                                                    Text("Level 6 not finished")
                                                        .foregroundColor(.black)
                                                        .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                                                )
                                        }
                                    }
                                    else{
                                        RoundedRectangle(cornerRadius: 12 * sizeScreen())
                                            .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
                                            .foregroundColor(Color("yellowOne"))
                                            .overlay(
                                                Text("Level 5 not finished")
                                                    .foregroundColor(.black)
                                                    .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                                            )
                                    }
                                }
                                else{
                                    RoundedRectangle(cornerRadius: 12 * sizeScreen())
                                        .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
                                        .foregroundColor(Color("yellowOne"))
                                        .overlay(
                                            Text("Level 4 not finished")
                                                .foregroundColor(.black)
                                                .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                                        )
                                }
                            }else{
                                RoundedRectangle(cornerRadius: 12 * sizeScreen())
                                    .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
                                    .foregroundColor(Color("yellowOne"))
                                    .overlay(
                                        Text("Level 3 not finished")
                                            .foregroundColor(.black)
                                            .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                                    )
                            }
                            
                        }
                        else{
                            RoundedRectangle(cornerRadius: 12 * sizeScreen())
                                .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
                                .foregroundColor(Color("yellowOne"))
                                .overlay(
                                    Text("Level 2 not finished")
                                        .foregroundColor(.black)
                                        .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                                )
                        }
                    }else{
                        RoundedRectangle(cornerRadius: 12 * sizeScreen())
                            .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
                            .foregroundColor(Color("yellowOne"))
                            .overlay(
                                Text("Level 1 not finished")
                                    .foregroundColor(.black)
                                    .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                            )
                    }
                }
                .frame(height: 600 * sizeScreen())
                    
                Text("Back")
                    .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
                    .foregroundColor(.white)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}
struct LevelTimeView: View {
    var level: Int
    var time: Int
    var body: some View {
        RoundedRectangle(cornerRadius: 12 * sizeScreen())
            .frame(width: 290 * sizeScreen(), height: 61 * sizeScreen())
            .foregroundColor(Color("yellowOne"))
            .overlay(
            Text("Level \(level), time: \(time)")
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 20 * sizeScreen()))
            )
    }
}
