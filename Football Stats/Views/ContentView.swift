//
//  ContentView.swift
//  Football Stats
//
//  Created by Marcello Gonzatto Birkan on 01/03/25.
//

import SwiftUI

struct ContentView: View {
  let dataService = DataService()
  
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
          print(await dataService.fetchData())
        }
    }
}

#Preview {
    ContentView()
}
