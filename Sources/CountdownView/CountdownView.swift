//
//  CountdownView.swift
//  CountdownView
//
//  Created by Kukushkin, Vladimir on 01.03.2020.
//  Copyright © 2020 kukushechkin. All rights reserved.
//

import SwiftUI
import Combine

fileprivate enum CountdownState {
    case notStarted
    case running
    case done
}

fileprivate class Countdown: ObservableObject {
    @Published var index: Int = 0
    @Published var state: CountdownState = .notStarted
    
    private var cancellable: AnyCancellable?
    private var startDate = Date()
    
    func count(_ steps: Int, onFinish: @escaping () -> Void) {
        self.state = .running
        self.index = 0
        self.startDate = Date()
        
        cancellable = Timer.publish(every: 1.0, on: RunLoop.main, in: .default)
            .autoconnect()
            .sink { time in
                let incrementingCounter = Int(self.startDate.distance(to: time))
                if incrementingCounter <= steps - 1 {
                    self.index += 1
                }
                else {
                    self.state = .done
                    self.cancellable?.cancel()
                    onFinish()
                }
            }
    }
}

fileprivate struct CountdownTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0.0, maxWidth: .infinity,
                   minHeight: 0.0, maxHeight: .infinity,
                   alignment: .center)
    }
}

public struct CountdownView: View {
    @ObservedObject private var countdown = Countdown()
    private let isVisible: Bool
    private let steps: [AnyView]
    
    private func getAnotherStepView(_ index: Int) -> AnyView {
        if index >= self.steps.count {
            return AnyView(Text("\(index)"))
        }
        return self.steps[index]
    }
    
    public var body: some View {
        VStack {
            if self.isVisible {
                self.getAnotherStepView(self.countdown.index)
                    .id("CountdownViewText_\(self.countdown.index)")
                    .modifier(CountdownTextModifier())
            }
        }
    }
    
    init(startOn: Binding<Bool>, steps: [AnyView], onFinish: @escaping () -> Void) {
        self.isVisible = startOn.wrappedValue
        self.steps = steps
        if startOn.wrappedValue {
            self.countdown.count(steps.count) {
                onFinish()
                startOn.wrappedValue = false
            }
        }
    }
    
    init(startOn: Binding<Bool>, steps: [String], onFinish: @escaping () -> Void) {
        let viewSteps = steps.map { label in
            // Default appearance
            AnyView(Text("\(label)")
                .font(.system(size: 70))
                .transition(.asymmetric(insertion: .move(edge: .leading),
                                        removal: .move(edge: .trailing)))
                .animation(.easeInOut(duration: 0.2)))
        }
        self.init(startOn: startOn, steps: viewSteps, onFinish: onFinish)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(startOn: .constant(true),
                      steps: ["3️⃣", "2️⃣", "1️⃣", "🔥🔥🔥"].map({ label in
                        AnyView(Text("\(label)")
                            .font(.system(size: 70))
                            .transition(.asymmetric(insertion: .move(edge: .leading),
                                                    removal:   .move(edge: .trailing)))
                            .animation(.easeInOut(duration: 0.2)))
                      })) {
            // done
        }
        .background(
            Circle()
                .fill(Color.primary)
                .padding()
                .opacity(0.5)
        )
    }
}
