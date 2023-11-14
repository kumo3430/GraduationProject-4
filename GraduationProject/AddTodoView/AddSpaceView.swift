//
//  AddSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import Foundation
import SwiftUI

struct AddSpaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskStore: TaskStore
    
    @State var title = ""
    @State var description = ""
    @State var label: String = ""
    @State var nextReviewDate = Date()
    @State var nextReviewTime = Date()
    @State var repetition1Count = Date()
    @State var repetition2Count = Date()
    @State var repetition3Count = Date()
    @State var repetition4Count = Date()
    @State var messenge = ""
    @State var isError = false
    
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: nextReviewDate)! }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("標題", text: $title)
                    TextField("內容", text: $description)
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
                        TextField("標籤", text: $label)
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("選擇時間", selection: $nextReviewDate, displayedComponents: [.date])
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
                        DatePicker("提醒時間", selection: $nextReviewTime, displayedComponents: [.hourAndMinute])
                    }
                }
                
                Section {
                    ForEach(0..<4) { index in
                        HStack {
                            Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                        }
                    }
                }
                if(isError) {
                    Text(messenge)
                        .foregroundColor(.red)
                }
            }
            // 一個隱藏的分隔線
            .listStyle(PlainListStyle())
            .navigationBarTitle("間隔學習")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成") { addStudySpaced{_ in } }
                                // 如果 title 為空，按鈕會被禁用，即無法點擊。
                .disabled(title.isEmpty && description.isEmpty)
                .onDisappear() {
                    repetition1Count = nextReviewDates[0]
                    repetition2Count = nextReviewDates[1]
                    repetition3Count = nextReviewDates[2]
                    repetition4Count = nextReviewDates[3]
                }
            )
        }
    }
    
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func addStudySpaced(completion: @escaping (String) -> Void) {
        var body: [String: Any] = [
            "title": title,
            "description": description,
            "label": label,
            "nextReviewDate": formattedDate(nextReviewDate),"nextReviewTime": formattedTime(nextReviewTime),
            "First": formattedDate(nextReviewDates[0]),"third": formattedDate(nextReviewDates[1]),
            "seventh": formattedDate(nextReviewDates[2]),"fourteenth": formattedDate(nextReviewDates[3]) ]
        
        phpUrl(php: "addStudySpaced" ,type: "addTask",body:body,store: taskStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            presentationMode.wrappedValue.dismiss()
//            completion(message[0])
            completion(message["message"]!)
        }
    }
}

struct AddSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpaceView()
            .environmentObject(TaskStore())
    }
}
