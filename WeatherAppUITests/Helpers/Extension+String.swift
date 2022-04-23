import Foundation

extension String {
    func localized(comment: String = "") -> String {
        let bundle = Bundle(for: MockTestCase.self)
        return NSLocalizedString(self, bundle: bundle, comment: comment)
    }

    func localized(comment: String = "", arguments: CVarArg...) -> String {
        String(format: self.localized(comment: comment), arguments: arguments)
    }
}
