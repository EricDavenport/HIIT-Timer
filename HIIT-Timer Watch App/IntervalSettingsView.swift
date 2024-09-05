import SwiftUI

struct IntervalSettingsView: View {
    @State private var workDuration: Double = 30
    @State private var restDuration: Double = 30
    @State private var totalWorkoutTime: Double? = nil
    @ObservedObject var workoutTimer: WorkoutTimer
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                
                Section("Work \(Int(workDuration)) secs") {
                    Slider(value: $workDuration, in: 10...300, step: 10) {
                        Text("Work Interval: \(Int(workDuration)) sec")
                    }
                    .padding()
                }
                
                Section("Rest \(Int(restDuration)) secs") {
                    Slider(value: $restDuration, in: 10...300, step: 10) {
                        Text("Rest Interval: \(Int(restDuration)) sec")
                    }
                    .padding()
                }
                
                Section("Total \(Int(totalWorkoutTimeDisplay()) ?? 0) secs") {
                    Slider(value: Binding(
                        get: { self.totalWorkoutTime ?? 0},
                        set: { self.totalWorkoutTime = $0 > 0 ? $0 : nil}
                    ), in: 0...3600, step: 60) {
                        Text("Total Workout Time: \(totalWorkoutTimeDisplay())")
                    }
                    .padding()
                }
                
                Button(action: saveSettings) {
                    Text("Save")
                        .font(.title)
                        .padding()
                }
            }
            .padding()
            .onAppear {
                // Populate sliders with current settings from workoutTimer
                self.workDuration = workoutTimer.workDuration
                self.restDuration = workoutTimer.restDuration
                self.totalWorkoutTime = workoutTimer.totalWorkoutTime
            }
        }
        
        
    }
    /// Saves the settings and updates the `WorkoutTimer` with the user-defined values.
    func saveSettings() {
        workoutTimer.updateSettings(
            work: workDuration,
            rest: restDuration,
            totalTime: totalWorkoutTime
        )
        presentationMode.wrappedValue.dismiss()
    }
    
    /// Returns a string representation of total workout time or `None` is no total time is set.
    func totalWorkoutTimeDisplay() -> String {
        if let totalTime = totalWorkoutTime {
            return "\(Int(totalTime)) sec"
        } else {
            return "None"
        }
    }
}

#Preview {
    IntervalSettingsView(workoutTimer: WorkoutTimer())
}
