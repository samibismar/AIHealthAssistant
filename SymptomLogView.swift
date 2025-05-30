import SwiftUI

struct SymptomLogView: View {
    @StateObject private var viewModel = SymptomLogViewModel()
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [Color.teal.opacity(0.3), Color.white]),
                    center: .top,
                    startRadius: 5,
                    endRadius: 300
                )
                .frame(height: 160)
                .ignoresSafeArea(edges: .top)

                VStack(spacing: 8) {
                    ECGWaveformView()
                        .frame(height: 50)

                    Text("Describe Your Symptom")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }

            TextField("e.g. sore throat, headache...", text: $viewModel.symptomText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button(action: {
                Task {
                    isLoading = true
                    await viewModel.sendSymptomToServer()
                    isLoading = false
                }
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send to AI")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.teal)
            .padding(.horizontal)
            .disabled(isLoading)

            if isLoading {
                ShimmerView()
            }

            if !viewModel.explanation.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("🧠 GPT's Explanation")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    ScrollView {
                        Text(viewModel.explanation)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 4)
                    }
                    .frame(minHeight: 100, maxHeight: 250)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.teal.opacity(0.2), lineWidth: 1)
                )
                .shadow(radius: 3)
                .padding(.horizontal)
            }

            NavigationLink(destination: SymptomLogHistoryView()) {
                HStack {
                    Image(systemName: "list.bullet.rectangle")
                    Text("See My Symptom History")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .navigationTitle("")
    }
}

struct ShimmerView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 120)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
            .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        SymptomLogView()
    }
}

struct ECGWaveformView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                var path = Path()
                let pattern: [CGFloat] = [
                    0, 0.2, 1, 0.2,    // P wave
                    -1, 3.5, -2, 0,    // QRS complex (smoothed slightly)
                    0.5, 0.3, 0,       // T wave
                    0, 0, 0            // rest
                ]
                let stepWidth: CGFloat = 2.0
                let patternLength = pattern.count
                let offset = CGFloat(time * 60).truncatingRemainder(dividingBy: CGFloat(patternLength) * stepWidth)

                for i in 0..<Int(size.width / stepWidth) {
                    let x = CGFloat(i) * stepWidth
                    let position = (CGFloat(i) + offset / stepWidth)
                    let index = Int(floor(position)) % patternLength
                    let nextIndex = (index + 1) % patternLength
                    let fraction = position - floor(position)
                    let interpolatedValue = pattern[index] * (1 - fraction) + pattern[nextIndex] * fraction
                    let y = size.height / 2 - interpolatedValue * 10

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }

                context.stroke(path, with: .color(.teal), lineWidth: 2)
            }
        }
    }
}
