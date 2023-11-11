//
//  CheckDietView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/5.
//

import SwiftUI
import Combine

struct CheckDietView: View {
    @State var dietValue: Float = 0.0
    @State var accumulatedValue: Float = 0.0
    @Binding var isTaskSuccess: Bool?
    @Binding var remainingValue: Float
    
    let dietUnits = ["次", "小時"]
    let dietUnit: String = "次"
    let habitType: String = "飲食"
    let dietType: String = "減糖"
    
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
                
                Text("飲食類型: \(dietType)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 1)

                HStack {
                    VStack(alignment: .leading) {
                        Text("目標")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)

                        Text("\(task.targetValue, specifier: "%.1f") \(dietUnit)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("已完成")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)

                        Text("\(accumulatedValue, specifier: "%.1f") \(dietUnit)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                    }
                }
                .padding(.horizontal, 10)

                HStack {
                    TextField("數值", value: $dietValue, format: .number)
                        .keyboardType(.decimalPad)
                        .frame(width: 70, height: 35)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isTaskSuccess == true ? Color.gray : Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                        )
                        .cornerRadius(8)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .disabled(isTaskSuccess == true)
                    
                    Text(dietUnit)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .foregroundColor(customBlue)
                        .frame(width: 100, alignment: .trailing)

                    Button(action: {
                        accumulatedValue += dietValue
                        let remaining = task.targetValue - accumulatedValue
                        remainingValue = remaining
                        CheckDietView.remainingValuePublisher.send((taskId: task.id, remainingValue: remaining))
                        
                        // 判斷是否成功
                        switch dietType {
                        case "減糖", "少油炸":
                            isTaskSuccess = accumulatedValue <= task.targetValue
                        case "多喝水", "多吃蔬果":
                            isTaskSuccess = accumulatedValue >= task.targetValue
                        default:
                            break
                        }

                    }) {
                        Image(systemName: isTaskSuccess == false ? "xmark" : "checkmark")
                            .foregroundColor(isTaskSuccess == true ? Color.gray : Color.white)
                            .padding(6)
                            .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                            .font(.system(size: 16))
                    }
                    .disabled(isTaskSuccess == true)
                }
                .padding(.horizontal, 10)
            }
            .padding(12)
                    
            Group {
                if (dietType == "減糖" || dietType == "少油炸") && isTaskSuccess == false {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(15)
                        .background(Circle().fill(Color.red))
                }
                else if (dietType == "多喝水" || dietType == "多吃蔬果") && isTaskSuccess == true {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(15)
                        .background(Circle().fill(Color.green))
                }
            }
        }
        .background(
            (dietType == "減糖" || dietType == "少油炸") && isTaskSuccess == false ? Color.gray :
            (dietType == "多喝水" || dietType == "多吃蔬果") && isTaskSuccess == true ? Color.gray :
            Color.clear
        )
    }
}

struct CheckDietView_Previews: PreviewProvider {
    @State static var isTaskSuccessPreview: Bool? = nil
    @State static var remainingValuePreview: Float = 0.0
    static var taskPreview = DailyTask(id: 1, name: "減糖", type: .diet, isCompleted: false, targetValue: 5.0)
    
    static var previews: some View {
        CheckDietView(isTaskSuccess: $isTaskSuccessPreview, remainingValue: $remainingValuePreview, task: taskPreview)
            .environmentObject(TaskService.shared)
    }
}
