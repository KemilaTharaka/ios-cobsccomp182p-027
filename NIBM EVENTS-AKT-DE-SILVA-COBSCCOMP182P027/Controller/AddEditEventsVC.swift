//
//  AddEditEventsVC.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 3/1/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class AddEditEventsVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var eventNameTxt: UITextField!
    @IBOutlet weak var eventDescTxt: UITextView!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    
    @IBOutlet weak var timeTxt: UITextField!
    
    @IBOutlet weak var eventImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
    
    //Variables
    var selectedCategory : Category!
    var eventToEdit : Event?
    
    var name = ""
    var eventDescription = ""
    var location = ""
    var date = ""
    var time = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        eventImgView.isUserInteractionEnabled = true
        eventImgView.clipsToBounds = true
        eventImgView.addGestureRecognizer(tap)
        
        if let event = eventToEdit {
            eventNameTxt.text = event.name
            eventDescTxt.text = event.eventDescription
            locationTxt.text = event.location
            dateTxt.text = event.date
            timeTxt.text = event.time
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: event.imageUrl){
                eventImgView.contentMode = .scaleAspectFit
                eventImgView.kf.setImage(with: url)
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func imgTapped() {
        
        //Launch the image picker
        launchImgPicker()
        
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument() {
        
        guard let image = eventImgView.image ,
        let name = eventNameTxt.text , name.isNotEmpty ,
        let description = eventDescTxt.text , description.isNotEmpty ,
        let location = locationTxt.text , location.isNotEmpty ,
        let date = dateTxt.text , date.isNotEmpty ,
            let time = timeTxt.text , time.isNotEmpty else {
                simpleAlert(title: "Missing Fields", msg: "Please fill out all required fields.")
                return
        }
        
        self.name = name
        self.eventDescription = description
        self.location = location
        self.date = date
        self.time = time
        
        
        activityIndicator.startAnimating()
        
        //Step: 1 - Turn the image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        //Step: 2 - Create a storage image reference -> A location in Firestorage for it to bo stored.
        let imageRef = Storage.storage().reference().child("/eventImages/\(name).jpg")
        
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
                    self.handleError(error: error, msg: "Unable to download image url.")
                    return
                }
                
                guard let url = url else { return }
                print(url)
                
//                Step: 6 - Upload new event document to the Firestore events collection.
                self.uploadDocument(url: url.absoluteString)
                
                
            })
            
            
        }
        
    }
    
    func uploadDocument(url: String) {
        
        var docRef: DocumentReference!
        var event = Event.init(name: name,
                               id: "",
                               imageUrl: url,
                               category: selectedCategory.id,
                               location: location,
                               eventDescription: eventDescription,
                               date: date,
                               time: time)
        
        if let eventToEdit  = eventToEdit {
            //We Are Editing
            docRef = Firestore.firestore().collection("events").document(eventToEdit.id)
            event.id = eventToEdit.id
        } else {
            //New Event
            docRef = Firestore.firestore().collection("events").document()
            event.id = docRef.documentID
        }
        
        let data = Event.modelToData(event: event)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new event to Firestore.")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    

}

extension AddEditEventsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        eventImgView.contentMode = .scaleAspectFill
        eventImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
