import Foundation

nonisolated struct RecentSearchTermViewModel: Hashable {
    let term: String

    init(term: String) {
        self.term = term
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(term.lowercased())
    }
}
