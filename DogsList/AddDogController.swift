//
//  AddDogController.swift
//  DogsList
//
//  Created by Bruno Rodrigues on 07/06/19.
//  Copyright © 2019 Bruno Rodrigues. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddDogController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var owner: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var vaccination: UIDatePicker!
    
    var picture: UIImage? {
        didSet{
            image.image = picture
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addDog(_ sender: Any) {
        guard let dogName = name.text else { pop(); return }
        guard let dogOwner = owner.text else { pop(); return }
        guard let image = image.image?.pngData() else { pop(); return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let vaccinationDate = dateFormatter.string(from: vaccination.date)
        let birthdayDate = dateFormatter.string(from: birthday.date)
        
        let database = Database.database().reference()
        let storage = Storage.storage().reference()
        
        
        
        database.child("availableIndex").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let index = snapshot.value as? Int else { return }
            database.child("dogs").child("dog\(index)").setValue(["nome": dogName,
                                                                  "dono": dogOwner,
                                                                  "nascimento": birthdayDate,
                                                                  "vacinacao": vaccinationDate])
            storage.child("dog\(index)").putData(image)
            database.removeAllObservers()
            database.child("availableIndex").setValue(index+1)
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    private func pop() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addPicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        picture = image
    }
}
