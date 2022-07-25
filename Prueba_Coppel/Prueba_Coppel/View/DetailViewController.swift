//
//  DetailViewController.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 23/07/22.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var viewModel: MovieDetailsViewModel!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var model = [MovieEntity]()
    var index = 0
    
    var imgMovie: UIImageView = {
        let imgMovie = UIImageView()
        imgMovie.translatesAutoresizingMaskIntoConstraints = false
        
        return imgMovie
    }()
    var lblTitle: UILabel = {
        let lblTitle = UILabel()
        lblTitle.textColor = .white
        lblTitle.font =  UIFont.boldSystemFont(ofSize: 25.0)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        return lblTitle
    }()
    var lblYear: UILabel = {
        let lblYear = UILabel()
        lblYear.textColor = .white
        lblYear.font =  UIFont.italicSystemFont(ofSize: 15.0)
        lblYear.translatesAutoresizingMaskIntoConstraints = false
        
        return lblYear
    }()
    var lblDesc: UILabel = {
        let lblDesc = UILabel()
        lblDesc.textColor = .white
        lblDesc.font = UIFont.systemFont(ofSize: 20.0)
        lblDesc.numberOfLines = 0
        lblDesc.adjustsFontSizeToFitWidth = true
        lblDesc.translatesAutoresizingMaskIntoConstraints = false
        lblDesc.textAlignment = .justified
        
        return lblDesc
    }()
    var btnFav: FavoriteButton = {
        let btnFav = FavoriteButton()
        btnFav.translatesAutoresizingMaskIntoConstraints = false
        btnFav.addTarget(self, action: #selector(btnFavoriteAction), for: .touchUpInside)

        return btnFav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = appColors.mainColor
        self.view.addSubview(imgMovie)
        self.view.addSubview(btnFav)
        self.view.addSubview(lblTitle)
        self.view.addSubview(lblYear)
        self.view.addSubview(lblDesc)
        getAllItems()
        setLayout()
        setValues()
    }
    
    private func setLayout(){
        navigationItem.title = viewModel.title
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        imgMovie.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgMovie.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        imgMovie.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imgMovie.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnFav.topAnchor.constraint(equalTo: imgMovie.topAnchor).isActive = true
        btnFav.leadingAnchor.constraint(equalTo: imgMovie.trailingAnchor, constant: 32).isActive = true
        lblTitle.topAnchor.constraint(equalTo: imgMovie.bottomAnchor, constant: 50).isActive = true
        lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblYear.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 32).isActive = true
        lblYear.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblDesc.topAnchor.constraint(equalTo: lblYear.bottomAnchor, constant: 80).isActive = true
        lblDesc.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblDesc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        lblDesc.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setValues(){
        lblTitle.text = viewModel.title
        lblYear.text = viewModel.year
        lblDesc.text = viewModel.overview
        btnFav.setup(model[index].favorite)
        imgMovie.setImageFromPath(viewModel.posterImage)
    }

    private func getAllItems(){
        do {
            let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            model = try context.fetch(fetchRequest)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @objc func btnFavoriteAction(){
        
        let isSelected = btnFav.isChecked
        
        if !isSelected {
            viewModel.favorite = true
            model[index].favorite = viewModel.favorite!
        } else {
            viewModel.favorite = false
            model[index].favorite = viewModel.favorite!
        }
        
        do {
            try self.context.save()
            getAllItems()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension UIImageView {
    func setImageFromPath(_ path: String?) {
        image = nil
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            guard let imagePath = path else {return}
            if let imageURL = URL(string: imagePath) {
                if let imageData = NSData(contentsOf: imageURL) {
                    image = UIImage(data: imageData as Data)
                } else {
                    // Image default - In case of error
                    image = UIImage(named: "noImageAvailable")
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
