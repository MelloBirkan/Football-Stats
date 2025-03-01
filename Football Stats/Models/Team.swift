//
//  Team.swift
//  Football Stats
//
//  Created by Marcello Gonzatto Birkan on 01/03/25.
//

import Foundation

struct Area: Codable {
  let id: Int
  let name: String
  let code: String
  let flag: String?

  init(id: Int, name: String, code: String, flag: String? = nil) {
    self.id = id
    self.name = name
    self.code = code
    self.flag = flag
  }
}

struct Competition: Codable {
  let id: Int
  let name: String
  let code: String
  let type: String
  let emblem: String?

  init(id: Int, name: String, code: String, type: String, emblem: String? = nil) {
    self.id = id
    self.name = name
    self.code = code
    self.type = type
    self.emblem = emblem
  }
}

struct Contract: Codable {
  let start: String
  let until: String

  init(start: String, until: String) {
    self.start = start
    self.until = until
  }
}

struct Coach: Codable {
  let id: Int
  let firstName: String?
  let lastName: String?
  let name: String
  let dateOfBirth: String?
  let nationality: String?
  let contract: Contract?

  init(id: Int, firstName: String? = nil, lastName: String? = nil, name: String, dateOfBirth: String? = nil, nationality: String? = nil, contract: Contract? = nil) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.name = name
    self.dateOfBirth = dateOfBirth
    self.nationality = nationality
    self.contract = contract
  }
}

struct Player: Codable {
  let id: Int
  let firstName: String?
  let lastName: String?
  let name: String
  let position: String?
  let dateOfBirth: String?
  let nationality: String?
  let shirtNumber: Int?
  let marketValue: Int?
  let contract: Contract?

  init(id: Int, firstName: String? = nil, lastName: String? = nil, name: String, position: String? = nil, dateOfBirth: String? = nil, nationality: String? = nil, shirtNumber: Int? = nil, marketValue: Int? = nil, contract: Contract? = nil) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.name = name
    self.position = position
    self.dateOfBirth = dateOfBirth
    self.nationality = nationality
    self.shirtNumber = shirtNumber
    self.marketValue = marketValue
    self.contract = contract
  }
}

struct Staff: Codable {
  let id: Int
  let firstName: String?
  let lastName: String?
  let name: String
  let dateOfBirth: String?
  let nationality: String?
  let contract: Contract?

  init(id: Int, firstName: String? = nil, lastName: String? = nil, name: String, dateOfBirth: String? = nil, nationality: String? = nil, contract: Contract? = nil) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.name = name
    self.dateOfBirth = dateOfBirth
    self.nationality = nationality
    self.contract = contract
  }
}

struct Team: Codable {
  let area: Area?
  let id: Int
  let name: String
  let shortName: String?
  let tla: String?
  let crest: String?
  let address: String?
  let website: String?
  let founded: Int?
  let clubColors: String?
  let venue: String?
  let runningCompetitions: [Competition]?
  let coach: Coach?
  let marketValue: Int?
  let squad: [Player]?
  let staff: [Staff]?
  let lastUpdated: String?

  init() {
    area = Area(id: 2224, name: "Spain", code: "ESP", flag: "https://crests.football-data.org/760.svg")
    id = 90
    name = "Real Betis Balompié"
    shortName = "Real Betis"
    tla = "BET"
    crest = "https://crests.football-data.org/90.png"
    address = "Avenida de Heliópolis, s/n Sevilla 41012"
    website = "http://www.realbetisbalompie.es"
    founded = 1907
    clubColors = "Green / White"
    venue = "Estadio Benito Villamarín"

    let defaultCompetition = Competition(id: 2014, name: "Primera Division", code: "PD", type: "LEAGUE", emblem: "https://crests.football-data.org/PD.png")
    runningCompetitions = [defaultCompetition]

    let defaultContract = Contract(start: "2020-08", until: "2023-06")
    coach = Coach(id: 11630, firstName: "Manuel", lastName: "Pellegrini", name: "Manuel Pellegrini", dateOfBirth: "1953-09-16", nationality: "Chile", contract: defaultContract)

    marketValue = 225_100_000

    let defaultPlayerContract = Contract(start: "2020-07", until: "2023-06")
    let defaultPlayer = Player(id: 7821, firstName: "", lastName: "Joel", name: "Joel Robles", position: "Goalkeeper", dateOfBirth: "1990-06-17", nationality: "Spain", shirtNumber: 1, marketValue: 2_000_000, contract: defaultPlayerContract)
    squad = [defaultPlayer]

    let defaultStaffContract = Contract(start: "2020-08", until: "2023-06")
    let defaultStaff = Staff(id: 63306, firstName: "", lastName: "Fernando", name: "Fernando Fernández", dateOfBirth: "1979-06-02", nationality: "Spain", contract: defaultStaffContract)
    staff = [defaultStaff]

    lastUpdated = "2022-05-03T08:22:26Z"
  }

  init(area: Area? = nil, id: Int, name: String, shortName: String? = nil, tla: String? = nil, crest: String? = nil, address: String? = nil, website: String? = nil, founded: Int? = nil, clubColors: String? = nil, venue: String? = nil, runningCompetitions: [Competition]? = nil, coach: Coach? = nil, marketValue: Int? = nil, squad: [Player]? = nil, staff: [Staff]? = nil, lastUpdated: String? = nil) {
    self.area = area
    self.id = id
    self.name = name
    self.shortName = shortName
    self.tla = tla
    self.crest = crest
    self.address = address
    self.website = website
    self.founded = founded
    self.clubColors = clubColors
    self.venue = venue
    self.runningCompetitions = runningCompetitions
    self.coach = coach
    self.marketValue = marketValue
    self.squad = squad
    self.staff = staff
    self.lastUpdated = lastUpdated
  }
}
