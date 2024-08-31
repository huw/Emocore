import AppIntents
import HealthKit

enum StateOfMindLabel: Int, AppEnum {
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

    public static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
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

    init?(from: HKStateOfMind.Label) {
        self.init(rawValue: from.rawValue)
    }

    var toHKStateOfMindLabel: HKStateOfMind.Label? {
        HKStateOfMind.Label(rawValue: rawValue)
    }
}
