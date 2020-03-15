import XCTest
@testable import CountdownView

final class CountdownViewTests: XCTestCase {
    func testCountdownViewFinished() {
        let finishExpectation = XCTestExpectation(description: "countdown did finish")
        let _ = CountdownView(startOn: .constant(true),
                                    steps: ["3️⃣", "2️⃣", "1️⃣", "🔥🔥🔥"]) {
            finishExpectation.fulfill()
        }
        
        wait(for: [finishExpectation], timeout: 5.0)
    }

    static var allTests = [
        ("testCountdownViewFinished", testCountdownViewFinished),
    ]
}
