//
//  ContentView2.swift
//  Rock Paper Scissors
//
//  Created by Dmitry Tokarev on 10.10.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var gameMode: GameMode = .single
    @State private var showSelector = true
    
    var body: some View {
        ZStack {
            
            switch gameMode {
            case .single:
                SinglePlayerView()
                    .blur(radius: showSelector ? 5 : 0)
            case .double:
                TwoPlayerView()
            }
            
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 250, height: 350)
                .foregroundColor(Color("Purple3"))
                .opacity(0.9)
                .overlay(
                    SelectorLable(gameMode: $gameMode, showSelector: $showSelector)
                )
                .opacity(showSelector ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5))
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SelectorLable: View {
    @Binding var gameMode: GameMode
    @Binding var showSelector: Bool
    @State private var showShadow = 0
    var body: some View {
        VStack {
            Text("Game Mode")
                .foregroundColor(.white)
                .font(.system(size: 35))
                .fontWeight(.heavy)
            Spacer()
            Button {
                    gameMode = .single
                    showSelector.toggle()
            } label: {
                ZStack {
                    Text("vs")
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "iphone")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(x: -12)
                    }
                    
                }.foregroundColor(.white)
                 .frame(width: 170, height: 60)
            }.padding(.bottom, 40)
            
            Button {
                gameMode = .double
                showSelector.toggle()
            } label: {
                ZStack {
                    Text("vs")
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                }.foregroundColor(.white)
                    .frame(width: 170, height: 60)
            }
            Spacer()
            
        }.padding()
    }
}
