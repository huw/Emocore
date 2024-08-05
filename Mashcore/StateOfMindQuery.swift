import AppIntents
import HealthKit

struct StateOfMindQuery: EntityPropertyQuery {
    static var sortingOptions = SortingOptions {
        // TODO: Sorting
//        SortableBy(\.$date)
//        SortableBy(\.$kind)
//        SortableBy(\.$valence)
    }

    static var properties = QueryProperties {
        Property(\.$date) {
            LessThanComparator { HKQuery.predicateForSamples(withStart: nil, end: $0, options: .strictEndDate) }
            LessThanOrEqualToComparator { HKQuery.predicateForSamples(withStart: nil, end: $0) }
            GreaterThanComparator { HKQuery.predicateForSamples(withStart: $0, end: nil, options: .strictStartDate) }
            GreaterThanOrEqualToComparator { HKQuery.predicateForSamples(withStart: $0, end: nil) }
            IsBetweenComparator { HKQuery.predicateForSamples(withStart: $0, end: $1) }
        }
        Property(\.$kind) {
            EqualToComparator { HKQuery.predicateForStatesOfMind(with: $0.toHKStateOfMindKind!) }
            // No directly supported not-equals predicate, but we can just invert it
            NotEqualToComparator {
                switch $0 {
                case .dailyMood: HKQuery.predicateForStatesOfMind(with: .momentaryEmotion)
                case .momentaryEmotion: HKQuery.predicateForStatesOfMind(with: .dailyMood)
                }
            }
        }
        Property(\.$valence) {
            EqualToComparator { HKQuery.predicateForStatesOfMind(withValence: $0, operatorType: .equalTo) }
            NotEqualToComparator { HKQuery.predicateForStatesOfMind(withValence: $0, operatorType: .notEqualTo) }
            LessThanComparator { HKQuery.predicateForStatesOfMind(withValence: $0, operatorType: .lessThan) }
            LessThanOrEqualToComparator { HKQuery.predicateForStatesOfMind(
                withValence: $0,
                operatorType: .lessThanOrEqualTo
            ) }
            GreaterThanComparator { HKQuery.predicateForStatesOfMind(withValence: $0, operatorType: .greaterThan) }
            GreaterThanOrEqualToComparator { HKQuery.predicateForStatesOfMind(
                withValence: $0,
                operatorType: .greaterThanOrEqualTo
            ) }
        }
        // TODO: Comparators for these
//        Property(\.$valenceClassification) {}
//        Property(\.$labels) {}
//        Property(\.$associations) {}
    }

    func entities(for identifiers: [UUID]) async throws -> [StateOfMind] {
        let predicate = HKQuery.predicateForObjects(with: Set(identifiers))
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.stateOfMind(predicate)],
            sortDescriptors: []
        )

        let samples = try await descriptor.result(for: healthStore)
        return try samples.map { try $0.toVendoredStateOfMind() }
    }

    func entities(
        matching comparators: [NSPredicate],
        mode: ComparatorMode,
        sortedBy _: [EntityQuerySort<StateOfMind>],
        limit: Int?
    ) async throws -> [StateOfMind] {
        let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)

        let descriptor = HKSampleQueryDescriptor(
            predicates: [.stateOfMind(predicate)],
            sortDescriptors: [],
            limit: limit
        )

        let samples = try await descriptor.result(for: healthStore)
        return try samples.map { try $0.toVendoredStateOfMind() }
    }
}