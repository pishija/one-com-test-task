//
//  ImageCaptureSelectionFlow.swift
//  Kalabalak
//
//  Created by Mihail Stevcev on 3/26/17.
//  Copyright © 2017 Mihail Stevcev. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices 

class MediaCaptureSelectionFlow: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var contextViewController: UIViewController?
    var completionHandler: ((UIImage?, Bool)->Void)?
    var controller: UIImagePickerController?
    
    //MARK: Flows
    
    func startImageCaptureSelectionFlow(from controller:UIViewController, with completionBlock: @escaping (UIImage?,Bool) -> Void) -> Void{
        let actionSheet = UIAlertController(title: "Image Source", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action: UIAlertAction) in
            self.startImageSelectionFlow(from: controller, with: completionBlock)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            self.startImageCaptureFlow(from: controller, with: completionBlock)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            completionBlock(nil, false)
        }))
        
        controller.present(actionSheet, animated: true, completion: nil)
    }
    
    func startImageSelectionFlow(from controller:UIViewController, with completionBlock: @escaping (UIImage?,Bool) -> Void) -> Void{
        self.checkIfPhotoLibraryAccessIsGranted { (granted: Bool) in
            if(granted){
                self.completionHandler = completionBlock
                self.contextViewController = controller
                self.selectCaptureMedia(forMediaTypes: [kUTTypeImage as String], fromSource: .photoLibrary)
                
            } else{
                self.showPhotoLibraryAccessDeniedAlert(in: controller)
                completionBlock(nil, granted)
            }
        }
    }
    
    func startImageCaptureFlow(from controller:UIViewController, with completionBlock: @escaping (UIImage?,Bool) -> Void) -> Void{
        self.checkIfCameraAccessIsGranted { (accessGranted: Bool) in
            if(accessGranted){
                self.completionHandler = completionBlock
                self.contextViewController = controller
                self.selectCaptureMedia(forMediaTypes: [kUTTypeImage as String], fromSource: .camera)
            } else {
                self.showCameraAccessDeniedAlert(in: controller)
                completionBlock(nil, accessGranted)
            }
        }
    }
    
    //MARK: UIImagePickerController
    func selectCaptureMedia(forMediaTypes mediaTypes: [String], fromSource source: UIImagePickerController.SourceType) -> Void{
        let supportedTypes = UIImagePickerController.availableMediaTypes(for: source)
        if(UIImagePickerController.isSourceTypeAvailable(source) && (supportedTypes?.count)! > 0){
            
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = source
            self.controller = picker
            self.contextViewController?.present(picker, animated: true, completion: nil)
        } else {
            self.completionHandler!(nil, false)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        if(mediaType == kUTTypeImage as String){
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            picker.dismiss(animated: true, completion: nil)
            self.completionHandler!(image, true)
        }
        else {
            picker.dismiss(animated: true, completion: nil)
            self.completionHandler!(nil, false)
        }
    }

    //MARK: Helpers
    func checkIfPhotoLibraryAccessIsGranted(completionBlock: @escaping (Bool) -> Void) -> Void{
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            case .authorized:
                completionBlock(true)
                break
            case .denied:
                completionBlock(false)
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                    if(status == .authorized){
                        completionBlock(true)
                    } else {
                        completionBlock(false)
                    }
                })
                break
            
            case .restricted:
                completionBlock(false)
            break
        
        }
    }
    
    func checkIfCameraAccessIsGranted(completion: @escaping (Bool) -> Void) -> Void{
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
            case .authorized:
                completion(true)
                break
            case .denied:
                completion(false)
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                    completion(granted)
               })
                break
        case .restricted:
                completion(false)
            break
        }
    }
    
    func showPhotoLibraryAccessDeniedAlert(in viewController: UIViewController) -> Void{
        let alertText = NSLocalizedString("\nIt looks like your privacy settings are preventing us from accessing your photo library. You can fix this by doing the following:\n\n1. Touch the \"Open settings\" button below to open the Settings app.\n\n2. Turn the Photos on.\n\n3. Open this app and try again.", comment: "")
        
        let alert = UIAlertController(title: "ERROR", message: alertText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open settings", comment: ""), style: .default, handler: { (action: UIAlertAction) in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment: ""), style: .cancel, handler: { (action: UIAlertAction) in
            
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showCameraAccessDeniedAlert(in viewController: UIViewController) -> Void{
        
        let alertText = NSLocalizedString("\nIt looks like your privacy settings are preventing us from accessing your camera. You can fix this by doing the following:\n\n1. Touch the \"Open settings\" button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again.", comment: "")
        
        let alert = UIAlertController(title: "ERROR", message: alertText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open settings", comment: ""), style: .default, handler: { (action: UIAlertAction) in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment: ""), style: .cancel, handler: { (action: UIAlertAction) in
            
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
