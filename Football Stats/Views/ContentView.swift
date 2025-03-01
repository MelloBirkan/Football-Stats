//
//  ContentView.swift
//  Football Stats
//
//  Created by Marcello Gonzatto Birkan on 01/03/25.
//

import SwiftUI

struct ContentView: View {
    let dataService = DataService()
    @State private var team: Team?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 50)
                } else if let error = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                            .padding()

                        Text(error)
                            .multilineTextAlignment(.center)
                            .padding()

                        Button("Tentar Novamente") {
                            loadData()
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                    }
                    .padding(.top, 50)
                } else if let team = team {
                    // Cabeçalho do Time
                    VStack(alignment: .center, spacing: 20) {
                        if let crestURL = team.crest {
                            AsyncImage(url: URL(string: crestURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 120)
                                } else if phase.error != nil {
                                    Image(systemName: "photo")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                } else {
                                    ProgressView()
                                        .frame(width: 120, height: 120)
                                }
                            }
                            .padding(.top)
                        }

                        VStack(spacing: 5) {
                            Text(team.name)
                                .font(.title)
                                .fontWeight(.bold)

                            if let shortName = team.shortName {
                                Text(shortName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            if let area = team.area {
                                HStack {
                                    if let flag = area.flag, let url = URL(string: flag) {
                                        AsyncImage(url: url) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 24, height: 16)
                                            } else {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 24, height: 16)
                                            }
                                        }
                                    }

                                    Text(area.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                            }

                            if let founded = team.founded {
                                Text("Fundado em \(founded)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            if let colors = team.clubColors {
                                Text(colors)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 5)
                            }
                        }

                        // Informações Adicionais
                        VStack(alignment: .leading, spacing: 15) {
                            if let venue = team.venue {
                                InfoRow(icon: "sportscourt", title: "Estádio", value: venue)
                            }

                            if let website = team.website {
                                InfoRow(icon: "link", title: "Website", value: website)
                            }

                            if let address = team.address {
                                InfoRow(icon: "map", title: "Endereço", value: address)
                            }

                            if let marketValue = team.marketValue {
                                InfoRow(icon: "eurosign.circle", title: "Valor de Mercado", value: formatCurrency(marketValue))
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        // Competições
                        if let competitions = team.runningCompetitions, !competitions.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Competições")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(competitions, id: \.id) { competition in
                                            VStack {
                                                if let emblem = competition.emblem, let url = URL(string: emblem) {
                                                    AsyncImage(url: url) { phase in
                                                        if let image = phase.image {
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 50, height: 50)
                                                        } else if phase.error != nil {
                                                            Image(systemName: "trophy")
                                                                .font(.system(size: 30))
                                                                .foregroundColor(.gray)
                                                        } else {
                                                            ProgressView()
                                                                .frame(width: 50, height: 50)
                                                        }
                                                    }
                                                } else {
                                                    Image(systemName: "trophy")
                                                        .font(.system(size: 30))
                                                        .foregroundColor(.gray)
                                                }

                                                Text(competition.name)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                                    .frame(width: 100)
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }

                        // Treinador
                        if let coach = team.coach {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Treinador")
                                    .font(.headline)
                                    .padding(.horizontal)

                                HStack(alignment: .top, spacing: 15) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue.opacity(0.8))
                                        .frame(width: 60, height: 60)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(coach.name)
                                            .font(.title3)
                                            .fontWeight(.semibold)

                                        if let nationality = coach.nationality {
                                            Text("Nacionalidade: \(nationality)")
                                                .font(.subheadline)
                                        }

                                        if let dateOfBirth = coach.dateOfBirth {
                                            Text("Data de Nascimento: \(dateOfBirth)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        if let contract = coach.contract {
                                            Text("Contrato: \(contract.start) até \(contract.until)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                .padding(.horizontal)
                            }
                            .padding(.top)
                        }

                        // Jogadores
                        if let squad = team.squad, !squad.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Elenco")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.bottom, 5)

                                ForEach(groupPlayersByPosition(squad)) { group in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(group.position)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal)
                                            .padding(.top, 5)

                                        ForEach(group.players, id: \.id) { player in
                                            PlayerRow(player: player)
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .padding(.bottom, 30)
                } else {
                    VStack {
                        Image(systemName: "sportscourt")
                            .font(.system(size: 60))
                            .foregroundColor(.blue.opacity(0.7))
                            .padding()

                        Text("Nenhum dado disponível")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        Button("Carregar Dados") {
                            loadData()
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 50)
                }
            }
            .navigationTitle("Football Stats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        loadData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .task {
            if team == nil {
                loadData()
            }
        }
    }

    private func loadData() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = await dataService.fetchData()

                // Simulando um pequeno atraso para mostrar o indicador de carregamento
                try await Task.sleep(nanoseconds: 500_000_000)

                DispatchQueue.main.async {
                    self.team = result
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Não foi possível carregar os dados: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.maximumFractionDigits = 0

        if value >= 1_000_000 {
            let millions = Double(value) / 1_000_000
            return formatter.string(from: NSNumber(value: millions))?.replacingOccurrences(of: ".00", with: "") ?? "\(value)" + " milhões"
        } else {
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
    }

    private func groupPlayersByPosition(_ players: [Player]) -> [PositionGroup] {
        let positionOrder = ["Goalkeeper", "Defence", "Midfield", "Offence"]
        var positionMap: [String: [Player]] = [:]

        // Agrupar jogadores por posição
        for player in players {
            let position = player.position ?? "Sem posição"
            if positionMap[position] == nil {
                positionMap[position] = []
            }
            positionMap[position]?.append(player)
        }

        // Ordenar grupos de acordo com a ordem predefinida
        var result: [PositionGroup] = []
        for position in positionOrder {
            if let playersInPosition = positionMap[position] {
                let positionName: String
                switch position {
                case "Goalkeeper": positionName = "Goleiros"
                case "Defence": positionName = "Defensores"
                case "Midfield": positionName = "Meio-Campistas"
                case "Offence": positionName = "Atacantes"
                default: positionName = position
                }

                result.append(PositionGroup(position: positionName, players: playersInPosition))
                positionMap.removeValue(forKey: position)
            }
        }

        // Adicionar quaisquer posições restantes
        for (position, players) in positionMap {
            result.append(PositionGroup(position: position, players: players))
        }

        return result
    }
}

struct PositionGroup: Identifiable {
    let id = UUID()
    let position: String
    let players: [Player]
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.subheadline)
            }
        }
    }
}

struct PlayerRow: View {
    let player: Player

    var body: some View {
        HStack {
            Text(player.shirtNumber != nil ? "#\(player.shirtNumber!)" : "")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.blue.opacity(0.8)))
                .padding(.trailing, 5)

            VStack(alignment: .leading, spacing: 2) {
                Text(player.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

                if let nationality = player.nationality {
                    Text(nationality)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if let marketValue = player.marketValue, marketValue > 0 {
                Text("€\(formattedValue(marketValue))")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private func formattedValue(_ value: Int) -> String {
        if value >= 1_000_000 {
            let millions = Double(value) / 1_000_000
            return String(format: "%.1fM", millions).replacingOccurrences(of: ".0", with: "")
        } else if value >= 1000 {
            let thousands = Double(value) / 1000
            return String(format: "%.1fK", thousands).replacingOccurrences(of: ".0", with: "")
        } else {
            return "\(value)"
        }
    }
}

#Preview {
    ContentView()
}
