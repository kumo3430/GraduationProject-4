//
//  StartView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/3.
//

import SwiftUI

struct StoryContentView: View {
    @State private var currentStep: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                if currentStep == 0 {
                    StoryCharacterView(currentStep: $currentStep)
                } else if currentStep == 1 {
                    StorySituationView(currentStep: $currentStep)
                } else if currentStep == 2 {
                    StorySolutionView(currentStep: $currentStep)
                } else if currentStep == 3 {
                    StoryResultView()
                }
            }
        }
    }
}

struct IntroAnimationView: View {
    @State private var showStory: Bool = false
    
    var body: some View {
        ZStack {
            Image("StoryIntro")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("即將為您敘述一段故事...")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                
                Spacer().frame(height: 50)
                
                NavigationLink(destination: StoryContentView()
                                .navigationBarBackButtonHidden(true)
                                .interactiveDismissDisabled(true),
                               isActive: $showStory) {
                    Button("開始", action: {
                        showStory = true
                    })
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.title3)
                }
            }
        }
    }
}

struct StoryBaseView: View {
    var image: String
    var description: String
    var action: (() -> Void)?

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()  // 這將推送下面的 VStack 到底部

                VStack(spacing: 15) {
                    Text(description)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(10)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                    
                    if let action = action {
                        Button("下一步", action: action)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .font(.title3)
                    }
                }
                .padding(25)
            }
        }
    }
}

struct StoryCharacterView: View {
    @Binding var currentStep: Int

    var body: some View {
        StoryBaseView(
            image: "StoryB1",
            description: "小明，面臨著考試壓力和人生方向的迷茫。",
            action: { currentStep += 1 }
        )
    }
}

struct StorySituationView: View {
    @Binding var currentStep: Int

    var body: some View {
        StoryBaseView(
            image: "StoryB2",
            description: "小明在一次偶然的機會下，聽到了「原子習慣」的概念，並對此產生了興趣。",
            action: { currentStep += 1 }
        )
    }
}

struct StorySolutionView: View {
    @Binding var currentStep: Int

    var body: some View {
        StoryBaseView(
            image: "StoryB3",
            description: "他下載了我習慣了，並開始每天紀錄自己的學習進度、設定小目標，並透過App中的心理學知識，學會了如何自我激勵和保持專注。",
            action: { currentStep += 1 }
        )
    }
}

struct StoryResultView: View {
    @State private var navigateToWelcome: Bool = false

    var body: some View {
        ZStack {
            StoryBaseView(
                image: "StoryB4",
                description: "考試結果出來，小明取得了出奇的好成績，她深知這一切都得益於App的幫助。",
                action: nil
            )
            
            VStack {
                Spacer()
                
                Button("下一步", action: {
                    navigateToWelcome = true
                })
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
                .font(.title3)
                .background(
                    NavigationLink("", destination: WelcomeView()
                        .navigationBarBackButtonHidden(true)
                        .interactiveDismissDisabled(true)
                    , isActive: $navigateToWelcome)
                    .hidden()
                )
                Spacer().frame(height: 50)
            }
        }
    }
}

#Preview {
    IntroAnimationView()
}
