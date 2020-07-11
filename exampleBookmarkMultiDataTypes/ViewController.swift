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
    
    //liste datasi tutulur
    var data1stringArray = [String]()
    var idArray = [UUID]()
    
    //segue icin indexpath.row
    var selectedName : String = ""
    var selectedUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //s3db lokasyonu
        let container = NSPersistentContainer(name: "exampleBookmarkMultiDataTypes")
        print("File name:")
        print(container.persistentStoreDescriptions.first?.url)
        
        //viewDidLoad icerisinde navigasyone .add ile ekleme butonu
        //action olarak addbuttonclicked cagir
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        //tablo gorunur
        table.delegate = self
        table.dataSource = self
        
        //fonksiyonu cagiriyoruz
        getData()
    }
    
    //2. segueden ana ekrana gelindiginde viewdidload reload etmez, viewwillappear kullanilir
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newValInserted"), object: nil)
    }
    
    
    @objc func getData() {
        
        //viewWillAppear sonrasi array temizleme
        data1stringArray.removeAll()
        idArray.removeAll()
        
        
        // AppDelegate icini miras aliyoruz
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // contexti local dosyaya getirdik
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            //data cekimi
            let results  = try context.fetch(fetchRequest)
            //mngd object
            for result in results as! [NSManagedObject]{
                if let data1string = result.value(forKey: "data1string") as? String{
                    self.data1stringArray.append(data1string)
                }
                //UUID ile eslestirme
                if let id = result.value(forKey: "id") as? UUID {
                    //listeye ekleme
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
       selectedName = ""
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
    
    //eklenmis data-gosterim icin 2. segueye veri aktarimi
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondVC"{
            let destinationVC = segue.destination as! secondVC
            destinationVC.chosenName = selectedName
            destinationVC.chosenUUID = selectedUUID
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = data1stringArray[indexPath.row]
        selectedUUID = idArray[indexPath.row]
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    //editingStyl... <commit
    //silme islemi
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let idString = idArray[indexPath.row].uuidString
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            //idye gore arama yapilir, UUID
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID {
                        if id == idArray[indexPath.row]{
                            context.delete(result)
                            print("delete done")
                            //silme isleminden sonra arrayden de alinir
                            data1stringArray.remove(at: indexPath.row)
                            idArray.remove(at: indexPath.row)
                            //arrayden alindigi icin reload
                            self.table.reloadData()
                            
                            do {try context.save() }
                            catch {print("err!")}
                            break
                        }
                        }
                    }
                }
            }
            catch{
                print("err!")
            }
        }
    }

}

