//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Dmitry Tokarev on 29.09.2021.
//

import SwiftUI

struct ContentView: View {
    
    let generator = UINotificationFeedbackGenerator()
    @State private var choosen = 0
    @State private var winNumber = 1
    @State private var playerScore = 0
    @State private var computerScore = 0
    @State private var rotation = true
    @State private var offset = true
    @State private var opacity = true
    @State private var grayscale = true
    @State private var activeButton = true
    @State private var offsetInWheel = true
    @State private var showWin = false
    @State private var showHelp = false
    
    var body: some View {
        ZStack {
            Color("Purple2").ignoresSafeArea()
            VStack {
                ZStack {
//Blur background
                    Ellipse()
                        .frame(width: offset ? 500 : 300,
                               height: offset ? 200 : 300)
                        .blur(radius: 70)
                        .foregroundColor(Color("EllipseBlur1").opacity(0.8))
                    
// MARK: Default stack with character
                    HStack {
                        Image("paper1")
                            .resizable()
                            .offset(x: offset ? 0 : 140)
                        Image("rock1")
                            .resizable()
                        Image("scissors")
                            .resizable()
                            .offset(x: offset ? 0: -140)
                    }.frame(width: UIScreen.main.bounds.width, height: 140)
                        .opacity(opacity ? 1.0 : 0.0)
                    
// MARK: Rotation wheel | Default = opacity
                    ZStack {
                        Image("ColorWheel")
                            .resizable()
                            .grayscale(grayscale ? 0 : 1.0)
                            .frame(width: 350, height: 350)
                            .rotationEffect(.degrees(rotation ? 0 : 480))
                        
//Random choosen character
                        Group { () -> Image in
                            switch winNumber {
                            case 1:
                                return Image("paper1")
                            case 2:
                                return Image("rock1")
                            case 3:
                                return Image("scissors")
                            default:
                                return Image("")
                                
                            }
                        }.scaleEffect(offsetInWheel ? 0 : 0.5)
                    }.opacity(opacity ? 0 : 1.0)
                    
//PopUp text
                    Image(popUpImageName())
                        .resizable()
                        .frame( height: 145)
                        .offset(y: showWin ? -200 : -600)
                    
                }
                Spacer()
//Score board
                HStack {
                    ZStack {
                        HelpTextView(text: "You", show: $showHelp)
                        ScoreWindow(score: $playerScore)
                    }
                    Spacer()
                    Text(":")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer()
                    ZStack {
                        HelpTextView(text: "iPhone", show: $showHelp)
                        ScoreWindow(score: $computerScore)
                    }
                }.frame(width: 300, height: 60)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showHelp.toggle()
                    }
                }
// MARK: Start button
                Button {
                    buttonAction()
                    activeButton.toggle()
//Haptic
                    self.generator.notificationOccurred(.success)
                } label: {
                    StartButton(active: $activeButton)
                }
//Disable button
// FIXME: check disable button when game is started
                .disabled(choosen == 0 ? true : false)
                .onTapGesture {
                    forgetChooseAnimation()
                }.padding(.vertical, 15)
                
//Charfcter choosen buttons
//FIXME: check tap when game started
                HStack(spacing: 30) {
                    ChooseCharacterButton(number: 1,
                                          imageName: "paper1",
                                          choosenInt: $choosen)
                    ChooseCharacterButton(number: 2,
                                          imageName: "rock1",
                                          choosenInt: $choosen)
                    ChooseCharacterButton(number: 3,
                                          imageName: "scissors",
                                          choosenInt: $choosen)
                }
                
            }
        }
    }
    
    private func buttonAction() {
        
        if activeButton {
            DispatchQueue.main.async {
                winNumber = Int.random(in: 1...3)
            }
        }
        withAnimation(.easeInOut(duration: 1.5)) {
            offset.toggle()
            opacity.toggle()
            rotation.toggle()
            self.generator.notificationOccurred(.success)
        }
//Duration for wheel animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 1.0)) {
                grayscale.toggle()
                offsetInWheel.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.interactiveSpring(response: 0.9, dampingFraction: 0.4, blendDuration: 0.2)) {
                showWin.toggle()
            }
                if activeButton {
                    showWin = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//Haptic
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
//Reset choosen
                        choosen = 0
                    }
                } else {
//Update score
                    if popUpImageName() == "win" {
                        playerScore += 1
                    } else if popUpImageName() == "lose" {
                        computerScore += 1
                    }
//                    else {
//                        playerScore += 1
//                        computerScore += 1
//                    }
                    
                }
        }
    }
    
    private func popUpImageName() -> String {
        if choosen == 1 && winNumber == 2 {
            return "win"
        } else if choosen == 2 && winNumber == 3 {
            return "win"
        } else if choosen == 3 && winNumber == 1 {
            return "win"
        } else if choosen == winNumber {
            return "tryagain"
        } else {
            return "lose"
        }
    }
    
    private func forgetChooseAnimation() {
        if choosen == 0 {
            var number = 0
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
                number += 1
                withAnimation(.easeInOut(duration: 0.2)) {
                    choosen = number
                    self.generator.notificationOccurred(.warning)
                }
                if number == 4 {
                    timer.invalidate()
                    choosen = 0
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChooseCharacterButton: View {
    
    let number: Int
    let imageName: String
    @Binding var choosenInt: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .frame(width: 80, height: 80)
            .overlay(
                Image(imageName)
                    .resizable()
                    .grayscale(choosenInt == number ? 0 : 1.0)
                    .scaleEffect(choosenInt == number ? 1.0 : 0.9)
                    .animation(.easeInOut)
            )
            .shadow(color: Color("EllipseBlur1"),
                    radius: choosenInt == number ? 10 : 0)
            .onTapGesture {
                choosenInt = number
            }
    }
}

struct StartButton: View {
    @Binding var active: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .frame(width: 300, height: 60, alignment: .center)
            .overlay(
                Text(active ? "START" : "RESTART")
                    .font(.system(size: 35))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            )
    }
}

struct ScoreWindow: View {
    @Binding var score: Int
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
