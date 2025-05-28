import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🩺 AI Health Assistant")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink("Log a Symptom") {
                    SymptomLogView()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
