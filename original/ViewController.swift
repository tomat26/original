//
//  ViewController.swift
//  original
//
//  Created by 関戸さき on 2024/10/25.
//

import UIKit

// ①UICollectionViewDelegate, UICollectionViewDelegateFlowLayoutを追記する！
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        collectionView.dataSource = self
////　　  ②この行を追加して、CollectionViewのセルの大きさを調節できるようにする
//        collectionView.delegate = self
//        
//        // ③レイアウト設定をする（縦方向にスクロールするように設定&セルの間の距離を設定）
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical // スクロール方向
//        layout.minimumLineSpacing = 8 // セル間の縦の間隔
//        layout.minimumInteritemSpacing = 0 // セル間の横の間隔
//        collectionView.collectionViewLayout = layout
        
        // カスタムセルの登録
        // collectionView.register(PostCell.self, forCellWithReuseIdentifier: "PostCell")
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 // 仮のアイテム数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        // 仮のデータ
        cell.setupCell(profile: UIImage(named: "profilePlaceholder") ?? UIImage(),
                       username: "Username",
                       post: UIImage(named: "postPlaceholder") ?? UIImage())
        
        return cell
    }
    
    // ④ここでセルのサイズを調節する（インスタっぽく1:1にするならこんな感じ！）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width // 横幅いっぱいにする
        return CGSize(width: width, height: width) // 高さも横幅と同じで1:1の正方形
    }
}
