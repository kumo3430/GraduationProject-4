//
//  RecommendedReadingView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/27.
//

import SwiftUI

struct RecommendedReadingView: View {
    let recommendedBooks: [Book] = [
        Book(title: "原子習慣", author: "James Clear", description: "探討如何建立好習慣、摒除壞習慣的策略和技巧."),
        Book(title: "心理學的力量", author: "Robert Cialdini", description: "深入探討心理學背後的原理與如何影響人的決策."),
        Book(title: "意志力", author: "罗伊·鲍迈斯特", description: "本書揭示了實驗研究的驚人結果，意志力像肌肉一樣，經常鍛煉就會增強，過度使用就會疲勞."),
        Book(title: "自控力", author: "Unknown", description: "對於想要減肥、戒煙、少喝酒或者更高效、更省力地工作的人來說，這是來自天堂的手冊."),
        Book(title: "彈性習慣", author: "史蒂芬．蓋斯", description: "《彈性習慣》討論了釋放壓力、克服拖延、輕鬆保持意志力的聰明學習法.")
    ]

    var body: some View {
        ZStack {
            Color(hex: "#F0EAE5").edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("推薦閱讀")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(recommendedBooks) { book in
                            BookCard(book: book)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct BookCard: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(book.title)
                .font(.headline)
                .fontWeight(.bold)
            Text("作者: \(book.author)")
                .font(.subheadline)
                .foregroundColor(Color(hex: "#A8A3A1"))
            Text(book.description)
                .font(.footnote)
                .foregroundColor(Color(hex: "#7C7977"))
                .lineLimit(4)
        }
        .padding()
        .background(Color(hex: "#D1CBC6"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let description: String
}

struct RecommendedReadingView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedReadingView()
    }
}
