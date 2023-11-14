//
//  AddSportView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct DetailSportView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sportStore: SportStore
    @Binding var sport: Sport
    
    let sports = [
        "跑步", "單車騎行", "散步", "游泳", "爬樓梯", "健身",
        "瑜伽", "舞蹈", "滑板", "溜冰", "滑雪", "跳繩",
        "高爾夫", "網球", "籃球", "足球", "排球", "棒球",
        "曲棍球", "壁球", "羽毛球", "舉重", "壁球", "劍道",
        "拳擊", "柔道", "跆拳道", "柔術", "舞劍", "團體健身課程"
    ]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false
    
    let sportUnits = ["小時", "次", "卡路里"]
    
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
                    Text(sport.title)
                        .foregroundColor(Color.gray)
                    Text(sport.description)
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
                        TextField("標籤", text: $sport.label)
                            .onChange(of: sport.label) { newValue in
                                sport.label = newValue
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
                        Text(formattedDate(sport.startDateTime))
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
                        DatePicker("提醒時間", selection: $sport.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: sport.reminderTime) { newValue in
                                sport.reminderTime = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                            .foregroundColor(.white) // 圖示顏色設為白色
                            .padding(6) // 確保有足夠的空間顯示外框和背景色
                            .background(Color.red) // 設定背景顏色
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                            .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                        Text("目標")
                        Spacer()
                        Text(sport.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(sport.selectedSport)
                            .foregroundColor(Color.gray)
                        Text(String(sport.sportValue))
                            .foregroundColor(Color.gray)
                        Text(sport.sportUnits)
                            .foregroundColor(Color.gray)
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
                        DatePicker("結束日期", selection: $sport.dueDateTime, displayedComponents: [.date])
                            .onChange(of: sport.dueDateTime) { newValue in
                                sport.dueDateTime = newValue
                            }
                    }
                }
                TextField("備註", text: $sport.todoNote)
                    .onChange(of: sport.todoNote) { newValue in
                        sport.todoNote = newValue
                    }
            }
            .navigationBarTitle("運動修改")
            .navigationBarItems(
                                trailing:  Button(action: {
                                    reviseSport{_ in }
                if sport.label == "" {
                    sport.label = "notSet"
                }
            }) {
                Text("完成")
                    .foregroundColor(.blue)
            })
        }
    }

    func reviseSport(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": sport.id,
            "label": sport.label,
            "reminderTime": formattedTime(sport.reminderTime),
            "dueDateTime": formattedDate(sport.dueDateTime),
            "todoNote": sport.todoNote
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
struct DetailSportView_Previews: PreviewProvider {
    static var previews: some View {
        @State var sport = Sport(id: 001,
                                 label:"我是標籤",
                                 title: "英文",
                                 description: "背L2單字",
                                 startDateTime: Date(),
                                 selectedSport: "溜冰",
                                 sportValue: 1.1,
                                 sportUnits: "次",
                                 recurringUnit: "每週",
                                 recurringOption:2,
                                 todoStatus: false,
                                 dueDateTime: Date(),
                                 reminderTime: Date(),
                                 todoNote: "我是備註",
                                 RecurringStartDate: Date(),
                                 RecurringEndDate: Date(),
                                 completeValue:  0)
        DetailSportView(sport: $sport)
    }
}
