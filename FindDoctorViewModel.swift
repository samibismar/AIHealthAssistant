import Foundation
import CoreLocation

typealias AppDoctor = NearbyDoctor

struct FindDoctorsResponse: Decodable {
    let explanation: String
    let specialty: String
    let doctors: [AppDoctor]
}

@MainActor
class FindDoctorViewModel: ObservableObject {
    @Published var doctors: [AppDoctor] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchDoctors(symptom: String, location: CLLocationCoordinate2D) async {
        guard let url = URL(string: "https://aihealthbackendminimal.onrender.com/find-doctors-full") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "symptom": symptom,
            "latitude": location.latitude,
            "longitude": location.longitude
        ]

        print("📡 Sending location to backend:")
        print("Lat: \(location.latitude), Lon: \(location.longitude), Symptom: \(symptom)")

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            isLoading = true
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("🧾 Raw JSON response from backend:")
                print(json)
            }
            let decoded = try JSONDecoder().decode(FindDoctorsResponse.self, from: data)
            print("✅ Doctors returned: \(decoded.doctors.count)")
            decoded.doctors.forEach { print("👨‍⚕️ \($0.name), \($0.distance) mi") }
            DispatchQueue.main.async {
                self.doctors = decoded.doctors
                print("Doctors fetched: \(self.doctors.count)")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load doctors."
            }
        }
        isLoading = false
    }
}
