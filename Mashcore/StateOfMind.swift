import AppIntents
import HealthKit

struct StateOfMind: TransientAppEntity {
    init() {
        id = UUID()
    }

    var id: UUID

    @Property(title: "Date")
    var date: Date

    @Property(title: "Kind")
    var kind: Kind

    @Property(title: "Valence")
    var valence: Double

    @Property(title: "Valence Classification")
    var valenceClassification: ValenceClassification

    @Property(title: "Labels")
    var labels: [Label]

    @Property(title: "Associations")
    var associations: [Association]

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

    var kindDescription: String {
        switch kind {
        case .momentaryEmotion: "Moment"
        case .dailyMood: "Day"
        @unknown default:
            fatalError("Unknown kind: \(kind)")
        }
    }

    var name: String {
        "A \(valenceClassificationDescription) \(kindDescription)"
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(
        name: "State of Mind Sample",
        numericFormat: "\(placeholder: .int) State of Mind samples"
    )

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)",
                              subtitle: "\(date.formatted(date: .numeric, time: .shortened))",
                              image: DisplayRepresentation.Image(systemName: "brain.head.profile"))
    }

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

    enum ValenceClassification: Int, AppEnum {
        case veryUnpleasant = 1
        case unpleasant = 2
        case slightlyUnpleasant = 3
        case neutral = 4
        case slightlyPleasant = 5
        case pleasant = 6
        case veryPleasant = 7

        public static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Valence Classification")

        public static var caseDisplayRepresentations: [ValenceClassification: DisplayRepresentation] = [
            .veryUnpleasant: "Very Unpleasant",
            .unpleasant: "Unpleasant",
            .slightlyUnpleasant: "Slightly Unpleasant",
            .neutral: "Neutral",
            .slightlyPleasant: "Slightly Pleasant",
            .pleasant: "Pleasant",
            .veryPleasant: "Very Pleasant",
        ]
    }
}
