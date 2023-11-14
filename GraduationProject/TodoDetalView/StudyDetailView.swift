//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI

struct StudyDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var todo: Todo
    @EnvironmentObject var todoStore: TodoStore
    
    
    @State var messenge = ""
    @State var isError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(todo.title)
                        .foregroundColor(Color.gray)
                    Text(todo.description)
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
                        TextField("標籤", text: $todo.label)
                            .onChange(of: todo.label) { newValue in
                                todo.label = newValue
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
                        Text(formattedDate(todo.startDateTime))
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
                        DatePicker("提醒時間", selection: $todo.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: todo.reminderTime) { newValue in
                                todo.reminderTime = newValue
                            }
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "book.closed.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                            .foregroundColor(.white) // 圖示顏色設為白色
                            .padding(6) // 確保有足夠的空間顯示外框和背景色
                            .background(Color.red) // 設定背景顏色
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                            .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                        Text("目標")
                        Spacer()
                        Text(todo.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(String(todo.studyValue))
                            .foregroundColor(Color.gray)
                        Text(todo.studyUnit)
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
                        DatePicker("結束日期", selection: $todo.dueDateTime, displayedComponents: [.date])
                            .onChange(of: todo.dueDateTime) { newValue in
                                todo.dueDateTime = newValue
                            }
                    }
                }
                
                TextField("備註", text: $todo.todoNote)
                    .onChange(of: todo.todoNote) { newValue in
                        todo.todoNote = newValue
                    }
            }
            .navigationBarTitle("一般學習修改")
            .navigationBarItems(
                                trailing: Button(action: {
                                    reviseTodo{_ in }
                if todo.label == "" {
                    todo.label = "notSet"
                }
            }) {
                Text("完成")
                    .foregroundColor(.blue)
            })
        }
    }
    
    func reviseTodo(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": todo.id,
            "label": todo.label,
            "reminderTime": formattedTime(todo.reminderTime),
            "dueDateTime": formattedDate(todo.dueDateTime),
            "todoNote": todo.todoNote
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

struct StudyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var todo = Todo(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                               studyValue: 3.0,
                               studyUnit: "小時",
                               recurringUnit:"每週",
                               recurringOption:2,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註",
                               RecurringStartDate: Date(),
                               RecurringEndDate: Date(),
                               completeValue:  0)
        StudyDetailView(todo: $todo)
    }
}
