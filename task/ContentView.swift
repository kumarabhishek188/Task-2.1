
import SwiftUI

// TaskItem view definition
struct TaskItem: View {
    var title: String
    var points: Int
    var hasTimer: Bool
    var isLeaderboardWinner: Bool // New property to distinguish winner
    
    @State private var timeRemaining = 3600 // 1 hour in seconds for the countdown
    @State private var timer: Timer?
    @State private var buttonTapped = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                if isLeaderboardWinner {
                    Image(systemName: "trophy.fill") // Trophy icon for the leaderboard winner
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center) // Center title and icon
            
            if hasTimer {
                Text("Next claim in: \(timeFormatted(timeRemaining))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .transition(.opacity) // Smooth transition
                    .animation(.easeInOut, value: timeRemaining) // Animate the countdown text
            }
            
            Text("\(points) Points")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Button(action: buttonAction) {
                Text(hasTimer ? "Claim Now" : "Share")
                    .foregroundColor(.white)
                    .padding()
                    .background(buttonTapped ? Color.orange : Color.blue) // Animated button color change
                    .cornerRadius(5)
                    .scaleEffect(buttonTapped ? 1.1 : 1.0) // Button scaling effect
                    .animation(.spring(), value: buttonTapped) // Smooth button scale animation
            }
        }
        .frame(width: 300, height: 150) // Fixed frame for equal size
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.8), .gray.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
        )
        .shadow(radius: 5)
        .padding(.horizontal)
        .onAppear {
            if hasTimer {
                runTimer()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func buttonAction() {
        buttonTapped.toggle() // Trigger animation when button is clicked
        if hasTimer {
            print("Claim now")
        } else {
            print("Share with friends")
        }
    }

    private func runTimer() {
        timer?.invalidate() // Cancel the previous timer if any
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                withAnimation { // Animate the countdown
                    timeRemaining -= 1
                }
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d min %02d sec", minutes, seconds)
    }
}

// ContentView that uses TaskItem
struct ContentView: View {
    var body: some View {
        ZStack {
            // Dark mode background with gradient
            LinearGradient(gradient: Gradient(colors: [.black, .gray]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea() // Full screen gradient
            
            VStack(spacing: 20) {
                // Monthly Leaderboard Winner TaskItem with trophy
                TaskItem(title: "Monthly Leaderboard Winner", points: 100, hasTimer: false, isLeaderboardWinner: true)
                
                // Other simple tasks without the trophy
                TaskItem(title: "Share With 5 friends!", points: 10, hasTimer: false, isLeaderboardWinner: false)
                TaskItem(title: "Claim 10 Point Every Hour", points: 10, hasTimer: true, isLeaderboardWinner: false)
            }
            .padding()
        }
    }
}

