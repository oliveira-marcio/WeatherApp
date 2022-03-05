import UIKit

class CurrentWeatherViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = NSLocalizedString("label", comment: "")
        label.isUserInteractionEnabled = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(label)

        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(createActionSheet))

        label.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func createActionSheet() {
        let optionMenu = UIAlertController(title: "Current weather for",
                                           message: "The City",
                                           preferredStyle: .actionSheet)

        for option in 1...3 {
            let action = UIAlertAction(title: "Test \(option)", style: .default)
            action.isEnabled = false
            optionMenu.addAction(action)
        }

        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(optionMenu, animated: true) {() -> Void in
            optionMenu.view.superview?.subviews[0].isUserInteractionEnabled = false
        }
    }
}

