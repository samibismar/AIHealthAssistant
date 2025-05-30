import Foundation

@MainActor
class SymptomLogViewModel: ObservableObject {
    @Published var symptomText: String = ""
    @Published var explanation: String = ""
    @Published var matchedSpecialty: String = ""

    func sendSymptomToServer() async {
        guard let url = URL(string: "https://aihealthbackendminimal.onrender.com/explain") else {
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

            // Debug print of raw JSON
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("Raw JSON:", json)
            }

            if let decoded = try? JSONDecoder().decode([String: String].self, from: data),
               let aiResponse = decoded["explanation"] {
                explanation = aiResponse
            } else {
                explanation = "Failed to decode server response."
            }
        } catch {
            print("Network error: \(error.localizedDescription)")
            explanation = "Network error: \(error.localizedDescription)"
        }
    }

    // Fetch recommended specialty from backend
    func fetchRecommendedSpecialty() async {
        guard let url = URL(string: "https://aihealthassistantbackend.onrender.com/match-specialty") else {
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
               let specialty = decoded["specialty"] {
                matchedSpecialty = specialty
                print("Matched Specialty: \(specialty)")
            } else {
                matchedSpecialty = "Could not determine specialty."
            }
        } catch {
            matchedSpecialty = "Error: \(error.localizedDescription)"
        }
    }
}
