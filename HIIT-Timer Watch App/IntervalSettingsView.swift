import SwiftUI

struct IntervalSettingsView: View {
    @State private var workDuration: Double = 30
    @State private var restDuration: Double = 30
    @State private var totalWorkoutTime: Double? = nil
    @ObservedObject var workoutTimer: WorkoutTimer
    //    @Environment(\.presentationMode) var presentationMode
    
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



//        ScrollView {
//            VStack {
//                Text("Set Intervals")
//                    .font(.headline)
//
//                VStack {
//                    Text("Work Duration:")
//                    Slider(value: $workDuration, in: 10...600, step: 10)
//                    Text("\(Int(workDuration))s")
//                }
//                .padding()
//
//                VStack {
//                    Text("Rest Duration:")
//                    Slider(value: $restDuration, in: 10...600, step: 10)
//                    Text("\(Int(restDuration))s")
//                }
//                .padding()
//
//                Button("Save") {
//                    do {
//                        try validateIntervals()
//                        workoutTimer.setIntervals(work: workDuration, rest: restDuration)
//
////                        presentationMode.wrappedValue.dismiss()
//                    } catch {
//                        print("Invalid interval settings: \(error.localizedDescription).")
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Intervals")
//        }
//    }
//
//    private func validateIntervals() throws {
//        guard workDuration > 0, restDuration > 0 else {
//            throw TimerError.invalidInterval("work and rest durations must be greater than zero.")
//        }
//    }
//}


#Preview {
    IntervalSettingsView(workoutTimer: WorkoutTimer())
}
