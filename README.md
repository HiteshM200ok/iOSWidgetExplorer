
# Dynamic iOS Widget with API Integration

This repository provides a demonstration of creating a dynamic iOS widget that fetches data from an API and displays it. The widget supports background updates and deep linking for navigating to detailed views.

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Implementation](#implementation)
- [Usage](#usage)

## Overview

This project showcases how to build an iOS widget that:
- Fetches data from an API.
- Displays this data dynamically.
- Supports background updates.
- Allows navigation using deep links.

## Setup

### Requirements

- Xcode 14 or later
- iOS 16.0 or later
- Swift 5.6 or later

### Clone the Repository

git clone https://github.com/HiteshM200ok/iOSWidgetExplorer.git

### TrialWidget

### Open the Project
- Open the project in Xcode.
- Build and run the project to see the widget in action.

## Implementation

### Widget Configuration
- The widget is defined in `TrialWidget.swift`:

```swift
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
````

## Provider

The `Provider` class handles data fetching and widget timeline management:

```swift
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), posts: [Post(id: 0, title: "Placeholder", body: "Placeholder body text.")])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), posts: [Post(id: 0, title: "Snapshot", body: "Snapshot body text.")])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        fetchData { posts in
            let entries = [SimpleEntry(date: Date(), posts: posts)]
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let posts: [Post]
}

```
## Fetching Data

The `fetchData` function retrieves data from an API:

```swift
func fetchData(completion: @escaping ([Post]) -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
            return
        }
        
        if let posts = try? JSONDecoder().decode([Post].self, from: data) {
            DispatchQueue.main.async {
                completion(posts)
            }
        } else {
            print("Failed to decode JSON")
        }
    }.resume()
}
````
## Widget View

The widget view is defined in `TrialWidgetEntryView.swift`:

```swift
struct TrialWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(entry.posts, id: \.id) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                        .lineLimit(3)
                }
                .padding()
                .widgetURL(URL(string: "myapp://PostSummary/\(post.title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"))
                Divider()
            }
        }
        .padding()
    }
}
```
## Usage

### Add the Widget to Your Home Screen

- Press and hold on the home screen.
- Tap the "+" icon to add a new widget.
- Select "Post Data Widget" from the widget list.

### Interact with the Widget

- Tap on the widget to navigate to the detailed view using a deep link.

