//
//  CategoryCell.swift
//  NIBM EVENTS-AKT DE SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/27/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImg.layer.cornerRadius = 5
    }
    
    func configureCell(category: Category){
        categoryLbl.text = category.name
        if let url = URL(string: category.imagUrl) {
            
            categoryImg.kf.setImage(with: url)
            
        }
    }
    

}
