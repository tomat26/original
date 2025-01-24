//
//  ViewController.swift
//  original
//
//  Created by 関戸さき on 2024/10/25.
//

import UIKit
import UserNotifications // 通知機能のために必要


// ①UICollectionViewDelegate, UICollectionViewDelegateFlowLayoutを追記する！
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let hour = 23/*Int.random(in: 8...20)*/
        
        var messages: [String] = []
        
        switch hour {
        case 8...11:
            messages = morningMessages
        case 12...17:
            messages = afternoonMessages
        case 18...24:
            messages = nightMessages
        default:
            messages = [] // 時間外
        }
        
        content.body = messages.randomElement() ?? "今日のミッションの時間だよ！"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
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
        return 4 // 仮のアイテム数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        // 仮のデータ
        cell.setupCell(profile: UIImage(named: DummyData.posts[indexPath.row].profileImage)!,
                       username: "Username",
                       post: UIImage(named: DummyData.posts[indexPath.row].postImage)!)
        
        return cell
    }
    
    // ④ここでセルのサイズを調節する（インスタっぽく1:1にするならこんな感じ！）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width // 横幅いっぱいにする
        return CGSize(width: width, height: width) // 高さも横幅と同じで1:1の正方形
    }
    
    
   
}
