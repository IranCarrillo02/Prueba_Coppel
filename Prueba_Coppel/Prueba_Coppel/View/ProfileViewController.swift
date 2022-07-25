//
//  ProfileViewController.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 23/07/22.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    var viewModel = MoviesListViewModel()
    var countFav = 0
    var dict = ["Title": [],"Year": [], "Overview": [], "Poster": []]
    var arrTitle: Array<Any> = []
    var arrYear: Array<Any> = []
    var arrOverview: Array<Any> = []
    var arrPoster: Array<Any> = []
    private var apiService = ApiService()
    private var urlString: String = ""
    private var model = [MovieEntity]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var lblProfile: UILabel = {
        let lblProfile = UILabel()
        lblProfile.text = "Perfil"
        lblProfile.font = UIFont.boldSystemFont(ofSize: 35.0)
        lblProfile.textColor = appColors.secondaryColor
        lblProfile.translatesAutoresizingMaskIntoConstraints = false
        
        return lblProfile
    }()
    
    var imgProfile: UIImageView = {
        let imgProfile = UIImageView()
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        imgProfile.image = UIImage(named: "profile")
        
        return imgProfile
    }()
    
    var lblFavorites: UILabel = {
        let lblFavorites = UILabel()
        lblFavorites.text = "Shows favoritos"
        lblFavorites.font = UIFont.boldSystemFont(ofSize: 20.0)
        lblFavorites.textColor = appColors.secondaryColor
        lblFavorites.translatesAutoresizingMaskIntoConstraints = false
        
        return lblFavorites
    }()
    
    var collectionFavs: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 500)
        let collectionFavs = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionFavs.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "favCell")
        collectionFavs.translatesAutoresizingMaskIntoConstraints = false
        collectionFavs.backgroundColor = .clear
        collectionFavs.showsHorizontalScrollIndicator = false
        
        
        return collectionFavs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = appColors.mainColor
        self.view.addSubview(lblProfile)
        self.view.addSubview(imgProfile)
        self.view.addSubview(lblFavorites)
        self.view.addSubview(collectionFavs)
        setLayout()
        getAllItems()
    }
    
    private func getAllItems(){
        do {
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            model = try context.fetch(fetchRequest)
            getFavsCount()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func getFavsCount() {
        for favs in model {
            if favs.favorite {
                dict["Title"]?.append(model[Int(favs.id) - 1].title!)
                dict["Year"]?.append(model[Int(favs.id) - 1].year!)
                dict["Overview"]?.append(model[Int(favs.id) - 1].overview!)
                dict["Poster"]?.append(model[Int(favs.id) - 1].poster!)
                countFav += 1
            }
        }
        
        arrTitle = dict["Title"]!
        arrYear = dict["Year"]!
        arrOverview = dict["Overview"]!
        arrPoster = dict["Poster"]!
        self.collectionFavs.dataSource = self
    }
    
    private func setLayout(){
        lblProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        lblProfile.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imgProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgProfile.topAnchor.constraint(equalTo: lblProfile.bottomAnchor, constant: 40).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant: 160).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: 160).isActive = true
        lblFavorites.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblFavorites.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        lblFavorites.topAnchor.constraint(equalTo: imgProfile.bottomAnchor, constant: 100).isActive = true
        collectionFavs.topAnchor.constraint(equalTo: lblFavorites.bottomAnchor, constant: 20).isActive = true
        collectionFavs.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        collectionFavs.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive = true
        collectionFavs.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8).isActive = true
    }
}

extension ProfileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countFav
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.favTitle.text = arrTitle[indexPath.row] as? String
        cell.favYear.text = convertDateFormater(arrYear[indexPath.row] as? String)
        cell.favOverview.text = arrOverview[indexPath.row] as? String
        let urlRow = arrPoster[indexPath.row] as! String
        let url = URL(string: "https://image.tmdb.org/t/p/w300" + urlRow)
        let data = try? Data(contentsOf: url!)
        cell.favPoster.image = UIImage(data: data!)

        return cell
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
}
