//
//  WeeklyReportView_Previews.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/19.
//

import SwiftUI

struct WeeklyReportView: View {
    @ObservedObject var viewModel: TaskCompletionViewModel
    
    var body: some View {
        List(viewModel.tasks) { task in
            HStack {
                Text(task.title)
                Spacer()
                ForEach(0..<7) { day in
                    // 這是完成指標的占位符。
                    // 您可能希望用更詳細的視圖替換它。
                    Rectangle()
                        .fill(completionColor(for: task, on: day))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("\(completionPercentage(for: task, on: day))%")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                }
                Text("摘要: \(weeklySummary(for: task))%")
            }
        }
    }
    
    // 用於確定顏色和百分比的占位符函數
    func completionColor(for task: TaskInfo, on day: Int) -> Color {
        // 根據完成狀態確定顏色的邏輯
        return .green
    }
    
    func completionPercentage(for task: TaskInfo, on day: Int) -> Int {
        // 獲取特定天的任務完成百分比的邏輯
        return 100
    }
    
    func weeklySummary(for task: TaskInfo) -> Int {
        let totalPercentage = (0..<7).reduce(0) { total, day in
            total + completionPercentage(for: task, on: day)
        }
        return totalPercentage / 7
    }

}

struct WeeklyReportView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyReportView(viewModel: TaskCompletionViewModel())
    }
}
