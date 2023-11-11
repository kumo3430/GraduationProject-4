//
//  account.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/3.
//

import Foundation
import SwiftSMTP
enum Message: String {
    case success = "Success"
    case userRegistered = "User registered successfully"
    case userLogin = "User login successfully"
    case notYetFilled = "not yet filled"
    case emailRegistered = "email is registered"
    case registrationFailed = "註冊失敗請重新註冊"
    case revise = "User revise Study successfully"
    case reviseSpace = "User revise Space successfully"
    case upDateCompleteValue = "User upDateCompleteValue successfully"
    case TrackingFirstDay = "User TrackingFirstDay successfully"
    case RecurringCheckList = "User RecurringCheckList successfully"
}

struct MailConfig {
    static let smtpHostname = "smtp.gmail.com"
    static let smtpEmail = "3430yun@gmail.com"
    static let smtpPassword = "knhipliavnpqxwty"
}
func sendEmail(verify: String,mail: String,completion: @escaping (String, String) -> Void) {
    DispatchQueue.global().async {
        generateRandomVerificationCode() { randomMessage in
             let verify = randomMessage
             sendMail(verify: verify, mail: mail) { message in
                 if message == Message.success.rawValue {
                     print("Send - 隨機變數為：\(verify)")
                 }
                 completion(verify, message)
             }
         }
     }
}
func generateRandomVerificationCode( completion: @escaping (String) -> Void) {
    let verify = Int.random(in: 1..<99999999)
    print("regiest - 隨機變數為：\(verify)")
    completion(String(verify))
}
func sendMail(verify: String,mail: String,completion: @escaping (String) -> Void) {
    let smtp = SMTP(
            hostname: MailConfig.smtpHostname,
            email: MailConfig.smtpEmail,
            password: MailConfig.smtpPassword
        )
    print("mail:\(mail)")
    let megaman = Mail.User(name: "我習慣了使用者", email: mail)
    let drLight = Mail.User(name: "Yun", email: "3430yun@gmail.com")
    let mail = Mail(
        from: drLight,
        to: [megaman],
        subject: "歡迎使用我習慣了！這是您的驗證信件",
        text: "以下是您的驗證碼： \(String(verify))"
    )
    
    smtp.send(mail) { error in
           if let error = error {
               print("regiest - \(error)")
               completion(error.localizedDescription)
           } else {
               completion(Message.success.rawValue)
               print("SEND: SUBJECT: \(mail.subject)")
                          print("SEND: SUBJECT: \(mail.text)")
                          print("FROM: \(mail.from)")
                          print("TO: \(mail.to)")
                          print("Send email successful")
           }
       }
}

//func handleLogin(data: Data, completion: @escaping ([String]) -> Void) {
func handleLogin(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleUserData(data: data, messageType: .userLogin, completion: completion)
}

//func handleRegister(data: Data, completion: @escaping ([String]) -> Void) {
func handleRegister(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleUserData(data: data, messageType: .userRegistered, completion: completion)
}

//func handleUserData(data: Data, messageType: Message, completion: @escaping ([String]) -> Void) {
func handleUserData(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(UserData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            UserDefaults.standard.set(true, forKey: "signIn")
            UserDefaults.standard.set("\(userData.id)", forKey: "uid")
            UserDefaults.standard.set("\(userData.email)", forKey: "userName")
//            completion([Message.success.rawValue])
            completion(["message":Message.success.rawValue])
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}
