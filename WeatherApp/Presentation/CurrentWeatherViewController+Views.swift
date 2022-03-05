import UIKit

extension CurrentWeatherViewController {
    private enum Constants {
        static let defaultSpacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let searchViewBorderWidth: CGFloat = 2
        static let searchViewCornerRadius: CGFloat = 16
        static let searchViewInsets: CGFloat = 8
        static let searchIcon: String = "SearchIcon"
    }

    private enum AccessibilityIdentifiers {
        static let searchTextView: String = "search_text_view"
        static let searchButton: String = "search_button"
        static let currentWeatherScene: String = "current_weather_scene"
    }

    internal func createSearchBar() -> UISearchBar {
        let bar = UISearchBar()
        bar.placeholder = "Enter location"
        bar.searchTextField.layer.borderWidth = Constants.searchViewBorderWidth
        bar.searchTextField.layer.cornerRadius = Constants.searchViewCornerRadius
        bar.searchTextField.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
        bar.backgroundImage = UIImage()
        bar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        bar.isUserInteractionEnabled = true
        bar.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        bar.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        bar.delegate = self
        return bar
    }

    internal func createRootView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [searchBar, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(Constants.defaultSpacing, after: searchBar)
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }

    internal func createTestLebel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = NSLocalizedString("label", comment: "")
        label.isUserInteractionEnabled = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }

    internal func setupSubviews() {
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = AccessibilityIdentifiers.currentWeatherScene
        view.addSubview(rootView)
    }

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.defaultSpacing),
            rootView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.defaultSpacing),
            rootView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.defaultSpacing),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultSpacing),
            searchBar.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: rootView.trailingAnchor)
        ])
    }

    internal func createActionSheet() {
        let optionMenu = UIAlertController(title: "Current weather for",
                                           message: "The City",
                                           preferredStyle: .actionSheet)

        for option in 1...3 {
            let action = UIAlertAction(title: "Test \(option)", style: .default)
            action.isEnabled = false
            optionMenu.addAction(action)
        }

        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(optionMenu, animated: true) {() -> Void in
            optionMenu.view.superview?.subviews[0].isUserInteractionEnabled = false
        }
    }
}
