//
//  List.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/29.
//

import Foundation

func handleStudySpaceList(data: Data,store: TaskStore) {
    handleDecodableData(TaskData.self, data: data) { userData in
        for index in userData.todoTitle.indices {
            let ReviewChecked0: Bool
            let ReviewChecked1: Bool
            let ReviewChecked2: Bool
            let ReviewChecked3: Bool
            if let startDate = convertToDate(userData.startDateTime[index]),
               let repetition1Count = convertToDate(userData.repetition1Count[index]),
               let repetition2Count = convertToDate(userData.repetition2Count[index]),
               let repetition3Count = convertToDate(userData.repetition3Count[index]),
               let repetition4Count = convertToDate(userData.repetition4Count[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                if (userData.repetition1Status[index] == "0" ){
                    ReviewChecked0 = false
                } else {
                    ReviewChecked0 = true
                }
                if (userData.repetition2Status[index] == "0" ){
                    ReviewChecked1 = false
                } else {
                    ReviewChecked1 = true
                }
                if (userData.repetition3Status[index] == "0" ){
                    ReviewChecked2 = false
                } else {
                    ReviewChecked2 = true
                }
                if (userData.repetition4Status[index] == "0" ){
                    ReviewChecked3 = false
                } else {
                    ReviewChecked3 = true
                }
                let taskId = Int(userData.todo_id[index])
                let task = Task(id: taskId!,label: userData.todoLabel[index]!, title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                DispatchQueue.main.async {
                    store.tasks.append(task)

                }
            } else {
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        }
    }
}

func handleStudyGeneralList(data: Data, store: TodoStore) {
    handleDecodableData(TodoData.self, data: data) { userData in
        for index in userData.todoTitle.indices {
            var todoStatus: Bool = false
            var recurringOption: Int = 0
            var recurringUnit: String = ""
            var studyUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
                if let yearsDifference = components.year, yearsDifference >= 5 {
                    recurringOption = 2
                } else {
                    recurringOption = 1
                }
                if (userData.frequency[index] == "1" ){
                    recurringUnit = "每日"
                } else  if (userData.frequency[index] == "2" ) {
                    recurringUnit = "每週"
                } else  if (userData.frequency[index] == "3" ) {
                    recurringUnit = "每月"
                }
                if (userData.studyUnit[index] == "0" ){
                    studyUnit = "小時"
                } else  if (userData.studyUnit[index] == "1" ) {
                    studyUnit = "次"
                }
                if (userData.todoStatus[index] == "0" ){
                    todoStatus = false
                } else {
                    todoStatus = true
                }

                let taskId = Int(userData.todo_id[index])
                let todo = Todo(id: taskId!,
                                label: userData.todoLabel[index]!,
                                title: userData.todoTitle[index],
                                description: userData.todoIntroduction[index],
                                startDateTime: startDate,
                                studyValue:  Float(userData.studyValue[index])!,
                                studyUnit: studyUnit,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,

                                todoStatus: todoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index])
                DispatchQueue.main.async {
                    store.todos.append(todo)

                }
            } else {
                print("StudyGeneralList - 日期或時間轉換失敗")
            }
        }
    }
}

func handleSportList(data: Data,store: SportStore) {
    handleDecodableData(SportData.self, data: data) { userData in
        for index in userData.todoTitle.indices {
            var todoStatus: Bool = false
            var recurringOption: Int = 0
            var recurringUnit: String = ""
            var sportUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
                if let yearsDifference = components.year, yearsDifference >= 5 {
                    recurringOption = 2
                } else {
                    recurringOption = 1
                }
                if (userData.frequency[index] == "1" ){
                    recurringUnit = "每日"
                } else  if (userData.frequency[index] == "2" ) {
                    recurringUnit = "每週"
                } else  if (userData.frequency[index] == "3" ) {
                    recurringUnit = "每月"
                }
                if (userData.sportUnit[index] == "0" ){
                    sportUnit = "小時"
                } else  if (userData.sportUnit[index] == "1" ) {
                    sportUnit = "次"
                } else  if (userData.sportUnit[index] == "2" ) {
                    sportUnit = "卡路里"
                }

                if (userData.todoStatus[index] == "0" ){
                    todoStatus = false
                } else {
                    todoStatus = true
                }

                let taskId = Int(userData.todo_id[index])
                let sport = Sport(id: taskId!,
                                label: userData.todoLabel[index]!,
                                title: userData.todoTitle[index],
                                description: userData.todoIntroduction[index],
                                startDateTime: startDate,
                                selectedSport: userData.sportType[index],
                                  sportValue:  Float(userData.sportValue[index])!,
                                sportUnits: sportUnit,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: todoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index])
                DispatchQueue.main.async {
                    store.sports.append(sport)

                }
            } else {
                print("SportList - 日期或時間轉換失敗")
            }
        }
    }
}

func handleDietList(data: Data,store: DietStore) {
    handleDecodableData(DietData.self, data: data) { userData in
        for index in userData.todoTitle.indices {
            var todoStatus: Bool = false
            var recurringOption: Int = 0
            var recurringUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
                if let yearsDifference = components.year, yearsDifference >= 5 {
                    recurringOption = 2
                } else {
                    recurringOption = 1
                }

                if (userData.frequency[index] == "1" ){
                    recurringUnit = "每日"
                } else  if (userData.frequency[index] == "2" ) {
                    recurringUnit = "每週"
                } else  if (userData.frequency[index] == "3" ) {
                    recurringUnit = "每月"
                }

                if (userData.todoStatus[index] == "0" ){
                    todoStatus = false
                } else {
                    todoStatus = true
                }

                let taskId = Int(userData.todo_id[index])
                let diet = Diet(id: taskId!,
                                label: userData.todoLabel[index]!,
                                title: userData.todoTitle[index],
                                description: userData.todoIntroduction[index],
                                startDateTime: startDate,
                                selectedDiets: userData.dietsType[index],
                                dietsValue: Int(userData.dietsValue[index])!,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: todoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index])
                DispatchQueue.main.async {
                    store.diets.append(diet)

                }
            } else {
                print("DietList - 日期或時間轉換失敗")
            }
        }
    }
}

func handletickersList(data: Data,store: TickerStore) {
    handleDecodableData(TickerData.self, data: data) { userData in
        for index in userData.ticker_id.indices {
            if let deadline = convertToDateTime(userData.deadline[index]) {
                //var exchange: Date?  // 聲明 exchange 變數
                var exchange: String?
                if userData.exchange[index] == nil {
                    //exchange = nil  // 不需要賦值，因為 exchange 變數已經初始化為 nil
                    exchange = "尚未兌換"
                } else {
                    exchange = (userData.exchange[index]!)
                }
                let taskId = userData.ticker_id[index]
                let task = Ticker(id: taskId, name: userData.name[index], deadline: deadline, exchage: exchange!)

                DispatchQueue.main.async {
                    store.tickers.append(task)
                }
            } else {
                print("TickerList - 尚未兌換")
            }
        }
    }
}
