extension WeatherAPI {
    struct RequestEntity: Decodable {
        let type: String
        let query: String
        let language: String
        let unit: String
    }

    struct LocationEntity: Decodable {
        let name: String
        let country: String
        let region: String
        let lat: String
        let lon: String
        let timezoneId: String
        let localtime: String
        let localtimeEpoch: Int
        let utcOffset: String
    }

    struct CurrentWeatherEntity: Decodable {
        let observationTime: String
        let temperature: Int
        let weatherCode: Int
        let weatherIcons: [String]
        let weatherDescriptions: [String]
        let windSpeed: Int
        let windDegree: Int
        let windDir: String
        let pressure: Int
        let precip: Int
        let humidity: Int
        let cloudcover: Int
        let feelslike: Int
        let uvIndex: Int
        let visibility: Int
        let isDay: String
    }

    struct WeatherEntity: Decodable {
        let request: RequestEntity
        let location: LocationEntity
        let current: CurrentWeatherEntity
    }
}

extension Weather {
    init(from weatherEntity: WeatherAPI.WeatherEntity) {
        self.init(name: weatherEntity.request.query,
                  temperature: weatherEntity.current.temperature,
                  description: weatherEntity.current.weatherDescriptions.joined(separator: ","))
    }
}
