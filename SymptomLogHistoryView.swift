import SwiftUI

struct SymptomLogHistoryView: View {
    @StateObject private var viewModel = SymptomLogHistoryViewModel()
    @State private var animateGradient = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.red.opacity(0.8), Color.teal.opacity(0.8)]),
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea(edges: .top)
                .frame(height: 160)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateGradient)
                .onAppear {
                    animateGradient = true
                }

                Text("🩺 Your Health Logs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            ScrollView {
                VStack(spacing: 16) {
                    Button(role: .destructive) {
                        viewModel.clearLogs()
                    } label: {
                        Label("Clear History", systemImage: "trash")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: FindDoctorView(viewModel: FindDoctorViewModel(), matchedSpecialty: "")) {
                        Label("Find a Doctor", systemImage: "stethoscope")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.logs) { log in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("📝 \(log.symptom)")
                                    .font(.headline)
                                    .foregroundColor(.red)

                                Text(log.explanation)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Text("Logged at: \(log.timestamp)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.teal.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .shadow(radius: 3)
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationTitle("")
        .task {
            await viewModel.fetchLogs()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SymptomLogHistoryView()
    }
}
