//
//  DogDetailsController.swift
//  DogsList
//
//  Created by Bruno Rodrigues on 07/06/19.
//  Copyright © 2019 Bruno Rodrigues. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class DogDetailsController: UIViewController {
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogBirth: UILabel!
    @IBOutlet weak var dogOwner: UILabel!
    @IBOutlet weak var dogVaccination: UILabel!
    
    var dog: Dog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImage.image = dog?.image
        dogName.text = dog?.name
        dogOwner.text = dog?.owner
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let birthday = formatter.string(from:  dog?.birth ?? Date())
        let vaccination = formatter.string(from: dog?.vaccination ?? Date())
        dogBirth.text = birthday
        dogVaccination.text = vaccination
    }

    @IBAction func deleteDog(_ sender: Any) {
        let database = Database.database().reference()
        let storage = Storage.storage().reference()
        guard let safeDog = dog else {
            navigationController?.popViewController(animated: true)
            return
        }
        database.child("dogs").child("dog\(safeDog.index)").removeValue { (error, reference) in
            if let err = error {
                print(error)
            }
            self.navigationController?.popViewController(animated: true)
        }
        storage.child("dogs").child("dog\(safeDog.index)").delete { (error) in
            if let err = error {
                print(error)
            }
        }
    }
}
