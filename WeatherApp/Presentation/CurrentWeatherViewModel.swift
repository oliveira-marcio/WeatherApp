struct CurrentWeatherViewModel: Equatable {
    let title: String
    let dismissLabel: String
    let locationName: String
    let locationTemperature: String
    let locationDescription: String

    init(title: String,
         dismissLabel: String,
         locationName: String,
         locationTemperature: String,
         locationDescription: String) {
        self.title = title
        self.dismissLabel = dismissLabel
        self.locationName = locationName
        self.locationTemperature = locationTemperature
        self.locationDescription = locationDescription
    }
}
