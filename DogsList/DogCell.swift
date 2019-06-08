//
//  DogCell.swift
//  DogsList
//
//  Created by Bruno Rodrigues on 07/06/19.
//  Copyright © 2019 Bruno Rodrigues. All rights reserved.
//

import UIKit

class DogCell: UITableViewCell {
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    

    func setup(name: String?, image: UIImage?) {
        dogImage.image = image
        dogName.text = name
    }

}
