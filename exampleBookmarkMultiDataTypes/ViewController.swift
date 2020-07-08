//
//  ViewController.swift
//  exampleBookmarkMultiDataTypes
//
//  Created by Eren FAIKOGLU on 05.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //viewDidLoad icerisinde navigasyone .add ile ekleme butonu
        //action olarak addbuttonclicked cagir
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    //addbuttonclicked 2. view'a segue yapilir
    @objc func addButtonClicked() {
       performSegue(withIdentifier: "toSecondVC", sender: nil)
    }

}

