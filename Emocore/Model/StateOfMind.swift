import AppIntents
import HealthKit

struct StateOfMind: AppEntity {
    typealias Kind = StateOfMindKind
    typealias Label = StateOfMindLabel
    typealias Association = StateOfMindAssociation
    typealias ValenceClassification = StateOfMindValenceClassification

    static var defaultQuery = StateOfMindQuery()

    init() {
        id = UUID()
    }

    var id: UUID

    @Property()
    var date: Date

    @Property()
    var kind: Kind

    @Property()
    var valence: Double

    @Property()
    var valenceClassification: ValenceClassification

    @Property()
    var labels: [Label]

    @Property()
    var associations: [Association]

    var healthKitStateOfMind: HKStateOfMind?

    var kindDescription: String {
        switch kind {
        case .momentaryEmotion: "Moment"
        case .dailyMood: "Day"
        @unknown default:
            fatalError("Unknown kind: \(kind)")
        }
    }

    var valenceClassificationDescription: String {
        switch valenceClassification {
        case .neutral: "Neutral"
        case .pleasant: "Pleasant"
        case .slightlyPleasant: "Slightly Pleasant"
        case .slightlyUnpleasant: "Slightly Unpleasant"
        case .unpleasant: "Unpleasant"
        case .veryPleasant: "Very Pleasant"
        case .veryUnpleasant: "Very Unpleasant"
        @unknown default:
            fatalError("Unknown valence classification: \(valenceClassification)")
        }
    }

    var name: String {
        "A \(valenceClassificationDescription) \(kindDescription)"
    }

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "State of Mind Samples",
        numericFormat: "\(placeholder: .int) State of Mind samples",
        synonyms: ["Mood", "Emotion"]
    )

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)",
                              subtitle: "\(date.formatted(date: .numeric, time: .shortened))",
                              image: DisplayRepresentation.Image(systemName: "brain.head.profile"))
    }
}
