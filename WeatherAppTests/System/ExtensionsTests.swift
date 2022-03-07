import XCTest
@testable import WeatherApp

final class ExtensionsTests: XCTestCase {
    // MARK: UIColor

    func test_GIVEN_dynamic_color_with_light_and_dark_colors_WHEN_trait_is_light_style_THEN_it_should_return_the_light_one() {
        let lightColor = UIColor.black
        let darkColor = UIColor.white

        let lightTrait = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .light)])
        let dynamicColor: UIColor = .dynamicColor(light: lightColor, dark: darkColor)

        XCTAssertEqual(dynamicColor.resolvedColor(with: lightTrait), lightColor)
    }

    func test_GIVEN_dynamic_color_with_light_and_dark_colors_WHEN_trait_is_dark_style_THEN_it_should_return_the_dark_one() {
        let lightColor = UIColor.black
        let darkColor = UIColor.white

        let darkTrait = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .dark)])
        let dynamicColor: UIColor = .dynamicColor(light: lightColor, dark: darkColor)

        XCTAssertEqual(dynamicColor.resolvedColor(with: darkTrait), darkColor)
    }

    // MARK: Collection

    func test_GIVEN_list_and_valid_index_WHEN_element_at_safe_index_is_read_THEN_it_should_return_element() {
        let list = [1, 2, 3]

        XCTAssertEqual(list[safe: 1], 2)
    }

    func test_GIVEN_list_and_invalid_index_WHEN_element_at_safe_index_is_read_THEN_it_should_return_nil() {
        let list = [1, 2, 3]

        XCTAssertNil(list[safe: 10])
    }
}
