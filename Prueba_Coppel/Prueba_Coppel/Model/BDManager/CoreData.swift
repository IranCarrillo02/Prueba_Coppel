//
//  CoreData.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 24/07/22.
//

import UIKit
import CoreData

class CoreData {
    
    private var id = 1
    static let sharedInstance = CoreData()
    private init(){}
    
    private let continer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private let fetchRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    
    func saveDataOf(movies:[Movie]) {
        
        self.continer?.performBackgroundTask{ [weak self] (context) in
            self?.deleteObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(movies: movies, context: context)
        }
    }
    
    private func deleteObjectsfromCoreData(context: NSManagedObjectContext) {
        do {
            let objects = try context.fetch(fetchRequest)
            _ = objects.map({context.delete($0)})
            try context.save()
        } catch {
            print("Deleting Error: \(error)")
        }
    }
    
    private func saveDataToCoreData(movies:[Movie], context: NSManagedObjectContext) {
        context.perform {
            for movie in movies {
                let movieEntity = MovieEntity(context: context)
                movieEntity.id = Int16(self.id)
                movieEntity.title = movie.title
                movieEntity.year = movie.year
                movieEntity.overview = movie.overview
                movieEntity.poster = movie.posterImage
                movieEntity.rate = movie.rate!
                movieEntity.favorite = false
                self.id += 1
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
