import Foundation
import HealthKit

enum StateOfMindIntentError: Swift.Error, CustomLocalizedStringResourceConvertible {
    case unknown(String)
    case unavailable
    case unauthorized(HKAuthorizationStatus)
    case notFound
    case valenceOutOfRange(Double)

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case let .unknown(description): "Something went wrong: \(description)"
        case .unavailable: "State of Mind data is not available on this device."
        case .notFound: "This State of Mind sample wasn't found in the Health app."
        case let .unauthorized(status):
            switch status {
            case .notDetermined: """
                Please open \(Bundle.main
                    .displayName) to authorize it to write State of Mind data to the Health app.
                """
            case .sharingDenied: """
                Please go to Settings → Privacy & Security → Health → \(Bundle.main.displayName) \
                to authorize \(Bundle.main.displayName) to write State of Mind data to the Health app.
                """
            default: "Something went wrong"
            }
        case let .valenceOutOfRange(valence): """
            State of Mind valence must be between -1 and 1, but \(valence) is out of that range.
            """
        }
    }
}
