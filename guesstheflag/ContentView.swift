//
//  ContentView.swift
//  guesstheflag
//
//  Created by Buhecha, Neeta (Trainee Engineer) on 15/05/2024.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var currentScore = 0
    @State private var questionsAsked = 0
    
    @State private var animationAmount = 0.0
    
    @State var isTapped = -1
    

    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        
                        
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number);
                            } label: {
                                FlagImage(image: countries[number])
                            }
                            .rotation3DEffect(
                                .degrees( (isTapped == number) ? 360 : 0.0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .animation(.default, value: isTapped)
                        }

                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                
                Button("Press Me") {
                    withAnimation {
                        animationAmount += 360
                    }
                }
                .rotation3DEffect(
                    .degrees(animationAmount),
                                          axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                
                Spacer()

                Text("Score: \(currentScore) / \(questionsAsked)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(currentScore) / \(questionsAsked)")
        }
    }

    func flagTapped(_ number: Int) {
        
        isTapped = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
        questionsAsked += 1
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isTapped = -1
    }
}

#Preview {
    ContentView()
}
