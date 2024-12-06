//
//  ViewController.swift
//  original
//
//  Created by 関戸さき on 2024/10/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    let posts = DummyData.posts
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath)
        let post = posts[indexPath.row]
        if let cell = cell as? PostCell {
            cell.setupCell(profile: UIImage(named: post.profileImage)!, username: post.username, post: UIImage(named: post.postImage)!)
        }
        
        return cell
    }

}

