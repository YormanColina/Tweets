//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 31/01/22.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButtom: UIButton!
    
    
    // MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
    }
    
    private func setupUI() {
        // 1. Asignar datasource
        // 2. registrar celda
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts() {
        // 1. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 2. Consumir el servicio
        SN.get(endpoint: Endpoints.getPosts) { (response: SNResultWithEntity<[Post], ErrorResponse>) in
            // Cerramos el indicador de carga
            SVProgressHUD.dismiss()
            
            switch response {
            case .success(let posts):
                self.dataSource = posts
                self.tableView.reloadData()
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription,
                                   style: .danger).show()
                
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
        }
        
    }
    
    private func deletePostAt(indexPath: IndexPath) {
        // 1. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 2. Obtener ID del post que vamos a borrar
        let postId = dataSource[indexPath.row].id
        
        // 3. Preparamos el endpoint para borrar
        let endpoint = Endpoints.delete + postId
        
        // 4. Consumir el servicio para borrar el post
        SN.delete(endpoint: endpoint) { (response: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            // Cerramos el indicador de carga
            SVProgressHUD.dismiss()
            
            switch response {
            case .success:
                // 1. Borrar el post del datasource
                self.dataSource.remove(at: indexPath.row)
                
                // 2. Borrar la celda de la table
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription,
                                   style: .danger).show()
                
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            // Aqu?? borramos el tweet
            self.deletePostAt(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Obtener el correo guardado de los user defaults
        let storedEmail = UserDefaults.standard.string(forKey: "email-saved")
        
        // S??lo permitimos borrar el post cuando el autor sea el mismo de la sesi??n
        return dataSource[indexPath.row].author.email == storedEmail
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    // n??mero total de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // Configurar celda deseada
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            // configurar la celda
            cell.setupCellWith(post: dataSource[indexPath.row])
            
            cell.needsToShowVideo = { url in
                // Aqu?? SI deber??amos abrir un ViewController
                let avPlayer = AVPlayer(url: url)
                
                let avPlayerController = AVPlayerViewController()
                avPlayerController.player = avPlayer
                
                self.present(avPlayerController, animated: true) {
                    avPlayerController.player?.play()
                }
            }
        }
        
        return cell
    }
}

// MARK: - Navigation
extension HomeViewController {
    
    // Este m??todo se llamar?? cuando hagamos transiciones entre pantallas (S??lo con Storyboards)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. Validar que el segue sea el esperando
        
        if segue.identifier == "showMap", let mapViewController = segue.destination as? MapViewController {
            // Ya sabemos que si vamos a la pantalla del mapa
            mapViewController.posts = dataSource.filter { $0.hasLocation }
        }
    }
}
