import AppIntents
import HealthKit
import HealthKitUI
import SwiftUI

struct ContentView: View {
    @State var isAuthenticated = false
    @State var isOnboardingPresented = false
    @State var isHealthAccessPresented = false

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
                isOnboardingPresented = true
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
                isAuthenticated = true
            case let .failure(error):
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}

#Preview {
    ContentView()
}
