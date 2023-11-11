//
//  TodayTasksView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/21.
//

import SwiftUI
import Lottie

struct TodayTasksView: View {
    @State private var previousCompletionStatus: [Int: Bool] = [:]
    @State private var remainingValues: [Int: Float] = [:]
    @ObservedObject private var taskService = TaskService.shared
    @ObservedObject var sleepTracker = SleepActionTracker()
    @State private var selectedTaskId: Int?
    @State private var playAnimation1: Bool = false //完成
    let animation1: String = "animation_lmvsn755"
    @State private var playAnimation2: Bool = false //繼續加油
    let animation2: String = "Animation - 1696509945910"
    @State private var playAnimation3: Bool = false //睡覺
    let animation3: String = "Animation - 1696502172126"
    @State private var playAnimation4: Bool = false //起床
    let animation4: String = "Animation - 1696502129829"
    @State private var playAnimation5: Bool = false //失敗
    let animation5: String = "Animation - 1696509680179"
    @EnvironmentObject var tabBarSettings: TabBarSettings
    
    var cardSpacing: CGFloat = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: cardSpacing) {
                        ForEach(taskService.tasks, id: \.id) { task in
                            ZStack {
                                getTaskView(for: task)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)  // Adjusted size here
                                    .cornerRadius(10)
                                    .onReceive(task.$isCompleted) { newValue in
                                        if newValue && !previousCompletionStatus[task.id, default: false] && !task.animationPlayed {
                                            print("\(task.name) has been completed!")
                                            taskService.updateTask(task)
                                            withAnimation {
                                                playAnimation1 = true
                                            }
                                            task.animationPlayed = true
                                        }
                                        previousCompletionStatus[task.id] = newValue
                                    }
                                    .onReceive(CheckStudyView.remainingValuePublisher) { (taskId, remainingValue) in
                                        if taskId == task.id {
                                            print("Received remainingValue: \(remainingValue) for task \(task.name)")
                                            if remainingValue > 0.0 && remainingValue < task.targetValue {
                                                print("Setting playAnimation to true")
                                                playAnimation2 = true
                                            }
                                        }
                                    }
                                    .onReceive(CheckSportView.remainingValuePublisher) { (taskId, remainingValue) in
                                        if taskId == task.id {
                                            print("Received remainingValue: \(remainingValue) for task \(task.name)")
                                            if remainingValue > 0.0 && remainingValue < task.targetValue {
                                                print("Setting playAnimation to true")
                                                playAnimation2 = true
                                            }
                                        }
                                    }
                                    .onReceive(task.$isSuccess) { isSuccess in
                                        guard let isSuccess = isSuccess else { return }
                                        if isSuccess {
                                            print("\(task.name) has been successfully completed!")
                                        } else {
                                            print("\(task.name) has failed!")
                                        }
                                    }
                                    .onReceive(sleepTracker.$lastAction) { action in
                                        guard task.type == .sleep && !task.animationPlayed else { return } // Only handle sleep type tasks
                                        if let action = action {
                                            switch action {
                                            case .sleep:
                                                withAnimation {
                                                    playAnimation3 = true
                                                }
                                                task.animationPlayed = true
                                                print("Received sleep action: \(action)")
                                            case .wakeUp:
                                                withAnimation {
                                                    playAnimation4 = true
                                                }
                                                task.animationPlayed = true
                                                print("Received sleep action: \(action)")
                                            }
                                        } else {
                                            print("No sleep action recorded.")
                                        }
                                    }
                                    .onReceive(task.$isSuccess) { isSuccess in
                                        guard let isSuccess = isSuccess else { return }
                                        if isSuccess {
                                            print("[Success Notification] \(task.name) was successfully achieved!")
                                        } else {
                                            print("[Failure Notification] \(task.name) was not completed successfully.")
                                            if !task.animationPlayed {
                                                withAnimation {
                                                    playAnimation5 = true
                                                }
                                                task.animationPlayed = true
                                            }
                                        }
                                    }
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    self.selectedTaskId = self.selectedTaskId == task.id ? nil : task.id
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .background(
                    LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationTitle("今日任務")
                .navigationBarTitleDisplayMode(.inline)
                
                if playAnimation1 {
                    VStack {
                        Text("恭喜！任務完成！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation1))
                            .play(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation1 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation2 {
                    VStack {
                        Text("加油！繼續前進！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation2))
                            .play(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation2 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation3 {
                    VStack {
                        Text("晚安！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation3))
                            .play(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation3 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation4 {
                    VStack {
                        Text("早安！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation4))
                            .play(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation4 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation5 {
                    VStack {
                        Text("失敗！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation5))
                            .play(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation5 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
            }
            .onAppear {
                        tabBarSettings.isHidden = true
                    }
                    .onDisappear {
                        tabBarSettings.isHidden = false
                    }
        }
    }
    
    func getTaskView(for task: DailyTask) -> some View {
        let isTaskCompletedBinding = Binding<Bool>(
            get: { task.isCompleted },
            set: {
                task.isCompleted = $0
                taskService.updateTask(task)
            }
        )
        
        let isSuccessBinding = Binding<Bool?>(
            get: { task.isSuccess },
            set: { task.isSuccess = $0 }
        )
        
        
        let remainingValueBinding = Binding<Float>(
            get: { self.remainingValues[task.id, default: task.targetValue] },
            set: { self.remainingValues[task.id] = $0 }
        )
        
        let taskView: AnyView
        
        switch task.type {
        case .sport:
            taskView = AnyView(CheckSportView(isTaskCompleted: isTaskCompletedBinding, remainingValue: remainingValueBinding, task: task))
        case .study:
            taskView = AnyView(CheckStudyView(isTaskCompleted: isTaskCompletedBinding, remainingValue: remainingValueBinding, task: task))
        case .space:
            taskView = AnyView(CheckSpaceView(isTaskCompleted: isTaskCompletedBinding, task: task))
        case .diet:
            taskView = AnyView(CheckDietView(isTaskSuccess: isSuccessBinding,  remainingValue: remainingValueBinding, task: task))
        case .sleep:
            taskView = AnyView(CheckSleepView(isTaskCompleted: isTaskCompletedBinding, isTaskSuccess: isSuccessBinding, task: task, sleepTracker: sleepTracker))
        }
        
        return taskView
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TodayTasksView_Previews: PreviewProvider {
    static var previews: some View {
        TodayTasksView()
            .environmentObject(TaskService.shared)
    }
}
