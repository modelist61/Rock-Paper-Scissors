//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Dmitry Tokarev on 29.09.2021.
//

import SwiftUI

struct SinglePlayerView: View {
    
    let generator = UINotificationFeedbackGenerator()
    
    @StateObject var game = GameViewModeli()

    @State private var showHelp = false

    @State private var firstStepAnimation = true
    @State private var secondStepAnimation = true
    
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
                        Image(game.randomImage.rawValue)
                        .scaleEffect(secondStepAnimation ? 0 : 0.5)
                    }.opacity(firstStepAnimation ? 0 : 1.0)
                    
//PopUp text
                    Image(game.resultOfSpin.rawValue)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 125)
                        .offset(y: game.startGame ? -200 : -600)
                        .animation(.interactiveSpring(response: 0.9,
                                                      dampingFraction: 0.4,
                                                      blendDuration: 0.2)
                                    .delay(game.startGame ? 1.2 : 0.0))
                }
                Spacer()
//Score board
                HStack {
                    ZStack {
                        HelpTextView(text: "You", show: $showHelp)
                        ScoreWindow(score: game.firstScore)
                    }
                    Spacer()
                    Text(":")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer()
                    ZStack {
                        HelpTextView(text: "iPhone", show: $showHelp)
                        ScoreWindow(score: game.secondScore)
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
                    StartButton(game: game)
                }
//Disable button
// FIXME: check disable button when game is started
                .disabled(game.selected == 0 ? true : false)
                .onTapGesture {
                    game.forgetChooseAnimation()
                }.padding(.vertical, 15)
                
//Character choosen buttons
//FIXME: check tap when game started
                HStack(spacing: 30) {
                    ChooseCharacterButton(game: game,
                                          number: 1,
                                          imageName: Images.paper.rawValue)
                    ChooseCharacterButton(game: game,
                                          number: 2,
                                          imageName: Images.rock.rawValue)
                    ChooseCharacterButton(game: game,
                                          number: 3,
                                          imageName: Images.scissors.rawValue)
                }.padding(.bottom, 16)
                    .disabled(game.selected > 0 ? true : false)
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
                } else {
                    game.updateScore()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePlayerView()
    }
}

struct ChooseCharacterButton: View {
    @ObservedObject var game: GameViewModeli
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
                game.selected = number
            }
    }
}

struct StartButton: View {
    @ObservedObject var game: GameViewModeli
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .frame(width: 300, height: 60, alignment: .center)
            .overlay(
                Text(!game.startGame ? "START" : "RESTART")
                    .font(.system(size: 35))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            )
    }
}

struct ScoreWindow: View {
    let score: Int
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .frame(width: 120, height: 60, alignment: .center)
            .overlay(
                Text("\(score)")
                    .font(.system(size: 35))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            )
    }
}

struct HelpTextView: View {
    let text: String
    @Binding var show: Bool
    var body: some View {
        Text(text)
            .font(.system(size: 25))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .offset(y: show ? -60 : 0)
    }
}
