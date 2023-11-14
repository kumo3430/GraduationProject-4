//
//  CommunityListView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/27.
//

import SwiftUI
import SafariServices

struct communityPostData: Encodable {
    var userID: String
    var Community: String
}

extension Color {
    static let color = Color("Color")
    static let color1 = Color("Color1")
    static let color2 = Color("Color2")
}

//struct Community: Identifiable {
//    enum Category: String, CaseIterable {
//        case 學習, 運動, 作息, 飲食
//    }
//
//    var id = UUID()
//    var name: String
//    var description: String
//    var memberCount: Int
//    var image: String
//    var category: Category
//}

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
    @AppStorage("userName") private var userName:String = ""
    @State var verify: String = ""
    @State private var showingSheet = false
    @EnvironmentObject var communityStore: CommunityStore
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
                        ForEach(communityStore.communitys) { community in
                            Button(action: {
                                print("我是社群")
                                postCommunity(community:community) { verify, error in
                                    if let error = error {
                                        // 处理错误
                                        print("Error: \(error.localizedDescription)")
                                    } else if let verify = verify {
                                        // 处理成功的情况
                                        openSafariView(verify)
                                    }
                                }
                                
                            }){
                                CommunityCard(community: community)
                            }
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
                            //                            ForEach(recommendedCommunities.filter {
                            //                                searchText.isEmpty ? true : $0.name.contains(searchText)
                            //                            }) { community in
                            //                                CommunityCard(community: community)
                            //                            }
                        } else if selectedCategory == 1 {
                            //                            ForEach(popularCommunities.filter {
                            //                                searchText.isEmpty ? true : $0.name.contains(searchText)
                            //                            }) { community in
                            //                                CommunityCard(community: community)
                            //                            }
                        } else {
                            //                            ForEach(availableCommunities.filter {
                            //                                searchText.isEmpty ? true : $0.name.contains(searchText)
                            //                            }) { community in
                            //                                CommunityCard(community: community)
                            //                            }
                        }
                    }
                }
            }
            .navigationBarItems(
                leading: NotificationButtonView(showingNotifications: $showingNotifications),
//                trailing: NavigationLink(destination: AddCommunityView()) {
//                    Text("創建")
//                        .foregroundColor(Color.morandiBlue)
//                }
                trailing:  Button("創建") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    AddCommunityView()
                        .presentationDetents([ .large, .large])
                }
            )
//            .sheet(isPresented: $showingNotifications) {
//                NotificationView()
//            }
//            if isCommunityIntroShowing {
//                CommunityIntroView(isShowing: $isCommunityIntroShowing)
//            }
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
    func openSafariView(_ verify: String) {
        print("VERIFY: \(verify)")
        let stringWithoutQuotes = verify.replacingOccurrences(of: "\"", with: "") // 去掉双引号的字符串
        print("stringWithoutQuotes: \(stringWithoutQuotes)")
            guard let url = URL(string: "http://163.17.136.73/web/login.aspx?\(stringWithoutQuotes)") else {
            print("无法构建有效的 URL-http://163.17.136.73/web_login.aspx?\(stringWithoutQuotes)")
            return
        }
        // 建立 SFSafariViewController 實例
        let safariViewController = SFSafariViewController(url: url)
        // 取得目前的 UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // 取得目前的 UIWindow
            if let mainWindow = windowScene.windows.first {
                // 以全屏方式彈出 SFSafariViewController
                DispatchQueue.main.async {
                   // 在主线程上执行与界面相关的操作，包括打开 Safari 视图控制器
//                    SFSafariViewController(url: url).present(safariViewController, animated:true, completion:nil)
                    mainWindow.rootViewController?.present(safariViewController, animated: true, completion: nil)
//                    communityStore.clearTodos()
                }
            }else{
                print("無法顯示2")
            }
        }else{
            print("無法顯示")
        }
    }
    
    private func postCommunity(community: Community,completion: @escaping (String?, Error?) -> Void) {
//            private func postTicker() {
            UserDefaults.standard.synchronize()
            class URLSessionSingleton {
                static let shared = URLSessionSingleton()
                let session: URLSession
                private init() {
                    let config = URLSessionConfiguration.default
                    config.httpCookieStorage = HTTPCookieStorage.shared
                    config.httpCookieAcceptPolicy = .always
                    session = URLSession(configuration: config)
                }
            }

            let url = URL(string: "http://163.17.136.73/api/values/community")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = communityPostData(userID: userName, Community: String(community.id))
            let jsonData = try! JSONEncoder().encode(body)

            request.httpBody = jsonData
            print("body:\(body)")
            print("jsonData:\(jsonData)")
            URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("StudySpaceList - Connection error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    if let responseData = data {
                                   // 解析伺服器端返回的錯誤信息
                                   let errorString = String(data: responseData, encoding: .utf8)
                                   print("Server Error: \(errorString ?? "")")
                               }
                    print("StudySpaceList - HTTP error: \(httpResponse.statusCode)")
                }
                else if let data = data{
                    print(data)
                    let decoder = JSONDecoder()
                    print(String(data: data, encoding: .utf8)!)
                    verify = String(data: data, encoding: .utf8)!
                    DispatchQueue.main.async {
                        completion(verify, nil) // 传递成功的数据
                    }
                }
            }
            .resume()
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
            //            ForEach(communities.filter {
            //                searchText.isEmpty ? true : $0.name.contains(searchText)
            //            }) { community in
            //                CommunityCard(community: community)
            //            }
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
//        NavigationLink(destination: Text(community.communityName)) {
            HStack(spacing: 15) {
                //                Image(community.image)
                //                    .resizable()
                //                    .scaledToFit()
                //                    .frame(width: 60, height: 60)
                //                    .clipShape(Circle())
                //                    .overlay(Circle().stroke(Color.morandiPink, lineWidth: 2))
                //                    .shadow(radius: 5)
                
                VStack(alignment: .leading) {
                    Text(community.communityName)
                        .font(.headline)
                        .foregroundColor(Color.morandiBlue)
                    
                    Text(community.communityDescription)
                        .font(.subheadline)
                        .foregroundColor(Color.morandiGreen)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    //                    HStack {
                    //                        Image(systemName: "person.2.fill")
                    //                            .foregroundColor(Color.morandiPink)
                    //                        Text("\(community.memberCount) members")
                    //                            .font(.footnote)
                    //                            .foregroundColor(Color.morandiPink)
                    //                    }
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                .fill(Color.morandiBackground)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5))
//        }
//        .buttonStyle(PlainButtonStyle())
    }
}

struct AddCommunityView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: Int = 0 // Use picker for category
    @EnvironmentObject var communityStore: CommunityStore
    @State private var coverPhoto: Image? = nil
    @Environment(\.presentationMode) var presentationMode
    let Category = ["學習", "運動", "作息", "飲食"]
    var body: some View {
//        VStack{
//            Text("Hello world")
//        }
        
        Form {
            Section(header: Text("基本資訊").foregroundColor(Color.morandiBlue)) {
                TextField("社群名稱", text: $name)
                TextField("描述", text: $description)
            }
            

            Section(header: Text("分類").foregroundColor(Color.morandiBlue)) {
                Picker("選擇分類", selection: $selectedCategory) {
                    ForEach(Category.indices) { index in
                        Text(Category[index])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Section(header: Text("封面照片").foregroundColor(Color.morandiBlue)) {
                Text("選擇封面照片")
            }
            
            Button(action: {
                addCommunity{_ in }
            }) {
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
    
    func addCommunity(completion: @escaping (String) -> Void) {
        let category = selectedCategory + 1
        var body: [String: Any] = [
            "communityName": name,
            "communityDescription": description,
            "communityCategory": selectedCategory + 1,
        ]

        print("body:\(body)")

        phpUrl(php: "addCommunity" ,type: "addTask",body:body,store: communityStore) { message in
            presentationMode.wrappedValue.dismiss()
//            completion(message[0])
            completion(message["message"]!)
        }
    }
}

struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityListView()
    }
}
