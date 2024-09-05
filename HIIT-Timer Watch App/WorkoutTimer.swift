import Foundation
import Combine
import WatchKit

enum TimerError: Error {
    case invalidInterval(String)
}

class WorkoutTimer: ObservableObject {
    @Published var timeRemaining: TimeInterval = 0
    @Published var isActive = false
    @Published var isPaused = false
    
    // TODO: add a isFinished bool and do some animated celebration
    // @Published var isFinished = false
    
    private var timer: Timer?
    var workDuration: TimeInterval = 30
    var restDuration: TimeInterval = 30
    private var isResting: Bool = false
    
    var displayTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    func start() throws {
        guard workDuration > 0, restDuration > 0 else {
            throw TimerError
                .invalidInterval("Work duration and rest duration must be greater than zero.")
        }
        
        isActive = true
        isPaused = false
        isResting = false
        timeRemaining = workDuration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    func pause() {
        guard isActive else { return }
        workDuration = timeRemaining
        isActive = false
        isPaused = true
        timer?.invalidate()
    }
    
    func stop() {
        guard isPaused else { return }
        isActive = false
        isPaused = false
        timeRemaining = 0
        workDuration = 30
        timer?.invalidate()
    }
    
    private func updateTimer() {
        guard timeRemaining > 0 else {
            if isResting {
                timeRemaining = workDuration
            } else {
                timeRemaining = restDuration
            }
            isResting.toggle()
            // MARK: Haptic feedback -> May need to adjust depending on real feel during workout
            WKInterfaceDevice.current().play(.notification)
            return
        }
        timeRemaining -= 1
    }
    

    
    func setIntervals(work: TimeInterval, rest: TimeInterval) {
        workDuration = work
        restDuration = rest
        timeRemaining = workDuration
    }
}
