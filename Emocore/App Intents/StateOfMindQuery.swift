import AppIntents
import HealthKit

struct StateOfMindQuery: EntityPropertyQuery {
    static var findIntentDescription =
        IntentDescription(
            "Searches for the State of Mind samples in the Health app that match the given criteria.",
            categoryName: "State of Mind",
            searchKeywords: ["mood", "emotion", "momentary", "daily"],
            resultValueName: "State of Mind Samples"
        )

    static var sortingOptions = SortingOptions {
        SortableBy(\.$date)
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
        Property(\.$valenceClassification) {
            // Allow users to select by valence classification by building our own compound components
            // Shortcuts won't display less-than comparators for this type, unfortunately
            EqualToComparator {
                NSCompoundPredicate(andPredicateWithSubpredicates: [
                    HKQuery.predicateForStatesOfMind(withValence: $0.bounds.lower, operatorType: .greaterThanOrEqualTo),
                    HKQuery.predicateForStatesOfMind(withValence: $0.bounds.upper, operatorType: .lessThan),
                ])
            }
            NotEqualToComparator {
                NSCompoundPredicate(orPredicateWithSubpredicates: [
                    HKQuery.predicateForStatesOfMind(withValence: $0.bounds.lower, operatorType: .lessThan),
                    HKQuery.predicateForStatesOfMind(withValence: $0.bounds.upper, operatorType: .greaterThanOrEqualTo),
                ])
            }
        }
        Property(\.$source) {
            EqualToComparator {
                if let source = $0?.healthKitSource {
                    return HKQuery.predicateForObjects(from: source)
                } else {
                    return NSPredicate()
                }
            }
        }
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
        sortedBy: [EntityQuerySort<StateOfMind>],
        limit: Int?
    ) async throws -> [StateOfMind] {
        let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)
        let sortDescriptors = sortedBy.compactMap {
            $0.by == \.$date ? SortDescriptor(
                \HKStateOfMind.startDate,
                order: $0.order == .ascending ? .forward : .reverse
            ) : nil
        }

        let descriptor = HKSampleQueryDescriptor(
            predicates: [.stateOfMind(predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit
        )

        let samples = try await descriptor.result(for: healthStore)
        return try samples.map { try $0.toVendoredStateOfMind() }
    }
}
