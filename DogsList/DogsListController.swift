//
//  ViewController.swift
//  DogsList
//
//  Created by Bruno Rodrigues on 07/06/19.
//  Copyright © 2019 Bruno Rodrigues. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

struct Dog: Hashable {
    var index: Int
    var name: String
    var owner: String
    var birth: Date
    var vaccination: Date
    var image: UIImage?
}

class DogsListController: UITableViewController {
    public var dogs: [Dog]? = [Dog]()
    
    override func viewWillAppear(_ animated: Bool) {
        let ref = Database.database().reference()
        let storage = Storage.storage().reference()
        ref.child("dogs").observeSingleEvent(of: .value, with: { (snapshot) in
            self.dogs = [Dog]()
            guard let dogs = self.dogs else { return }
            guard let dogsInfo = snapshot.value as? [String: Any] else { return }
            print(dogsInfo as AnyObject)
            let allKeys = dogsInfo.keys
            for (index, key) in allKeys.enumerated() {
                guard let dogInfo = dogsInfo[key] as? [String: Any] else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                guard let birthday = dateFormatter.date(from: dogInfo["nascimento"] as? String ?? "") else { return }
                guard let vaccination = dateFormatter.date(from: dogInfo["vacinacao"] as? String ?? "") else { return }
                guard let name = dogInfo["nome"] as? String else { return }
                guard let owner = dogInfo["nome"] as? String else { return }
                guard let dogIndex = Int(key.dropFirst(3)) else { return }
                let dog = Dog(index: dogIndex, name: name, owner: owner, birth: birthday, vaccination: vaccination, image: nil)
                storage.child("dog\(index)").getData(maxSize: 1024*1024, completion: { (data, err) in
                    if let error = err {
                        print(error)
                    }
                    if let imageData = data {
                        guard let dogImage = UIImage(data: imageData) else { return }
                        self.dogs?[index].image = dogImage
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                })
                if dogs.count < allKeys.count {
                    self.dogs?.insert(dog, at: index)
                }
                self.tableView.reloadData()
            }
        })
        ref.removeAllObservers()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dogCell") as? DogCell else { return UITableViewCell() }
        cell.setup(name: dogs?[indexPath.row].name, image: dogs?[indexPath.row].image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "dogDetailsController") as? DogDetailsController else { return }
        
        controller.dog = dogs?[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    @IBAction func addDog(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addDogController = storyboard.instantiateViewController(withIdentifier: "addDogController") as? AddDogController else { return }
        navigationController?.pushViewController(addDogController, animated: true)
    }
}


