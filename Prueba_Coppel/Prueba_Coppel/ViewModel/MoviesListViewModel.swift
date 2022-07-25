//
//  MoviesListViewModel.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 24/07/22.
//

import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: MoviesListViewModel)
}

class MoviesListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>?
    
    weak var delegate: UpdateTableViewDelegate?
    
    func retrieveDataFromCoreData() {
        
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            
            self.fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            // Notifies the tableView when any changes have occurred to the data
            fetchedResultsController?.delegate = self
            
            // Fetch data
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                print("Failed to initialize FetchedResultsController: \(error)")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.reloadData(sender: self)
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object (indexPath: IndexPath) -> MovieEntity? {
        return fetchedResultsController?.object(at: indexPath)
    }
}
