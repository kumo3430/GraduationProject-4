//
//  ProfileEditView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/30.
//

import SwiftUI

struct ProfileEditView: View {
    @Binding var username: String
    @Binding var userProfileImage: Image
    @Binding var userDescription: String
    
    @State private var selectedImage: Image? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                // Implement Image Picker Here
                // After selecting an image, update the `selectedImage` state.
            }, label: {
                selectedImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(radius: 10)
                ?? userProfileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(radius: 10)
            })
            
            TextField("用戶名稱", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
            
            TextEditor(text: $userDescription)
                .padding()
                .frame(height: 150)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
            
            Button("儲存修改") {
                if let newImage = selectedImage {
                    userProfileImage = newImage
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .padding()
        .background(Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all))
        .navigationBarTitle("查看和編輯個人資料", displayMode: .inline)
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(username: .constant("shinji"), userProfileImage: .constant(Image("shinji")), userDescription: .constant("這是我的習慣養成之旅，與我一起進步吧!"))
    }
}

