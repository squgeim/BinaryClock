//
//  BinaryClockWidget.swift
//  BinaryClockWidget
//
//  Created by Shreya Dahal on 2020-10-31.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Using timeIntervalSince to create a new date because the TimeInterval
        // value in timeIntervalSince is always aligned to seconds -- we are
        // basically rounding-off any milli/microseconds so that the timeline
        // is precisely laid out.
        let currentDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)

        // Creating a timeline for the next 1 hour. Widget is only refresh a limited
        // number of times, so it is best to have timeline ready for a long time.
        for secondOffset in 0 ..< 3600 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct BinaryClockWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            ForEach(getTimeBitList(date: entry.date), id: \.self) { bitList in
                VStack {
                    ForEach(bitList, id: \.self) { bit in
                        bit ? Text("◼︎") : Text("☐")
                    }
                }
            }
        }
    }
}

@main
struct BinaryClockWidget: Widget {
    let kind: String = "BinaryClockWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BinaryClockWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("BinaryClock")
        .description("Display current time in binary!")
    }
}

struct BinaryClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        BinaryClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
