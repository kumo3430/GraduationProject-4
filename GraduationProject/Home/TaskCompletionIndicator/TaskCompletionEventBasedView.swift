//
//  TaskCompletionEventBasedView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/14.
//

import SwiftUI

struct TaskCompletionEventBasedView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: TaskCompletionViewModel

    var body: some View {
        VStack(spacing: 20) {
            Picker("選擇事件類型", selection: $viewModel.selectedEventType) {
                ForEach(EventType.allCases, id: \.self) { event in
                    Text(event.rawValue).tag(event)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)

            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 12)
                    .frame(width: 180, height: 180)

                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.completionPercentageForEvent(event: viewModel.selectedEventType, date: selectedDate)))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 180, height: 180)
                    .rotationEffect(Angle(degrees: -90))

                Text("\(Int(viewModel.completionPercentageForEvent(event: viewModel.selectedEventType, date: selectedDate) * 100))%")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(Color.blue)
            }
            .animation(.easeInOut)
            
            VStack(alignment: .leading, spacing: 15) {
                let data = viewModel.breakdownForEvent(event: viewModel.selectedEventType, date: selectedDate)

                ForEach(data.keys.sorted(), id: \.self) { key in
                    if let value = data[key] {
                        HStack {
                            Text(key)
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                            ProgressView(value: value)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                                .frame(width: 150, height: 8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                            Text("\(Int(value * 100))%")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TaskCompletionEventBasedView_Previews: PreviewProvider {
    static var previews: some View {
        // Create dummy data for the preview
        let sampleDate = Date()
        let viewModel = TaskCompletionViewModel()
        
        TaskCompletionEventBasedView(selectedDate: .constant(sampleDate), viewModel: viewModel)
    }
}
