import HealthKit

enum StateOfMindConversionError: Error {
    case unknown
}

extension HKStateOfMind {
    func toVendoredStateOfMind() throws -> StateOfMind {
        guard let kind = StateOfMind.Kind(rawValue: kind.rawValue) else {
            throw StateOfMindConversionError.unknown
        }

        guard let valenceClassification = StateOfMind.ValenceClassification(
            rawValue: valenceClassification.rawValue
        ) else {
            throw StateOfMindConversionError.unknown
        }

        // For the lists, start by filtering out anything that doesn't convert, then throw if anything got filtered
        let labels = labels.compactMap { StateOfMind.Label(rawValue: $0.rawValue) }
        guard labels.count == self.labels.count else {
            throw StateOfMindConversionError.unknown
        }

        let associations = associations.compactMap { StateOfMind.Association(rawValue: $0.rawValue) }
        guard associations.count == self.associations.count else {
            throw StateOfMindConversionError.unknown
        }

        var sample = StateOfMind()
        sample.id = uuid
        sample.date = startDate
        sample.kind = kind
        sample.valence = valence
        sample.valenceClassification = valenceClassification
        sample.labels = labels
        sample.associations = associations

        return sample
    }
}
