//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationLink(destination: ServoView()) {
                Text("Connect to a ESP32")
        }
        NavigationView {
            Text("Hello, World!")
                .navigationTitle("ESP32")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
