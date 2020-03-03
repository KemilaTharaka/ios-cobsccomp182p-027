//
//  AddEditCategoryVC.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 3/1/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class AddEditCategoryVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit : Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        //If we are editing, categoryToEdit will != nil
        
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }

        // Do any additional setup after loading the view.
    }
    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        //Launch the image picker
        launchImgPicker()
    }
    
   
    @IBAction func addCategoryClicked(_ sender: Any) {
        
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument() {
        
        guard let image = categoryImg.image ,
            let categoryName = nameTxt.text , categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Must add category name and image!")
                return
        }
        
        activityIndicator.startAnimating()
        
        
        //Step: 1 - Turn the image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        //Step: 2 - Create a storage image reference -> A location in Firestorage for it to bo stored.
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        //Step: 3 - Set the meta data.
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //Step: 4 - Upload the data.
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            
            //Step: 5 - Once the image is uploaded,retreive the download URL.
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image url.")
                    return
                }
                
                guard let url = url else { return }
                print(url)
                
                //Step: 6 - Upload new category document to the Firestore category collection.
                self.uploadDocument(url: url.absoluteString)

                
            })
            

        }
        
        
    }
    
    func uploadDocument(url: String) {
        
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!,
                                     id: "",
                                     imgUrl: url,
                                     timeStamp: Timestamp())
        
        
        if let categoryToEdit  = categoryToEdit {
            //We Are Editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            //New category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.modelToData(category: category)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new category to Firestore.")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func handleError(error: Error?, msg: String) {
        debugPrint(error!.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }

}
extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
