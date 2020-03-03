//
//  EventCell.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/28/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import Kingfisher

protocol EventCellDelegate : class {
    func eventLiked(event: Event)
}

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImg: RoundedImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    weak var delegate : EventCellDelegate?
    private var event : Event!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(event: Event, delegate: EventCellDelegate){
        
        self.event = event
        self.delegate = delegate
        
        eventTitle.text = event.name
        location.text = event.location
        date.text = event.date
        time.text = event.time
        
        if let url = URL(string: event.imageUrl) {
            
            let placeholder = UIImage(named: "placeholder-1")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            eventImg.kf.indicatorType = .activity
            eventImg.kf.setImage(with: url, placeholder: placeholder, options: options)
            
        }
        
        if UserService.likes.contains(event) {
            
            likeBtn.setImage(UIImage(named: AppImages.FilledLike), for: .normal)
            
        }else {
            likeBtn.setImage(UIImage(named: AppImages.EmptyLike), for: .normal)
        }
        
        
    }

    @IBAction func likeClicked(_ sender: Any) {
        
         delegate?.eventLiked(event: event)
        
    }
    
}
