//
//  AddDietView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct DietDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dietStore: DietStore
    @Binding var diet: Diet
    
    let diets = [
        "減糖", "多喝水", "少油炸", "多吃蔬果"
    ]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false
    
    let dietsUnitsByType: [String: [String]] = [
        "減糖": ["次"],
        "多喝水": ["豪升"],
        "少油炸": ["次"],
        "多吃蔬果": ["份"]
    ]
    
    let dietsPreTextByType: [String: String] = [
        "減糖": "少於",
        "多喝水": "至少",
        "少油炸": "少於",
        "多吃蔬果": "至少"
    ]
    
    struct TodoData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var dueDateTime: String
        var todoNote: String
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(diet.title)
                        .foregroundColor(Color.gray)
                    Text(diet.description)
                        .foregroundColor(Color.gray)
                }
                Section {
                    HStack {
                        
                        Image(systemName: "tag.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                            .foregroundColor(.white) // 圖示顏色設為白色
                            .padding(6) // 確保有足夠的空間顯示外框和背景色
                            .background(Color.yellow) // 設定背景顏色
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                            .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                        Spacer()
                        TextField("標籤", text: $diet.label)
                            .onChange(of: diet.label) { newValue in
                                diet.label = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        Text("選擇時間")
                        Spacer()
                        Text(formattedDate(diet.startDateTime))
                            .foregroundColor(Color.gray)
                    }
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("提醒時間", selection: $diet.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: diet.reminderTime) { newValue in
                                diet.reminderTime = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                            .foregroundColor(.white) // 圖示顏色設為白色
                            .padding(6) // 確保有足夠的空間顯示外框和背景色
                            .background(Color.red) // 設定背景顏色
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                            .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                        Text("目標")
                        Spacer()
                        Text(diet.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(diet.selectedDiets)
                            .foregroundColor(Color.gray)
                       
                        if let preText = dietsPreTextByType[diet.selectedDiets] {
                            Text(preText)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        } else {
                            Text("少於")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                        Text(String(diet.dietsValue))
                            .foregroundColor(Color.gray)
                        if let primaryUnits = dietsUnitsByType[diet.selectedDiets] {
                            Text(primaryUnits.first!)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        } else {
                            Text("次")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                    }
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("結束日期", selection: $diet.dueDateTime, displayedComponents: [.date])
                            .onChange(of: diet.dueDateTime) { newValue in
                                diet.dueDateTime = newValue
                            }
                    }
                }
                TextField("備註", text: $diet.todoNote)
                    .onChange(of: diet.todoNote) { newValue in
                        diet.todoNote = newValue
                    }
            }
            .navigationBarTitle("飲食修改")
            .navigationBarItems(
                                trailing:  Button(action: {
                                    reviseDiet{_ in }
                if diet.label == "" {
                    diet.label = "notSet"
                }
            }) {
                Text("完成")
                    .foregroundColor(.blue)
            })
        }
    }
    
    func reviseDiet(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": diet.id,
            "label": diet.label,
            "reminderTime": formattedTime(diet.reminderTime),
            "dueDateTime": formattedDate(diet.dueDateTime),
            "todoNote": diet.todoNote
        ]
        phpUrl(php: "reviseStudy" ,type: "reviseTask",body:body, store: nil){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
//            completion(message[0])
            completion(message["message"]!)
        }
    }
}
struct DietDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var diet = Diet(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                               selectedDiets: "減醣",
                               dietsValue: 1,
                               recurringUnit: "每週",
                               recurringOption:2,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註",
                               RecurringStartDate: Date(),
                               RecurringEndDate: Date(),
                               completeValue:  0)
        DietDetailView(diet: $diet)
    }
}
