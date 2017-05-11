import Foundation
import Himotoki
import LoggerAPI

extension CocoaPodsLicense {
    public static func parse(_ content: String) -> [CocoaPodsLicense] {
        do {
            let plist = try PropertyListSerialization.propertyList(from: content.data(using: String.Encoding.utf8)!,
                                                                    options: [],
                                                                    format: nil)

            return try AcknowledgementsPlist.decodeValue(plist).preferenceSpecifiers
                .filter { $0.isLicense }
                // TODO
                .map { CocoaPodsLicense(library: CocoaPods(name: $0.title, version: nil), body: $0.footerText) }
        } catch let e {
            Log.error(String(describing: e))
            return []
        }
    }
}

struct AcknowledgementsPlist {
    let preferenceSpecifiers: [PreferenceSpecifier]
}

extension AcknowledgementsPlist: Decodable {
    static func decode(_ e: Extractor) throws -> AcknowledgementsPlist {
        return try AcknowledgementsPlist(preferenceSpecifiers: e.array("PreferenceSpecifiers"))
    }
}

struct PreferenceSpecifier {
    let footerText: String
    let title: String
    let type: String
    let license: String?
    var isLicense: Bool { return license != nil }
}

extension PreferenceSpecifier: Decodable {
    static func decode(_ e: Extractor) throws -> PreferenceSpecifier {
        return try PreferenceSpecifier(footerText: e.value("FooterText"),
                                       title: e.value("Title"),
                                       type: e.value("Type"),
                                       license: e.valueOptional("License"))
    }
}
