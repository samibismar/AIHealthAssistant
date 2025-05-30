import Foundation

@MainActor
class SymptomLogHistoryViewModel: ObservableObject {
    @Published var logs: [SymptomLog] = []
    
    func clearLogs() {
        logs.removeAll()
    }


    func fetchLogs() async {
        guard let url = URL(string: "https://aihealthbackendminimal.onrender.com/logs") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([String: [SymptomLog]].self, from: data)
            logs = decoded["logs"] ?? []
        } catch {
            print("Failed to fetch logs: \(error)")
        }
    }
}
