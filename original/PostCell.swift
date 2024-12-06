//
//  PostCell.swift
//  original
//
//  Created by 関戸さき on 2024/11/15.
//


import UIKit

class PostCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var goodButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = UIImage()
        usernameLabel.text = ""
        postImageView.image = UIImage()
        
    }
    
    func setupCell(profile: UIImage, username: String, post: UIImage) {
        profileImageView.image = profile
        usernameLabel.text = username
        postImageView.image = post
    }
}
