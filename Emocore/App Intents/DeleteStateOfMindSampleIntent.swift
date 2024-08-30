import AppIntents
import HealthKit

struct DeleteStateOfMindSampleIntent: AppIntent {
    typealias Error = StateOfMindIntentError

    static var title: LocalizedStringResource = "Delete State of Mind"
    static var description = IntentDescription(
        "Deletes a State of Mind sample from the Health app.",
        categoryName: "State of Mind",
        searchKeywords: ["mood", "emotion", "momentary", "daily"]
    )

    @Parameter(
        description: """
        A State of Mind sample. \
        To get a State of Mind sample, use the 'Find State of Mind Samples' Shortcut.
        """,
        requestValueDialog: "Which State of Mind sample?"
    )
    var stateOfMind: StateOfMind

    static var parameterSummary: some ParameterSummary {
        Summary("Delete \(\.$stateOfMind)")
    }

    func perform() async throws -> some ReturnsValue {
        let sample = stateOfMind.healthKitStateOfMind

        let status = healthStore.authorizationStatus(for: HKSampleType.stateOfMindType())
        if !HKHealthStore.isHealthDataAvailable() {
            throw Error.unavailable
        } else if status != .sharingAuthorized {
            throw Error.unauthorized(status)
        }

        guard let sample else {
            throw Error.notFound
        }

        do {
            try await healthStore.delete(sample)
            return .result()
        } catch {
            throw Error.unknown(error.localizedDescription)
        }
    }
}
