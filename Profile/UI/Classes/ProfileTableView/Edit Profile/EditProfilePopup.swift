import UIKit
import Foundation
import DatePickerDialog
import SkyFloatingLabelTextField

protocol EditProfilePopupDelegate: class {
    func updateUserProfile(user: User)
}

class EditProfilePopup: AbstractPopup, UITextFieldDelegate{
    var delegate:EditProfilePopupDelegate!
    private var topProfileView: UIView!
    var profilePicture: CircleImage!
    private let font = UIFont (name: "GillSans", size: UIScreen.main.bounds.width * 0.045)

    var editImage: UIImageView!
    private var nameView: TextFieldCheckView!
    private var emailView: TextFieldCheckView!
    private var birthdayView: TextFieldCheckView!
    private var allFields: [TextFieldCheckView] = []
    private let darkGray = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    private let coachZoneRed = UIColor.init(red: 223/255, green: 0/255, blue: 46/255, alpha: 1)
    let imagePicker = UIImagePickerController()

    var user: User
    init(user: User){
        self.user = user
        super.init(title: "Edit Profile")
        customizeSubviews()
        constrainSubviews()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    private func customizeSubviews(){
        customizeSelf()
        cusomtizeTopProfileView()
        customizeProfilePicture()
        customizeEditImage()
        customizeFields()
    }
    
    private func constrainSubviews(){
        constrainTopProfileView()
        constrainProfilePicture()
        constrainTextFields()
        constrainEditImage()
    }
    
    private func customizeSelf(){
        self.doneButton.setImage(UIImage.init(), for: .normal)
        self.doneButton.setTitle("Save", for: .normal)
        let fontSize = UIScreen.main.bounds.width * 0.045
        let buttonFont = UIFont (name: "GillSans-SemiBold", size: fontSize)
        self.doneButton.titleLabel?.font = buttonFont
        self.doneButton.titleLabel?.textAlignment = .left
        self.doneButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        let resignResponderGesture = UITapGestureRecognizer(target: self, action: #selector(resignAllResponders))
        self.addGestureRecognizer(resignResponderGesture)
    }
    
    private func cusomtizeTopProfileView(){
        topProfileView = UIView()
        topProfileView.backgroundColor = .lightGray
        topProfileView.layer.cornerRadius = cornerRadius
        topProfileView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.containerView.addSubview(topProfileView)
    }
    
    private func customizeProfilePicture(){
        let coachZoneRed = UIColor.init(red: 223/255, green: 0/255, blue: 46/255, alpha: 1)
        let borderWidth = UIScreen.main.bounds.height * 0.01
        profilePicture = CircleImage()
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.borderColor = coachZoneRed.cgColor
        profilePicture.layer.borderWidth = borderWidth
        profilePicture.backgroundColor = .white
        profilePicture.isUserInteractionEnabled = true
        profilePicture.image = user.profile_picture
        self.containerView.addSubview(profilePicture)
    }
    
    private func customizeEditImage(){
        editImage = UIImageView()
        let image = UIImage(named: "Edit")
        self.addSubview(editImage)
        editImage.image = image
        editImage.contentMode = .scaleToFill
        editImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLibrary))
        editImage.addGestureRecognizer(tapGesture)
        profilePicture.addGestureRecognizer(tapGesture)
    }
    
    private func customizeFields(){
        let second_color:UIColor = .init(red: 128/255, green: 0, blue: 46/255, alpha: 1)
        nameView = TextFieldCheckView(type: .name, base_color: darkGray, second_color: second_color, mainText: "NAME")
        emailView = TextFieldCheckView(type: .email, base_color: darkGray, second_color: second_color, mainText: "EMAIL")
        birthdayView = TextFieldCheckView(type: .birthday, base_color: darkGray, second_color: darkGray, mainText: "BIRTHDAY")
        allFields = [nameView, emailView, birthdayView]
        let textStrings: [String] = [user.name, user.email, user.birthday]
        for (index,field) in allFields.enumerated(){
            let textField = field.textField!
            textField.selectedLineColor = coachZoneRed
            textField.selectedTitleColor = coachZoneRed
            textField.textColor = .black
            textField.tintColor = .black
            textField.text = textStrings[index]
            textField.titleErrorColor = .red
            textField.lineErrorColor = .red
            _ = field.validateMe()
            containerView.addSubview(field)
        }
        let birthdayTappedGesture = UITapGestureRecognizer(target: self, action: #selector(openBirthday))
        birthdayView.textField.addGestureRecognizer(birthdayTappedGesture)
    }

    
    private func constrainTopProfileView(){
        topProfileView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.15))
    }
    
    private func constrainProfilePicture(){
        profilePicture.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, height: containerView.heightAnchor, width: profilePicture.heightAnchor, sizeMultiplier: .init(width: 1, height: 0.25))
        profilePicture.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: topProfileView.bottomAnchor).isActive = true
    }
    
    private func constrainEditImage(){
        let topOffset = UIScreen.main.bounds.height * 0.02
        let leftOffset = UIScreen.main.bounds.width * 0.02
        let padding: UIEdgeInsets = UIEdgeInsets.init(top: topOffset, left: leftOffset, bottom: 0, right: 0)
        editImage.anchor(top: self.containerView.topAnchor, leading: profilePicture.trailingAnchor, bottom: nil, trailing: nil, height: self.editImage.widthAnchor, width: self.widthAnchor, sizeMultiplier: CGSize.init(width: 0.08, height: 1), padding: padding)
      

    }
    private func constrainTextFields(){
        let anchors = [profilePicture.bottomAnchor, nameView.bottomAnchor, emailView.bottomAnchor]
        let verticalPadding = UIScreen.main.bounds.height * 0.02
        let horizantalPadding = UIScreen.main.bounds.width * 0.075
        let fieldPadding: UIEdgeInsets = .init(top: verticalPadding, left: horizantalPadding, bottom: verticalPadding, right: horizantalPadding)
        for (index,field) in allFields.enumerated(){
            field.anchor(top: anchors[index], leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.12), padding: fieldPadding)
        }
    }
    

    
    @objc func resignAllResponders(){
        for field in allFields{
            field.textField!.resignFirstResponder()
        }
    }
 
    private func updateLocalUser(){
        for field in allFields{
            if let text = field.textField!.text{
                if field == nameView{
                    user.name = text
                }
                else if field == emailView{
                    user.email = text
                }
                else if field == birthdayView{
                    user.birthday = text
                }
            }
        }
        user.profile_picture = self.profilePicture.image
    }
    
    @objc func updateProfile(){
        var allValid = true
        allFields.forEach { (field) in
            if !field.validateMe(showErrorMessage: true){
                allValid = false
            }
        }
        if allValid{
            updateLocalUser()
            closeMe()
            delegate.updateUserProfile(user: user)
        }
    }
    
    override func constrainSelf(){
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(self)
        let topOffset = UIScreen.main.bounds.height * 0.04
        let bottomOffset = UIScreen.main.bounds.height * 0.3
        let horizantalOffset = UIScreen.main.bounds.width * 0.1
        let containerPadding: UIEdgeInsets = .init(top: topOffset, left: horizantalOffset, bottom: bottomOffset, right: horizantalOffset)
        dimView.containerView.anchor(equalTo: dimView, padding: containerPadding, sizeMultiplier: .zero)
        self.anchor(equalTo: dimView.containerView)
    }
    
    override func closeMe(){
        super.closeMe()
        resignAllResponders()
    }
    
    //Responsible for birthday input prompt. After updates field with new info, and validates.
    @objc func openBirthday(){
        DatePickerDialog().show("Birthday", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.birthdayView.textField.text = formatter.string(from: dt)
            }
            _ = self.birthdayView.validateMe()
        }
    }
    

}


