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
    @StateObject var tickerStore = TickerStore()
    @StateObject private var tabBarSettings = TabBarSettings()
    
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
                        taskStore.clearTasks()
                        todoStore.clearTodos()
                        sportStore.clearTodos()
                        dietStore.clearTodos()
                        tickerStore.clearTodos()
                        UserDefaults.standard.set("", forKey: "uid")
                        UserDefaults.standard.set("", forKey: "userName")
                        UserDefaults.standard.set("", forKey: "password")
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
                        .environmentObject(tabBarSettings)
                        .environmentObject(TaskStore())
                        .environmentObject(TodoStore())
                        .onAppear() {
    //                        StudySpaceList()
                            List()
                            print("AppView-AppStorageUid:\(uid)")
                            print("AppView-AppStorageUserName:\(userName)")
                            print("AppView-AppStoragePassword:\(password)")
                        }
                }
            }
        }
    }
    
    private func List() {
        StudySpaceList {
            self.StudyGeneralList {
                self.SportList {
                    self.DietList {
                        self.tickersList {
                        }
                    }
                }
            }
        }
    }

    private func StudySpaceList(completion: @escaping () -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudySpaceList" ,type: "list",body:body,store: taskStore)
        completion()
    }

    private func StudyGeneralList(completion: @escaping () -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudyGeneralList",type: "list",body:body,store: todoStore)
        completion()
    }

    private func SportList(completion: @escaping () -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "SportList",type: "list",body:body,store: sportStore)
        completion()
    }

    private func DietList(completion: @escaping () -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "DietList",type: "list",body:body,store: dietStore)
        completion()
    }

    private func tickersList(completion: @escaping () -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "tickersList",type: "list",body:body,store: tickerStore)
        completion()
    }
    
  
}
