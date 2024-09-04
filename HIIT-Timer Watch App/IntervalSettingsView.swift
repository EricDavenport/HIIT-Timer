import SwiftUI

struct IntervalSettingsView: View {
    @State private var workDuration: Double = 30
    @State private var restDuration: Double = 30
    @ObservedObject var workoutTimer: WorkoutTimer
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Set Intervals")
                    .font(.headline)
                
                VStack {
                    Text("Work Duration:")
                    Slider(value: $workDuration, in: 10...600, step: 10)
                    Text("\(Int(workDuration))s")
                }
                .padding()
                
                VStack {
                    Text("Rest Duration:")
                    Slider(value: $restDuration, in: 10...600, step: 10)
                    Text("\(Int(restDuration))s")
                }
                .padding()
                
                Button("Save") {
                    do {
                        try validateIntervals()
                        workoutTimer.setIntervals(work: workDuration, rest: restDuration)
                        
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Invalid interval settings: \(error.localizedDescription).")
                    }
                }
                .padding()
            }
            .navigationTitle("Intervals")
        }
    }
    
    private func validateIntervals() throws {
        guard workDuration > 0, restDuration > 0 else {
            throw TimerError.invalidInterval("work and rest durations must be greater than zero.")
        }
    }
}

#Preview {
    IntervalSettingsView(workoutTimer: WorkoutTimer())
}
