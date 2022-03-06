import Foundation

enum ConfigurationKey: String {
    case weatherApiBaseUrl = "weather_api_base_url"
    case weatherApiApiKey = "weather_api_api_key"
}

enum Configuration {
    static var infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Configuration Plist file not found.")
        }
        return dict
    }()

    static func config<T>(key: ConfigurationKey) -> T? {
        infoDict[key.rawValue] as? T
    }

    static func baseURL() -> URL {
        guard let baseURL: String = Configuration.config(key: .weatherApiBaseUrl),
              let url = URL(string: "http://\(baseURL)")
        else {
            fatalError("Invalid base url configuration")
        }
        return url
    }

    static func apiKey() -> String {
        guard let urlHost: String = Configuration.config(key: .weatherApiApiKey) else {
            fatalError("Invalid api key configuration")
        }
        return urlHost
    }
}

