//
// CheckSportView.swift
// GraduationProject
//
//  Created by heonrim on 9/22/23.
//

import SwiftUI
import Combine

struct CheckSportView: View {
    @State var sportValue: Float = 0.0
    @State var accumulatedValue: Float = 0.0
    @Binding var isTaskCompleted: Bool
    @State private var isCompleted: Bool = false
    @Binding var remainingValue: Float
    
    let sportUnits = ["次", "小時"]
    let sportUnit: String = "次"
    let habitType: String = "運動"
    let sportType: String = "跑步"
    
    let titleColor = Color(red: 229/255, green: 86/255, blue: 4/255)
    let customBlue = Color(red: 175/255, green: 168/255, blue: 149/255)
    var task: DailyTask
    static let remainingValuePublisher = PassthroughSubject<(taskId: Int, remainingValue: Float), Never>()
    
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
                
                Text("運動類型: \(sportType)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 1)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("目標")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text("\(task.targetValue, specifier: "%.1f") \(sportUnit)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("已完成")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text("\(accumulatedValue, specifier: "%.1f") \(sportUnit)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                    }
                }
                .padding(.horizontal, 10)
                
                HStack {
                    TextField("數值", value: $sportValue, format: .number)
                        .keyboardType(.decimalPad)
                        .frame(width: 70, height: 35)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isTaskCompleted ? Color.gray : Color.white) // Change background color based on completion status
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                        )
                        .cornerRadius(8)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .disabled(isTaskCompleted)
                    
                    Text(sportUnit)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .foregroundColor(customBlue)
                        .frame(width: 100, alignment: .trailing)
                    
                    Button(action: {
                        accumulatedValue += sportValue
                        let remaining = task.targetValue - accumulatedValue
                        remainingValue = remaining
                        CheckSportView.remainingValuePublisher.send((taskId: task.id, remainingValue: remaining))
                        if accumulatedValue >= task.targetValue {
                            isTaskCompleted = true
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(isTaskCompleted ? Color.gray : Color.white)
                            .padding(6)
                            .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                            .font(.system(size: 16))
                    }
                    .disabled(isTaskCompleted)
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
        .background(isTaskCompleted ? Color.gray : Color.clear)
    }
}

struct CheckSportView_Previews: PreviewProvider {
    @State static var isTaskCompletedPreview: Bool = false
    @State static var remainingValuePreview: Float = 0.0
    static var taskPreview = DailyTask(id: 1, name: "跑步", type: .sport, isCompleted: false, targetValue: 5.0)
    
    static var previews: some View {
        CheckSportView(isTaskCompleted: $isTaskCompletedPreview, remainingValue: $remainingValuePreview, task: taskPreview)
            .environmentObject(TaskService.shared)
    }
}
