//
//  UserViewController.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 22.5.21..
//

import UIKit
import Kingfisher

class UserViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name.full
        ageLabel.text = "Age: \(user.dateOfBirth.age)"
        emailLabel.text = user.email
        userImageView.kf.setImage(
            with: URL(string: user.picture.large),
            placeholder: UIImage(named: "ic-profile"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }

}
