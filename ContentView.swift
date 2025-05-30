import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.teal.opacity(0.15), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.teal.opacity(0.2))
                            .frame(width: 100, height: 100)

                        Image(systemName: "cross.case.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.teal)
                    }
                    .padding(.top)

                    Text("AI Health Assistant")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Log symptoms, get instant insights, and track your health journey.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    VStack(spacing: 16) {
                        NavigationLink {
                            SymptomLogView()
                        } label: {
                            Label("Log a Symptom", systemImage: "square.and.pencil")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.teal)
                        .shadow(radius: 2)

                        NavigationLink {
                            SymptomLogHistoryView()
                        } label: {
                            Label("View History", systemImage: "clock.arrow.circlepath")
                        }
                        .buttonStyle(.bordered)
                        .shadow(radius: 1)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
    