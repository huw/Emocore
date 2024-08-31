import AppIntents
import HealthKit

enum SourceQueryError: Error {
    case unknown
}

struct SourceQuery: EnumerableEntityQuery {
    static var findIntentDescription =
        IntentDescription(
            "Searches for the State of Mind sources in the Health app that match the given criteria.",
            categoryName: "Source",
            searchKeywords: ["source", "device"],
            resultValueName: "Sources"
        )

    func entities(for identifiers: [String]) async throws -> [Source] {
        try await withCheckedThrowingContinuation { continuation in
            let query = HKSourceQuery(sampleType: .stateOfMindType(),
                                      samplePredicate: nil) { _, sources, error in
                guard let sources = sources else {
                    continuation.resume(throwing: error ?? SourceQueryError.unknown)
                    return
                }

                continuation
                    .resume(returning: sources.map { $0.toVendoredSource() }.filter { identifiers.contains($0.id) })
            }
            healthStore.execute(query)
        }
    }

    func allEntities() async throws -> [Source] {
        try await withCheckedThrowingContinuation { continuation in
            let query = HKSourceQuery(sampleType: .stateOfMindType(),
                                      samplePredicate: nil) { _, sources, error in
                guard let sources = sources else {
                    continuation.resume(throwing: error ?? SourceQueryError.unknown)
                    return
                }

                continuation.resume(returning: sources.map { $0.toVendoredSource() })
            }
            healthStore.execute(query)
        }
    }
}
