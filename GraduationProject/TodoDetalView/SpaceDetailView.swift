//
//  TodoDetailView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct SpaceDetailView: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    @State var title = ""
    @State var description = ""
    @State var nextReviewTime = Date()
    @State var repetition1Status:Int = 0
    @State var repetition2Status:Int = 0
    @State var repetition3Status:Int = 0
    @State var repetition4Status:Int = 0
    @State var messenge = ""
    @State var isError = false
    
    struct reviseUserData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var message: String
    }
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: task.nextReviewDate)! }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(task.title)
                        .foregroundColor(Color.gray)
                    Text(task.description)
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
                        TextField("標籤", text: $task.label)
                            .onChange(of: task.label) { newValue in
                                task.label = newValue
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
                        Text(formattedDate(task.nextReviewDate))
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
                        DatePicker("提醒時間", selection: $task.nextReviewTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: task.nextReviewTime) { newValue in
                                task.nextReviewTime = newValue
                            }
                        
                    }
                }
                Section {
                    ForEach(0..<4) { index in
                        HStack {
                            Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                        }
                    }
                }
                Text(messenge)
                    .foregroundColor(.red)
            }
                .navigationTitle("間隔學習修改")
                .navigationBarItems(
                    trailing: Button("完成") { reviseStudySpaced{_ in }}
                )
        }
        .onAppear() {
            task.title = task.title
            task.description = task.description
            task.nextReviewTime = task.nextReviewTime
        }
    }
        
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func reviseStudySpaced(completion: @escaping (String) -> Void) {
        let body = [ "id": task.id,
                     "title": task.title,
                     "label": task.label,
                     "description": task.description,
                     "reminderTime": formattedTime(task.nextReviewTime)] as [String : Any]

        phpUrl(php: "reviseSpace" ,type: "reviseTask",body:body, store: nil){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            print("修改間隔學習回傳：\(String(describing: message["message"]))")
            if message["message"] == "Success" {
                isError = false
                messenge = ""
                presentationMode.wrappedValue.dismiss()
            } else {
                isError = true
                messenge = "習慣建立錯誤 請聯繫管理員"
            }
            completion(message["message"]!)
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        // 創建一個@State變數
        @State var task = Task(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               nextReviewDate: Date(),
                               nextReviewTime: Date(),
                               repetition1Count: Date(),
                               repetition2Count: Date(),
                               repetition3Count: Date(),
                               repetition4Count: Date(),
                               isReviewChecked0: true,
                               isReviewChecked1: false,
                               isReviewChecked2: false,
                               isReviewChecked3: false)
        
        SpaceDetailView(task: $task) // 使用綁定的task
        //            .environmentObject(TaskStore())
    }
}
