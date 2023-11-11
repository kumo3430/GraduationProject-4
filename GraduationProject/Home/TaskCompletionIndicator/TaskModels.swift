//
//  TaskModels.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/14.
//

import Foundation

enum ViewingMode: String, CaseIterable {
    case byTime = "依照時間"
    case byEvent = "依照事件"
}

enum EventType: String, CaseIterable {
    case generalLearning = "一般學習"
    case intervalLearning = "間隔學習"
    case exercise = "運動"
    case routine = "作息"
    case diet = "飲食"
}

struct TaskInfo: Identifiable {
    var id = UUID()  // Add this line
    var title: String
    var date: Date
    var completedTasks: Int
    var totalTasks: Int
    var eventName: EventType
}
