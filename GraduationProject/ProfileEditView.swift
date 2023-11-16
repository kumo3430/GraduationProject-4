//
//  ProfileEditView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/30.
//

import SwiftUI

struct ProfileEditView: View {
    @State private var username: String = "尚未輸入"
    @State private var userDescription: String = "尚未輸入"
    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedImage: Image? = nil
    
    var body: some View {
        VStack(spacing: 20) {
//            Button(action: {
//                // Implement Image Picker Here
//                // After selecting an image, update the `selectedImage` state.
//            }, label: {
//                selectedImage?
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                    .shadow(radius: 10)
//                ?? userProfileImage
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                    .shadow(radius: 10)
//            })
            
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
                reviseProfile{_ in }
//                if let newImage = selectedImage {
//                    userProfileImage = newImage
//                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .onAppear() {
            if let name = UserDefaults.standard.string(forKey: "userName") ,
               let description = UserDefaults.standard.string(forKey: "userDescription"){
                // 在c画面中使用存储的userName值
                username = name
                userDescription = description
                print("Stored userName: \(username)")
                print("Stored userName: \(userDescription)")
            } else {
                // 如果没有找到存储的userName值，则使用默认值或采取其他适当的措施
                print("Stored userName: \(username)")
                print("Stored userName: \(userDescription)")
            }

        }
        .padding()
        .background(Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all))
        .navigationBarTitle("查看和編輯個人資料", displayMode: .inline)
    }
    
    func reviseProfile(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "username": username,
            "userDescription": userDescription,
        ]
        phpUrl(php: "reviseProfile" ,type: "reviseTask",body:body, store: nil){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
//            completion(message[0])
            completion(message["message"]!)
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
//        ProfileEditView(username: .constant("shinji"), userProfileImage: .constant(Image("shinji")), userDescription: .constant("這是我的習慣養成之旅，與我一起進步吧!"))
        ProfileEditView()
    }
}

