import UIKit

class ProfileViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Домашнее задание по iOS"
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
        Навигация в iOS и жизненный цикл UIViewController

        Выполнил: Паничкин Кирилл
        """
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),

            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
}
