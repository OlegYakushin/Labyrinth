//
//  FunctionForResize.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//

import Foundation
import SwiftUI
func sizeScreen() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
       let screenHeight = UIScreen.main.bounds.height
       
       if UIDevice.current.userInterfaceIdiom == .pad {
           if screenWidth == 1024 {
               return screenWidth / 1024
           }
          else if screenWidth > 1024 {
               return screenWidth / 1024
           } else if screenWidth > 768 {
               return screenWidth / 834
           } else {
               return screenWidth / 768
           }
       } else {
           if UIScreen.main.bounds.width == 375 {
               return screenWidth / 480
           } else {
               if screenWidth > screenHeight {
                   return screenWidth / 844
               } else {
                   return screenWidth / 390
               }
           }
       }
   }
