import UIKit

extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
