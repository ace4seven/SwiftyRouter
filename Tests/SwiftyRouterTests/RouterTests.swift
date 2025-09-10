import Testing
import SwiftUI
@testable import SwiftyRouter

enum DummyRoute: SwiftyRouter {

    case home, details, settings

    func viewForDestination() -> some View {
        switch self {
        case .home:
            Text("Home")
        case .details:
            Text("Details")
        case .settings:
            Text("Settings")
        }
    }
}

@Suite("Router Core Functionality")
struct RouterTests {

    // Test that pushing a destination increases the path count
    @Test
    func shouldIncreasePathCountWhenPushingDestination() {
        let router = Router<DummyRoute>()
        let initialCount = router.path.count
        router.push(.details)
        #expect(router.path.count == initialCount + 1)
    }

    // Test that popping a destination decreases the path count
    @Test
    func shouldDecreasePathCountWhenPoppingDestination() {
        let router = Router<DummyRoute>()
        router.push(.details)
        let countAfterPush = router.path.count
        router.pop()
        #expect(router.path.count == countAfterPush - 1)
    }

    // Test that popToRoot clears the path
    @Test
    func shouldClearPathWhenPopToRoot() {
        let router = Router<DummyRoute>()
        router.push(.details)
        router.push(.settings)
        router.popToRoot()
        #expect(router.path.count == 0)
    }

    // Test that router initializes empty (no destinations in path)
    @Test
    func shouldHaveEmptyPathWhenInitialized() {
        let router = Router<DummyRoute>()
        #expect(router.path.count == 0)
    }

    // Test that show (modal) navigation does not affect path
    @Test
    func shouldNotChangePathWhenShowingModal() {
        let router = Router<DummyRoute>()
        router.push(.home)
        let countBeforeShow = router.path.count
        router.show(.settings)
        #expect(router.path.count == countBeforeShow)
    }

    // Test that push sets the last destination in path
    @Test
    func shouldSetLastDestinationWhenPushing() {
        let router = Router<DummyRoute>()
        router.push(.settings)
        #expect(router.path.last == .settings)
    }

    // Test that popping with a depth greater than the path count throws SwiftyRouterError.invalidPopDepth
    @Test
    func shouldThrowInvalidPopDepthWhenPoppingTooMany() {
        let router = Router<DummyRoute>()
        router.push(.home)
        // Path has 1 item; popping 2 should throw
        do {
            try router.pop(to: 2)
            #expect(Bool(false), "Expected SwiftyRouterError.invalidPopDepth to be thrown")
        } catch let error as SwiftyRouterError {
            #expect(error == .invalidPopDepth)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
}
