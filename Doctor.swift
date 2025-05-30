import Foundation

struct NearbyDoctor: Identifiable, Codable {
    var id = UUID()
    let name: String
    let specialty: String
    let phone: String
    let location: String
    let distance: Double
}
