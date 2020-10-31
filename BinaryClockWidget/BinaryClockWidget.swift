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

        // Creating a timeline for the next 5 minutes.
        for secondOffset in 0 ..< 360 {
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

func getTimeStr(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HHmmss"
    let dateStr = formatter.string(from: date)

    return dateStr
}

func getBitsForChar(digit: Int) -> [Bool] {
    switch digit {
    case 0:
        return [false,false,false,false]
    case 1:
        return [false,false,false,true]
    case 2:
        return [false,false,true,false]
    case 3:
        return [false,false,true,true]
    case 4:
        return [false,true,false,false]
    case 5:
        return [false,true,false,true]
    case 6:
        return [false,true,true,false]
    case 7:
        return [false,true,true,true]
    case 8:
        return [true,false,false,false]
    case 9:
        return [true,false,false,true]
    default:
        return [false,false,false,false]
    }
}

func getTimeBitList(date: Date) -> [[Bool]] {
    var bitList: [[Bool]] = []

    let time = getTimeStr(date: date)

    for char in time {
        let bits = getBitsForChar(digit: Int(String(char)) ?? 0)
        bitList.append(bits);
    }

    return bitList
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct BinaryClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        BinaryClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
