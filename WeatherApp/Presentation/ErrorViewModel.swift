struct ErrorViewModel: Equatable {
    let title: String
    let message: String
    let dismiss: String

    init(title: String,
         message: String,
         dismiss: String) {
        self.title = title
        self.message = message
        self.dismiss = dismiss
    }
}
