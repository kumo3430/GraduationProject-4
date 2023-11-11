//
//  TaskCompletionTimeBasedView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/14.
//

import SwiftUI

struct TaskCompletionTimeBasedView: View {
    @Binding var selectedTimeFrame: TimeFrame
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: TaskCompletionViewModel
    
    let orderedWeekdays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
    
    var currentKeys: [String] {
        switch selectedTimeFrame {
        case .week:
            return orderedWeekdays
        case .month:
            return ["第一週", "第二週", "第三週", "第四週"]
        case .year:
            return ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        }
    }
    
    var dateRangeForIndicator: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch selectedTimeFrame {
        case .week:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
        case .month:
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
            let endOfMonth = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!)!
            return "\(formatter.string(from: startOfMonth)) - \(formatter.string(from: endOfMonth))"
        case .year:
            let startOfYear = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: selectedDate))!
            let endOfYear = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .year, value: 1, to: startOfYear)!)!
            return "\(formatter.string(from: startOfYear)) - \(formatter.string(from: endOfYear))"
        }
    }
    
    func dateRange(for date: Date, in timeFrame: TimeFrame) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch timeFrame {
        case .week:
            let startOfWeek = Calendar.current.startOfWeek(for: date)
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
        case .month:
            let startOfMonth = Calendar.current.startOfMonth(for: date)
            let endOfMonth = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!)!
            return "\(formatter.string(from: startOfMonth)) - \(formatter.string(from: endOfMonth))"
        case .year:
            let startOfYear = Calendar.current.startOfYear(for: date)
            let endOfYear = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .year, value: 1, to: startOfYear)!)!
            return "\(formatter.string(from: startOfYear)) - \(formatter.string(from: endOfYear))"
        }
    }

    var body: some View {
        
        VStack(spacing: 20) {
            Picker("選擇時間指標", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases, id: \.self) { frame in
                    Text(frame.rawValue).tag(frame)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            
            HStack {
                Button(action: {
                    switch selectedTimeFrame {
                    case .week:
                        selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                    case .month:
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                    case .year:
                        selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .padding(.horizontal, 10)
                }
                
                Text(dateRange(for: selectedDate, in: selectedTimeFrame))
                    .font(.headline)
                
                Button(action: {
                    switch selectedTimeFrame {
                    case .week:
                        selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                    case .month:
                        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                    case .year:
                        selectedDate = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .padding(.horizontal, 10)
                }
            }
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 12)
                    .frame(width: 180, height: 180)
                
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.completionPercentage(for: selectedTimeFrame, date: selectedDate)))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 180, height: 180)
                    .rotationEffect(Angle(degrees: -90))
                
                Text("\(Int(viewModel.completionPercentage(for: selectedTimeFrame, date: selectedDate) * 100))%")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(Color.blue)
            }
            .animation(.easeInOut)
            
            VStack(alignment: .leading, spacing: 15) {
                let data = viewModel.breakdown(for: selectedTimeFrame, date: selectedDate)
                
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

struct TaskCompletionTimeBasedView_Previews: PreviewProvider {
    static var previews: some View {
        // Added mock data for the preview
        let viewModel = TaskCompletionViewModel()
        TaskCompletionTimeBasedView(selectedTimeFrame: .constant(.week), selectedDate: .constant(Date()), viewModel: viewModel)
    }
}
