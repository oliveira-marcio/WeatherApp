import Foundation
import UIKit

@MainActor protocol CurrentWeatherRouter {
    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel)
    func displayError()
}

@MainActor final class CurrentWeatherRouterImplementation: CurrentWeatherRouter {
    private enum LocalizationKeys {
        static let errorTitle = "WeatherRequestFailTitle"
        static let errorMessage = "WeatherRequestFailMessage"
        static let errorDismiss = "WeatherRequestFailDismiss"
        static let resultsTitle = "WeatherResultsTitle"
        static let resultsTemperature = "WeatherResultsTemperature"
        static let resultsDismissLabel = "WeatherResultsDismissLabel"
    }

    weak var currentWeatherViewController: CurrentWeatherViewController?

    init(currentWeatherViewController: CurrentWeatherViewController) {
        self.currentWeatherViewController = currentWeatherViewController
    }

    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel) {
        guard let currentWeatherViewController = currentWeatherViewController else { return }

        let resultsController = UIAlertController(title: LocalizationKeys.resultsTitle.localized(),
                                                  message: "",
                                                  preferredStyle: .actionSheet)

        resultsController.addAction(createAlertAction(title: weatherViewModel.locationName))
        resultsController.addAction(createAlertAction(title: LocalizationKeys.resultsTemperature.localized(arguments: weatherViewModel.locationTemperature)))
        resultsController.addAction(createAlertAction(title: weatherViewModel.locationDescription))

        resultsController.addAction(UIAlertAction(title: LocalizationKeys.resultsDismissLabel.localized(), style: .cancel))

        if let popoverController = resultsController.popoverPresentationController {
            popoverController.sourceView = currentWeatherViewController.view
            popoverController.sourceRect = currentWeatherViewController.view.bounds
            popoverController.permittedArrowDirections = []
        }

        currentWeatherViewController.present(resultsController, animated: true) {() -> Void in
            // Disable scene interactions to avoid results dismiss on tapping outside
            resultsController.view.superview?.subviews[0].isUserInteractionEnabled = false
        }
    }

    private func createAlertAction(title: String) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default)
        action.isEnabled = false
        return action
    }

    func displayError() {
        let alertController = UIAlertController(title: LocalizationKeys.errorTitle.localized(),
                                                message: LocalizationKeys.errorMessage.localized(),
                                                preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: LocalizationKeys.errorDismiss.localized(), style: .cancel))

        currentWeatherViewController?.present(alertController, animated: true)
    }
}
