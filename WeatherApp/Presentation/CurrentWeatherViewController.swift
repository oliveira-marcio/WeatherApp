import UIKit

class CurrentWeatherViewController: UIViewController {

    internal lazy var searchTextView: UITextView = createSearchTextView()
    internal lazy var searchButton: UIButton = createSearchButton()
    internal lazy var searchContainer: UIStackView = createSearchContainerStackView()
    internal lazy var rootView: UIStackView = createRootView()
    internal lazy var label: UILabel = createTestLebel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }
    
    /**
     * Workaround to force the search text view border color update on traitCollectionDidChange()
     * It should be properly handled in a custom view
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Not the best approach to force the search text view border color update.
        // It should be handled in a custom view
        searchTextView.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
        searchTextView.layoutIfNeeded()
    }
}

