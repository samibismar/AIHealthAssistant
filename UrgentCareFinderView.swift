import SwiftUI
import MapKit
import CoreLocation

struct UrgentCareFinderView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),  // placeholder, will update onAppear
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var urgentCares: [UrgentCare] = []
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: urgentCares) { care in
                MapMarker(coordinate: care.coordinate, tint: .red)
            }
            .frame(height: 300)
            
            List(urgentCares) { care in
                VStack(alignment: .leading) {
                    Text(care.name)
                        .font(.headline)
                    Text(care.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            if let userLocation = locationManager.location {
                region.center = userLocation
                fetchNearbyUrgentCares()
            }
        }
    }
    
    func fetchNearbyUrgentCares() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Urgent Care"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            urgentCares = response.mapItems.map { item in
                UrgentCare(
                    name: item.name ?? "Unknown",
                    address: item.placemark.title ?? "No address",
                    coordinate: item.placemark.coordinate
                )
            }
        }
    }
}

struct UrgentCare: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    UrgentCareFinderView()
        .environmentObject(LocationManager())
}
