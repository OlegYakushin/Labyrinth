//
//  GameManager.swift
//  Labyrinth
//
//  Created by Oleg Yakushin on 4/4/24.
//


import Foundation
struct Game: Codable {
    var currentLevel: Int
    var currentTime: Int
    var level1Time: Int
    var level2Time: Int
    var level3Time: Int
    var level4Time: Int
    var level5Time: Int
    var level6Time: Int
}
class GameManager: ObservableObject {
    @Published var game: Game?

    init() {
           loadGame()
        if game == nil {
                   initializeGame()
               }
       }
   
    private func saveGame() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(game) {
            UserDefaults.standard.set(encoded, forKey: "game")
        }
    }
    func refreshLevel() {
        guard var game = game else { return }
       game.currentLevel = 1
        self.game = game
        saveGame()
    }
    func nextLevel() {
        guard var game = game else { return }
        var nextLevel = game.currentLevel + 1
        if nextLevel > 6 {
            nextLevel = 1
        }
       game.currentLevel += 1
        self.game = game
        saveGame()
    }
    func updateTimeIfNeeded(newTime: Int, forLevel level: Int) {
        guard var game = game else { return }
        
        switch level {
        case 1:
            if newTime < game.level1Time || game.level1Time == 0 {
                game.level1Time = newTime
                self.game = game
                saveGame()
            }
        case 2:
            if newTime < game.level2Time || game.level2Time == 0 {
                game.level2Time = newTime
                self.game = game
                saveGame()
            }
        case 3:
            if newTime < game.level3Time || game.level3Time == 0 {
                game.level3Time = newTime
                self.game = game
                saveGame()
            }
        case 4:
            if newTime < game.level4Time || game.level4Time == 0 {
                game.level4Time = newTime
                self.game = game
                saveGame()
            }
        case 5:
            if newTime < game.level5Time || game.level5Time == 0 {
                game.level5Time = newTime
                self.game = game
                saveGame()
            }
        case 6:
            if newTime < game.level6Time || game.level6Time == 0 {
                game.level6Time = newTime
                self.game = game
                saveGame()
            }
        default:
            break
        }
    }

    func loadGame() {
        if let data = UserDefaults.standard.data(forKey: "game") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Game.self, from: data) {
                game = decoded
            }
        }
    }
    private func initializeGame() {
        game = Game(currentLevel: 1, currentTime: 0, level1Time: 0, level2Time: 0, level3Time: 0, level4Time: 0, level5Time: 0, level6Time: 0)
        saveGame()
    }
}

