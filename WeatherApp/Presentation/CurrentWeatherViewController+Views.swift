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

    internal func createSearchTextView() -> UITextView {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = AccessibilityIdentifiers.searchTextView
        textField.layer.borderWidth = Constants.searchViewBorderWidth
        textField.layer.cornerRadius = Constants.searchViewCornerRadius
        textField.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
        textField.textContainerInset = UIEdgeInsets(top: Constants.searchViewInsets,
                                                    left: Constants.searchViewInsets,
                                                    bottom: Constants.searchViewInsets,
                                                    right: Constants.searchViewInsets)
        textField.isScrollEnabled = false
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    internal func createSearchButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = AccessibilityIdentifiers.searchButton
        button.setImage(UIImage(named: Constants.searchIcon), for: .normal)
        button.tintColor = .dynamicColor(light: .black, dark: .white)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        button.addTarget(self, action: #selector(createActionSheet), for: .touchUpInside)
        return button
    }

    internal func createSearchContainerStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [searchTextView, searchButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.smallSpacing
        stackView.axis = .horizontal
        stackView.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        stackView.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return stackView
    }

    internal func createRootView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [searchContainer, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(Constants.defaultSpacing, after: searchContainer)
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
            searchContainer.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            searchContainer.trailingAnchor.constraint(equalTo: rootView.trailingAnchor)
        ])
    }

    @objc private func createActionSheet() {
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
