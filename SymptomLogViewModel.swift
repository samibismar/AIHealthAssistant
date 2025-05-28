import Foundation

@MainActor
class SymptomLogViewModel: ObservableObject {
    @Published var symptomText: String = ""
    @Published var explanation: String = ""
    
    func sendSymptomToServer() async {
        guard let url = URL(string: "http://127.0.0.1:5000/explain") else {
            print("Invalid URL")
            return
        }

        let payload: [String: String] = ["symptom": symptomText]

        guard let jsonData = try? JSONEncoder().encode(payload) else {
            print("Failed to encode payload")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decoded = try? JSONDecoder().decode([String: String].self, from: data),
               let aiResponse = decoded["explanation"] {
                explanation = aiResponse
            } else {
                explanation = "Failed to decode server response."
            }
        } catch {
            explanation = "Network error: \(error.localizedDescription)"
        }
    }
}
