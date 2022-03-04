struct Weather: Equatable {
    private let name: String
    private let temperature: Int
    private let description: String

    public init(name: String, temperature: Int, description: String) {
        self.name = name
        self.temperature = temperature
        self.description = description
    }
}
