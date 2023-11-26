//
//  ProfileEditView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/30.
//

import SwiftUI

struct ProfileEditView: View {
    @Binding var username: String
    @Binding var userDescription: String
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCoverPhotoName: String
    @State private var showingCoverPhotoPicker = false // 控制選擇器的顯示
    // 假設這些是您要顯示的資源束中的圖片名稱
    let coverPhotoNames = (1...29).map { "GP\($0)" }
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                showingCoverPhotoPicker = true
            }, label: {
                Image(selectedCoverPhotoName)
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
//        .onAppear() {
//            if let name = UserDefaults.standard.string(forKey: "userName") ,
//               let description = UserDefaults.standard.string(forKey: "userDescription"),
//               let image = UserDefaults.standard.string(forKey: "image"){
//                // 在c画面中使用存储的userName值
//                username = name
//                userDescription = description
//                selectedCoverPhotoName = image
//                print("Stored userName: \(username)")
//                print("Stored userDescription: \(userDescription)")
//                print("Stored selectedCoverPhotoName: \(selectedCoverPhotoName)")
//            } else {
//                // 如果没有找到存储的userName值，则使用默认值或采取其他适当的措施
//                print("Stored userName: \(username)")
//                print("Stored userDescription: \(userDescription)")
//                print("Stored selectedCoverPhotoName: \(selectedCoverPhotoName)")
//            }
//
//        }
        .padding()
        .background(Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all))
        .navigationBarTitle("查看和編輯個人資料", displayMode: .inline)
        .sheet(isPresented: $showingCoverPhotoPicker) {
                    CoverPhotoPicker(coverPhotos: coverPhotoNames, selectedPhotoName: $selectedCoverPhotoName)
                }
    }
    
    func reviseProfile(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "username": username,
            "userDescription": userDescription,
            "image": selectedCoverPhotoName,
        ]
        print("body:\(body)")
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
        @State var username = "我習慣了"
        @State var userDescription = "這是我的習慣養成之旅，與我一起進步吧!"
        @State var selectedCoverPhotoName = "appstore"
        ProfileEditView(username: $username, userDescription: $userDescription, selectedCoverPhotoName: $selectedCoverPhotoName)
    }
}

