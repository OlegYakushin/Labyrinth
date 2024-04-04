//
//  BackgroundView.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack{
            Image("backgroundImage")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    BackgroundView()
}
