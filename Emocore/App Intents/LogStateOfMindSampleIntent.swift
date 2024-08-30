import AppIntents
import HealthKit

struct LogStateOfMindSampleIntent: AppIntent {
    typealias Error = StateOfMindIntentError

    static var title: LocalizedStringResource = "Log State of Mind"
    static var description = IntentDescription(
        "Adds a State of Mind sample into the Health app. You can log a momentary emotion or a daily mood.",
        categoryName: "State of Mind",
        searchKeywords: ["mood", "emotion", "momentary", "daily"],
        resultValueName: "State of Mind"
    )

    @Parameter(
        description: """
        The kind of feeling type captured by a state of mind log, \
        considering the period of time the reflection concerns.
        """,
        requestValueDialog: "Log an Emotion or Mood"
    )
    var kind: StateOfMind.Kind

    @Parameter(
        description: """
        The date and time of the data point. \
        When logging a daily mood, the time component will be ignored. \
        The current date will be used if you don't provide a date.
        """,
        kind: .dateTime,
        requestValueDialog: "When was this sample taken?"
    )
    var date: Date?

    @Parameter(
        description: """
        A signed, self-reported measure of how positive or negative one is feeling, \
        on a continuous scale from -1 to +1.
        """,
        controlStyle: .field,
        inclusiveRange: (-1.0, 1.0),
        requestValueDialog: "Choose how you're feeling right now"
    )
    var valence: Double

    @Parameter(
        description: "A specific word describing a felt experience.",
        requestValueDialog: "What best describes this feeling?"
    )
    var labels: [StateOfMind.Label]?

    @Parameter(
        description: "A general facet of life with which a felt experience may be associated.",
        requestValueDialog: "What's having the biggest impact on you?"
    )
    var associations: [StateOfMind.Association]?

    static var parameterSummary: some ParameterSummary {
        Summary("Log \(\.$kind) of valence \(\.$valence) at \(\.$date)") {
            \.$labels
            \.$associations
        }
    }

    func perform() async throws -> some ReturnsValue<StateOfMind> {
        // Convert the enums, which should work unless the HealthKit coding changes.
        guard let kind = kind.toHKStateOfMindKind else {
            throw Error.unknown("Couldn't convert intent kind to HealthKit kind")
        }

        // For the lists, start by filtering out anything that doesn't convert, then throw if anything got filtered
        let labels = (labels ?? []).compactMap { $0.toHKStateOfMindLabel }
        guard labels.count == (self.labels?.count ?? 0) else {
            throw Error.unknown("Couldn't convert intent labels to HealthKit labels")
        }

        let associations = (associations ?? []).compactMap {
            $0.toHKStateOfMindAssociation
        }
        guard associations.count == (self.associations?.count ?? 0) else {
            throw Error.unknown("Couldn't convert intent associations to HealthKit associations")
        }

        var date = date ?? Date.now
        if kind == .dailyMood {
            // If the daily mood isn't logged today, then set it to 10pm (this is what the Health app does)
            // Throw if, for some reason, this conversion doesn't work
            if !Calendar.current.isDateInToday(date) {
                if let dailyDate = Calendar.current.date(
                    bySettingHour: 22,
                    minute: 0,
                    second: 0,
                    of: date
                ) {
                    date = dailyDate
                } else {
                    throw Error.unknown("Couldn't update intent date to 10:00pm for daily mood")
                }
            }
        }

        let sample = HKStateOfMind(
            date: date,
            kind: kind,
            valence: valence,
            labels: labels,
            associations: associations
        )

        let status = healthStore.authorizationStatus(for: HKSampleType.stateOfMindType())
        if !HKHealthStore.isHealthDataAvailable() {
            throw Error.unavailable
        } else if status != .sharingAuthorized {
            throw Error.unauthorized(status)
        }

        do {
            try await healthStore.save(sample)
            return try .result(value: sample.toVendoredStateOfMind())
        } catch {
            throw Error.unknown(error.localizedDescription)
        }
    }
}
