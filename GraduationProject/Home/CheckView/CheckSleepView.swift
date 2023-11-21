//
//  CheckSleepView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/5.
//

import SwiftUI
import Foundation
import Combine

struct CheckSleepView: View {
    @State var sleepValue: Float = 0.0
    @State var accumulatedValue: Float = 0.0
    @State var isTaskCompleted: Bool = false
    @State var isTaskSuccess: Bool = false
    @State private var isCompleted: Bool = false
    @State private var isSuccess: Bool? = nil
    @State var routineType: Int = 0
    let sleepUnits = ["小時"]
    let sleepUnit: String = "小時"
    let habitType: String = "作息"
    //    let task.selectedRoutines: String = "早起"
    //睡眠類型分為早睡、早起、睡眠時長
    
    let titleColor = Color(red: 229/255, green: 86/255, blue: 4/255)
    let customBlue = Color(red: 175/255, green: 168/255, blue: 149/255)
    //    var task: DailyTask
    var task: Routine
    @EnvironmentObject var routineStore: RoutineStore
    @State private var routineTimeToString = ""
    @State private var routineTimeToDate = Date()
    @State private var sleepTimeToString = ""
    @State private var sleepTimeToDate = Date()
    @State private var wakeUpTimeToString = ""
    @State private var wakeUpTimeToDate = Date()
    static let remainingValuePublisher = PassthroughSubject<(isCompleted: Bool, routineType: Int), Never>()
    
    @State private var sleepStartTime = Date()
    @State private var sleepEndTime = Date()
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 1)
                
                Text("習慣類型：\(habitType)")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 1)
                Text("作息類型: \(task.selectedRoutines)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 1)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("目標")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        if task.selectedRoutines == "早睡" {
                            Text("早睡目標: \(routineTimeToString)")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if task.selectedRoutines == "早起" {
                            Text("早起目標: \(routineTimeToString)")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if task.selectedRoutines == "睡眠時長" {
                            Text("睡眠目標: \(task.routineValue) 小時")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("已完成")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        if task.selectedRoutines == "早睡" {
                            Text(task.sleepTime != nil ? "睡覺時間: \(formattedTime(from: task.sleepTime!))" : "未記錄")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if task.selectedRoutines == "早起" {
                            Text(task.wakeUpTime != nil ? "起床時間: \(formattedTime(from: task.wakeUpTime!))" : "未記錄")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        } else if task.selectedRoutines == "睡眠時長" {
                            Text(task.sleepTime != nil ? "睡覺時間: \(formattedTime(from: task.sleepTime!))" : "未記錄")
                            Text("睡眠時長: \(accumulatedValue, specifier: "%.1f") \(sleepUnit)")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                HStack {
                    if task.selectedRoutines == "早睡" {
                        Button(action: {
                            sleepStartTime = Date()
//                            routineStore.updateCompleteValue(withID: task.id, newValue: sleepStartTime, type: 0)
                            routineType = 0
                            routineStore.updateRecurring(withID: task.id, newDate: nil, newTime: sleepStartTime, type: routineType)
                            sleepTimeToString = GraduationProject.formattedTime(sleepStartTime)
                            sleepTimeToDate = convertToTimeHR(sleepTimeToString) ?? Date()
                            print("我是早睡 routineTime ＝ \(routineTimeToString) rtime ＝ \(sleepTimeToString)")
                            print("我是早睡time routineTime ＝ \(routineTimeToDate) rtime ＝ \(sleepTimeToDate)")
                            isTaskCompleted =  sleepTimeToDate < routineTimeToDate
                            isTaskSuccess = isTaskCompleted
                            isCompleted = true
                            CheckSleepView.remainingValuePublisher.send((isCompleted: isTaskCompleted, routineType: routineType))
                            upDateCompleteValue{_ in }
                        }) {
                            Text("睡覺")
                                .frame(minWidth: 60, idealWidth: 60, maxWidth: 60, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                .padding(5)
                                .background(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)) ? Color.gray : customBlue)
                                .foregroundColor(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)) ? Color.gray : Color.white)
                                .cornerRadius(8)
                        }
                        .disabled(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)))
                    } else if task.selectedRoutines == "早起" {
                        Button(action: {
                            sleepEndTime = Date()
//                            routineStore.updateCompleteValue(withID: task.id, newValue: sleepEndTime, type: 1)
                            routineType = 1
                            routineStore.updateRecurring(withID: task.id, newDate: nil, newTime: sleepEndTime, type: routineType)
                            wakeUpTimeToString = GraduationProject.formattedTime(sleepEndTime)
                            wakeUpTimeToDate = convertToTimeHR(wakeUpTimeToString) ?? Date()
                            print("我是早睡 routineTime ＝ \(routineTimeToString) rtime ＝ \(wakeUpTimeToString)")
                            print("我是早睡time routineTime ＝ \(routineTimeToDate) rtime ＝ \(wakeUpTimeToDate)")
                            isTaskCompleted =  wakeUpTimeToDate < routineTimeToDate
                            isTaskSuccess = isTaskCompleted
                            isCompleted = true
                            CheckSleepView.remainingValuePublisher.send((isCompleted: isTaskSuccess, routineType: routineType))
                            upDateCompleteValue{_ in }
                        }) {
                            Text("起床")
                                .frame(minWidth: 60, idealWidth: 60, maxWidth: 60, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                .padding(5)
                                .background(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)) ? Color.gray : customBlue)
                                .foregroundColor(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)) ? Color.gray : Color.white)
                                .cornerRadius(8)
                        }
                        .disabled(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)))
                    } else if task.selectedRoutines == "睡眠時長" {
                        Button(action: {
                            if task.sleepTime == nil {
                                sleepStartTime = Date()
                                routineType = 2
                                routineStore.updateRecurring(withID: task.id, newDate: Date(), newTime: sleepStartTime, type: routineType)
                                // 測試取消
//                                routineStore.updateCompleteValue(withID: task.id, newValue: sleepStartTime, type: 0)
                                CheckSleepView.remainingValuePublisher.send((isCompleted: isTaskSuccess, routineType: routineType))
                                upDateCompleteValue{_ in }
                            } else  if task.sleepTime != nil {
                                isCompleted = true
                                sleepEndTime = Date()
//                                routineStore.updateCompleteValue(withID: task.id, newValue: sleepEndTime, type: 1)
                                print("睡眠時長id: \(task.id)")
//                                routineStore.duplicateRoutineWithID(task.id, newID: 0)
                                routineType = 3
                                routineStore.updateRecurring(withID: task.id, newDate: Date(), newTime: sleepEndTime, type: routineType)
                                upDateCompleteValue{_ in }
                            }
                            print("我是睡眠時長檢查：\(task)")
                        }) {
                            Text(task.sleepTime == nil ? "睡覺" : "起床")
                                .frame(minWidth: 60, idealWidth: 60, maxWidth: 60, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
                                .padding(5)
                                .background(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)) ? Color.gray : customBlue)
                                .foregroundColor(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)) ? Color.gray : Color.white)
                                .cornerRadius(8)
                        }
                        .disabled(task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil)))
                    }
                }
                .padding(.horizontal, 10)
            }
            .onChange(of: task.wakeUpTime) { newValue in
                if (task.selectedRoutines == "睡眠時長") {
                    print("我是睡眠時長time sleepTime ＝ \(task.sleepTime) wakeUpTime ＝ \(newValue)")
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: task.sleepTime!, to: newValue!)
                    let totalHours = Float(components.hour ?? 0) + Float(components.minute ?? 0) / 60.0
                    accumulatedValue = totalHours
                    isTaskSuccess = totalHours < 24.0 && totalHours > Float(task.routineValue)
                    CheckSleepView.remainingValuePublisher.send((isCompleted: isTaskSuccess, routineType: 3))
                }
            }
            .padding(12)
            .background(
                (task.id == 0  ||  isTaskCompleted || ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil))) ? Color.gray : Color.clear
            )
            if isTaskCompleted {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .background(Circle().fill(Color.green))
            } else if ((task.selectedRoutines == "早睡" && task.sleepTime != nil) || (task.selectedRoutines == "早起" && task.wakeUpTime != nil) || (task.wakeUpTime != nil && task.sleepTime != nil)) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .background(Circle().fill(Color.red))
            }
        }
        .onAppear() {
            routineTimeToString = GraduationProject.formattedTime(task.routineTime)
            routineTimeToDate = convertToTimeHR(routineTimeToString) ?? Date()
            if (task.sleepTime != nil) {
                sleepTimeToString = GraduationProject.formattedTime(task.sleepTime!)
                sleepTimeToDate = convertToTimeHR(sleepTimeToString) ?? Date()
            }
            if (task.wakeUpTime != nil) {
                wakeUpTimeToString = GraduationProject.formattedTime(task.wakeUpTime!)
                wakeUpTimeToDate = convertToTimeHR(wakeUpTimeToString) ?? Date()
            }
            
            
            if (task.selectedRoutines == "早睡") {
                if (task.sleepTime != nil) {
                    print("我是早睡 routineTime ＝ \(routineTimeToString) rtime ＝ \(sleepTimeToString)")
                    print("我是早睡time routineTime ＝ \(routineTimeToDate) rtime ＝ \(sleepTimeToDate)")
                    isTaskCompleted =  sleepTimeToDate < routineTimeToDate
                }
            } else if (task.selectedRoutines == "早起") {
                if (task.wakeUpTime != nil) {
                    print("我是早睡 routineTime ＝ \(routineTimeToString) rtime ＝ \(wakeUpTimeToString)")
                    print("我是早睡time routineTime ＝ \(routineTimeToDate) rtime ＝ \(wakeUpTimeToDate)")
                    isTaskCompleted =  wakeUpTimeToDate < routineTimeToDate
                }
            } else {
                if (task.wakeUpTime != nil && task.sleepTime != nil) {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: task.sleepTime!, to: task.wakeUpTime!)
                    let totalHours = Float(components.hour ?? 0) + Float(components.minute ?? 0) / 60.0
                    isTaskCompleted = totalHours < 24.0 && totalHours > Float(task.routineValue)
                }
            }
        }
    }
    
    func upDateCompleteValue(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": task.id,
            "RecurringStartDate": formattedDate(task.RecurringStartDate),
            "RecurringEndDate": formattedDate(task.RecurringEndDate),
            "completeValue": accumulatedValue,
            "isComplete": isTaskSuccess,
            "routineType": routineType,
        ]
        print("body:\(body)")
        phpUrl(php: "upDateCompleteValue" ,type: "reviseTask",body:body, store: nil){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
//            completion(message[0])
            completion(message["message"]!)
        }
    }
}

struct CheckSleepView_Previews: PreviewProvider {
    @State static var  sampleTodo = Routine(
        id: 1,
        label: "SampleLabel",
        title: "SampleTitle",
        description: "SampleDescription",
        startDateTime: Date(),
        selectedRoutines: "早睡",
        routineValue: 5,
        routineTime: Date(),
        recurringOption: 1,
        todoStatus: false,
        dueDateTime: Date(),
        reminderTime: Date(),
        todoNote: "SampleNote",
        RecurringStartDate: Date(),
        RecurringEndDate: Date(),
        sleepTime: Date(),
        wakeUpTime: Date()
    )
    static var previews: some View {
        CheckSleepView(task: sampleTodo)
            .environmentObject(TaskService.shared)
    }
}
