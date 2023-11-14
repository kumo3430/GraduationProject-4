//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore
import Foundation

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @State private var shouldList = false
    @State private var hasListBeenCalled = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("uid") private var uid:String = ""
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("password") private var password:String = ""
    @AppStorage("RegistrationView") var showRegistrationView: Bool = false
    
    @StateObject var taskStore = TaskStore()
    @StateObject var todoStore = TodoStore()
    @StateObject var sportStore = SportStore()
    @StateObject var dietStore = DietStore()
    @StateObject var routineStore = RoutineStore()
    @StateObject var tickerStore = TickerStore()
    @StateObject var communityStore = CommunityStore()
    @StateObject var completionRates = CompletionRatesViewModel()
    @StateObject private var tabBarSettings = TabBarSettings()
    
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
//                        taskStore.clearTasks()
//                        todoStore.clearTodos()
//                        sportStore.clearTodos()
//                        dietStore.clearTodos()
//                        tickerStore.clearTodos()
//                        UserDefaults.standard.set("", forKey: "uid")
//                        UserDefaults.standard.set("", forKey: "userName")
//                        UserDefaults.standard.set("", forKey: "password")
                        handleLogout()
                    }
        
            } else {
                if showRegistrationView {
                    RegistrationView()
                } else {
                    TabBarView()
                        .environmentObject(taskStore)
                        .environmentObject(todoStore)
                        .environmentObject(sportStore)
                        .environmentObject(dietStore)
                        .environmentObject(tickerStore)
                        .environmentObject(routineStore)
                        .environmentObject(communityStore)
                        .environmentObject(completionRates)
                        .environmentObject(tabBarSettings)
//                        .environmentObject(TaskStore())
//                        .environmentObject(TodoStore())
                        .onAppear() {
//                            List()
//                            print("AppView-AppStorageUid:\(uid)")
//                            print("AppView-AppStorageUserName:\(userName)")
//                            print("AppView-AppStoragePassword:\(password)")
                            fetchDataIfNeeded()
                            printUserInfo()
                        }
                }
            }
        }
    }
    private func handleLogout() {
        shouldList = false
        taskStore.clearTasks()
        todoStore.clearTodos()
        sportStore.clearTodos()
        dietStore.clearTodos()
        routineStore.clearTodos()
        communityStore.clearTodos()
        completionRates.clearTodos()
        tickerStore.clearTodos()
        UserDefaults.standard.set("", forKey: "uid")
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("", forKey: "password")
    }
    
    private func fetchDataIfNeeded() {
        if !shouldList {
            list()
            shouldList = true
        }
    }
    
    private func printUserInfo() {
        print("AppView-AppStorageUid:\(uid)")
        print("AppView-AppStorageUserName:\(userName)")
        print("AppView-AppStoragePassword:\(password)")
    }
    
    private func printResultMessage(for message: String, withOperationName operationName: String) {
        if message == "Success" {
            print("\(operationName) Success")
        } else {
            print("\(operationName) failed with message: \(message)")
        }
    }
  
    private func list() {
        tickersList { tickersListMessage in
            printResultMessage(for: tickersListMessage, withOperationName: "TickersList")
        }
        RoutineList { dietListMessage in
            printResultMessage(for: dietListMessage, withOperationName: "RoutineList")
        }
        DietList { dietListMessage in
            printResultMessage(for: dietListMessage, withOperationName: "DietList")
        }
        SportList { sportListMessage in
            printResultMessage(for: sportListMessage, withOperationName: "SportList")
        }
        StudyGeneralList { generalListMessage in
            printResultMessage(for: generalListMessage, withOperationName: "StudyGeneralList")
        }
        StudySpaceList { spaceListMessage in
            printResultMessage(for: spaceListMessage, withOperationName: "StudySpaceList")
        }
        CommunityList { spaceListMessage in
            printResultMessage(for: spaceListMessage, withOperationName: "CommunityList")
        }
    }
    
    private func StudySpaceList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudySpaceList" ,type: "list",body:body,store: taskStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
           // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    private func StudyGeneralList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudyGeneralList",type: "list",body:body,store: todoStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
           // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    private func SportList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "SportList",type: "list",body:body,store: sportStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
           // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    private func DietList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "DietList",type: "list",body:body,store: dietStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
           // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    private func RoutineList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "RoutineList",type: "list",body:body,store: routineStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
           // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    private func tickersList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "tickersList",type: "list",body:body,store: tickerStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            //// completion(message[0])
            completion(message["message"]!)
        }
    }
    private func CommunityList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "CommunityList",type: "list",body:body,store: communityStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            //// completion(message[0])
            completion(message["message"]!)
        }
    }
}

