//
//  secondVC.swift
//  exampleBookmarkMultiDataTypes
//
//  Created by Eren FAIKOGLU on 05.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import CoreData

class secondVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var data1string: UITextField!
    @IBOutlet weak var data2string: UITextField!
    @IBOutlet weak var data3double: UITextField!
    @IBOutlet weak var data4bin: UIImageView!
    @IBOutlet weak var data5decimal: UITextField!
    @IBOutlet weak var data6date: UITextField!
    @IBOutlet weak var data7int: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //gestureRecognizer ekranin herhangi bir yerinde tiklandiginda hideKeyboard fonksiyonu gelsin
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        data4bin.isUserInteractionEnabled = true
        let date4binTapped = UITapGestureRecognizer(target: self, action: #selector(imagetap))
        data4bin.addGestureRecognizer(date4binTapped)
    }
    
    //gorseli sectiriyoruz on imageTap
    @objc func imagetap() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion:  nil)
        
    }
    
    //didFinishPick... keyi ile secilen imagein areaya yazilmasi
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        data4bin.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //hide keyboard func
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print("save clicked.")
        // AppDelegate icini miras aliyoruz
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // contexti local dosyaya getirdik
        let context = appDelegate.persistentContainer.viewContext
        // contexti kullaniyoruz // import CoreData gerekli
        let newObj = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        
        //farkli data tiplerini convert ederek newObj.setValue ile yaziyoruz
        //userDefaults ile ayni sekilde
        if let data1stringObj = data1string.text{newObj.setValue(data1stringObj, forKey: "data1string")}
        
        newObj.setValue("test", forKey: "data2string")
        print("\(data1string.text!) taken")
        print("\(data2string.text!) taken")
        //if let data2stringObj = data2string.text{newObj.setValue(data2stringObj, forKey: "data2string")}
        //if let data3doubleObj = Double(data3double.text!){newObj.setValue(data3doubleObj, forKey: "data3double")}
        //newObj.setValue(nil, forKey: "data5decimal")
        //newObj.setValue(nil, forKey: "data6date")
        //newObj.setValue(nil, forKey: "data7int")
        
        //unique verilen UUID
        newObj.setValue(UUID(), forKey: "id")
        
        //secilen img
        let img = data4bin.image!.jpegData(compressionQuality: 0.7)
        newObj.setValue(img, forKey: "data4bin")
        
        
        do {
            try context.save()
            print("save ok")
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("save err.")
        }
    }
    
    
    @IBAction func keyboardButton(_ sender: Any) {
        //endEditing 5.x versiyonda calismiyor
        view.endEditing(false)
        print("keyboard enabled.")

    }
    
}
