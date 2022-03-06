import Foundation
import UIKit

protocol CurrentWeatherRouter {
    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel)
    func displayError(title: String, message: String)
}

final class CurrentWeatherRouterImplementation: CurrentWeatherRouter {
    weak var currentWeatherViewController: CurrentWeatherViewController?

    init(currentWeatherViewController: CurrentWeatherViewController) {
        self.currentWeatherViewController = currentWeatherViewController
    }

    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel) {
        let resultsController = UIAlertController(title: weatherViewModel.title,
                                                  message: "",
                                                  preferredStyle: .actionSheet)

        resultsController.addAction(createAlertAction(title: weatherViewModel.locationName))
        resultsController.addAction(createAlertAction(title: weatherViewModel.locationTemperature))
        resultsController.addAction(createAlertAction(title: weatherViewModel.locationDescription))

        resultsController.addAction(UIAlertAction(title: weatherViewModel.dismissLabel, style: .cancel))

        currentWeatherViewController?.present(resultsController, animated: true) {() -> Void in
            // Disable scene interactions to avoid results dismiss on tapping outside
            resultsController.view.superview?.subviews[0].isUserInteractionEnabled = false
        }
    }

    private func createAlertAction(title: String) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default)
        action.isEnabled = false
        return action
    }

    func displayError(title: String, message: String) {

    }
}
