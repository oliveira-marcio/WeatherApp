import Foundation

extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    func localized(comment: String = "", arguments: CVarArg...) -> String {
        String(format: self.localized(comment: comment), arguments: arguments)
    }
}
