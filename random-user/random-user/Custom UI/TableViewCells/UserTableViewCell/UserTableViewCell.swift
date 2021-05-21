//
//  UserTableViewCell.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    func setup(name: String, age: Int, flag: String, imageUrl: String) {
        nameLabel.text = name
        ageLabel.text = "Age: \(age)"
        flagLabel.text = flag
        userImageView.kf.setImage(with: URL(string: imageUrl))
    }
}
