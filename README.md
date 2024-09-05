# HIITimer
___
#### Overview
HIIT Timer is a standalone WatchOS app designed for athletes, runners and fitness enthusiasts who follow High-Intensity Interval Training (HIIT) routines. The app provides customizable interval timing for both woth and rest periods, allowing users to set different workout structures with a focus on ease of use and minimal distractions.

Users can customize their workout intervals (work and rest durations) and optionally, a total workout time. The app allows for complex interval structures such as multiple work/rest combinations. With real-time display of current sets, elapsed time and haptic feedback for transitions between intervals. The app ensures an optimized HIIT workout experience right from the apple watch.
___
#### Features
* Customizable Intervals: Users can set custom durations for work and rest intervals.
* Multiple Cycle Configurations: Supports complex interval cycles such as 2 minutes work, 1 minute rest, or mixed cycles.
* Infinite Mode: Option to keep the timer running until manually stopped.
* Total Workout Time: Ability to set a maximum total workout duration, counting down from the set time.
* Dynamic Display: Shows current set, whether it's a work or rest interval, and the total elapsed time.
* Interactive Timer: Tap the display to toggle between elapsed time, time remaining, or current set number.
* Haptic Feedback: Stronger haptic feedback when intervals end and the workout is completed.
___
#### User Interface
###### Main Timer View:
* Displays the current interval (work/rest) and the time remaining.
* Shows the current set number.
* Buttons for starting, pausing, and stopping the workout.
###### Interval Settings View:
* Sliders tp set workinterval, rest interval and total workout time.
* Save button to apply the changes and return to the main timer screen
___
#### How to Use
1. Set Intervals:
    * Open the `Set Intervals` page to define work, rest and total workout time.
    * Use the sliders page to adjust the durations according to your training plan.
    * Press **Save** to confirm your settings.
1. Start the timer:
    * Press the **Play** button to start the workout
    * The app will automatically switch between work and rest intervals based on the configured settings.
    * User will receive haptic feedback on when to switch from rest to work until the total workout time finishes or until the user stops the workout.
1. Pause and Resume:
    * Press **Pause** to temporarily stop the workout. Press **Play** again to resume.
1. Stop the timer:
    * Press **Stop** to end the workout and reset the timer to the initial values set in the intervals.
1. Track Progress:
    * The display will show the currentset and the interval type (work/rest).
1. Receive Haptic Feedback:
    * You will feel haptic feedback at the end of each interval and a stronger feedback when the workout ends.
___
#### Technical Details
Language and Frameworks:
* Language: Swift
* Framework: SwiftUI, Combine
* Platform: watchOS 7.0+
___
#### Key Components:
`WorkoutTimer`: Class: Manages all workout timing logic, including intervals, total elapsed time, and switching between work/rest periods.
`ContentView`: Displays the current state of the timer and the controls for starting, pausing, and stopping the workout.
`IntervalSettingsView`: Provides UI for adjusting the work and rest intervals and setting a total workout time.
___
#### Core Features:
Timers and Intervals: The `WorkoutTimer` class uses Swift's Timer to track the workout progress. It also updates the display to show the remaining time in each interval.
State Management: Uses the `@Published` property wrapper to bind the timer's state to the views, ensuring real-time UI updates.
Haptic Feedback: Incorporates haptic feedback through `WKInterfaceDevice` for a tactile experience.
___
#### Screenshots
___
#### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/username/HIIT-Workout-Timer.git
    ```
1. Open the project in Xcode:
    ```bash
    cd HIIT-Workout-Timer
    open HIIT-Workout-Timer.xcodeproj
    ```
1. Build and run the project on your Apple Watch simulator or a physical device.
___
#### Future Improvements
* _Heart Rate Monitoring_: Integrating Apple Watch heart rate data to display real-time heart rate during workouts.
* _Workout History_: Adding the ability to log and review past workouts.
* _Additional Interval Types_: Expanding interval types to include warm-up and cool-down phases.