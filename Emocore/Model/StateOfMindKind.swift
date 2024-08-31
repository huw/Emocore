import AppIntents
import HealthKit

enum StateOfMindKind: Int, AppEnum {
    case momentaryEmotion = 1
    case dailyMood = 2

    public static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Kind")

    public static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
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

    init?(from: HKStateOfMind.Kind) {
        self.init(rawValue: from.rawValue)
    }

    var toHKStateOfMindKind: HKStateOfMind.Kind? {
        HKStateOfMind.Kind(rawValue: rawValue)
    }
}
