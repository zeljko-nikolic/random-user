//
//  UserViewController.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 22.5.21..
//

import UIKit
import Kingfisher

protocol UserViewControllerDelegate: AnyObject {
    func userViewController(_ userViewController: UserViewController, didTapOn email: String)
}

class UserViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    var user: User!
    var delegate: UserViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmailLabel()
        populateData()
    }
    
    //MARK: - Private
    private func setupEmailLabel() {
        emailLabel.textColor = .link
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEmailTapped)))
        emailLabel.isUserInteractionEnabled = true
    }
    
    @objc private func onEmailTapped() {
        delegate?.userViewController(self, didTapOn: user.email)
    }
    
    private func populateData() {
        nameLabel.text = user.name.full
        ageLabel.text = "Age: \(user.dateOfBirth.age)"
        emailLabel.attributedText = NSAttributedString(string: user.email,
                                                       attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        userImageView.kf.setImage(with: URL(string: user.picture.large),
                                  placeholder: UIImage(named: "ic-profile"),
                                  options: [.transition(.fade(1)), .cacheOriginalImage])
    }
    
}
