//
//  FirstViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var tapLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.tapLabel.alpha)
        print("\(self) viewWillAppear")
        // navigationBarを非表示
        navigationController?.navigationBar.isHidden = true
        // tapLabelを点滅
        UILabel.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.tapLabel.alpha = 0
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(tapLabel.alpha)
        tapLabel.alpha = 1
    }
    
    func setup() {
        // tapGestureの設定
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(presentView))
        self.view.addGestureRecognizer(tapGR)

    }
    
    @objc func presentView() {
        performSegue(withIdentifier: "ToAppList", sender: self)
    }

}
