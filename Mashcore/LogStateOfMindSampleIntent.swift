import AppIntents
import HealthKit

enum StateOfMind {
    enum Kind: Int, AppEnum {
        case momentaryEmotion = 1
        case dailyMood = 2

        public static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Kind")

        public static var caseDisplayRepresentations: [Kind: DisplayRepresentation] = [
            .momentaryEmotion: .init(
                title: "Emotion",
                subtitle: "How you feel right now",
                image: .init(systemName: "clock")
            ),
            .dailyMood: .init(
                title: "Mood",
                subtitle: "How you've felt overall today",
                image: .init(systemName: "sun.horizon.fill")
            ),
        ]
    }

    enum Label: Int, AppEnum {
        case amazed = 1
        case amused = 2
        case angry = 3
        case annoyed = 32
        case anxious = 4
        case ashamed = 5
        case brave = 6
        case calm = 7
        case confident = 33
        case content = 8
        case disappointed = 9
        case discouraged = 10
        case disgusted = 11
        case drained = 34
        case embarrassed = 12
        case excited = 13
        case frustrated = 14
        case grateful = 15
        case guilty = 16
        case happy = 17
        case hopeful = 35
        case hopeless = 18
        case indifferent = 36
        case irritated = 19
        case jealous = 20
        case joyful = 21
        case lonely = 22
        case overwhelmed = 37
        case passionate = 23
        case peaceful = 24
        case proud = 25
        case relieved = 26
        case sad = 27
        case satisfied = 38
        case scared = 28
        case stressed = 29
        case surprised = 30
        case worried = 31

        public static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Label")

        public static var caseDisplayRepresentations: [Label: DisplayRepresentation] = [
            .amazed: "Amazed",
            .amused: "Amused",
            .angry: "Angry",
            .annoyed: "Annoyed",
            .anxious: "Anxious",
            .ashamed: "Ashamed",
            .brave: "Brave",
            .calm: "Calm",
            .confident: "Confident",
            .content: "Content",
            .disappointed: "Disappointed",
            .discouraged: "Discouraged",
            .disgusted: "Disgusted",
            .drained: "Drained",
            .embarrassed: "Embarrassed",
            .excited: "Excited",
            .frustrated: "Frustrated",
            .grateful: "Grateful",
            .guilty: "Guilty",
            .happy: "Happy",
            .hopeful: "Hopeful",
            .hopeless: "Hopeless",
            .indifferent: "Indifferent",
            .irritated: "Irritated",
            .jealous: "Jealous",
            .joyful: "Joyful",
            .lonely: "Lonely",
            .overwhelmed: "Overwhelmed",
            .passionate: "Passionate",
            .peaceful: "Peaceful",
            .proud: "Proud",
            .relieved: "Relieved",
            .sad: "Sad",
            .satisfied: "Satisfied",
            .scared: "Scared",
            .stressed: "Stressed",
            .surprised: "Surprised",
            .worried: "Worried",
        ]
    }

    enum Association: Int, AppEnum {
        case community = 1
        case currentEvents = 2
        case dating = 3
        case education = 4
        case family = 5
        case fitness = 6
        case friends = 7
        case health = 8
        case hobbies = 9
        case identity = 10
        case money = 11
        case partner = 12
        case selfCare = 13
        case spirituality = 14
        case tasks = 15
        case travel = 16
        case work = 17
        case weather = 18

        public static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Association")

        public static var caseDisplayRepresentations: [Association: DisplayRepresentation] = [
            .community: "Community",
            .currentEvents: "Current Events",
            .dating: "Dating",
            .education: "Education",
            .family: "Family",
            .fitness: "Fitness",
            .friends: "Friends",
            .health: "Health",
            .hobbies: "Hobbies",
            .identity: "Identity",
            .money: "Money",
            .partner: "Partner",
            .selfCare: "Self-Care",
            .spirituality: "Spirituality",
            .tasks: "Tasks",
            .travel: "Travel",
            .work: "Work",
            .weather: "Weather",
        ]
    }
}

enum LogStateOfMindError: Error, CustomLocalizedStringResourceConvertible {
    case unknown
    case unavailable
    case unauthorized(HKAuthorizationStatus)

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .unknown: "Something went wrong"
        case .unavailable: "State of Mind data is not available on this device."
        case let .unauthorized(status):
            switch status {
            case .notDetermined: "Please open Mashcore to authorize it to write State of Mind data to the Health app."
            case .sharingDenied: """
                Please go to Settings → Privacy & Security → Health → Mashcore to authorize Mashcore to write State of Mind data to the Health app.
                """
            default: "Something went wrong"
            }
        }
    }
}

struct LogStateOfMindSampleIntent: AppIntent {
    static var title: LocalizedStringResource = "Log State of Mind"
    static var description: IntentDescription =
        "Adds a State of Mind sample into the Health app. You can log a momentary emotion or a daily mood."

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
        "The date and time of the data point. \
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

    func perform() async throws -> some IntentResult {
        // Convert the enums, which should work unless the HealthKit coding changes.
        guard let kind = HKStateOfMind.Kind(rawValue: kind.rawValue) else {
            throw LogStateOfMindError.unknown
        }

        // For the lists, start by filtering out anything that doesn't convert, then throw if anything got filtered
        let labels = (labels ?? []).compactMap { HKStateOfMind.Label(rawValue: $0.rawValue) }
        guard labels.count == (self.labels?.count ?? 0) else {
            throw LogStateOfMindError.unknown
        }

        let associations = (associations ?? []).compactMap { HKStateOfMind.Association(rawValue: $0.rawValue) }
        guard associations.count == (self.associations?.count ?? 0) else {
            throw LogStateOfMindError.unknown
        }

        var date = date ?? Date.now
        if kind == .dailyMood {
            // Throw if, for some reason, this conversion doesn't work
            if let dailyDate = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: date) {
                date = dailyDate
            } else {
                throw LogStateOfMindError.unknown
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
        if healthStore.isHealthDataAvailable() {
            throw LogStateOfMindError.unavailable
        } else if status != .sharingAuthorized {
            throw LogStateOfMindError.unauthorized(status)
        }

        do {
            try await healthStore.save(sample)
        } catch {
            throw LogStateOfMindError.unknown
        }

        return .result()
    }
}
