//
//  ContentView.swift
//  BinaryClock
//
//  Created by Shreya Dahal on 2020-10-31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Binary Clock")
                .font(.largeTitle)
                .padding()
            Text("This is just the container app. All the magic happens in the widget!")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
