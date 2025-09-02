import UIKit

class PostViewController: UIViewController {
    var post: Post?
    private let titleBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        title = post?.title ?? "Пост"

        view.addSubview(titleBackgroundView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Информация", style: .plain, target: self, action: #selector(openInfo))
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc func openInfo() {
        let info = InfoViewController()
        info.modalPresentationStyle = .pageSheet
        info.modalTransitionStyle = .coverVertical
        present(info, animated: true)
    }

}
