//
//  RegistrationView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/17.
//

import SwiftUI

struct RegistrationView: View {
    @State private var currentStep: Int = 0
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var navigateToStory: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Image(currentStep == 0 ? "Registration1" : "Registration2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    if currentStep == 0 {
                        Text("你希望我們怎麼稱呼你？")
                            .font(.headline)

                        TextField("暱稱", text: $nickname)
                            .padding(10)
                            .font(.title2)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                            .frame(maxWidth: 300)

                        Button(action: {
                            withAnimation {
                                currentStep += 1
                            }
                        }) {
                            Text("下一步")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Text("分享你的第一個目標是什麼？")
                            .font(.headline)

                        TextField("我的目標是...", text: $goal)
                            .padding(10)
                            .font(.title2)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                            .frame(maxWidth: 300)

                        Button(action: {
                            print("Registration Completed!")
                            navigateToStory = true
                        }) {
                            Text("完成註冊")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .background(
                            NavigationLink("", destination: StoryContentView()
                                .navigationBarBackButtonHidden(true)
                                .interactiveDismissDisabled(true)
                            , isActive: $navigateToStory)
                            .hidden()
                        )
                    }
                    Spacer().frame(height: 100)  // 將位置稍微往上移
                }
                .padding(.all, 20)
                .cornerRadius(10)
                .transition(.slide)
                .animation(.easeInOut(duration: 1.0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
