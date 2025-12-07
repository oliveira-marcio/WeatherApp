import Foundation

nonisolated struct RecentSearchTermViewModel: Hashable {
    let term: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(term.lowercased())
    }
}
