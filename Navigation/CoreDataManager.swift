//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import CoreData
import StorageService

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Navigation")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed to load: \(error)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func savePost(_ post: Post) {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND postDescription == %@",
            post.author,
            post.description
        )
        
        if let existing = try? viewContext.fetch(request), !existing.isEmpty {
            return
        }
        
        let entity = PostEntity(context: viewContext)
        entity.author = post.author
        entity.postDescription = post.description
        entity.image = post.image
        entity.likes = Int32(post.likes)
        entity.views = Int32(post.views)
        
        try? viewContext.save()
    }
    
    func fetchPosts() -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deletePost(_ postEntity: PostEntity) {
        viewContext.delete(postEntity)
        try? viewContext.save()
    }
}
extension PostEntity {
    func toPost() -> Post {
        Post(
            author: author ?? "",
            description: postDescription ?? "",
            image: image ?? "",
            likes: Int(likes),
            views: Int(views)
        )
    }
}
