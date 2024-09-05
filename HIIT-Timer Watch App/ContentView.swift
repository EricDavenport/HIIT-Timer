import SwiftUI
import Combine
import WatchKit

/// `ContentView` is the main interface for the workout timer app.
/// It displays the current set, whether its a work or rest set, and managers userinteractioon with the timer
struct ContentView: View {
    @ObservedObject var workoutTimer = WorkoutTimer()
    
    @State private var showingIntervalSettings = false
    @State private var showingElapsedTime = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        VStack {
                            Text(currentDisplay())
                            Text(intervalTypeDisplay())
                        }
                        Text(timerDisplay())
                            .font(.system(size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .layoutPriority(1)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                toggleTimerDisplay()
                            }
                            .padding()
                    }
                    .frame(height: 100)
                    HStack {
                        Button(action: {
                            workoutTimer.isRunning ? workoutTimer.pause() : workoutTimer.start()
                        }) {
                            Image(systemName: workoutTimer.isRunning ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 40))
                                .padding()
                        }
                        
                        Button(action: {
                            workoutTimer.stop()
                        }) {
                            Image(systemName: "stop.circle.fill")
                                .font(.system(size: 40))
                                .padding()
                                .foregroundColor(workoutTimer.isRunning ? .gray : .red)
                        }
                        .disabled(workoutTimer.isRunning)
                    }
                    .padding()
                    
                    Button("Intervals") {
                        showingIntervalSettings.toggle()
                    }
                    .font(.title2)
                    .padding()
                    .sheet(isPresented: $showingIntervalSettings) {
                        IntervalSettingsView(workoutTimer: workoutTimer)
                    }
                }
            }
        }
    }
    
    /// Displays the current set number.
    func currentDisplay() -> String {
        return "Set \(workoutTimer.currentSet)"
    }
    
    /// Displays whether the current interval is a work or rest interval.
    func intervalTypeDisplay() -> String {
        return workoutTimer.isWorkInterval ? "Work" : "Rest"
    }
    
    /// Toggkes between showing the elapsed time and the remaining time when tapping the timer.
    func toggleTimerDisplay() {
        showingElapsedTime.toggle()
    }
    
    /// Dispalys either the elapsed time or the remaining time based on the user interaction
    func timerDisplay() -> String {
        if showingElapsedTime {
            return formattedTime(workoutTimer.totalElapsedTime)
        } else if let timeRemaining = workoutTimer.timeRemaining {
            return formattedTime(timeRemaining)
        } else {
            return "N/A"
        }
    }
    
    /// Formats a TimeInterval (seconds) into a MM:SS format
    func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
