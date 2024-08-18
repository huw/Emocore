import AppIntents
import HealthKit
import HealthKitUI
import SwiftUI

struct ContentView: View {
    @AppStorage("hasPresentedOnboarding") private var hasPresentedOnboarding = false
    @State private var isAuthenticated = false
    @State private var isOnboardingPresented = false
    @State private var isHealthAccessPresented = false

    @State private var shortcutsLinkWidth: CGFloat?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Open Shortcuts") {
                        if let url = URL(string: "shortcuts://") {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Create Shortcut") {
                        if let url = URL(string: "shortcuts://create-shortcut") {
                            UIApplication.shared.open(url)
                        }
                    }
                } footer: {
                    Text("""
                    \(Bundle.main.displayName) provides Shortcuts for adding and retrieving \
                    State of Mind data from HealthKit. You can configure them in the Shortcuts app.
                    """)
                }

                Section {
                    Button("Update Health access") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                } footer: {
                    Text("""
                    To update Health access, go to the Settings app → Privacy & Security → Health.
                    """)
                }

                Section {
                    Button("Open source code on GitHub") {
                        if let url = URL(string: "https://github.com/huw/Emocore") {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Contact support") {
                        if let urlEscaped =
                            "mailto:huw@hyperreal.technology?subject=\(Bundle.main.displayName) support request"
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url =
                                URL(string: urlEscaped) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            .disabled(!isAuthenticated)
            .navigationTitle(Bundle.main.displayName)
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
        let defaults = UserDefaults(suiteName: "Preview")!
        defaults.set(true, forKey: "hasPresentedOnboarding")
        return defaults
    }()

    ContentView().defaultAppStorage(defaults)
}

#Preview {
    ContentView()
}
