//
//  TrialWidget.swift
//  TrialWidget
//
//  Created by 200OK-IOS4 on 12/08/24.
//

import WidgetKit
import SwiftUI

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

struct TrialWidgetEntryView: View {
    var entry: Provider.Entry
    let imageURL = "https://via.placeholder.com/150"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(entry.posts, id: \.id) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                        .lineLimit(3) // Adjust based on the size
                    Divider().padding(16)
                    // Replace Divider with Static Image
                    Image("200ok")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .cornerRadius(8)
                }
                .padding()
                .widgetURL(URL(string: "myapp://PostSummary/\(post.title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"))
            }
        }
        .padding()
        .activityBackgroundTint(Color(uiColor: UIColor.red))
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), posts: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),  posts: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        fetchData { posts in
            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            
            let entries = posts.prefix(5).enumerated().map { index, post in
                SimpleEntry(
                    date: Calendar.current.date(byAdding: .minute, value: index * 1, to: Date())!,
                    posts: Array(posts.prefix(1))
                )
            }
            
            let timeline = Timeline(entries: entries, policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    //URL:
    private func fetchData(completion: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data")
                return
            }
            let posts = try? JSONDecoder().decode([Post].self, from: data)
            completion(posts ?? [])
        }
        task.resume()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let posts: [Post] // Array of posts
}

@main
struct TrialWidget: Widget {
    let kind: String = "MyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TrialWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Post Data Widget")
        .description("Displays data from an API.")
        .supportedFamilies([.systemLarge])
    }
}
