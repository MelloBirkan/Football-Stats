//
//  DataService.swift
//  Football Stats
//
//  Created by Marcello Gonzatto Birkan on 01/03/25.
//

import Foundation

struct DataService {
  let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
  
  func fetchData() async -> Team {
    guard let apiKey else {
      print("API key not found.")
      return Team()
    }
    
    if let url = URL(string: "https://api.football-data.org/v4/teams/\(Int.random(in: 1...99))") {
      var request = URLRequest(url: url)
      request.addValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
      
      do {
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(Team.self, from: data)
        return result
        
      } catch {
        print(error)
      }
    }
    return Team()
  }
}
