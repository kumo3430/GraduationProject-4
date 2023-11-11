//
//  CommunityListView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/27.
//

import SwiftUI

extension Color {
    static let color = Color("Color")
    static let color1 = Color("Color1")
    static let color2 = Color("Color2")
}

struct Community: Identifiable {
    enum Category: String, CaseIterable {
        case 學習, 運動, 作息, 飲食
    }
    
    var id = UUID()
    var name: String
    var description: String
    var memberCount: Int
    var image: String
    var category: Category
}

extension Color {
    static let morandiPink = Color(red: 180/255, green: 120/255, blue: 140/255)
    static let morandiBlue = Color(red: 100/255, green: 120/255, blue: 140/255)
    static let morandiGreen = Color(red: 172/255, green: 210/255, blue: 194/255)
    static let morandiBackground = Color(hex: "#F5F3F0")
}

struct CommunityIntroView: View {
    @Binding var isShowing: Bool
    @State private var dontShowAgain: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#A8A39D")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("歡迎來到我們的社群！")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
                    .padding([.top, .bottom])
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1️⃣ 自我覺察與成長")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("在這裡，你可以探索自我，察覺自身的變化，並在支持性的環境中成長。")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("2️⃣ 團體的支持與鼓勵")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("分享你的感受和經驗，並從社群的反饋中學習和進步。")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("3️⃣ 社會互動與學習")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("通過互動，學習新的社會技能，並從他人的經驗中獲得啟示。")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("4️⃣ 團體規範與從眾效應")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("一同創造有益的社群規範，並遵循正向的團體力量，共同達成目標。")
                        .font(.body)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("立即加入")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                HStack {
                    Image(systemName: dontShowAgain ? "checkmark.square.fill" : "square")
                        .foregroundColor(.white)
                        .onTapGesture {
                            dontShowAgain.toggle()
                        }
                    Text("不再顯示")
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: closeIntro) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    func closeIntro() {
        if dontShowAgain {
            UserDefaults.standard.set(true, forKey: "dontShowIntroAgain")
        }
        isShowing = false
    }
}

struct CommunityListView: View {
    @State private var selectedSegment = 0
    @State private var selectedCategory = 0
    @State private var searchText: String = ""
    @State private var showingNotifications = false
    @State private var isCommunityIntroShowing = true
    
    // Sample data for the joined communities
    let joinedCommunities: [Community] = [
        Community(name: "徒步探險", description: "一起徒步，感受大自然", memberCount: 41, image: "GP1", category: .運動),
        Community(name: "冥想與平靜", description: "冥想帶來內心平靜", memberCount: 36, image: "GP2", category: .作息),
        Community(name: "膳食多元化", description: "嘗試各種健康飲食", memberCount: 34, image: "GP3", category: .飲食),
        Community(name: "日常瑜伽", description: "瑜伽成為日常一部分", memberCount: 45, image: "GP4", category: .運動),
        Community(name: "放鬆舒眠", description: "學習放鬆，享受深眠", memberCount: 47, image: "GP5", category: .作息),
    ]
    
    // Sample data for available communities
    let availableCommunities: [Community] = [
        Community(name: "騎行樂趣", description: "騎自行車，保持活力", memberCount: 48, image: "GP6", category: .運動),
        Community(name: "夜晚冥想", description: "深夜冥想，平靜思緒", memberCount: 40, image: "GP7", category: .作息),
        Community(name: "健康飲食家族", description: "家庭共享健康飲食", memberCount: 50, image: "GP8", category: .飲食),
        Community(name: "健走社團", description: "一起健走，健康生活", memberCount: 44, image: "GP9", category: .運動),
        Community(name: "靈感早晨", description: "清晨靈感，創造力無限", memberCount: 49, image: "GP10", category: .作息),
        Community(name: "烤食探索", description: "烤食愛好者的聚會", memberCount: 33, image: "GP11", category: .飲食),
        Community(name: "健康生活愛好者", description: "探索健康生活的愛好者", memberCount: 47, image: "GP12", category: .飲食),
        Community(name: "自然愛好者", description: "尋找大自然的美麗", memberCount: 45, image: "naturelover", category: .作息),
        Community(name: "水果嘗試者", description: "品味各種水果的美味", memberCount: 41, image: "fruitexplorer", category: .飲食),
        Community(name: "日常鍛鍊", description: "持之以恆的運動", memberCount: 43, image: "dailyexercise", category: .運動),
        Community(name: "睡前冥想", description: "準備好入眠的冥想", memberCount: 39, image: "bedtimemeditation", category: .作息),
        Community(name: "營養健康分享", description: "分享營養知識和食譜", memberCount: 50, image: "nutritionhealth", category: .飲食),
        Community(name: "團隊運動", description: "一起挑戰，團結力量大", memberCount: 46, image: "teamsports", category: .運動),
        Community(name: "輕食探索者", description: "探索輕食的多樣性", memberCount: 47, image: "lighteats", category: .飲食),
        Community(name: "早晨靈感創作", description: "早晨創意發想的好時光", memberCount: 44, image: "morningcreativity", category: .作息),
        Community(name: "戶外冒險家", description: "冒險愛好者的聚會", memberCount: 49, image: "outdooradventures", category: .作息),
        Community(name: "休息日放鬆", description: "休息日輕鬆，保持活力", memberCount: 48, image: "relaxationday", category: .作息),
    ]
    // Sample data for recommended communities
    let recommendedCommunities: [Community] = [
        Community(name: "跑步愛好者", description: "一起鍛煉身體，激發活力", memberCount: 45, image: "GP13", category: .運動),
        Community(name: "健康飲食分享", description: "探討營養均衡的飲食方式", memberCount: 38, image: "GP14", category: .飲食),
        Community(name: "早鳥學習團", description: "清晨學習，提升自己", memberCount: 48, image: "GP15", category: .學習),
        Community(name: "冥想心靈", description: "學習冥想，平靜內心", memberCount: 40, image: "GP16", category: .作息),
        Community(name: "健身新手村", description: "健身入門，互相鼓勵", memberCount: 50, image: "GP17", category: .運動),
        Community(name: "健康烹飪秘笈", description: "健康飲食的烹飪技巧", memberCount: 32, image: "GP18", category: .飲食),
        Community(name: "早起早睡", description: "培養良好的生活習慣", memberCount: 46, image: "GP19", category: .作息),
        Community(name: "瑜伽之旅", description: "探索身心平衡的旅程", memberCount: 44, image: "GP20", category: .運動),
        Community(name: "均衡生活分享", description: "分享維持均衡生活的方法", memberCount: 39, image: "balancedlife", category: .作息),
        Community(name: "蔬食愛好者", description: "推崇蔬食生活方式", memberCount: 47, image: "vegetarian", category: .飲食),
        Community(name: "每日小步走", description: "每天行走，保持健康", memberCount: 42, image: "dailywalks", category: .運動),
        Community(name: "心靈鍛鍊", description: "提升內在力量和平靜", memberCount: 37, image: "mindtraining", category: .作息),
        Community(name: "瑜伽愛好者", description: "練習瑜伽，活力滿滿", memberCount: 49, image: "yogalove", category: .運動),
        Community(name: "健康生活分享", description: "分享促進健康的生活方式", memberCount: 35, image: "healthyliving", category: .飲食),
        Community(name: "早安好習慣", description: "建立美好的早晨習慣", memberCount: 43, image: "goodmorninghabits", category: .作息),
    ]
    
    // Sample data for popular communities
    let popularCommunities: [Community] = [
        Community(name: "均衡飲食計畫", description: "打造均衡飲食計畫", memberCount: 43, image: "GP21", category: .飲食),
        Community(name: "團體瑜伽", description: "共同練習瑜伽的樂趣", memberCount: 50, image: "GP22", category: .運動),
        Community(name: "健康心靈", description: "注重心靈健康", memberCount: 42, image: "GP23", category: .作息),
        Community(name: "夜間散步", description: "夜晚散步，享受寧靜", memberCount: 46, image: "GP24", category: .作息),
        Community(name: "瑜伽冥想聚會", description: "瑜伽和冥想的完美結合", memberCount: 45, image: "GP25", category: .運動),
        Community(name: "健身達人", description: "健身達人的聚會", memberCount: 40, image: "GP26", category: .運動),
        Community(name: "食材探索", description: "探索各種美味食材", memberCount: 42, image: "GP27", category: .飲食),
        Community(name: "天然飲食方式", description: "崇尚天然飲食方式", memberCount: 48, image: "GP28", category: .飲食),
        Community(name: "規律運動", description: "堅持規律運動", memberCount: 44, image: "GP29", category: .運動),]
    
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("", selection: $selectedSegment) {
                    Text("已加入").tag(0)
                    Text("探索").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedSegment == 0 {
                    ScrollView {
                        SearchBar(text: $searchText, placeholder: "搜索社群")
                            .padding(.vertical, 5)
                        ForEach(joinedCommunities.filter {
                            searchText.isEmpty ? true : $0.name.contains(searchText)
                        }) { community in
                            CommunityCard(community: community)
                        }
                    }
                } else {
                    ScrollView {
                        SearchBar(text: $searchText, placeholder: "搜索社群")
                            .padding(.vertical, 5)
                        Picker("Category", selection: $selectedCategory) {
                            Text("推薦").tag(0)
                            Text("熱門").tag(1)
                            Text("全部").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        if selectedCategory == 0 {
                            ForEach(recommendedCommunities.filter {
                                searchText.isEmpty ? true : $0.name.contains(searchText)
                            }) { community in
                                CommunityCard(community: community)
                            }
                        } else if selectedCategory == 1 {
                            ForEach(popularCommunities.filter {
                                searchText.isEmpty ? true : $0.name.contains(searchText)
                            }) { community in
                                CommunityCard(community: community)
                            }
                        } else {
                            ForEach(availableCommunities.filter {
                                searchText.isEmpty ? true : $0.name.contains(searchText)
                            }) { community in
                                CommunityCard(community: community)
                            }
                        }
                    }
                }
            }
            .navigationBarItems(
                leading: NotificationButtonView(showingNotifications: $showingNotifications),
                trailing: NavigationLink(destination: AddCommunityView()) {
                    Text("創建")
                        .foregroundColor(Color.morandiBlue)
                }
            )
            .sheet(isPresented: $showingNotifications) {
                NotificationView()
            }
            if isCommunityIntroShowing {
                CommunityIntroView(isShowing: $isCommunityIntroShowing)
            }
        }
        .background(
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.color, Color.color1, Color.color2]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                }
            }
        )
    }
}

struct NotificationButtonView: View {
    @Binding var showingNotifications: Bool
    
    var body: some View {
        Button(action: {
            showingNotifications.toggle()
        }) {
            Image(systemName: "bell")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.morandiBlue)
        }
    }
}

struct SectionView: View {
    let title: String
    let communities: [Community]
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title2)
                .padding(.leading)
                .padding(.top)
            ForEach(communities.filter {
                searchText.isEmpty ? true : $0.name.contains(searchText)
            }) { community in
                CommunityCard(community: community)
            }
        }
        .padding(.bottom)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5))
    }
}

struct NotificationView: View {
    let notifications = [
        ("徒步探險", "GP1", "王小明在「徒步探險」回覆了您的貼文"),
        ("冥想與平靜", "GP2", "李小芬在「冥想與平靜」發表了一篇新貼文"),
        ("膳食多元化", "GP3", "張大偉在「膳食多元化」說您的貼文讚"),
        ("日常瑜伽", "GP4", "陳小英剛加入了「日常瑜伽」"),
        // ... 以此類推，您可以添加更多的通知
    ]
    
    var body: some View {
        List(notifications, id: \.0) { (communityName, communityImageName, message) in
            HStack {
                Image(communityImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .background(Color.morandiGreen)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.morandiPink, lineWidth: 2))
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(communityName)
                        .font(.headline)
                        .foregroundColor(Color.morandiBlue)
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(Color.morandiPink)
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 10))
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
                .padding(10)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.2)))
        .padding(.horizontal)
    }
}

struct CommunityCard: View {
    let community: Community
    
    var body: some View {
        NavigationLink(destination: Text(community.name)) {
            HStack(spacing: 15) {
                Image(community.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.morandiPink, lineWidth: 2))
                    .shadow(radius: 5)
                
                VStack(alignment: .leading) {
                    Text(community.name)
                        .font(.headline)
                        .foregroundColor(Color.morandiBlue)
                    
                    Text(community.description)
                        .font(.subheadline)
                        .foregroundColor(Color.morandiGreen)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(Color.morandiPink)
                        Text("\(community.memberCount) members")
                            .font(.footnote)
                            .foregroundColor(Color.morandiPink)
                    }
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                .fill(Color.morandiBackground)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddCommunityView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: Community.Category = .學習  // Use picker for category
    @State private var coverPhoto: Image? = nil
    
    var body: some View {
        Form {
            Section(header: Text("基本資訊").foregroundColor(Color.morandiBlue)) {
                TextField("社群名稱", text: $name)
                TextField("描述", text: $description)
            }
            
            Section(header: Text("分類").foregroundColor(Color.morandiBlue)) {
                Picker("選擇分類", selection: $selectedCategory) {
                    ForEach(Community.Category.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section(header: Text("封面照片").foregroundColor(Color.morandiBlue)) {
                Text("選擇封面照片")
            }
            
            Button(action: {}) {
                Text("新增社群")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.morandiPink, Color.morandiBlue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top)
        }
    }
}

struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityListView()
    }
}
