//
//  EventsVC.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/28/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventsVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //Variables
    var events = [Event]()
    var category: Category!
    var listner: ListenerRegistration!
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.EventCell, bundle: nil), forCellReuseIdentifier: Identifiers.EventCell)
        
        setupQuery()

        // Do any additional setup after loading the view.
    }
    
    func setupQuery() {
        
        listner = db.events(category: category.id).addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let event = Event.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, event: event)
                case .modified:
                    self.onDocumentModified(change: change, event: event)
                case .removed:
                    self.onDocumentRemoved(change: change)
                    
                }
                
            })
        })
        
    }
    


}

extension EventsVC: UITableViewDelegate, UITableViewDataSource{
    
    func onDocumentAdded(change: DocumentChange, event: Event){
        
        let newIndex = Int(change.newIndex)
        events.insert(event, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        
    }
    
    func onDocumentModified(change: DocumentChange, event: Event){
        
        if change.newIndex == change.oldIndex {
            //Row changed, but remained in the same position
            let index = Int(change.newIndex)
            events[index] = event
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
            
        } else {
            //Row changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            events.remove(at: oldIndex)
            events.insert(event, at: newIndex)
            
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
    }
    
    func onDocumentRemoved(change: DocumentChange){
        
        let oldIndex = Int(change.oldIndex)
        events.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .left)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.EventCell, for: indexPath) as? EventCell {
            
            cell.configureCell(event: events[indexPath.row])
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EventDetailVC()
        let selectedEvent = events[indexPath.row]
        vc.event = selectedEvent
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
