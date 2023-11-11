//
//  DiaryView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI

struct DiaryEntry: Identifiable {
    let id: UUID
    let date: Date
    let content: String
    let attachments: [Attachment]
}

enum Attachment {
    case image(UIImage)
}

struct DiaryView: View {
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var showingEditor = false

    var body: some View {
            List {
                ForEach(diaryEntries.sorted(by: { $0.date > $1.date }), id: \.id) { entry in
                    NavigationLink(destination: DiaryEntryDetailView(entry: entry)) {
                        DiaryEntryRow(entry: entry)
                    }
                }
                .onDelete(perform: deleteDiaryEntry)
            }
            .listStyle(PlainListStyle())
            .background(Color.morandiBackground)
            .navigationTitle("習慣日記")
            .navigationBarItems(trailing: Button(action: { showingEditor = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.morandiBlue)
            })
            .sheet(isPresented: $showingEditor) {
                DiaryEntryEditor { newEntry in
                    diaryEntries.append(newEntry)
                    showingEditor = false
                }
            }
    }

    func deleteDiaryEntry(at offsets: IndexSet) {
        diaryEntries.remove(atOffsets: offsets)
    }
}

struct DiaryEntryRow: View {
    let entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(entry.date, style: .date)
                .font(.caption)
                .foregroundColor(Color.morandiBlue)
            Text(entry.content)
                .lineLimit(2)
                .font(.body)
                .foregroundColor(Color.morandiGreen)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

struct DiaryEntryDetailView: View {
    let entry: DiaryEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(entry.date, style: .date)
                    .font(.caption)
                    .foregroundColor(Color.morandiBlue)
                Text(entry.content)
                    .font(.title2)
                    .foregroundColor(Color.morandiGreen)
                ForEach(entry.attachments.indices, id: \.self) { index in
                    let attachment = entry.attachments[index]
                    switch attachment {
                    case .image(let image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
            }
            .padding(15)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(15)
                    }
                    .background(Color.morandiBackground)
                    .navigationTitle("日記詳情")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DiaryEntryEditor: View {
    @State private var content: String = ""
    @State private var attachments: [Attachment] = []
    let onSave: (DiaryEntry) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("新日記")
                .font(.largeTitle)
                .padding(.top, 40)
                .foregroundColor(Color.morandiGreen)
            TextEditor(text: $content)
                .frame(height: 300)
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.morandiBlue, lineWidth: 1))
            Button("保存") {
                let newEntry = DiaryEntry(id: UUID(), date: Date(), content: content, attachments: attachments)
                onSave(newEntry)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 60)
            .background(Color.morandiBlue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        }
        .padding(30)
        .background(Color.morandiBackground.edgesIgnoringSafeArea(.all))
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
