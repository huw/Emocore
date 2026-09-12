import AppIntents
import HealthKit

enum StateOfMindAssociation: Int, AppEnum {
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

    public static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
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

    init?(from: HKStateOfMind.Association) {
        self.init(rawValue: from.rawValue)
    }

    var toHKStateOfMindAssociation: HKStateOfMind.Association? {
        HKStateOfMind.Association(rawValue: rawValue)
    }

    /// Every case by its display name, lowercased, plus a few spellings people
    /// actually type. Used by the name-based parameters on the log intent so a
    /// Shortcut can pass words it computed at runtime.
    static let byName: [String: Self] = [
        "community": .community,
        "current events": .currentEvents,
        "dating": .dating,
        "education": .education,
        "family": .family,
        "fitness": .fitness,
        "friends": .friends,
        "health": .health,
        "hobbies": .hobbies,
        "identity": .identity,
        "money": .money,
        "partner": .partner,
        "self-care": .selfCare,
        "spirituality": .spirituality,
        "tasks": .tasks,
        "travel": .travel,
        "work": .work,
        "weather": .weather
    ]

    init?(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        // Health renders "Self-Care" and "Current Events"; callers type all sorts of
        // things. Match the display name first, then again with separators normalised,
        // so "self care", "self-care" and "selfCare" all land on the same case.
        if let hit = Self.byName[trimmed] {
            self = hit
            return
        }
        let normalised = trimmed
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
        for (key, value) in Self.byName
        where key.replacingOccurrences(of: "-", with: " ") == normalised {
            self = value
            return
        }
        return nil
    }
}
