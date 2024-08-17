import Foundation

extension Bundle {
    var displayName: String {
        // I'm really sure this will exist in all contexts
        // swiftlint:disable:next force_cast
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
}
