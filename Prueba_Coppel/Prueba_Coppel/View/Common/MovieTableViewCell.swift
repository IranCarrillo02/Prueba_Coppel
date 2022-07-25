//
//  MovieTableViewCell.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 23/07/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    var moviePoster = UIImageView()
    var movieFavorite = UIImageView()
    var movieTitle = UILabel()
    var movieYear = UILabel()
    var movieOverview = UILabel()
    
    private var apiService = ApiService()
    private var urlString: String = ""
    
    
    func setCellWithValuesOf(_ movie: MovieEntity) {
        addSubview(moviePoster)
        addSubview(movieFavorite)
        addSubview(movieTitle)
        addSubview(movieYear)
        addSubview(movieOverview)
        
        configureImageView()
        configureTitleLabel()
        configureYearLabel()
        configureOverviewLabel()
        setImageConstraints()
        setImageFavConstraints()
        setTitleLabelConstraints()
        setYearLabelConstraints()
        setOverviewLabelConstraints()
        updateUI(title: movie.title, releaseDate: movie.year, overview: movie.overview, poster: movie.poster, favorite: movie.favorite)
    }
    
    private func updateUI(title: String?, releaseDate: String?, overview: String?, poster: String?, favorite: Bool?) {
          
        self.movieTitle.text = title
        self.movieYear.text = convertDateFormater(releaseDate)
        self.movieOverview.text = overview

        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString

        guard let posterImageURL = URL(string: urlString) else {
          self.moviePoster.image = UIImage(named: "noImageAvailable")
          return
        }

        // Before we download the image we clear out the old one
        self.moviePoster.image = nil

        apiService.getImageDataFrom(url: posterImageURL) { [weak self] (data: Data) in
                if let image = UIImage(data: data) {
                    self?.moviePoster.image = image
                } else {
                    self?.moviePoster.image = UIImage(named: "noImageAvailable")
                }
            }
        if favorite ?? false {
            movieFavorite.image = UIImage(named: "fav")
        } else {
            movieFavorite.image = UIImage(named: "unfav")
        }
    }
    
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
    
    /*required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    func configureImageView(){
        moviePoster.layer.cornerRadius = 15
        moviePoster.clipsToBounds = true
    }
    
    func configureTitleLabel(){
        movieTitle.numberOfLines = 0
        movieTitle.adjustsFontSizeToFitWidth = true
        movieTitle.textColor = appColors.secondaryColor
    }
    
    func configureYearLabel(){
        movieYear.numberOfLines = 0
        movieYear.adjustsFontSizeToFitWidth = true
        movieYear.textColor = appColors.secondaryColor
    }
    func configureOverviewLabel(){
        movieOverview.numberOfLines = 0
        movieOverview.adjustsFontSizeToFitWidth = true
        movieOverview.textColor = .white
    }

    func setImageConstraints(){
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moviePoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        moviePoster.heightAnchor.constraint(equalToConstant: 150).isActive = true
        moviePoster.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setImageFavConstraints(){
        movieFavorite.translatesAutoresizingMaskIntoConstraints = false
        movieFavorite.leadingAnchor.constraint(equalTo: movieTitle.trailingAnchor, constant: -12).isActive = true
        movieFavorite.heightAnchor.constraint(equalToConstant: 24).isActive = true
        movieFavorite.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    func setTitleLabelConstraints(){
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 20).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    func setYearLabelConstraints(){
        movieYear.translatesAutoresizingMaskIntoConstraints = false
        movieYear.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 20).isActive = true
        movieYear.heightAnchor.constraint(equalToConstant: 20).isActive = true
        movieYear.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 8).isActive = true
        movieYear.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    func setOverviewLabelConstraints(){
        movieOverview.translatesAutoresizingMaskIntoConstraints = false
        movieOverview.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 20).isActive = true
        movieOverview.heightAnchor.constraint(equalToConstant: 80).isActive = true
        movieOverview.topAnchor.constraint(equalTo: movieYear.bottomAnchor, constant: 12).isActive = true
        movieOverview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
}
