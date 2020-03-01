//
//  UserService.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 3/1/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    //Variables
    var user = User()
    var likes = [Event]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListner : ListenerRegistration? = nil
    var likesListner : ListenerRegistration? = nil
    
    
    var isGuest : Bool {
        
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListner = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
            print(self.user)
        })
        
        let likesRef = userRef.collection("likes")
        likesListner = likesRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let like = Event.init(data: document.data())
                self.likes.append(like)
            })
        })
        
    }
    
    func likeSelected(event: Event){
        let likesRef = Firestore.firestore().collection("users").document(user.id).collection("likes")
        
        if likes.contains(event) {
            //We remove it as likes
            likes.removeAll{ $0 == event }
            likesRef.document(event.id).delete()
            
        }else {
            //Add as a like
            likes.append(event)
            let data = Event.modelToData(event: event)
            likesRef.document(event.id).setData(data)
            
        }
    }
    
    
    
    func logOutUser() {
        userListner?.remove()
        userListner = nil
        likesListner?.remove()
        likesListner = nil
        user = User()
        likes.removeAll()
    }
    
}
