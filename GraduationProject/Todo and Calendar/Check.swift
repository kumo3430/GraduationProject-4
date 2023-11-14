//
//  Check.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/18.
//

import Foundation

func TrackingFirstDay(id: Int, completion: @escaping (Date, Int) -> Void) {
    let body = ["id": id] as [String : Any]
    phpUrl(php: "TrackingFirstDay" ,type: "Tracking",body:body,store: nil) { message in
        for (key, value) in message {
            if let selectedDate = convertToDate(key), let Instance_id = Int(value) {
                completion(selectedDate, Instance_id)
            }
            
        }
    }
}


func RecurringCheckList(id: Int,targetvalue:Float,store:(any ObservableObject)? = nil,completion: @escaping ([String:String]) -> Void) {
    let body = ["id": id,"targetvalue": targetvalue] as [String : Any]
    phpUrl(php: "RecurringCheckList", type: "Tracking", body: body, store: store) { message in
        completion(message)
    }
}

func handleTrackingFirstDay(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(FirstDay.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            let selectedDate = userData.RecurringStartDate
            let Instance_id = String(userData.id)
            completion([selectedDate:Instance_id])
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}

func handleRecurringCheckList(data: Data,store: CompletionRatesViewModel, messageType: Message, completion: @escaping ([String: String]) -> Void) {
    handleDecodableData(CheckList.self, data: data) { userData in
        print("\(messageType.rawValue) - userDate:\(userData)")
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            store.clearTodos()

            let completeValue = userData.completeValue.compactMap { (Double($0) ?? 0)/(Double(userData.targetvalue) ?? 0) }
            let checkDate = userData.checkDate.compactMap { $0 }
            // 使用 zip 将两个数组合并成元组的数组
            if completeValue.count == checkDate.count {
                // 使用 zip 函数将两个数组合并为元组数组

                let combinedArray = Array(zip(checkDate, completeValue))
                // 使用 Dictionary(uniqueKeysWithValues:) 创建字典
//                let combinedDictionary = Dictionary(uniqueKeysWithValues: combinedArray)
                
//                let combinedDictionary = Dictionary(combinedArray, uniquingKeysWith: { (current, new) in
//                    current + new
//                })
                store.completionRates = Dictionary(combinedArray, uniquingKeysWith: { (current, new) in
                    current + new
                })
                // 打印合并后的字典
//                print(combinedDictionary)
//                completion(combinedDictionary)
            } else {
                print("两个数组的元素数量不一致")
            }
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message": userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}
