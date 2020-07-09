//
//  ViewController.swift
//  exampleBookmarkMultiDataTypes
//
//  Created by Eren FAIKOGLU on 05.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var data1stringArray = [String]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = NSPersistentContainer(name: "exampleBookmarkMultiDataTypes")
        print("File name:")
        print(container.persistentStoreDescriptions.first?.url)
        
        //viewDidLoad icerisinde navigasyone .add ile ekleme butonu
        //action olarak addbuttonclicked cagir
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        table.delegate = self
        table.dataSource = self
        
        //fonksiyonu cagiriyoruz
        getData()
    }
    
    
    func getData() {
        
        // AppDelegate icini miras aliyoruz
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // contexti local dosyaya getirdik
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results  = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let data1string = result.value(forKey: "data1string") as? String{
                    self.data1stringArray.append(data1string)
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                
                
            }
            
        } catch {
            print("err.")
        }
        self.table.reloadData()
        print("Total \(idArray.count) rows listed.")
        
    }
    
    
    
    
    //addbuttonclicked 2. view'a segue yapilir
    @objc func addButtonClicked() {
       performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Row no \(idArray.count) is listing.")
        return idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data1stringArray[indexPath.row]
        return cell
    }

}

