//
//  CameraViewController.swift
//  original
//
//  Created by 関戸さき on 2024/12/13.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.layer.borderColor = UIColor.black.cgColor  // 枠線の色
        cameraButton.layer.borderWidth = 1.0 // 枠線の太さ
        cameraButton.layer.cornerRadius = 10 //ボタンの角を丸める
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
        
        let image = info[.originalImage] as! UIImage
        let size = CGSize(width: image.size.width / 8, height: image.size.height / 8)
        let resizedImage = UIGraphicsImageRenderer(size: size).image { _ in image.draw(in: CGRect(origin: .zero, size: size))
            photoImageView.image = image
            
        }
    }
    
    
    func drawText(image: UIImage) -> UIImage{
        
        let text = "post1"
        
        let fontSize = image.size.width / 10
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Dela Gothic One", size: fontSize)!,
            NSAttributedString.Key.foregroundColor: UIColor.white

        ]
        
        // テキストのサイズを計算
            let textSize = text.size(withAttributes: textFontAttributes)
            
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
    
    @IBAction func onTappedTextButton() {
        if photoImageView.image != nil {
            photoImageView.image = drawText(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
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
