//
//  EventDetailVC.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 3/1/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import Kingfisher

class EventDetailVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    //Variables
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitle.text = event.name
        eventDescription.text = event.eventDescription
        
        if let url = URL(string: event.imageUrl) {
            eventImg.kf.setImage(with: url)
        }
        
        location.text = event.location
        date.text = event.date
        time.text = event.time
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissEvent(_: )))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissEvent() {
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func dismissEvent(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    

}
