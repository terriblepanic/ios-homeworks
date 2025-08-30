import UIKit

class ProfileViewController: UIViewController {
    
    private let headerView = ProfileHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .white
        view.addSubview(headerView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeAreaTop = view.safeAreaInsets.top
        headerView.frame = CGRect(
            x: 0,
            y: safeAreaTop,
            width: view.bounds.width,
            height: view.bounds.height
        )
    }

}
