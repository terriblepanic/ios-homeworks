//
//  InfoViewController.swift
//  Navigation
//

import UIKit

final class InfoViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Загрузка todo..."
        return label
    }()

    private lazy var planetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Загрузка планеты..."
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        setupUI()
        loadTodoData()
        loadPlanetData()
    }

    // MARK: - Setup UI

    private func setupUI() {
        createAlertButton()

        view.addSubview(todoLabel)
        view.addSubview(planetLabel)

        NSLayoutConstraint.activate([
            todoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            todoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            planetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 16),
            planetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            planetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func createAlertButton() {
        let button = CustomButton(
            title: "Alert",
            titleColor: .white,
            backgroundColor: .systemPink
        ) { [weak self] in
            self?.tapAlertButton()
        }

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc func tapAlertButton() {
        let alert = UIAlertController(title: "Attention",
                                      message: "How are you feeling?",
                                      preferredStyle: .alert)
        let fine = UIAlertAction(title: "Fine", style: .default) { _ in
            print("Fine")
        }
        alert.addAction(fine)

        let so = UIAlertAction(title: "So-so", style: .destructive) { _ in
            print("So-so")
        }
        alert.addAction(so)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Network

    private func loadTodoData() {
        TodoService.fetchTodo(id: 5) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todo):
                    self?.todoLabel.text = todo.title
                case .failure:
                    self?.todoLabel.text = "Ошибка загрузки todo"
                }
            }
        }
    }

    private func loadPlanetData() {
        PlanetService.fetchPlanet(id: 1) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let planet):
                    self?.planetLabel.text = "Orbital period: \(planet.orbitalPeriod)"
                case .failure:
                    self?.planetLabel.text = "Ошибка загрузки планеты"
                }
            }
        }
    }
}
