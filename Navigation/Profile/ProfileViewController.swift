//
//  ProfileViewController.swift
//  Navigation
//

import UIKit

final class ProfileViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    
    // MARK: - Properties
    
    private var viewModel: ProfileViewModelInput!
    
    static let headerIdent = "header"
    static let photoIdent = "photo"
    static let postIdent = "post"
    
    static var postTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdent)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: photoIdent)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: postIdent)
        return table
    }()
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(Self.postTableView)
        setupConstraints()
        Self.postTableView.dataSource = self
        Self.postTableView.delegate = self
        Self.postTableView.refreshControl = UIRefreshControl()
        Self.postTableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        
        #if DEBUG
        Self.postTableView.backgroundColor = .systemGray2
        #endif
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            Self.postTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            Self.postTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            Self.postTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            Self.postTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func reloadTableView() {
        Self.postTableView.reloadData()
        Self.postTableView.refreshControl?.endRefreshing()
    }
}

// MARK: - DEBUG: ProfileViewModelOutput

extension ProfileViewController: ProfileViewModelOutput {
    func didUpdateStatus(_ status: String) {
        print("Status updated to: \(status)")
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.posts.count  // Используем ViewModel
        default:
            assertionFailure("no registered section")
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = Self.postTableView.dequeueReusableCell(withIdentifier: Self.photoIdent, for: indexPath) as! PhotosTableViewCell
            return cell
        case 1:
            let cell = Self.postTableView.dequeueReusableCell(
                withIdentifier: Self.postIdent, for: indexPath
            ) as! PostTableViewCell
            
            let post = viewModel.posts[indexPath.row]
            cell.configPostArray(post: post)
            
            cell.onDoubleTap = { [weak self] in
                CoreDataManager.shared.savePost(post)
                self?.showSavedToast()
            }
            
            return cell
        default:
            assertionFailure("no registered section")
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.headerIdent) as! ProfileHeaderView
        
        if let user = viewModel.user {
            headerView.configure(with: user)
        }
        
        headerView.onStatusUpdate = { [weak self] newStatus in
            self?.viewModel.updateStatus(newStatus)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 220 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: false)
            coordinator?.showPhotos()
        case 1:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            if let post = cell as? PostTableViewCell {
                post.incrementPostViewsCounter()
            }
        default:
            assertionFailure("no registered section")
        }
    }
    
    private func showSavedToast() {
        let toast = UILabel()
        toast.text = "  ❤️ Saved to Favourites  "
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        toast.textColor = .white
        toast.font = .systemFont(ofSize: 14, weight: .medium)
        toast.layer.cornerRadius = 12
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.textAlignment = .center
        
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            toast.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 1.2, options: [], animations: {
            toast.alpha = 0
        }) { _ in
            toast.removeFromSuperview()
        }
    }
}

