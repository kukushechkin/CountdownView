# CountdownView SwiftUI view

![Swift](https://github.com/kukushechkin/CountdownView/workflows/Swift/badge.svg?branch=master)

A simple view to display sequence of views before something important starts.

```swift

@State private var start = false

...

.overlay(
    CountdownView(startOn: $start,
                  steps: ["3️⃣", "2️⃣", "1️⃣", "🔥🔥🔥"].map({ label in
                    AnyView(Text("\(label)")
                        .font(.system(size: 70))
                        .transition(.asymmetric(insertion: .move(edge: .leading),
                                                removal:   .move(edge: .trailing)))
                        .animation(.easeInOut(duration: 0.2)))
                  })) {
        self.workoutManager.makeAndStartNewWorkout(type: .test)
    }
    .background(
        Circle()
            .fill(Color.primary)
            .padding()
            .opacity(0.5)
    )
)

```
