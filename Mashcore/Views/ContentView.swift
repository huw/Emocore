import AppIntents
import HealthKit
import HealthKitUI
import SwiftUI

struct ContentView: View {
    @AppStorage("hasPresentedOnboarding") private var hasPresentedOnboarding = false
    @State private var isAuthenticated = false
    @State private var isOnboardingPresented = false
    @State private var isHealthAccessPresented = false

    var body: some View {
        VStack {
            ShortcutsLink()
                .disabled(!isAuthenticated)
        }
        .fullScreenCover(
            isPresented: $isOnboardingPresented,
            content: {
                OnboardingView {
                    isHealthAccessPresented = true
                }
            }
        )
        .onAppear {
            if HKHealthStore.isHealthDataAvailable() {
                if !hasPresentedOnboarding {
                    isOnboardingPresented = true
                } else {
                    // Otherwise, just trigger the health request, which should automatically succeed
                    isHealthAccessPresented = true
                }
            }
        }
        .healthDataAccessRequest(
            store: healthStore,
            shareTypes: [HKSampleType.stateOfMindType()],
            readTypes: [HKSampleType.stateOfMindType()],
            trigger: isHealthAccessPresented
        ) { result in
            switch result {
            case .success:
                isOnboardingPresented = false
                hasPresentedOnboarding = true
                isAuthenticated = true
            case let .failure(error):
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}

#Preview {
    let defaults: UserDefaults = {
        let defaults = UserDefaults(suiteName: "PreviewUserDefaults")!
        defaults.set(true, forKey: "hasPresentedOnboarding")
        return defaults
    }()

    ContentView().defaultAppStorage(defaults)
}

#Preview {
    ContentView()
}
