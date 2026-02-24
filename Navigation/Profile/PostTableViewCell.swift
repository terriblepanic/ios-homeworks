//
//  PostTableViewCell.swift
//  Navigation
//
import StorageService
import iOSIntPackage
import UIKit

class PostTableViewCell: UITableViewCell {
    
    private var viewCounter = 0
    private let imageProcessor = ImageProcessor()
    
    var onDoubleTap: (() -> Void)?
    
    var postAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    var postImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    var postDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    var postLikes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()


    var postViews: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    // MARK: - Init section
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(postAuthor, postImage, postDescription, postLikes, postViews)
        setupConstraints()
        setupDoubleTap()
        self.selectionStyle = .default
    }

    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    
    // MARK: - Double tap
    
    private func setupDoubleTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc private func handleDoubleTap() {
        onDoubleTap?()
        
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.contentView.alpha = 1.0
            }
        }
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            postAuthor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.indent),
            postAuthor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            postAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),

            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor, multiplier: 0.56),
            postImage.topAnchor.constraint(equalTo: postAuthor.bottomAnchor, constant: LayoutConstants.indent),

            postDescription.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: LayoutConstants.indent),
            postDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            postDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),

            postLikes.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: LayoutConstants.indent),
            postLikes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            postLikes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.indent),

            postViews.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: LayoutConstants.indent),
            postViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),
            postViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.indent)
        ])
    }

    // MARK: - Configure
    
    func configPostArray(post: Post) {
        postAuthor.text = post.author
        postDescription.text = post.description
        
        if let originalImage = UIImage(named: post.image) {
            imageProcessor.processImage(sourceImage: originalImage, filter: .noir) { processedImage in
                DispatchQueue.main.async {
                    self.postImage.image = processedImage ?? originalImage
                }
            }
        }
        
        postLikes.text = "Likes: \(post.likes)"
        viewCounter = post.views
        postViews.text = "Views: \(viewCounter)"
    }
    
    func incrementPostViewsCounter() {
        viewCounter += 1
        postViews.text = "Views: \(viewCounter)"
    }
}
