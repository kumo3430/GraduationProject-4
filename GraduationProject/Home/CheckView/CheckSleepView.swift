//
//  CheckSleepView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/5.
//

import SwiftUI
import Combine

class SleepActionTracker: ObservableObject {
    @Published var lastAction: SleepAction? = nil
    enum SleepAction {
        case sleep, wakeUp
    }
}

struct CheckSleepView: View {
    @State var sleepValue: Float = 0.0
    @State var accumulatedValue: Float = 0.0
    @Binding var isTaskCompleted: Bool
    @Binding var isTaskSuccess: Bool?
    @State private var isCompleted: Bool = false
    @State private var isSuccess: Bool? = nil
    
    let sleepUnits = ["小時"]
    let sleepUnit: String = "小時"
    let habitType: String = "作息"
    let sleepType: String = "早起"
    //睡眠類型分為早睡、早起、睡眠時長
    
    let titleColor = Color(red: 229/255, green: 86/255, blue: 4/255)
    let customBlue = Color(red: 175/255, green: 168/255, blue: 149/255)
    var task: DailyTask
    static let remainingValuePublisher = PassthroughSubject<(taskId: Int, remainingValue: Float), Never>()
    
    @State private var sleepStartTime: Date? = nil
    @State private var sleepEndTime: Date? = nil
    @ObservedObject var sleepTracker: SleepActionTracker

    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 1)
                
                Text("習慣類型：\(habitType)")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 1)
                Text("作息類型: \(sleepType)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 1)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("目標")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)

                        if sleepType == "早睡" {
                            Text("早睡目標: \(task.formattedTargetTime() ?? "未設定")")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if sleepType == "早起" {
                            Text("早起目標: \(task.formattedTargetTime() ?? "未設定")")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if sleepType == "睡眠時長" {
                            Text("睡眠目標: \(task.targetValue, specifier: "%.1f") \(sleepUnit)")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("已完成")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        if sleepType == "早睡" {
                            Text(sleepStartTime != nil ? "睡覺時間: \(formattedTime(from: sleepStartTime!))" : "未記錄")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if sleepType == "早起" {
                            Text(sleepEndTime != nil ? "起床時間: \(formattedTime(from: sleepEndTime!))" : "未記錄")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if sleepType == "睡眠時長" {
                            Text("睡眠時長: \(accumulatedValue, specifier: "%.1f") \(sleepUnit)")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                HStack {
                    if sleepType == "早睡" {
                            Button(action: {
                                sleepStartTime = Date()
                                let hour = Calendar.current.component(.hour, from: sleepStartTime!)
                                accumulatedValue = Float(hour)
                                if let targetDate = task.targetTime {
                                    let targetHour = Calendar.current.component(.hour, from: targetDate)
                                    isTaskSuccess = hour < targetHour
                                }
                                sleepTracker.lastAction = .sleep
                            }) {
                                Text("睡覺")
                                    .frame(minWidth: 60, idealWidth: 60, maxWidth: 60, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                                                    .padding(5)
                                                                    .background(isCompleted ? Color.gray : customBlue)
                                                                    .foregroundColor(Color.white)
                                                                    .cornerRadius(8)
                        }
                        .disabled(isCompleted)
                    } else if sleepType == "早起" {
                        Button(action: {
                            sleepEndTime = Date()
                            let hour = Calendar.current.component(.hour, from: sleepEndTime!)
                            accumulatedValue = Float(hour)
                            if let targetDate = task.targetTime {
                                let targetHour = Calendar.current.component(.hour, from: targetDate)
                                isTaskSuccess = hour < targetHour
                            }
                            sleepTracker.lastAction = .wakeUp
                        }) {
                            Text("起床")
                                .frame(minWidth: 60, idealWidth: 60, maxWidth: 60, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                                                .padding(5)
                                                                .background(isCompleted ? Color.gray : customBlue)
                                                                .foregroundColor(Color.white)
                                                                .cornerRadius(8)
                        }
                        .disabled(isCompleted)
                    } else if sleepType == "睡眠時長" {
                        Button(action: {
                            if sleepStartTime == nil {
                                sleepStartTime = Date()
                                sleepTracker.lastAction = .sleep
                            } else {
                                sleepEndTime = Date()
                                let sleepDuration = sleepEndTime!.timeIntervalSince(sleepStartTime!)
                                accumulatedValue += Float(sleepDuration / 3600.0)
                                isTaskSuccess = accumulatedValue >= task.targetValue
                                sleepStartTime = nil
                                sleepEndTime = nil
                                sleepTracker.lastAction = .wakeUp
                            }
                        }) {
                            Text(sleepStartTime == nil ? "睡覺" : "起床")
                                .frame(minWidth: 60, idealWidth: 60, maxWidth: 60, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                .padding(5)
                                .background(isCompleted ? Color.gray : customBlue)
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                        }
                        .disabled(isCompleted)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(12)
            
            if isTaskCompleted {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .background(Circle().fill(Color.green))
            }
        }
    }
}

struct CheckSleepView_Previews: PreviewProvider {
    @State static var isTaskCompletedPreview: Bool = false
    @State static var isSuccessPreview: Bool? = nil
    @State static var remainingValuePreview: Float = 0.0
    
    static var taskPreview: DailyTask = {
        let dateComponents = DateComponents(hour: 22, minute: 0)
        let targetTime = Calendar.current.date(from: dateComponents)!
        return DailyTask(id: 1, name: "晚上10點前入睡", type: .sleep, isCompleted: false, targetValue: 8.0, targetTime: targetTime)
    }()
    
    static var previews: some View {
        let sleepTrackerPreview = SleepActionTracker()

        return CheckSleepView(isTaskCompleted: $isTaskCompletedPreview, isTaskSuccess: $isSuccessPreview, task: taskPreview, sleepTracker: sleepTrackerPreview)
            .environmentObject(TaskService.shared)
    }
}
