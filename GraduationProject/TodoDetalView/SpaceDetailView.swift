//
//  TodoDetailView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct SpaceDetailView: View {
    //@State var task: Task
    @Binding var task: Task
    //@State var isReviewChecked: [Bool] = Array(repeating: false, count: 4)
    @Environment(\.presentationMode) var presentationMode
    @State var title = ""
    @State var description = ""
    @State var nextReviewTime = Date()
    @State var repetition1Status:Int = 0
    @State var repetition2Status:Int = 0
    @State var repetition3Status:Int = 0
    @State var repetition4Status:Int = 0
    @State var message = ""
    @State var isError = false
//    struct reviseUserData : Decodable {
//        var userId: String?
//        var category_id: Int
//        var todoTitle: String
//        var todoIntroduction: String
//        //        var startDateTime: String
//        var reminderTime: String
//        var todo_id: Int
//        //        var repetition1Count: String
//        var repetition1Status: Int
//        //        var repetition2Count: String
//        var repetition2Status: Int
//        //        var repetition3Count: String
//        var repetition3Status: Int
//        //        var repetition4Count: String
//        var repetition4Status: Int
//        var message: String
//    }
    
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
                
//                Section(header: Text("間隔學習法日程表")) {
//                    VStack {
//                        HStack{
//                            Toggle(isOn: $task.isReviewChecked0) {
//                                Text("第\(formattedInterval(0))天： \(formattedDate(nextReviewDates[0]))")
//                            }
//                            .onChange(of: task.isReviewChecked0) { newValue in
//                                task.isReviewChecked0 = newValue
//                                print("New ReviewChecked0 : \(task.isReviewChecked0)")
//                            }
//                        }
//                        HStack{
//                            Toggle(isOn: $task.isReviewChecked1) {
//                                Text("第\(formattedInterval(1))天： \(formattedDate(nextReviewDates[1]))")
//                            }
//                            .onChange(of: task.isReviewChecked1) { newValue in
//                                task.isReviewChecked1 = newValue
//                                print("New ReviewChecked1 : \(task.isReviewChecked1)")
//                            }
//                        }
//                        HStack{
//                            Toggle(isOn: $task.isReviewChecked2) {
//                                Text("第\(formattedInterval(2))天： \(formattedDate(nextReviewDates[2]))")
//                            }
//                            .onChange(of: task.isReviewChecked2) { newValue in
//                                task.isReviewChecked2 = newValue
//                                print("New ReviewChecked2 : \(task.isReviewChecked2)")
//                            }
//                        }
//                        HStack{
//                            Toggle(isOn: $task.isReviewChecked3) {
//                                Text("第\(formattedInterval(3))天： \(formattedDate(nextReviewDates[3]))")
//                            }
//                            .onChange(of: task.isReviewChecked3) { newValue in
//                                task.isReviewChecked3 = newValue
//                                print("New ReviewChecked3 : \( task.isReviewChecked3)")
//                            }
//                        }
//                    }
//                }
                //                Text(messenge)
                //                    .foregroundColor(.red)
            }
            Text(message)
                .foregroundColor(.red)
                .navigationTitle("間隔學習修改")
                .navigationBarItems(
                    trailing: Button("完成", action: reviseStudySpaced)
                )
        }
        .onAppear() {
            task.title = task.title
            task.description = task.description
            task.nextReviewTime = task.nextReviewTime
//            task.isReviewChecked0 = task.isReviewChecked0
//            task.isReviewChecked1 = task.isReviewChecked1
//            task.isReviewChecked2 = task.isReviewChecked2
//            task.isReviewChecked3 = task.isReviewChecked3
        }
        //        .navigationBarTitle("任務")
        //        .navigationTitle("任務")
        //        .navigationBarItems(
        //            trailing: Button("完成", action: reviseStudySpaced)
        //        )
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
    
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    //    func handleCompletion() {
    //        // Handle the completion action here
    //        task = Task(id: task.id,title: task.title, description: task.description, nextReviewDate: task.nextReviewDate, nextReviewTime: task.nextReviewTime, isReviewChecked0: task.isReviewChecked0, isReviewChecked1:  task.isReviewChecked1, isReviewChecked2: task.isReviewChecked2, isReviewChecked3:  task.isReviewChecked3 )
    //        presentationMode.wrappedValue.dismiss()
    //    }
    
    func reviseStudySpaced() {
        if ( task.isReviewChecked0 ) {
            repetition1Status = 1
        } else {
            repetition1Status = 0
        }
        if ( task.isReviewChecked1 ) {
            repetition2Status = 1
        } else {
            repetition2Status = 0
        }
        if ( task.isReviewChecked2 ) {
            repetition3Status = 1
        } else {
            repetition3Status = 0
        }
        if ( task.isReviewChecked3 ) {
            repetition4Status = 1
        } else {
            repetition4Status = 0
        }
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
        let url = URL(string: "http://127.0.0.1:8888/reviseTask/reviseSpace.php")!
//        let url = URL(string: "http://127.0.0.1:8888/reviseTask/reviseStudySpaced.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/register.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
//        let body = ["id":  task.id,"title": task.title, "description": task.description,"nextReviewTime": formattedTime(task.nextReviewTime),"repetition1Status": repetition1Status,"repetition2Status":repetition2Status,"repetition3Status": repetition3Status,"repetition4Status": repetition4Status ] as [String : Any]
        let body = [ "id": task.id,
                     "label": task.label,
                     "reminderTime": formattedTime(task.nextReviewTime)] as [String : Any]
        print("reviseStudySpaced - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("reviseStudySpaced - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("reviseStudySpaced - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    //                    確認api會印出的所有內容
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(reviseUserData.self, from: data)
                    if (userData.message == "User revise Space successfully") {
                        print("============== verifyView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("reviseStudySpaced - userDate:\(userData)")
//                        print("使用者ID為：\(userData.userId ?? "N/A")")
//                        print("事件id為：\(userData.todo_id)")
//                        print("事件種類為：\(userData.category_id)")
//                        print("事件名稱為：\(userData.todoTitle)")
//                        print("事件簡介為：\(userData.todoIntroduction)")
//                        //                        print("開始時間為：\(userData.startDateTime)")
//                        print("提醒時間為：\(userData.reminderTime)")
//                        print("事件編號為：\(userData.todo_id)")
//                        //                        print("第一次間隔重複時間為：\(userData.repetition1Count)")
//                        print("第一次間隔重複狀態為：\(userData.repetition1Status)")
//                        //                        print("第二次間隔重複時間為：\(userData.repetition2Count)")
//                        print("第二次間隔重複狀態為：\(userData.repetition2Status)")
//                        //                        print("第三次間隔重複時間為：\(userData.repetition3Count)")
//                        print("第三次間隔重複狀態為：\(userData.repetition3Status)")
//                        //                        print("第四次間隔重複時間為：\(userData.repetition4Count)")
//                        print("第四次間隔重複狀態為：\(userData.repetition4Status)")
                        print("事件id為：\(userData.todo_id)")
                        print("事件種類為：\(userData.label)")
                        print("提醒時間為：\(userData.reminderTime)")
                        print("reviseStudySpaced - message：\(userData.message)")
                        DispatchQueue.main.async {
                            isError = false
                            // 如果沒有錯才可以關閉視窗並且把此次東西暫存起來
                            //                            task = Task(id: task.id,title: task.title, description: task.description, nextReviewDate: task.nextReviewDate, nextReviewTime: task.nextReviewTime, isReviewChecked0: task.isReviewChecked0, isReviewChecked1:  task.isReviewChecked1, isReviewChecked2: task.isReviewChecked2, isReviewChecked3:  task.isReviewChecked3 )
                            task = Task(id: task.id, label: task.label,title: task.title, description: task.description, nextReviewDate: task.nextReviewDate, nextReviewTime: task.nextReviewTime,repetition1Count: task.repetition1Count,repetition2Count: task.repetition2Count,repetition3Count: task.repetition3Count,repetition4Count: task.repetition4Count, isReviewChecked0: task.isReviewChecked0, isReviewChecked1:  task.isReviewChecked1, isReviewChecked2: task.isReviewChecked2, isReviewChecked3:  task.isReviewChecked3 )
                            presentationMode.wrappedValue.dismiss()
                        }
                        print("============== verifyView ==============")
                    } else  {
                        isError = true
                        print("reviseStudySpaced - message：\(userData.message)")
                        message = "修改失敗，請重新建立"
                    }
                } catch {
                    isError = true
                    print("reviseStudySpaced - 解碼失敗：\(error)")
                    message = "修改失敗，請重新建立"
                }
            }
        }
        .resume()
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
