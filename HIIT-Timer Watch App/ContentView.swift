import SwiftUI
import Combine
import WatchKit

struct ContentView: View {
    @ObservedObject var workoutTimer = WorkoutTimer()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(workoutTimer.displayTime)
                    .font(.system(size: 40))
                    .padding()
                
                HStack {
                    // MARK: Start button
                    Button(action: {
                        if workoutTimer.isActive {
                            workoutTimer.pause()
                        } else {
                            do {
                                try workoutTimer.start()
                            } catch {
                                print("Error starting timer: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Image(systemName: workoutTimer.isActive ? "pause" : "play")
                    }
                    .padding()
                    .disabled(false)  // button always active
                    
                    // MARK: Stop Button
                    Button(action: {
                        workoutTimer.stop()
                    }) {
                        Image(systemName: "stop")
                    }
                    .padding()
                    .disabled(!workoutTimer.isPaused)  // only enabled when play == pause
                }
                
                NavigationLink(destination: IntervalSettingsView(workoutTimer: workoutTimer)) {
                    Text("Set Intervals")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
