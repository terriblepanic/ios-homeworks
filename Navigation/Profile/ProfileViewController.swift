import UIKit

final class ProfileViewController: UIViewController {

    private let headerView = ProfileHeaderView()
    private let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        return button
    }()
    private let titleBackgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = .white
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .systemGray6

        view.addSubview(titleBackgroundView)
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bottomButton)
        bottomButton.addTarget(self, action: #selector(bottomButtonPressed), for: .touchUpInside)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func bottomButtonPressed() {
        print("Нажата кнопка 'Выйти'")
    }
}
