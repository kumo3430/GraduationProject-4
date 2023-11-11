//
//  SpacedView.swift
//  SpacedRepetition
//
//  Created by heonrim on 5/1/23.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @AppStorage("uid") private var uid: String = ""
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var hasLoadedData = false
    @State var ReviewChecked0: Bool
    @State var ReviewChecked1: Bool
    @State var ReviewChecked2: Bool
    @State var ReviewChecked3: Bool
    
    var switchViewAction: () -> Void
    
    var body: some View {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    
                    if taskStore.tasks.isEmpty && todoStore.todos.isEmpty && sportStore.sports.isEmpty {
                        EmptyStateView()
                    } else {
                        ScrollView {
                            SectionHeaderView(title: "間隔學習法")
                            ForEach(taskStore.tasks.indices, id: \.self) { index in
                                NavigationLink(destination: SpaceDetailView(task: $taskStore.tasks[index])) {
                                    ItemView(title: taskStore.tasks[index].title, description: taskStore.tasks[index].description, date: taskStore.tasks[index].nextReviewDate)
                                }
                            }
                            
                            SectionHeaderView(title: "一般學習法")
                            ForEach(todoStore.todos.indices, id: \.self) { index in
                                NavigationLink(destination: StudyDetailView(todo: $todoStore.todos[index])) {
                                    ItemView(title: todoStore.todos[index].title, description: todoStore.todos[index].description, date: todoStore.todos[index].startDateTime)
                                }
                            }
                            
                            SectionHeaderView(title: "運動")
                            ForEach(sportStore.sports.indices, id: \.self) { index in
                                NavigationLink(destination: DetailSportView(sport: $sportStore.sports[index])) {
                                    ItemView(title: sportStore.sports[index].title, description: sportStore.sports[index].description, date: sportStore.sports[index].startDateTime)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationBarTitle("待辦事項", displayMode: .inline)
                .navigationBarItems(leading: leadingBarItem, trailing: trailingBarItem)
                // ... other views and modifiers ...
            }
        }
        
        // Empty state view
        private func EmptyStateView() -> some View {
            Text("尚未新增事項")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        // Section header view
        private func SectionHeaderView(title: String) -> some View {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        // List item view
    private func ItemView(title: String, description: String, date: Date, icon: String = "calendar") -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.blue.opacity(0.7))
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 250)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Start time: \(formattedDate(date))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }

        
        // Leading navigation bar item
        var leadingBarItem: some View {
            Button(action: switchViewAction) {
                Image(systemName: "calendar")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
        }
        
        // Trailing navigation bar item
        var trailingBarItem: some View {
            Button(action: { showingActionSheet = true }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
        }
        
        // Function to format date
        private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: date)
        }
    }

struct SpacedView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false, switchViewAction: {})
        //        TodoListView(switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .environmentObject(SportStore())
    }
}
