import AppIntents
import HealthKit

// Which labels belong with which valence.
//
// HealthKit exposes no valence metadata on `HKStateOfMind.Label`, so this grouping is a
// proposal rather than a reading of Apple's own. It follows what the Health app does in
// practice — pick Very Pleasant and it does not go on to offer Angry — without trying to
// reproduce Apple's exact curation, which isn't published.
//
// The bands are deliberately generous. Only the two extremes filter at all; anywhere in
// the middle every label stays available, because a merely slightly-unpleasant moment
// really can be both anxious and hopeful, and hiding one of those would make the picker
// wrong rather than tidy.
extension StateOfMindLabel {
    /// Labels that read as positive. Offered from Neutral upward.
    static let pleasant: Set<Self> = [
        .amazed, .amused, .brave, .calm, .confident, .content, .excited, .grateful,
        .happy, .hopeful, .joyful, .passionate, .peaceful, .proud, .relieved,
        .satisfied, .surprised,
    ]

    /// Labels that read as negative. Offered from Neutral downward.
    static let unpleasant: Set<Self> = [
        .angry, .annoyed, .anxious, .ashamed, .disappointed, .discouraged, .disgusted,
        .drained, .embarrassed, .frustrated, .guilty, .hopeless, .indifferent,
        .irritated, .jealous, .lonely, .overwhelmed, .sad, .scared, .stressed,
        .surprised, .worried,
    ]

    /// The labels worth offering at a given valence.
    ///
    /// Above +1/3 the unpleasant ones are dropped, below -1/3 the pleasant ones are, and
    /// in between nothing is hidden. `Surprised` sits in both sets on purpose: it is the
    /// one word here that genuinely goes either way.
    static func offered(at valence: Double?) -> [Self] {
        guard let valence else { return allCases }
        let allowed: Set<Self>
        switch valence {
        case 1.0 / 3.0...: allowed = pleasant
        case ...(-1.0 / 3.0): allowed = unpleasant
        default: return allCases
        }
        return allCases.filter { allowed.contains($0) }
    }
}

extension StateOfMindAssociation {
    /// Associations are facets of life, not feelings, so none of them belong to a
    /// valence. Every one is offered whatever the valence — this exists only so the two
    /// pickers are configured the same way.
    static func offered(at valence: Double?) -> [Self] { allCases }
}

/// Offers only the labels that suit the valence already chosen.
struct StateOfMindLabelOptions: DynamicOptionsProvider {
    @IntentParameterDependency<LogStateOfMindSampleIntent>(\.$valence)
    var logIntent

    func results() async throws -> [StateOfMindLabel] {
        StateOfMindLabel.offered(at: logIntent?.valence)
    }
}
