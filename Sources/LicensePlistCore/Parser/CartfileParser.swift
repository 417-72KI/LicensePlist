import Foundation

public protocol CartfileParserProtocol {
    func parse(content: String) -> [Library]
}

class CartfileParser: CartfileParserProtocol {
    func parse(content: String) -> [Library] {
        let regex = try! NSRegularExpression(pattern: "github \"(\\w+)/(\\w+)\"", options: [])
        let nsContent = content as NSString
        let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length))
        let libraries = matches.map { match -> Library? in
            let numberOfRanges = match.numberOfRanges
            guard numberOfRanges == 3 else {
                assert(false, "maybe invalid regular expression to: \(nsContent.substring(with: match.range))")
                return nil
            }
            return Library(source: .cartfile,
                           name: nsContent.substring(with: match.rangeAt(2)),
                           owner: nsContent.substring(with: match.rangeAt(1)))
            }
            .flatMap { $0 }
        let librarySet = Set(libraries)
        return Array(librarySet).sorted { lhs, rhs in
            if lhs.name == rhs.name {
                return lhs.owner ?? "" < rhs.owner ?? ""
            }
            return lhs.name < rhs.name
        }
    }
}
