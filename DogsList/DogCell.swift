//
//  DogCell.swift
//  DogsList
//
//  Created by Bruno Rodrigues on 07/06/19.
//  Copyright © 2019 Bruno Rodrigues. All rights reserved.
//

import UIKit

class DogCell: UITableViewCell {
    
    /// An instace of UIImageView which will be used to hold the dog image
    @IBOutlet weak var dogImage: UIImageView!
    
    /// An instance of UILabel which will be used to hold the dog name
    @IBOutlet weak var dogName: UILabel!
    

    func setup(name: String?, image: UIImage?) {
        dogImage.image = image
        dogName.text = name
    }

}
