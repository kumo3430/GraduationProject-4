//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI

struct AddStudyView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoStore: TodoStore
    
    @State var uid: String = ""
    @State var category_id: Int = 1
    @State var label: String = ""
    @State var todoTitle: String = ""
    @State var todoIntroduction: String = ""
    @State var startDateTime: Date = Date()
    @State var todoStatus: Bool = false
    @State var reminderTime: Date = Date()
    @State var todoNote: String = ""
    @State private var studyValue: Float = 0.0
    @State private var selectedStudyUnit: String = "次"
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1  // 1: 持續重複, 2: 選擇結束日期
    @State private var recurringEndDate = Date()
    @State private var selectedTimeUnit: String = "每日"
    
    @State var messenge = ""
    @State var isError = false
    @State private var studyUnit: String = "次"
    let studyUnits = ["次", "小時"]
    let timeUnits = ["每日", "每週", "每月"]
    
    
    struct TodoData : Decodable {
        var userId: String?
        var category_id: Int
        var label: String?
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        
        var studyValue: Float
        var studyUnit: Int
        
        var todoStatus: Int
        var reminderTime: String
        var dueDateTime: String
        var todo_id: Int
        var todoNote: String?
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("標題", text: $todoTitle)
                    TextField("內容", text: $todoIntroduction)
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
                        DatePicker("選擇時間", selection: $startDateTime, displayedComponents: [.date])
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
                        DatePicker("提醒時間", selection: $reminderTime, displayedComponents: [.hourAndMinute])
                    }
                }
                
                Section {
                    HStack {
                        Menu {
                            ForEach(timeUnits, id: \.self) { unit in
                                Button(action: {
                                    selectedTimeUnit = unit
                                }) {
                                    Text(unit)
                                }
                            }
                        } label: {
                            Text(selectedTimeUnit)
                                .padding(.trailing)
                        }
                        
                        Spacer()
                        
                        TextField("輸入數值", value: $studyValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 80, alignment: .center)
                        
                        Picker("選擇單位", selection: $studyUnit) {
                            ForEach(studyUnits, id: \.self) { unit in
                                Text(unit)
                                    .font(.system(size: 12))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150, alignment: .trailing)
                        
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120, alignment: .trailing)
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        
                        Picker("週期", selection: $recurringOption) {
                            Text("一直重複").tag(1)
                            Text("週期結束時間").tag(2)
                        }
                    }
                    
                    if recurringOption == 2 {
                        DatePicker("結束重複日期", selection: $recurringEndDate, displayedComponents: [.date])
                    }
                }
                TextField("備註", text: $todoNote)
            }
            .navigationBarTitle("一般學習")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成", action: addTodo)
                .disabled(todoTitle.isEmpty && todoIntroduction.isEmpty)
            )
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter.string(from: date)
    }
    
    func addTodo() {
//        GraduationProjectApp.phpUrl(php: "addStudyGeneral", type: "addTask")
//        phpUrl(php: "StudySpaceList",type: "list")
        
        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }
        
        let url = URL(string: "http://172.20.10.3:8888/addTask/addStudyGeneral.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var body: [String: Any] = [
            "label": label,
            "todoTitle": todoTitle,
            "todoIntroduction": todoIntroduction,
            "startDateTime": formattedDate(startDateTime),
            "studyValue": studyValue,
            "reminderTime": formattedTime(reminderTime),
            "todoNote": todoNote
        ]
        if studyUnit == "小時" {
            body["studyUnit"] = 0
        } else if studyUnit == "次" {
            body["studyUnit"] = 1
        }
        if selectedTimeUnit == "每日" {
            body["frequency"] = 1
        } else if selectedTimeUnit == "每週" {
            body["frequency"] = 2
        } else if selectedTimeUnit == "每月" {
            body["frequency"] = 3
        }

        
            if recurringOption == 1 {
                // 持續重複
                body["dueDateTime"] = formattedDate(Calendar.current.date(byAdding: .year, value: 5, to: recurringEndDate)!)
            } else {
                // 選擇結束日期
                body["dueDateTime"] = formattedDate(recurringEndDate)
            }
      
        
        print("AddTodoView - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("AddTodoView - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("AddTodoView - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print("AddTodoView - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User New StudyGeneral successfullyUser New first RecurringInstance successfully" || todoData.message == "User New StudyGeneral successfully") {
                        print("============== AddTodoView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addStudySpaced - userDate:\(todoData)")
                        print("使用者ID為：\(todoData.userId ?? "N/A")")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.category_id)")
                        print("事件名稱為：\(todoData.todoTitle)")
                        print("事件簡介為：\(todoData.todoIntroduction)")
                        print("事件種類為：\(todoData.label ?? "N/A")")
                        print("事件狀態為：\(todoData.todoStatus)")
                        print("開始時間為：\(todoData.startDateTime)")
                        print("運動目標量為：\(todoData.studyValue)")
                        print("運動目標單位為：\(todoData.studyUnit)")
                        print("提醒時間為：\(todoData.reminderTime)")
                        print("截止日期為：\(todoData.dueDateTime)")
                        print("事件備註：\(todoData.todoNote ?? "N/A")")
                        print("事件編號為：\(todoData.todo_id)")
                        print("AddTodoView - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            var todo: Todo?
                            todo = Todo(id: Int(exactly: todoData.todo_id)!,
                                        label: label,
                                        title: todoTitle,
                                        description: todoIntroduction,
                                        startDateTime: startDateTime,
                                        studyValue: studyValue,
                                        studyUnit: studyUnit,
                                        recurringUnit: selectedTimeUnit,
                                        recurringOption: recurringOption,
                                        todoStatus: todoStatus,
                                        dueDateTime: recurringEndDate,
                                        reminderTime: reminderTime,
                                        todoNote: todoNote)
                            if let unwrappedTodo = todo {  // 使用可選綁定來解封 'todo'
                                todoStore.todos.append(unwrappedTodo)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        print("============== AddTodoView ==============")
                    }  else {
                        isError = true
                        print("AddTodoView - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"                    }
                } catch {
                    isError = true
                    print("AddTodoView - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
        }
        .resume()
    }
}

struct AddStudyView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudyView()
            .environmentObject(TodoStore())
    }
}
