//
//  CameraViewController.swift
//  original
//
//  Created by 関戸さき on 2024/12/13.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            
            
            
        }
    }
    
}


