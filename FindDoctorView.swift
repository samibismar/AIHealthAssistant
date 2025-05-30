import SwiftUI

struct Doctor: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let specialty: String
    let phone: String
    let location: String
}

import CoreLocation

struct FindDoctorView: View {
    @ObservedObject var viewModel: FindDoctorViewModel
    @StateObject private var locationManager = LocationManager()
    var matchedSpecialty: String

    var body: some View {
        NavigationView {
            VStack {
                if !matchedSpecialty.isEmpty {
                    Text("Recommended: \(matchedSpecialty)")
                        .font(.subheadline)
                        .foregroundColor(.teal)
                        .padding(.top)
                }

                if viewModel.isLoading {
                    ProgressView("Loading doctors...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if viewModel.doctors.isEmpty {
                    Text("No doctors found near you.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.doctors) { doctor in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.teal)
                                VStack(alignment: .leading) {
                                    Text(doctor.name)
                                        .font(.headline)
                                    Text(doctor.specialty)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }

                            Text("📍 \(doctor.location)")
                                .font(.footnote)

                            Text("📞 \(doctor.phone)")
                                .font(.footnote)

                            Divider()
                        }
                        .padding(.vertical, 8)
                    }
                }

                Button(action: {
                    print("Prep for Visit tapped")
                }) {
                    Label("Prep for Visit", systemImage: "doc.plaintext")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Find a Doctor")
            .task {
                while locationManager.authorizationStatus != .authorizedWhenInUse &&
                      locationManager.authorizationStatus != .authorizedAlways {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }

                print("📍 LocationManager status is authorized")
                print("📍 locationManager.location = \(String(describing: locationManager.location))")

                if let userLocation = locationManager.location {
                    print("📍 Location received:")
                    print("Latitude: \(userLocation.latitude), Longitude: \(userLocation.longitude)")

                    if userLocation.latitude.isFinite, userLocation.longitude.isFinite {
                        await viewModel.fetchDoctors(symptom: matchedSpecialty, location: userLocation)
                    } else {
                        print("❗ Invalid coordinates (NaN) – skipping fetch.")
                    }
                } else {
                    print("❗ Location is nil")
                }
            }
        }
    }
}
