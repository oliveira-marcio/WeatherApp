import XCTest

final class CurrentWeatherPageObject: PageObject {
    let sceneId = "current_weather_scene"

    lazy var searchField = sceneElement.searchFields["Enter location"]
    let searchButton = CurrentWeatherPageObject.proxy.keyboards.firstMatch.buttons["Search"]

    lazy var loadingView = CurrentWeatherPageObject.proxy.activityIndicators.firstMatch

    lazy var currentWeatherSheet = CurrentWeatherPageObject.proxy.sheets["Current weather for"]
    lazy var currentWeatherSheetDismissButton = CurrentWeatherPageObject.proxy.sheets["Current weather for"].buttons["Dismiss"]
    
    lazy var nyCurrentWeatherLocation = CurrentWeatherPageObject.proxy.sheets["Current weather for"].buttons["New York, United States of America"]
    lazy var nyCurrentWeatherTemperature = CurrentWeatherPageObject.proxy.sheets["Current weather for"].buttons["4ºC"]
    lazy var nyCurrentWeatherDescription = CurrentWeatherPageObject.proxy.sheets["Current weather for"].buttons["Partly cloudy"]

    lazy var currentWeatherErrorAlert = CurrentWeatherPageObject.proxy.alerts["Error"].staticTexts["Failed to request current weather"]
    lazy var currentWeatherErrorAlertDismissButton = CurrentWeatherPageObject.proxy.alerts["Error"].buttons["Dismiss"]

    lazy var recentSearchTermsView = CurrentWeatherPageObject.proxy.tables["recent_search_term_list"]

    func findRecentSearchElement(with text: String) -> XCUIElement {
        sceneElement.tables.cells.containing(.staticText, identifier: text).element
    }

    func getRecentSearchStrings() -> [String] {
        sceneElement.tables.cells.staticTexts.allElementsBoundByIndex.map(\.label)
    }
}
