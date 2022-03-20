import Foundation
import UIKit

@MainActor protocol CurrentWeatherRouter {
    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel)
    func displayError(errorViewModel: ErrorViewModel)
}

@MainActor final class CurrentWeatherRouterImplementation: CurrentWeatherRouter {
    weak var currentWeatherViewController: CurrentWeatherViewController?

    init(currentWeatherViewController: CurrentWeatherViewController) {
        self.currentWeatherViewController = currentWeatherViewController
    }

    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel) {
        guard let currentWeatherViewController = currentWeatherViewController else { return }

        let resultsController = UIAlertController(title: weatherViewModel.title,
                                                  message: "",
                                                  preferredStyle: .actionSheet)

        resultsController.addAction(createAlertAction(title: weatherViewModel.locationName))
        resultsController.addAction(createAlertAction(title: weatherViewModel.locationTemperature))
        resultsController.addAction(createAlertAction(title: weatherViewModel.locationDescription))

        resultsController.addAction(UIAlertAction(title: weatherViewModel.dismissLabel, style: .cancel))

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

    func displayError(errorViewModel: ErrorViewModel) {
        let alertController = UIAlertController(title: errorViewModel.title,
                                                message: errorViewModel.message,
                                                preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: errorViewModel.dismiss, style: .cancel))

        currentWeatherViewController?.present(alertController, animated: true)
    }
}
