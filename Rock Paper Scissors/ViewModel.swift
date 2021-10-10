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

class DoubleGameViewModeli: ObservableObject {
    @Published var doubleSelected = (0, 0)
    @Published var doubleImageResult: (Images, Images) = (.rock, .rock)
    @Published var playersReady = (false, false)
    @Published var startGame = false
    @Published var doubleScore = (0, 0)
    
    @Published var selected = 0
    
    func spin() {
        prepareImage()
    }
    
    func updateScore() {
        //        if resultOfSpin == .win {
        //            firstScore += 1
        //        } else if resultOfSpin == .lose {
        //            secondScore += 1
        //        }
        
        let p1 = doubleSelected.0
        let p2 = doubleSelected.1
        
        if p1 == 1 && p2 == 2 {
            doubleScore.0 += 1
        } else if p1 == 1 && p2 == 3 {
            doubleScore.1 += 1
        } else if p1 == 2 && p2 == 1 {
            doubleScore.1 += 1
        } else if p1 == 2 && p2 == 3 {
            doubleScore.0 += 1
        } else if p1 == 3 && p2 == 1 {
            doubleScore.0 += 1
        } else if p1 == 3 && p2 == 2 {
            doubleScore.1 += 1
        }
    }
    
    private func prepareImage() {
        switch doubleSelected.0 {
        case 1: doubleImageResult.0 = .paper
        case 2: doubleImageResult.0 = .rock
        case 3: doubleImageResult.0 = .scissors
        default: doubleImageResult.0 = .empty
        }
        switch doubleSelected.1 {
        case 1: doubleImageResult.1 = .paper
        case 2: doubleImageResult.1 = .rock
        case 3: doubleImageResult.1 = .scissors
        default: doubleImageResult.1 = .empty
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


