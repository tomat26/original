//
//  ViewController.swift
//  original
//
//  Created by 関戸さき on 2024/10/25.
//

import UIKit
import UserNotifications // 通知機能のために必要
import Firebase
import FirebaseFirestore



extension UIImage {
    public convenience init(url: String) {
        // URLが正しいか確認
        if let validURL = URL(string: url) {
            do {
                // URLから画像データを取得
                let data = try Data(contentsOf: validURL)
                self.init(data: data)!
                return
            } catch let err {
                // エラーが発生した場合の処理
                print("Error : \(err.localizedDescription)")
            }
        }
        
        // URLが無効またはエラーの場合、ダミー画像（SF Symbolsのstar）を使用
        if let symbolImage = UIImage(systemName: "scribble.variable") {
            self.init(cgImage: symbolImage.cgImage!) // SF Symbolsの画像を使用
        } else {
            // 万が一SF Symbolsが読み込めない場合の予備処理
            self.init()
        }
    }
}
// ①UICollectionViewDelegate, UICollectionViewDelegateFlowLayoutを追記する！
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var posts: [Post] = []
    
    let image = UIImage(named: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        
        
        collectionView.dataSource = self
        //　　  ②この行を追加して、CollectionViewのセルの大きさを調節できるようにする
        collectionView.delegate = self
        
        // ③レイアウト設定をする（縦方向にスクロールするように設定&セルの間の距離を設定）
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // スクロール方向
        layout.minimumLineSpacing = 8 // セル間の縦の間隔
        layout.minimumInteritemSpacing = 0 // セル間の横の間隔
        collectionView.collectionViewLayout = layout
        
        // カスタムセルの登録
        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        
        // 通知の許可をリクエスト
        requestNotificationAuthorization()
        
        
        // 通知の重複を防ぐため、最初に既存の通知を削除
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyMission"])
        // 通知をスケジュール
        scheduleRandomDailyNotification()
    }
    
    
    // 通知の許可をリクエストする関数
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("通知の許可が得られました。")
            } else {
                print("通知の許可が得られませんでした。")
            }
        }
    }
    
    // MARK: - 通知をスケジュール
    func scheduleRandomDailyNotification() {
        let content = UNMutableNotificationContent()
        
        
        content.title = "Mission!"
        content.sound = .default
        
        let morningMessages = ["おはようございます！素晴らしい一日のスタートにミッションをどうぞ！", "素晴らしい1日のスタートを切るためのミッションをチェックしてみて！", "今日も一歩を踏み出すために、まずはミッションをクリアしよう！"]
        let afternoonMessages = ["午後のスパイスに、楽しいチャレンジをどうぞ！", "忙しい日々の中でも、小さな楽しみを見つけましょう！", "午後のエネルギーをチャージして、ミッションを楽しんで！"]
        let nightMessages = ["1日の締めくくりに、ちょっとしたミッションで達成感を感じてみよう！", "お疲れさまでした！今日もよく頑張ったね、ミッションで最後にもう一歩！", "1日を終える前に、ささやかな達成感を味わって！"]
        
        //        // 現在の時間を取得
        //        let hour = Calendar.current.component(.hour, from: Date())
        
        
        // ランダムな時間を作成（朝8時から夜8時まで）
        let hour = Int.random(in: 8...20)
        
        var messages: [String] = []
        
        switch hour {
        case 8...11:
            messages = morningMessages
        case 12...17:
            messages = afternoonMessages
        case 18...20:
            messages = nightMessages
        default:
            messages = [] // 時間外
        }
        
        content.body = messages.randomElement() ?? "今日のミッションの時間だよ！"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyMission", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error)")
            } else {
                print("通知がスケジュールされました: \(hour)時")
            }
        }
    }
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count// 仮のアイテム数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        // 仮のデータ
        cell.setupCell(profile: (UIImage(named:posts[indexPath.row].profileImage)) ?? UIImage(named: "post1"_)! /*?? UIImage(named: "post2")*/,
                       username: "Username",
                       post: UIImage(named: posts[indexPath.row].postImage)!
//        var test: String? = nil
//
//        print(test ?? "いい")
        
        return cell
    }
    
    // ④ここでセルのサイズを調節する（インスタっぽく1:1にするならこんな感じ！）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width // 横幅いっぱいにする
        return CGSize(width: width, height: width) // 高さも横幅と同じで1:1の正方形
    }
    
    
    // Firestoreからデータを取得
    func fetchPosts() {
        db.collection("posts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            
            
            // 取得したデータを辞書から`Post`型に変換して追加
            self.posts = querySnapshot?.documents.compactMap { document -> Post? in
                let data = document.data()
                

                
                // 必要なフィールドを安全に取り出してPost型を生成
                var id = data["id"] as? String ?? "defaultId"  // デフォルト値を設定
                var profileImage = data["profileImage"] as? String ?? "defaultprofileImage"  // デフォルト値を設定
                var username = data["username"] as? String ?? "defaultusername"  // デフォルト値を設定
                var postImageURL = data["postImages"] as? String ?? "No postImage"  // デフォルト値を設定
                var comments = data["comments"] as? String ?? "No comments"  // デフォルト値を設定
                var goodButton = data["goodButton"] as? String ?? "No goodButton"  // デフォルト値を設定
                var userId = data["userId"] as? String ?? "defaultUserId"  // デフォルト値を設定
                var createdAt = data["createdAt"] as? String ?? "No Date"  // createdAtを追加（デフォルト値）
               
//                 if  profileImage =
                
                // 必要なデータがない場合でもデフォルト値を使ってPost型を生成
                return Post(id: id, profileImage: profileImage, username: username, postImage: postImageURL, comments: comments, goodButton: goodButton, userId: userId,  createdAt: createdAt)
            } ?? []  // compactMapがnilを返す場合は空の配列を返す
            
            print(self.posts)
            // createdAtをDate型に変換してソート（新しい順）
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // createdAtの日付フォーマットを指定
            
            self.posts.sort { post1, post2 in
                guard let date1 = dateFormatter.date(from: post1.createdAt),
                      let date2 = dateFormatter.date(from: post2.createdAt) else {
                    return false  // 日付の解析に失敗した場合は順序を変更しない
                }
                return date1 > date2  // 新しい日付が前に来るように並べ替え
            }
            
            // UIを更新
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            print("Posts successfully fetched and stored: \(self.posts)")
        }
    }
    
   
    
    
    
    
}
