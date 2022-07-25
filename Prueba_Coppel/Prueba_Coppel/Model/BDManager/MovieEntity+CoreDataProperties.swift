//
//  MovieEntity+CoreDataProperties.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 24/07/22.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var id: Int16
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var rate: Double

}

extension MovieEntity : Identifiable {

}
