import Foundation
import Combine
import WatchKit

enum TimerError: Error {
    case invalidInterval(String)
}

/// `WorkoutTimer` is the core class responsible for managing the workout state and timers.
///  It tracks the current Interval, whether it's work or rest, and handles the countdown logic.
class WorkoutTimer: ObservableObject {
    
    @Published var currentTime: TimeInterval = 0
    @Published var timeRemaining: TimeInterval?
    @Published var totalElapsedTime: TimeInterval = 0
    @Published var isRunning = false
    //    @Published var isActive = false
    //    @Published var isPaused = false
    @Published var isWorkInterval = true
    @Published var currentSet = 1
    
    private var timer: Timer? = nil
    
    /// Properties to store the user-defined interval values (updated by IntervalSettingsView)
    var workDuration: TimeInterval = 30
    var restDuration: TimeInterval = 30
    var totalWorkoutTime: TimeInterval?
    //    private var isResting: Bool = false
    
    /// Store the original values to reset after stop
    private var savedWorkDuration: TimeInterval = 30
    private var savedRestDuration: TimeInterval = 30
    private var savedTotalWorkoutTimer: TimeInterval? = nil
    
    /// Starts the workout timer, resetting if necessary.
    func start() {
        if totalElapsedTime == 0 {
            resetTimer()
        }
        isRunning = true
        scheduleTimer()
    }
    
    /// Pauses the workout, stopping the timer from counting down.
    func pause() {
        isRunning = false
        timer?.invalidate()
    }
    
    /// Stops the workout and resets to initial settings
    func stop() {
        isRunning = false
        timer?.invalidate()
        resetToSavedSettings()
    }
    
    /// Resets the timer to the initial interval settings.
    func resetTimer() {
        currentSet = 1
        isWorkInterval = true
        totalElapsedTime = 0
        timeRemaining = workDuration
    }
    
    /// Resets the timer to the saved settings from IntervalSettingsView.
    private func resetToSavedSettings() {
        workDuration = savedWorkDuration
        restDuration = savedRestDuration
        totalWorkoutTime = savedTotalWorkoutTimer
        resetTimer()
    }
    
    /// Updates the saved settings from the IntervalSettingsView when changes are made.
    func updateSettings(work: TimeInterval, rest: TimeInterval, totalTime: TimeInterval?) {
        self.workDuration = work
        self.restDuration = rest
        self.totalWorkoutTime = totalTime
        self.savedWorkDuration = work
        self.savedRestDuration = rest
        self.savedTotalWorkoutTimer = totalTime
    }
    
    /// Schedules the next tick of the timer, switching between work and rest intervals.
    ///  Includes error handling to ensure timer logic is not interrupted.
    private func scheduleTimer() {
        timer?.invalidate()
        
        guard timeRemaining != nil else {
            // update error
            print("Error: timeRemaining is nil, cannot schedule timer.")
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Ensure timerRemaining is valid
            if let timeRemaining = self.timeRemaining {
                if timeRemaining > 0 {
                    self.timeRemaining! -= 1
                    self.totalElapsedTime += 1
                } else {
                    self.switchInterval()
                }
            } else {
                print("Error: timeRemainging is nil during the timer countdown.")
            }
        }
    }
    
    /// Switches between work and rest intervals.
    /// Includes error handling for invalid durations.
    private func switchInterval() {
        currentSet += 1
        WKInterfaceDevice.current().play(.start)
        if isWorkInterval {
            timeRemaining = restDuration
            isWorkInterval = false
        } else {
            timeRemaining = workDuration
            isWorkInterval = true
        }
        
        guard timeRemaining != nil else {
            print("Error: timeRemaining was set to nil after switching intervals.")
            return
        }
        
        if let totalWorkoutTime = totalWorkoutTime, totalElapsedTime >= totalWorkoutTime {
            WKInterfaceDevice.current().play(.stop)
            stop()
        }
    }
    
    //    var displayTime: String {
    //        let minutes = Int(timeRemaining) / 60
    //        let seconds = Int(timeRemaining) % 60
    //
    //        return String(format:"%02d:%02d", minutes, seconds)
    //    }
    //
    //    func start() throws {
    //        guard workDuration > 0, restDuration > 0 else {
    //            throw TimerError
    //                .invalidInterval("Work duration and rest duration must be greater than zero.")
    //        }
    //
    //        isActive = true
    //        isPaused = false
    //        isResting = false
    //        timeRemaining = workDuration
    //        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    //            self.updateTimer()
    //        }
    //    }
    //
    //    func pause() {
    //        guard isActive else { return }
    //        workDuration = timeRemaining
    //        isActive = false
    //        isPaused = true
    //        timer?.invalidate()
    //    }
    //
    //    func stop() {
    //        guard isPaused else { return }
    //        isActive = false
    //        isPaused = false
    //        timeRemaining = 0
    //        workDuration = 30
    //        timer?.invalidate()
    //    }
    //
    //    private func updateTimer() {
    //        guard timeRemaining > 0 else {
    //            if isResting {
    //                timeRemaining = workDuration
    //            } else {
    //                timeRemaining = restDuration
    //            }
    //            isResting.toggle()
    //            // MARK: Haptic feedback -> May need to adjust depending on real feel during workout
    //            WKInterfaceDevice.current().play(.notification)
    //            return
    //        }
    //        timeRemaining -= 1
    //    }
    //
    //
    //
    //    func setIntervals(work: TimeInterval, rest: TimeInterval) {
    //        workDuration = work
    //        restDuration = rest
    //        timeRemaining = workDuration
    //    }
}
