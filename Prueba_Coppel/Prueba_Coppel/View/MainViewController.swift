//
//  MainViewController.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 23/07/22.
//

import UIKit

class MainViewController: UIViewController, UpdateTableViewDelegate {
    
    private var viewModel = MoviesListViewModel()
    private var model = [MovieEntity]()
    private var countFav = 0
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tblMovies: UITableView = {
        let tblMovies = UITableView()
        tblMovies.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tblMovies.rowHeight = 160
        tblMovies.backgroundColor = UIColor.clear
        tblMovies.showsVerticalScrollIndicator = false
        
        return tblMovies
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColors.mainColor
        self.view.addSubview(tblMovies)
        setNavLayout()
        self.viewModel.delegate = self
        loadData()
        self.tblMovies.dataSource = self
        self.tblMovies.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblMovies.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
    }
    
    private func getAllItems(){
        do {
            model = try self.context.fetch(MovieEntity.fetchRequest())
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @objc func actionSheetPresent(){
        let actionSheet = UIAlertController(title: "¿Qué quieres hacer?", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Ver perfil", style: .default, handler: { _ in
            let vc = ProfileViewController()
            vc.viewModel = self.viewModel
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func loadData() {
        viewModel.retrieveDataFromCoreData()
    }
    
    private func setNavLayout(){
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "TV Shows"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = appColors.secondaryColor
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem = nil;
        navigationItem.hidesBackButton = true;
        navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        let imageBar = UIImage(systemName: "list.bullet")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let item =  UIBarButtonItem(image: imageBar, style: .plain, target: self, action: #selector(actionSheetPresent))
        self.navigationItem.rightBarButtonItem = item
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func reloadData(sender: MoviesListViewModel) {
       self.tblMovies.reloadData()
   }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        let object = viewModel.object(indexPath: indexPath)
        
        if let movieCell = cell as? MovieTableViewCell {
            if let movie = object {
                movieCell.setCellWithValuesOf(movie)
            }
        }
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailViewController()
        let indexRow = indexPath.row
        detailsVC.index = indexRow
        let selectedMovie = viewModel.object(indexPath: indexPath)
        detailsVC.viewModel = MovieDetailsViewModel(movieDetails: selectedMovie)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
