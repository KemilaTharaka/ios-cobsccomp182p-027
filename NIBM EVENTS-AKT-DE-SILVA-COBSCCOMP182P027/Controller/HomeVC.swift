//
//  ViewController.swift
//  NIBM EVENTS-AKT DE SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/25/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let category = Category.init(name: "NIBM", id: "kjhgfd", imagUrl: "https://images.unsplash.com/photo-1569930784237-ea65a2f40a83?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", isActive: true, timeStamp: Timestamp())
        
        categories.append(category)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously{ (result, error) in
                if let error = error { 
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        if let user  = Auth.auth().currentUser, !user.isAnonymous{
            //We are logged in
            loginOutBtn.title = "Logout"
        } else {
            loginOutBtn.title = "Login"
        }
        
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }

    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        }else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error{
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presentLoginController()
                }
            } catch {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
        
    }
}
    
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCell(category: categories[indexPath.item])
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width -  50) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

