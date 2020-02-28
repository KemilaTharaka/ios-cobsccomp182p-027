//
//  ViewController.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/27/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }


}

