import UIKit

class CurrentWeatherViewController: UIViewController {
    var presenter: CurrentWeatherPresenter!

    internal lazy var searchBar: UISearchBar = createSearchBar()
    internal lazy var tableView: UITableView = createTableView()
    internal lazy var loadingIndicator: UIActivityIndicatorView = createLoadingIndicator()
    internal lazy var rootView: UIStackView = createRootView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
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

extension CurrentWeatherViewController: CurrentWeatherView {
    func display(loading: Bool) {
        loadingIndicator.isHidden = !loading
        tableView.isHidden = loading
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

extension CurrentWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }

        searchBar.resignFirstResponder()
        presenter.onSearchButtonTapped(query: query)
    }
}

