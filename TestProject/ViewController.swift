//
//  ViewController.swift
//  TestProject
//
//  Created by Ildar Zalyalov on 08.11.2017.
//  Copyright © 2017 Ildar Zalyalov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    var adManager: AdManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager = YandexAdFoxViewManager()
        
        adManager.configure(with: contentView, and: self)
        adManager.loadAd()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

