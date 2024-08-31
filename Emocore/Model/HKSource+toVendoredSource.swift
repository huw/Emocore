import HealthKit

extension HKSource {
    func toVendoredSource() -> Source {
        var source = Source()

        source.id = bundleIdentifier
        source.name = name
        source.healthKitSource = self

        return source
    }
}
