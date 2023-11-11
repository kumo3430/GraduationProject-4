//
//  HabitTrackingIndicatorView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/20.
//
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum TaskFilter: String, CaseIterable {
    case all = "全部"
    case generalLearning = "一般學習"
    case intervalLearning = "間隔學習"
    case exercise = "運動"
    case diet = "飲食"
    case routine = "作息"
}

enum IndicatorType: String, CaseIterable {
    case week = "週"
    case month = "月"
    case year = "年"
}

struct HabitTask: Identifiable {
    let id = UUID()
    let name: String
}

struct HabitTrackingIndicatorView: View {
    @State private var selectedFilter = TaskFilter.all
    @State private var tasks: [HabitTask] = [
        HabitTask(name: "背英文單字"),
        HabitTask(name: "游泳"),
        HabitTask(name: "減糖")
    ]
    @State private var selectedTask: HabitTask?

    var body: some View {
        VStack {
            Text("習慣追蹤指標")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#6B6B6B"))
                .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TaskFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            self.selectedFilter = filter
                        }) {
                            Text(filter.rawValue)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(self.selectedFilter == filter ? Color(hex: "#3B82F6") : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(self.selectedFilter == filter ? .white : Color(hex: "#6B6B6B").opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)


            ScrollView {
                            LazyVStack(spacing: 20) { // 增加顶部间距
                                ForEach(tasks) { task in
                                    Button(action: {
                                        selectedTask = task
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Color(hex: "#91A3B0"))
                                                .padding([.leading, .trailing], 15) // 增加左右间距
                                            
                                            Text(task.name)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(hex: "#6B6B6B"))
                                                .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .sheet(item: $selectedTask) { task in
                                        TaskDetailView(task: task, taskName: task.name)
                                    }
                                }
                            }
                            .padding() // 统一增加四周间距
                        }
                        .background(Color(hex: "#EFEFEF").edgesIgnoringSafeArea(.all))
                        .cornerRadius(10)

                        Spacer()

        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
}

struct TaskDetailView: View {
    var task: HabitTask
    var taskName: String
    @State private var selectedIndicator = IndicatorType.week

    var body: some View {
        VStack(spacing: 20) {
            Text(taskName)
                .font(.system(size: 30, weight: .semibold, design: .default))
                .foregroundColor(Color(hex: "#4A4A4A"))
                .padding(.top, 20)

            Picker("Indicator", selection: $selectedIndicator) {
                ForEach(IndicatorType.allCases, id: \.self) { indicator in
                    Text(indicator.rawValue).tag(indicator)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            .background(Color(hex: "#EFEFEF"))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)

            Group {
                if selectedIndicator == .week {
                    EnhancedWeekReportView(task: task)
                } else if selectedIndicator == .month {
                    EnhancedMonthReportView(task: task)
                } else if selectedIndicator == .year {
                    YearIndicatorView(task: task)
                }
            }
            .transition(.slide)

            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
}

extension DateFormatter {
    static let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月d日"
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()

    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        formatter.dateFormat = "YYYY年MM月"
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()
    
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年"
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter
    }()
    
    static let fullDateWithTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設置時區為台北標準時間
        return formatter
    }()
}


struct EnhancedWeekReportView: View {
    let task: HabitTask
    @State private var selectedDate = Date()

    var completionRates: [String: Double] {
        let rates = [
            "2023-10-02": 0.5,
            "2023-10-03": 0.7,
            "2023-10-04": 1.0,
        ]
        return rates
    }

    var datesOfWeek: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                    print("Selected week starting from: \(DateFormatter.fullDateWithTimeZone.string(from: selectedDate))")
                }) {
                    Image(systemName: "arrow.left")
                }
                Spacer()

                let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
                let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
                Text("\(startOfWeek, formatter: DateFormatter.weekFormatter) - \(endOfWeek, formatter: DateFormatter.weekFormatter)")
                    .font(.headline)
                    .onTapGesture {
                        selectedDate = Date()
                    }

                Spacer()

                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(datesOfWeek, id: \.self) { date in
                        let formattedDate = DateFormatter.dateOnlyFormatter.string(from: date)
                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)

                            Spacer()

                            ProgressBar(value: completionRates[formattedDate] ?? 0)
                                .frame(width: 235, height: 20)
                                .animation(.easeInOut(duration: 1.0))
                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                .padding(5)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}

struct EnhancedMonthReportView: View {
    let task: HabitTask
    @State private var selectedDate = Date()

    var completionRates: [String: Double] {
        let rates = [
            "2023-10-01": 0.5,
            "2023-10-02": 0.7,
            "2023-10-03": 1.0,
        ]
        return rates
    }

    var datesOfMonth: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)

        guard let startOfMonth = calendar.date(from: components),
              let rangeOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth) else { return dates }

        for day in rangeOfMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }
        return dates
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.left")
                }

                Spacer()

                Text("\(selectedDate, formatter: DateFormatter.monthFormatter)")
                    .font(.headline)
                    .onTapGesture {
                        selectedDate = Date()
                    }

                Spacer()

                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(datesOfMonth, id: \.self) { date in
                        let formattedDate = DateFormatter.dateOnlyFormatter.string(from: date)
                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)

                            Spacer()

                            ProgressBar(value: completionRates[formattedDate] ?? 0)
                                .frame(width: 235, height: 20)
                                .animation(.easeInOut(duration: 1.0))
                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                .padding(5)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}

struct YearIndicatorView: View {
    let task: HabitTask
    @State private var selectedDate = Date()

    var completionRates: [String: [Double]] {
        let rates = [
            "2023": [0.5, 0.7, 1.0, 0.4, 0.8, 0.6, 0.9, 0.3, 0.6, 0.8, 0.5, 0.7]
        ]
        return rates
    }

    let months = [
        "一月", "二月", "三月", "四月",
        "五月", "六月", "七月", "八月",
        "九月", "十月", "十一月", "十二月"
    ]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 减少一年
                    selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.left")
                }

                Spacer()

                Text("\(selectedDate, formatter: DateFormatter.yearFormatter)") // 使用新的年份格式化器
                    .font(.headline)
                    .onTapGesture {
                        // 点击时返回当前年
                        selectedDate = Date()
                    }

                Spacer()

                Button(action: {
                    // 增加一年
                    selectedDate = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()

            ScrollView {
                VStack(spacing: 10) {
                    let yearString = DateFormatter.dateOnlyFormatter.string(from: selectedDate).prefix(4)
                    let rates = completionRates[String(yearString)] ?? Array(repeating: 0.0, count: 12)
                    ForEach(0..<rates.count) { index in
                        HStack {
                            Text(months[index])
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)

                            Spacer()

                            ProgressBar(value: rates[index])
                                .frame(width: 235, height: 20)
                                .animation(.easeInOut(duration: 1.0))
                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                .padding(5)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}

struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(hex: "#E0E0E0"))
                    .cornerRadius(5)

                Rectangle()
                    .fill(Color(hex: "#91A3B0"))
                    .cornerRadius(5)
                    .frame(width: geometry.size.width * CGFloat(value))
            }
        }
        .overlay(
            Text("\(Int(value * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "#6B6B6B"))
        )
    }
}

struct HabitTrackingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackingIndicatorView()
    }
}
