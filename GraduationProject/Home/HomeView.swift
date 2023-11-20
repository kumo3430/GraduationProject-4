//
//  HomeView.swift
//  GraduationProject
//
//  Created by heonrim on 8/3/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @EnvironmentObject var tickerStore: TickerStore
    @EnvironmentObject var communityStore: CommunityStore
    @State private var showQuoteView: Bool = false
    @Binding var tabBarHidden: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    NavigationLink(destination: QuoteView()) {
                        QuoteCardView().cardStyle()
                    }.clearNavigationLinkStyle()
                    
                    NavigationLink(destination: TodayTasksView()) {
                        TodayTodoCardView()
                            .cardStyle()
                    }
                    .clearNavigationLinkStyle()
                    
                    NavigationLink(destination: HabitTrackingIndicatorView()) {
                        HabitTrackingIndicatorCardView()
                            .cardStyle()
                    }
                    .clearNavigationLinkStyle()
                    
                    NavigationLink(destination: AchievementsPageView()) {
                        AchievementCardView(achievement: Achievement(title: "首次之旅", description: "第一次添加習慣", achieved: true, imageName: "plus.circle.fill"))
                            .cardStyle()
                    }
                    .clearNavigationLinkStyle()
                    
                    
                    let sampleActivities = [
                        CommunityActivity(userName: "王小明", groupName: "學習小組", habitCategory: "學習", timeFrame: "今日"),
                        CommunityActivity(userName: "李小花", groupName: "運動俱樂部", habitCategory: "運動", timeFrame: "本週"),
                        // ... 可以添加更多假資料
                    ]

                    CommunityCardScrollView(activities: sampleActivities)

                }
                .padding()
            }
            .background(
                ZStack {
                    LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                    
                    GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                    }
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) { offset in
                if offset > 10 && !tabBarHidden {
                    withAnimation {
                        tabBarHidden = true
                    }
                } else if offset < 10 && tabBarHidden {
                    withAnimation {
                        tabBarHidden = false
                    }
                }
            }
        }
        .onChange(of: tabBarHidden) { newValue in
            print("TabBar hidden status: \(newValue)")
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension View {
    func cardStyle() -> some View {
        self.padding(.all, 5)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(0.3))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .foregroundColor(.black)
            )
    }
}

struct ClearNavigationLinkStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black) // Or any color of your choice
    }
}

extension View {
    func clearNavigationLinkStyle() -> some View {
        modifier(ClearNavigationLinkStyle())
    }
}


struct HomeView_Previews: PreviewProvider {
    @State static var mockTabBarHidden = false
    
    static var previews: some View {
        NavigationView {
            HomeView(tabBarHidden: $mockTabBarHidden)
                .environmentObject(TaskStore())
                .environmentObject(TodoStore())
        }
    }
}
