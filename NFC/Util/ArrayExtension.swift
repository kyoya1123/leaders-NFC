import Foundation

extension Array where Element: Equatable {
    mutating func replace(_ before: Array.Element, to after: Array.Element) {
        self = self.map { ($0 == before) ? after : $0 }
    }
}
