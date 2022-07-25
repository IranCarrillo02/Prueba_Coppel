//
//  MovieModel.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 23/07/22.
//

import Foundation

struct MoviesData: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable {
    
    let title: String?
    let year: String?
    let posterImage: String?
    let overview: String?
    let rate: Double?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview
        case year = "release_date"
        case posterImage = "poster_path"
        case rate = "vote_average"
    }
}
