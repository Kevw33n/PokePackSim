//
//  PokePackSimWidget.swift
//  PokePackSimWidget
//
//  Created by Kevin Dai on 4/26/25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), cardName: "Pikachu", cardImageData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), cardName: "Pikachu", cardImageData: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // manual SwiftData fetching inside Provider
        Task {
            do {
                let modelContainer = try ModelContainer(for: Card.self)
                let modelContext = await modelContainer.mainContext

                let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.name)])
                let cards = try await modelContext.fetch(descriptor)

                let rareCards = cards.filter { $0.isRare }

                if let card = rareCards.randomElement() {
                    var cardImageData: Data? = nil

                    if let url = URL(string: card.images.small) {
                        do {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            cardImageData = data
                        } catch {
                            print("Failed to download image data: \(error)")
                        }
                    }

                    let entry = SimpleEntry(date: Date(), cardName: card.name, cardImageData: cardImageData)

                    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date().addingTimeInterval(3600)

                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                    completion(timeline)
                    return
                }

                let entry = SimpleEntry(date: Date(), cardName: nil, cardImageData: nil)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
                completion(timeline)

            } catch {
                print("Error fetching cards from SwiftData: \(error)")
                let entry = SimpleEntry(date: Date(), cardName: nil, cardImageData: nil)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let cardName: String?
    let cardImageData: Data?
}

struct PokePackSimWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack(spacing: 8) {
            if let data = entry.cardImageData,
               let uiImage = UIImage(data: data)
            {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
            if let name = entry.cardName {
                Text(name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            } else {
                Text("No Rare Cards Yet!")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [.black, .white, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct PokePackSimWidget: Widget {
    let kind: String = "PokePackSimWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PokePackSimWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Check Out This Rare Pull")
        .description("Shows a random rare Pokémon card from your collection.")
    }
}

#Preview(as: .systemLarge) {
    PokePackSimWidget()
} timeline: {
    SimpleEntry(date: .now, cardName: "nklnldnflsfksdlfjdlskfjsklfjklnsfnjkdsfnskjfndsjkfnjsdkfnfnskdnfdj", cardImageData: nil)
}
