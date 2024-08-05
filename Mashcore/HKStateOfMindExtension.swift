import HealthKit

enum StateOfMindConversionError: Error {
    case unknown
}

extension HKStateOfMind {
    func toVendoredStateOfMind() throws -> StateOfMind {
        guard let kind = StateOfMind.Kind(from: kind) else {
            throw StateOfMindConversionError.unknown
        }

        guard let valenceClassification = StateOfMind.ValenceClassification(from: valenceClassification) else {
            throw StateOfMindConversionError.unknown
        }

        // For the lists, start by filtering out anything that doesn't convert, then throw if anything got filtered
        let labels = labels.compactMap { StateOfMind.Label(from: $0) }
        guard labels.count == self.labels.count else {
            throw StateOfMindConversionError.unknown
        }

        let associations = associations.compactMap { StateOfMind.Association(from: $0) }
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
