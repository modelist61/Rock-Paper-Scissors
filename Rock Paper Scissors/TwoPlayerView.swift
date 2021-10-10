//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Dmitry Tokarev on 29.09.2021.
//

import SwiftUI

struct TwoPlayerView: View {
    
    let generator = UINotificationFeedbackGenerator()
    
    @StateObject var game = DoubleGameViewModeli()
    @State private var showHelp = false
    @State private var firstStepAnimation = true
    @State private var secondStepAnimation = true
    
    @State private var selectidPlayer = 1
    
    var body: some View {
        ZStack {
            Color("Purple2").ignoresSafeArea()
            VStack {
                ZStack {
//Blur background
                    Ellipse()
                        .frame(width: firstStepAnimation ? 500 : 300,
                               height: firstStepAnimation ? 200 : 300)
                        .blur(radius: 70)
                        .foregroundColor(Color("EllipseBlur1").opacity(0.8))
                    
// MARK: Default stack with character
                    HStack {
                        Image(Images.paper.rawValue)
                            .resizable()
                            .offset(x: firstStepAnimation ? 0 : 140)
                        Image(Images.rock.rawValue)
                            .resizable()
                        Image(Images.scissors.rawValue)
                            .resizable()
                            .offset(x: firstStepAnimation ? 0: -140)
                    }.frame(width: UIScreen.main.bounds.width, height: 140)
                        .opacity(firstStepAnimation ? 1.0 : 0.0)
                        
                    
// MARK: Rotation wheel | Default = opacity 0
                    ZStack {
                        Image("ColorWheel")
                            .resizable()
                            .grayscale(secondStepAnimation ? 0 : 1.0)
                            .frame(width: 350, height: 350)
                            .rotationEffect(.degrees(firstStepAnimation ? 0 : 480))
//Random chosen character
                        ZStack {
                            Text("VS")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .fontWeight(.black)
                                .scaleEffect(secondStepAnimation ? 0.0 : 1.0)
                            HStack {
                                Image(game.doubleImageResult.0.rawValue)
                                    .resizable()
                                    .aspectRatio( contentMode: .fit)
                                    .scaleEffect(secondStepAnimation ? 0.0 : 0.7)
                                    .offset(x: secondStepAnimation ? 105 : 0)
                                Image(game.doubleImageResult.1.rawValue)
                                    .resizable()
                                    .aspectRatio( contentMode: .fit)
                                    .scaleEffect(secondStepAnimation ? 0.0 : 0.7)
                                    .offset(x: secondStepAnimation ? -105 : 0)
                            }.frame(width: UIScreen.main.bounds.width, height: 510)
                        }
                    }.opacity(firstStepAnimation ? 0.0 : 1.0)
                    
                }
                Spacer()
//Score board
                HStack {
                    ZStack {
                        HelpTextView(text: "Player1", show: $showHelp)
                        ScoreWindow(score: game.doubleScore.0)
                    }
                    Spacer()
                    Text(":")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer()
                    ZStack {
                        HelpTextView(text: "Player2", show: $showHelp)
                        ScoreWindow(score: game.doubleScore.1)
                    }
                }.frame(width: 300, height: 60)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showHelp.toggle()
                        }
                    }
// MARK: Start button
               
                Button {
                    game.startGame.toggle()
                    startAnimation()
//Haptic
                    self.generator.notificationOccurred(.success)
                } label: {
                    StartButtonDoubleGame(game: game, selectidPlayerNo: $selectidPlayer)
                }
//Disable button
// FIXME: check disable button when game is started
//                .disabled(game.selected == 0 ? true : false)
                .disabled(game.playersReady == (true, true) ? false : true)
                .onTapGesture {
                    game.forgetChooseAnimation()
                }.padding(.vertical, 15)
                
//Character choosen buttons
//FIXME: check tap when game started
                HStack(spacing: 30) {
                    ChooseCharacterButtonDoubleGame(game: game,
                                                    selectidPlayerNo: $selectidPlayer,
                                                    number: 1,
                                                    imageName: Images.paper.rawValue)
                    ChooseCharacterButtonDoubleGame(game: game,
                                                    selectidPlayerNo: $selectidPlayer,
                                                    number: 2,
                                                    imageName: Images.rock.rawValue)
                    ChooseCharacterButtonDoubleGame(game: game,
                                                    selectidPlayerNo: $selectidPlayer,
                                                    number: 3,
                                                    imageName: Images.scissors.rawValue)
                }.padding(.bottom, 16)
                 .disabled(game.playersReady == (true, true) ? true : false)
            }
        }
    }
//MARK: - Button Action func
    private func startAnimation() {
        DispatchQueue.main.async {
            if game.startGame {
                game.spin()
            }
        }
//FirstStepAnimation
        withAnimation(.easeInOut(duration: 1.5)) {
            firstStepAnimation.toggle()
//Haptic
            self.generator.notificationOccurred(.success)
        }
//Delay for wheel animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 1.0)) {
                secondStepAnimation.toggle()
            }
        }
//End spin with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.interactiveSpring(response: 0.9,
                                             dampingFraction: 0.4,
                                             blendDuration: 0.2)) {
            }
                if !game.startGame {
//Haptic
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    game.selected = 0
                    selectidPlayer = 1
                    game.doubleSelected = (0, 0)
                    game.playersReady = (false, false)
                } else {
                    game.updateScore()
                }
        }
    }
}

struct TwoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TwoPlayerView()
    }
}


struct StartButtonDoubleGame: View {
    @ObservedObject var game: DoubleGameViewModeli
    @Binding var selectidPlayerNo: Int
    var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .frame(width: 300, height: 60, alignment: .center)
                .overlay(
                    Text(buttonText(state: selectidPlayerNo))
                        .font(.system(size: 35))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                )
//        }
        
    }
    func buttonText(state: Int) -> String {
        switch state {
        case 0:
            return !game.startGame ? "START" : "RESTART"
        case 1:
            return "1 selected"
        case 2:
            return "2 selected"
        default:
            return "error"
        }
    }
}

struct ChooseCharacterButtonDoubleGame: View {
    @ObservedObject var game: DoubleGameViewModeli
    @Binding var selectidPlayerNo: Int
    let number: Int
    let imageName: String

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .frame(width: 80, height: 80)
            .overlay(
                Image(imageName)
                    .resizable()
                    .grayscale(game.selected == number ? 0 : 1.0)
                    .scaleEffect(game.selected == number ? 1.0 : 0.8)
                    .animation(.easeInOut)
            )
            .shadow(color: Color("EllipseBlur1"),
                    radius: game.selected == number ? 10 : 0)
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                switch selectidPlayerNo {
                case 1:
                    game.doubleSelected.0 = number
                    game.playersReady.0 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        game.selected = 0
                        selectidPlayerNo = 2
                    }
                case 2:
                    game.doubleSelected.1 = number
                    game.playersReady.1 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        game.selected = 0
                        selectidPlayerNo = 0
                    }
                default:
                    break
                }
                game.selected = number
            }
    }
}
//
//struct ScoreWindow: View {
//    let score: Int
//    var body: some View {
//        RoundedRectangle(cornerRadius: 15)
//            .foregroundColor(.white)
//            .frame(width: 120, height: 60, alignment: .center)
//            .overlay(
//                Text("\(score)")
//                    .font(.system(size: 35))
//                    .fontWeight(.heavy)
//                    .foregroundColor(.black)
//            )
//    }
//}
//
//struct HelpTextView: View {
//    let text: String
//    @Binding var show: Bool
//    var body: some View {
//        Text(text)
//            .font(.system(size: 25))
//            .fontWeight(.heavy)
//            .foregroundColor(.white)
//            .offset(y: show ? -60 : 0)
//    }
//}
