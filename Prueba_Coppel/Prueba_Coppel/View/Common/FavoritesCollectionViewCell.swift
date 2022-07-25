//
//  FavoritesCollectionViewCell.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 24/07/22.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    var favTitle = UILabel()
    var favYear = UILabel()
    var favOverview = UILabel()
    var favPoster = UIImageView()
    
    private var apiService = ApiService()
    private var urlString: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(favPoster)
        addSubview(favTitle)
        addSubview(favYear)
        addSubview(favOverview)
        configurefavLabel()
        setFavConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurefavLabel(){
        favTitle.numberOfLines = 0
        favTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        favTitle.adjustsFontSizeToFitWidth = true
        favTitle.textColor = appColors.secondaryColor
        
        favYear.numberOfLines = 0
        favYear.font = UIFont.italicSystemFont(ofSize: 10.0)
        favYear.textColor = appColors.secondaryColor
        
        favOverview.numberOfLines = 0
        favOverview.adjustsFontSizeToFitWidth = true
        favOverview.textColor = .white
    }
    
    func setFavConstraints(){
        favPoster.translatesAutoresizingMaskIntoConstraints = false
        favPoster.topAnchor.constraint(equalTo: topAnchor).isActive = true
        favPoster.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        favPoster.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        favPoster.heightAnchor.constraint(equalToConstant: 230).isActive = true
        favPoster.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        favTitle.translatesAutoresizingMaskIntoConstraints = false
        favTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        favTitle.topAnchor.constraint(equalTo: favPoster.bottomAnchor, constant: 10).isActive = true
        favTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        favTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        favYear.translatesAutoresizingMaskIntoConstraints = false
        favYear.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        favYear.topAnchor.constraint(equalTo: favTitle.bottomAnchor, constant: 10).isActive = true
        favYear.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        
        favOverview.translatesAutoresizingMaskIntoConstraints = false
        favOverview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        favOverview.topAnchor.constraint(equalTo: favTitle.bottomAnchor, constant: 25).isActive = true
        favOverview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        favOverview.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
