import Foundation
import SwiftUI
import FirebaseCore
import Firebase // 添加 Firebase 模塊
import GoogleSignIn
import SafariServices

struct TestView: View {
    @EnvironmentObject var tickerStore: TickerStore
    @AppStorage("uid") private var uid:String = ""
    var body: some View {
        NavigationView {
            VStack {
                if tickerStore.tickers.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(tickerStore.tickers) { ticker in
                            TickerRow(ticker: ticker)
                        }
                    }
                }
            }
        }.onAppear() {
            reList()
            print("tickerList: \(tickerStore.tickers)")
        }
        .navigationTitle("票卷列表")
    }
    
    private func EmptyStateView() -> some View {
        Text("尚未獲得票卷")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func reList() {
        tickersList { tickersListMessage in
            printResultMessage(for: tickersListMessage, withOperationName: "TickersList")
        }
    }
    private func printResultMessage(for message: String, withOperationName operationName: String) {
        if message == "Success" {
            print("\(operationName) Success")
        } else {
            print("\(operationName) failed with message: \(message)")
        }
    }
    func tickersList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
         phpUrl(php: "tickersList",type: "list",body:body,store: tickerStore){ message in
             // 在此处调用回调闭包，将 messenge 值传递给调用者
             //// completion(message[0])
             completion(message["message"]!)
         }
     }
}

struct PostData: Encodable {
    var userID: String
    var TickerID: String
}

struct TickerRow: View {
    @EnvironmentObject var tickerStore: TickerStore
    var ticker: Ticker
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("uid") private var uid:String = ""
    @AppStorage("password") private var password:String = ""
    @State var ticker_id: String = ""
    @State var verify: String = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("名稱： \(ticker.name)")
                Text("id： \(ticker.id)")
                Text("截止日期： \(formattedDate(ticker.deadline))")
                Text("兌換時間： \(ticker.exchage)")
            }
            Spacer()
            Button(action: {
                postTicker { verify, error in
                    if let error = error {
                        // 处理错误
                        print("Error: \(error.localizedDescription)")
                    } else if let verify = verify {
                        // 处理成功的情况
                        openSafariView(verify)
                    }
                }
                
            }, label: {
                Image(systemName: "gift.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                    .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                    .foregroundColor(.blue)
            })

        }
        
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
                }
            }else{
                print("無法顯示2")
            }
        }else{
            print("無法顯示")
        }
    }

    private func postTicker(completion: @escaping (String?, Error?) -> Void) {
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

            let url = URL(string: "http://163.17.136.73/api/values/post")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = PostData(userID: userName, TickerID: ticker.id)
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

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(TickerStore())
    }
}
