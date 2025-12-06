import XCTest

@MainActor
final class CurrentWeatherPageObject: PageObject {
    private enum LocalizationKeys {
        static let errorTitle = "WeatherRequestFailTitle"
        static let errorMessage = "WeatherRequestFailMessage"
        static let errorDismiss = "WeatherRequestFailDismiss"
        static let resultsTitle = "WeatherResultsTitle"
        static let resultsTemperature = "WeatherResultsTemperature"
        static let resultsDismissLabel = "WeatherResultsDismissLabel"
        static let searchHint = "WeatherSearchHint"
    }

    let sceneId = "current_weather_scene"

    lazy var searchField = sceneElement.searchFields[LocalizationKeys.searchHint.localized()]
    let searchButton = CurrentWeatherPageObject.proxy.keyboards.firstMatch.buttons["Search"]

    lazy var loadingView = CurrentWeatherPageObject.proxy.activityIndicators.firstMatch

    lazy var currentWeatherSheet = CurrentWeatherPageObject.proxy
        .sheets[LocalizationKeys.resultsTitle.localized()]

    lazy var currentWeatherSheetDismissButton = currentWeatherSheet
        .buttons[LocalizationKeys.resultsDismissLabel.localized()]
    
    lazy var nyCurrentWeatherLocation = currentWeatherSheet
        .buttons["New York, United States of America"]

    lazy var nyCurrentWeatherTemperature = currentWeatherSheet
        .buttons[LocalizationKeys.resultsTemperature.localized(arguments: 4)]

    lazy var nyCurrentWeatherDescription = currentWeatherSheet
        .buttons["Partly cloudy"]

    lazy var currentWeatherErrorAlert = CurrentWeatherPageObject.proxy
        .alerts[LocalizationKeys.errorTitle.localized()]
        .staticTexts[LocalizationKeys.errorMessage.localized()]

    lazy var currentWeatherErrorAlertDismissButton = CurrentWeatherPageObject.proxy
        .alerts[LocalizationKeys.errorTitle.localized()]
        .buttons[LocalizationKeys.errorDismiss.localized()]

    lazy var recentSearchTermsView = CurrentWeatherPageObject.proxy.tables["recent_search_term_list"]

    func findRecentSearchElement(with text: String) -> XCUIElement {
        sceneElement.tables.cells.containing(.staticText, identifier: text).element
    }

    func getRecentSearchStrings() -> [String] {
        sceneElement.tables.cells.staticTexts.allElementsBoundByIndex.map(\.label)
    }
}
