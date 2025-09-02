import UIKit

class PostViewController: UIViewController {
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        title = post?.title ?? "Пост"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Информация", style: .plain, target: self, action: #selector(openInfo))
    }

    @objc func openInfo() {
        let info = InfoViewController()
        info.modalPresentationStyle = .pageSheet
        info.modalTransitionStyle = .coverVertical
        present(info, animated: true)
    }

}
