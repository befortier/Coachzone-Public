import UIKit
import Foundation
import Photos

extension EditProfilePopup: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @objc func openLibrary(){
        checkPermission()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            self.profilePicture.image = selectedImage
        }
        togglePicker(false)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        togglePicker(false)
    }

    func togglePicker(_ show: Bool){
        if let controller = getController(){
            show ? controller.present(imagePicker, animated: true) : controller.dismiss(animated: true)
            self.dimView.isHidden = show
            self.isHidden = show
      
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.togglePicker(true)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus == .authorized {
                    self.togglePicker(true)
                }
                else {
                    self.alertUserToEnableAccess()
                }
            })
            break
        case .restricted, .denied:
            alertUserToEnableAccess()
            print("User do not have access to photo album.")
            break
        }
    }
    
    func alertUserToEnableAccess(){
        let alertController = UIAlertController(title: "Access Denied", message: "Please go to app settings and allow photo library access to upload a photo", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let controller = getController(){
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getController() -> LoggedInController?{
        if let profileTableView = self.delegate as? ProfileTableView{
            if let controller = profileTableView.parentViewController as? LoggedInController{
                return controller
            }
        }
        return nil
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
}

