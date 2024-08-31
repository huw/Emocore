import AppIntents
import HealthKit

enum StateOfMindValenceClassification: Int, AppEnum {
    case veryUnpleasant = 1
    case unpleasant = 2
    case slightlyUnpleasant = 3
    case neutral = 4
    case slightlyPleasant = 5
    case pleasant = 6
    case veryPleasant = 7

    public static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Valence Classification")

    public static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .veryUnpleasant: "Very Unpleasant",
        .unpleasant: "Unpleasant",
        .slightlyUnpleasant: "Slightly Unpleasant",
        .neutral: "Neutral",
        .slightlyPleasant: "Slightly Pleasant",
        .pleasant: "Pleasant",
        .veryPleasant: "Very Pleasant",
    ]

    // Bounds were determined through trial and error, before realising they're at sevenths
    // The lower bound is inclusive, while the upper bound is strict (even when doing negatives)
    var bounds: (lower: Double, upper: Double) {
        switch self {
        case .veryUnpleasant: (lower: -7 / 7, upper: -5 / 7)
        case .unpleasant: (lower: -5 / 7, upper: -3 / 7)
        case .slightlyUnpleasant: (lower: -3 / 7, upper: -1 / 7)
        case .neutral: (lower: -1 / 7, upper: 1 / 7)
        case .slightlyPleasant: (lower: 1 / 7, upper: 3 / 7)
        case .pleasant: (lower: 3 / 7, upper: 5 / 7)
        case .veryPleasant: (lower: 5 / 7, upper: 7 / 7)
        }
    }

    init?(from: HKStateOfMind.ValenceClassification) {
        self.init(rawValue: from.rawValue)
    }

    var toHKStateOfMindValenceClassification: HKStateOfMind.ValenceClassification? {
        HKStateOfMind.ValenceClassification(rawValue: rawValue)
    }
}
