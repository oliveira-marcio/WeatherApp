import UIKit

class CurrentWeatherViewController: UIViewController {

    internal lazy var searchBar: UISearchBar = createSearchBar()
    internal lazy var rootView: UIStackView = createRootView()
    internal lazy var label: UILabel = createTestLebel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()

        // Just to test new mock target and DI
        SceneDelegate.appEnvironment.domain.getCurrentWeatherUseCase.invoke(query: "Lisbon", completion: { result in
            switch result {
            case let .success(weather): print("Weather: \(weather)")
            case .failure(_): print("Error fetching weather")
            }
        })
    }
    
    /**
     * Workaround to force the search bar border color update on traitCollectionDidChange()
     * It should be properly handled in a custom view
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            searchBar.searchTextField.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
        }
    }
}

extension CurrentWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let _ = searchBar.text else {
            return
        }

        searchBar.resignFirstResponder()
        createActionSheet()
    }
}

