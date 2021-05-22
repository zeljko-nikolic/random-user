//
//  UserTableViewCell.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var flagLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    func setup(user: User) {
        nameLabel.text = user.name.full
        ageLabel.text = "Age: \(user.dateOfBirth.age)"
        flagLabel.text = user.nationalityFlag
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: user.picture.large),
                                  options: [.transition(.fade(1)),.cacheOriginalImage])
    }
}
