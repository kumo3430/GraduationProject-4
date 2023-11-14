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

extension Color {
    static let morandiPink = Color(red: 180/255, green: 120/255, blue: 140/255)
    static let morandiBlue = Color(red: 100/255, green: 120/255, blue: 140/255)
    static let morandiGreen = Color(red: 172/255, green: 210/255, blue: 194/255)
    static let morandiBackground = Color(hex: "#F5F3F0")
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
                    }
                }
            }
            .navigationBarItems(
                leading: NotificationButtonView(showingNotifications: $showingNotifications),
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
