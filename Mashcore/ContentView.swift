import AppIntents
import HealthKit
import HealthKitUI
import SwiftUI

struct ContentView: View {
    @State var authenticated = false
    @State var trigger = false

    var body: some View {
        ShortcutsLink()
            .disabled(!authenticated)
            .onAppear {
                if HKHealthStore.isHealthDataAvailable() {
                    trigger.toggle()
                }
            }
            .healthDataAccessRequest(
                store: healthStore,
                shareTypes: [HKSampleType.stateOfMindType()],
                readTypes: [],
                trigger: trigger
            ) { result in
                switch result {
                case .success:
                    authenticated = true
                case let .failure(error):
                    fatalError("*** An error occurred while requesting authentication: \(error) ***")
                }
            }
    }
}

#Preview {
    ContentView()
}
