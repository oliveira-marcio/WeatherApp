import Foundation

struct RecentSearchTermViewModel: Hashable, Equatable {
    let term: String

    init(term: String) {
        self.term = term
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(term.lowercased())
    }
}
