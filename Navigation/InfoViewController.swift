import UIKit

class InfoViewController: UIViewController {

    private lazy var showAlertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать сообщение", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Информация"

        view.addSubview(showAlertButton)

        NSLayoutConstraint.activate([
            showAlertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAlertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showAlertButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        showAlertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }

    @objc func showAlert() {
        let alert = UIAlertController(title: "Внимание", message: "Вы нажали кнопку!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in print("Нажали Ок") })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in print("Нажали Отмена") })

        present(alert, animated: true)
    }
}
