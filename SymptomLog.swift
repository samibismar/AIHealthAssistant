import Foundation

struct SymptomLog: Identifiable, Decodable {
    let symptom: String
    let explanation: String
    let timestamp: String

    var id: String {
        symptom + timestamp
    }
}
