//
//  TaskCompletionIndicatorCardView.swift
//  GraduationProject
//
//  Created by heonrim on 8/28/23.
//

import SwiftUI

struct TaskCompletionIndicatorCardView: View {
    @State private var selectedIndicator: TimeFrame = .week
    @ObservedObject var viewModel: TaskCompletionViewModel = TaskCompletionViewModel()

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("任務完成指標")
                    .font(.headline)
                
                Picker("選擇時間指標", selection: $selectedIndicator) {
                    ForEach(TimeFrame.allCases, id: \.self) { frame in
                        Text(frame.rawValue).tag(frame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                let completionPercentage = viewModel.completionPercentage(for: selectedIndicator, date: Date())
                
                ProgressView(value: completionPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text("\(Int(completionPercentage * 100))% 已完成")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cardStyle()
        }
    }
}

struct TaskCompletionIndicatorCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCompletionIndicatorCardView()
    }
}
