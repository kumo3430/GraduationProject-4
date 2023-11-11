//
//  PsychologyKnowledgeView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI

struct PsychologyKnowledgeView: View {
    @State private var knowledgeIndex = 0
    
    let knowledgeData: [Knowledge] = [
        Knowledge(title: "認知錯誤", description: "人們在處理資訊時容易犯的思考錯誤。", imageName: "brain"),
        Knowledge(title: "自我效能感", description: "一個人對自己能夠完成某項任務的信心程度。", imageName: "person.fill"),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("心理學小知識")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 50)
                    .foregroundColor(Color(hex: "#A8A39D"))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack {
                        Image(systemName: knowledgeData[knowledgeIndex].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.top, 30)
                            .foregroundColor(Color(hex: "#A8A39D"))
                        
                        Text(knowledgeData[knowledgeIndex].title)
                            .font(.title2)
                            .padding(.top, 20)
                            .foregroundColor(Color(hex: "#A8A39D"))
                        
                        Text(knowledgeData[knowledgeIndex].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(Color(hex: "#92908D"))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        if knowledgeIndex > 0 {
                            knowledgeIndex -= 1
                        }
                    }, label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color(hex: "#A8A39D"))
                            .cornerRadius(20)
                    })
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        if knowledgeIndex < knowledgeData.count - 1 {
                            knowledgeIndex += 1
                        }
                    }, label: {
                        Image(systemName: "arrow.right")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color(hex: "#A8A39D"))
                            .cornerRadius(20)
                    })
                    .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
                
            }
        }
    }
}

struct Knowledge {
    let title: String
    let description: String
    let imageName: String
}

struct PsychologyKnowledgeView_Previews: PreviewProvider {
    static var previews: some View {
        PsychologyKnowledgeView()
    }
}
