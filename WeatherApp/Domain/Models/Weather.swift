struct Weather: Equatable {
    let name: String
    let temperature: Int
    let description: String

    init(name: String, temperature: Int, description: String) {
        self.name = name
        self.temperature = temperature
        self.description = description
    }
}
