import AppIntents
import HealthKit

struct Source: AppEntity, Equatable {
    static var defaultQuery = SourceQuery()

    init() {
        id = UUID().uuidString
    }

    @Property(title: "Bundle Identifier")
    var id: String

    @Property()
    var name: String

    var healthKitSource: HKSource?

    static func == (lhs: Source, rhs: Source) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.healthKitSource == rhs.healthKitSource
    }

    var imageSystemName: String {
        switch id {
        case "com.apple.Health": "heart.fill"
        case _ where id.hasPrefix("com.apple.health.") && name.hasSuffix("Watch"): "applewatch"
        case _ where id.hasPrefix("com.apple.health."): "iphone"
        default: "app"
        }
    }

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "State of Mind Sources",
        numericFormat: "\(placeholder: .int) State of Mind sources"
    )

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)", subtitle: "ID: \(id)", image: .init(systemName: imageSystemName))
    }
}
