//
//  LoginViewController.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 22/07/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private var apiService = ApiService()
    
    var imgLogo: UIImageView = {
        let img = UIImage(named: "Logo")
        let imgLogo = UIImageView(image: img)
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        
        return imgLogo
    }()
    var txfEmail: UITextField = {
        let txfEmail = UITextField()
        txfEmail.placeholder = "Email"
        txfEmail.layer.borderWidth = 1
        txfEmail.layer.cornerRadius = 5
        txfEmail.backgroundColor = .white
        txfEmail.keyboardType = .emailAddress
        txfEmail.translatesAutoresizingMaskIntoConstraints = false
        
        return txfEmail
    }()
    var txfPassword: UITextField = {
        let txfPassword = UITextField()
        txfPassword.placeholder = "Password"
        txfPassword.layer.borderWidth = 1
        txfPassword.layer.cornerRadius = 5
        txfPassword.backgroundColor = .white
        txfPassword.isSecureTextEntry = true
        txfPassword.translatesAutoresizingMaskIntoConstraints = false

        return txfPassword
    }()
    var btnLogin: UIButton = {
        let btnLogin = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        btnLogin.backgroundColor = appColors.secondaryColor
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.layer.cornerRadius = 10
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.addTarget(self, action: #selector(btnLoginAction), for: .touchUpInside)

        return btnLogin
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imgLogo)
        self.view.addSubview(txfEmail)
        self.view.addSubview(txfPassword)
        self.view.addSubview(btnLogin)
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func btnLoginAction(){
        self.loadPopularMoviesData()
    }
    
    func setUpLayout(){
        self.view.backgroundColor = appColors.mainColor
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        imgLogo.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imgLogo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        txfEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txfEmail.topAnchor.constraint(equalTo: imgLogo.bottomAnchor, constant: 80).isActive = true
        txfEmail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        txfEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        txfPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txfPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        txfPassword.topAnchor.constraint(equalTo: txfEmail.bottomAnchor, constant: 32).isActive = true
        txfPassword.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        btnLogin.topAnchor.constraint(equalTo: txfPassword.bottomAnchor, constant: 64).isActive = true
    }
    
    private func loadPopularMoviesData() {
        self.apiService.getPopularMoviesData { [weak self] (result) in
            switch result {
            case .success(let listOf):
                CoreData.sharedInstance.saveDataOf(movies: listOf.movies)
                let vc = MainViewController()
                if let email = self!.txfEmail.text, let password = self!.txfPassword.text{
                    Auth.auth().signIn(withEmail: email, password: password){
                        (result, error) in
                        if error == nil {
                            self?.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al hacer login", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                            self!.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                // Show alert message in case of error
                self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
           let action = UIAlertAction(title: "OK", style: .default) { (action) in
               self.dismiss(animated: true, completion: nil)
           }
           alertController.addAction(action)
           self.present(alertController, animated: true, completion: nil)
       }
}
