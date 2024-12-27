//
//  CameraViewController.swift
//  original
//
//  Created by 関戸さき on 2024/12/13.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var number: Int!
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var missionLabel2: UILabel!
    @IBOutlet var missionLabel3: UILabel!
    @IBOutlet var missionLabel4: UILabel!
    @IBOutlet var saveButton: UIButton!
    
    var showMission: String!
    var missions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionLabel2.isHidden = false
        missionLabel3.isHidden = false
        missionLabel.isHidden = true
        missionLabel4.isHidden = true
        saveButton.isHidden = true
        
        missions =
        ["今日の服を写そう"]
        
//        missions = ["水や鏡などに映った面白い反射を撮ってみよう","写真の中に自分の指を隠して撮影してみよう","わざと写真を逆さまにして撮ってみよう","しましま模様があるものを見つけよう", "日本的なものを撮影してみよう", "未来を感じさせる何かを撮影しよう", "左右対称の構図で撮影してみよう", "何かのマークやロゴを見つけて撮影しよう", "今日の服を写そう", "英語が書かれているものを見つけて撮影", "ミッションが見つかりませんでした" ]
        number = Int.random(in: 0..<missions.count)
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
        
    }
    
    
    func drawText(image: UIImage) -> UIImage{
        
        let text = showMission!
        
        let fontSize = image.size.width / 10
        let textFontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DelaGothicOne-Regular", size: fontSize)!,
            .foregroundColor: UIColor.white

        ]
        
        // テキストのサイズを計算
            let textSize = text.size(withAttributes: textFontAttributes)
//            
            // 中央揃えのX座標
            let textX = (image.size.width - textSize.width) / 2
            
            // 一番上で揃えるY座標
            let margin: CGFloat = 20.0  // 上部の余白
            let textY = margin
            
            // テキストの描画範囲
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
    
    

}
