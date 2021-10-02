//
//  ViewModel.swift
//  Rock Paper Scissors
//
//  Created by Dmitry Tokarev on 01.10.2021.
//

import Foundation
import SwiftUI

class GameViewModeli: ObservableObject {
    @Published var selected = 0
    @Published var random = 0
    @Published var firstScore = 0
    @Published var secondScore = 0
    @Published var startGame = false
    @Published var randomImage: Images = .rock
    @Published var resultOfSpin: ResultImage = .win
    
    func spin() {
        random = Int.random(in: 1...3)
        prepareResultImage()
        prepareRandomImage()
    }
    
    func updateScore() {
        if resultOfSpin == .win {
            firstScore += 1
        } else if resultOfSpin == .lose {
            secondScore += 1
        }
    }
    
    private func prepareRandomImage() {
        switch random {
        case 1: randomImage = .paper
        case 2: randomImage = .rock
        case 3: randomImage = .scissors
        default: randomImage = .empty
        }
    }
    
    private func prepareResultImage() {
        if selected == 1 && random == 2 {
            resultOfSpin = .win
        } else if selected == 2 && random == 3 {
            resultOfSpin = .win
        } else if selected == 3 && random == 1 {
            resultOfSpin = .win
        } else if selected == random {
            resultOfSpin = .tryAgain
        } else {
            resultOfSpin = .lose
        }
    }
    
    func forgetChooseAnimation() {
        if selected == 0 {
            var number = 0
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
                number += 1
                withAnimation(.easeInOut(duration: 0.2)) {
                self.selected = number
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                }
                if number == 4 {
                    timer.invalidate()
                    self.selected = 0
                }
            }
        }
    }
        
}
