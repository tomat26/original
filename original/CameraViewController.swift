//
//  CameraViewController.swift
//  original
//
//  Created by 関戸さき on 2024/12/13.
//

import UIKit
import Cloudinary
import Firebase
import FirebaseFirestore


class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var number: Int!
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var missionLabel2: UILabel!
    @IBOutlet var missionLabel3: UILabel!
    @IBOutlet var missionLabel4: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var postButton: UIButton!
    
    let config = CLDConfiguration(cloudName: "dio0w7psc", secure: true)
    var cloudinary: CLDCloudinary?
    
    let db = Firestore.firestore()
       var posts: [Post] = []
    
    var showMission: String!
    var missions: [String] = []
    var missionPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudinary = CLDCloudinary(configuration: config)
        
        missionLabel2.isHidden = false
        missionLabel3.isHidden = false
        missionLabel.isHidden = true
        missionLabel4.isHidden = true
        saveButton.isHidden = true
        postButton.isHidden = true
        cameraButton.isHidden = false
        
        
        //        missions =
        //        ["今日の服を写そう"]
        
        missions = ["水や鏡などに映った面白い反射を撮ってみよう","写真の中に自分の指を隠して撮影してみよう","わざと写真を逆さまにして撮ってみよう","しましま模様があるものを見つけよう", "日本的なものを撮影してみよう", "未来を感じさせる何かを撮影しよう", "左右対称の構図で撮影してみよう", "何かのマークやロゴを見つけて撮影しよう", "今日の服を写そう", "英語が書かれているものを見つけて撮影", "ミッションが見つかりませんでした" ]
        number = Int.random(in: 0..<missions.count-1)
        showMission = missions[number]
        
        
        missionLabel.text = showMission
        missionLabel2.text = showMission
        
        
        //        switch number {
        //        case 0:
        //                    missionLabel.text = "水や鏡などに映った面白い反射を撮ってみよう"
        //            showMision =
        //                case 1:
        //                    missionLabel.text = "写真の中に自分の指を隠して撮影してみよう"
        //                case 2:
        //                    missionLabel.text = "わざと写真を逆さまにして撮ってみよう"
        //                case 3:
        //                    missionLabel.text = "しましま模様があるものを見つけよう"
        //                case 4:
        //                    missionLabel.text = "日本的なものを撮影してみよう"
        //                case 5:
        //                    missionLabel.text = "未来を感じさせる何かを撮影しよう"
        //                case 6:
        //                    missionLabel.text = "左右対称の構図で撮影してみよう"
        //                case 7:
        //                    missionLabel.text = "何かのマークやロゴを見つけて撮影しよう"
        //                case 8:
        //                    missionLabel.text = "今日の服を写そう"
        //                case 9:
        //                    missionLabel.text = "英語が書かれているものを見つけて撮影"
        //                default:
        //                    missionLabel.text = "ミッションが見つかりませんでした"
        //                }
        
        cameraButton.layer.borderColor = UIColor.black.cgColor  // 枠線の色
        cameraButton.layer.borderWidth = 1.0 // 枠線の太さ
        cameraButton.layer.cornerRadius = 10 //ボタンの角を丸める
        
        missionLabel.font = UIFont(name: "DelaGothicOne-Regular", size: 30)
        missionLabel.adjustsFontSizeToFitWidth = true
        missionLabel2.font = UIFont(name: "DelaGothicOne-Regular", size: 30)
        missionLabel2.adjustsFontSizeToFitWidth = true
        missionLabel3.font = UIFont(name: "DelaGothicOne-Regular", size: 18)
        missionLabel4.font = UIFont(name: "DelaGothicOne-Regular", size: 18)
        //        saveButton.titleLabel?.font = UIFont(name: "DelaGothicOne-Regular", size: 20)
        //        saveButton.font = UIFont(name: "DelaGothicOne-Regular", size: 20)
    }
    
    @IBAction func onTappedCameraButton() {
        presentPickerController(sourceType: .camera)
        
    }
    
    @IBAction func onTappedAlbumButton() {
        presentPickerController(sourceType: .photoLibrary)
    }
    
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        guard let originalImage = info[.originalImage] as? UIImage else {
            return
        }
        
        missionPhoto = originalImage
        
        let imageWithText = drawText(image: originalImage)
        
        photoImageView.image = imageWithText
        //
        //        let image = info[.originalImage] as! UIImage
        //        let size = CGSize(width: image.size.width / 8, height: image.size.height / 8)
        //        let resizedImage = UIGraphicsImageRenderer(size: size).image { _ in image.draw(in: CGRect(origin: .zero, size: size))
        
        //
        missionLabel2.isHidden = true
        missionLabel3.isHidden = true
        cameraButton.isHidden = true
        missionLabel.isHidden = false
        missionLabel4.isHidden = false
        saveButton.isHidden = false
        postButton.isHidden = false
        cameraButton.isHidden = true
        
    }
    
    
    func drawText(image: UIImage) -> UIImage {
        let text = showMission!
        
        // 最初に適当なフォントサイズを設定
        var fontSize = image.size.width / 10
        
        // 最大フォントサイズと最小フォントサイズを設定
        let _: CGFloat = image.size.width / 5
        let minFontSize: CGFloat = 10
        
        let textFontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DelaGothicOne-Regular", size: fontSize)!,
            .foregroundColor: UIColor.white
        ]
        
        // テキストのサイズを計算
        var textSize = text.size(withAttributes: textFontAttributes)
        
        // 文字が長すぎる場合はフォントサイズを調整
        while textSize.width > image.size.width - 40 {
            fontSize -= 1
            if fontSize < minFontSize {
                fontSize = minFontSize
                break
            }
            let textFontAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "DelaGothicOne-Regular", size: fontSize)!,
                .foregroundColor: UIColor.white
            ]
            textSize = text.size(withAttributes: textFontAttributes)
        }
        
        // 中央揃えのX座標
        let textX = (image.size.width - textSize.width) / 2
        let margin: CGFloat = 20.0 // 上部の余白
        let textY = margin
        
        let textRect = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
        
        // 新しい画像を作成
        UIGraphicsBeginImageContext(image.size)
        
        // 元の画像を描画
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // テキストを描画
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // 作成した画像を取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 描画コンテキストを終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //    func drawMaskImage(image: UIImage) -> UIImage{
    //
    //        let maskImage = UIImage(named: "post1")!
    //
    //        UIGraphicsBeginImageContext(image.size)
    //
    //        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    //
    //        let margin: CGFloat = 50.0
    //        let maskRect = CGRect(x: image.size.width - maskImage.size.width - margin, y: image.size.height - maskImage.size.height - margin, width: maskImage.size.width, height: maskImage.size.height)
    //
    //        maskImage.draw(in: maskRect)
    //
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //
    //        UIGraphicsEndImageContext()
    //
    //        return newImage!
    //    }
    //
    //    @IBAction func onTappedTextButton() {
    //        if photoImageView.image != nil {
    //            photoImageView.image = drawText(image: photoImageView.image!)
    //        } else {
    //            print("画像がありません")
    //        }
    //    }
    
    //    @IBAction func onTappedIllustButton() {
    //        if photoImageView.image != nil {
    //            photoImageView.image = drawMaskImage(image: photoImageView.image!)
    //        } else {
    //            print("画像がありません")
    //        }
    //    }
    
    
    
    //保存
    @IBAction func onTappedUploadButton() {
        if photoImageView.image != nil {
            
            let activityVC = UIActivityViewController(activityItems: [photoImageView.image!,"#photoMaster"], applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        // 投稿画像が空でないことを確認
        guard let postImage = missionPhoto else {
            // サムネイル画像が空の場合の処理
            showAlert(title: "入力エラー", message: "サムネイル画像を選択してください。")
            return
        }
        
        Task {
            let postImageURL = await uploadPostImage(image: postImage)
            // 空でない場合、取得したtextとthumbnailを引数として渡して保存処理
            savePostToFirestore(postImageURL: postImageURL)
        }
    }
    
    // アラートを表示する関数
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //サムネイルを保存する関数
    func uploadPostImage(image: UIImage) async -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8), let cloudinary = cloudinary else {
            print("画像データの準備に失敗しました")
            return ""
        }
        
        let uploader = cloudinary.createUploader()
        
        return await withCheckedContinuation { continuation in
            var isResumed = false
            let uniquePublicId = "thumbnail_\(UUID().uuidString)"
            let params = CLDUploadRequestParams().setPublicId(uniquePublicId)
            
            uploader.upload(data: imageData, uploadPreset: "manga_thumbnail", params: params, progress: { progress in
                print("アップロード進行中: \(progress.fractionCompleted * 100)%")
            }) { result, error in
                guard !isResumed else { return }
                
                if let error = error {
                    print("アップロード失敗: \(error.localizedDescription)")
                    isResumed = true
                    continuation.resume(returning: "")
                    return
                }
                
                if let result = result, let secureUrl = result.secureUrl {
                    print("アップロード成功: \(secureUrl)")
                    isResumed = true
                    continuation.resume(returning: secureUrl)
                } else {
                    print("アップロード結果が不明です")
                    isResumed = true
                    continuation.resume(returning: "")
                }
            }
        }
    }
    
    func savePostToFirestore(postImageURL: String) {
           let uuid = UUID()
           let currentDate = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let createdAt = formatter.string(from: currentDate)

           print(postImageURL)

        let post = Post(id: uuid.uuidString, profileImage: "", username: "exampleUserId", postImage: postImageURL, comments: "", goodButton: "", userId: "",  createdAt: "")

           let postData: [String: Any] = [
               "id": post.id,
               "profileImage": post.profileImage,
               "userId": post.userId,
               "postImage": post.postImage,
               "goodButton": post.goodButton,
               "createdAt": createdAt
           ]

           db.collection("posts").document(uuid.uuidString).setData(postData) { error in
               if let error = error {
                   print("Error saving post to Firestore: \(error.localizedDescription)")
                   DispatchQueue.main.async {
                       self.showAlert(title: "エラー", message: "投稿の保存に失敗しました。再試行してください。")
                   }
               } else {
                   print("Post saved successfully!")
                   DispatchQueue.main.async {
                       self.posts.append(post)

                       self.showAlert(title: "成功！", message: "投稿できました！")
                   }
               }
           }
       }
}
