//
//  secondVC.swift
//  exampleBookmarkMultiDataTypes
//
//  Created by Eren FAIKOGLU on 05.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit

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
    
    //didFinishPick...
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        data4bin.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //fonksiyon detayi
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        print("save clicked.")
    }
    
    
    @IBAction func keyboardButton(_ sender: Any) {
        //endEditing 5.x versiyonda calismiyor
        view.endEditing(false)
        print("keyboard enabled.")

    }
    
}
