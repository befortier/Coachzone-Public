import UIKit
import SkyFloatingLabelTextField

class TextFieldCheckView: UIView, UITextFieldDelegate{
    //Dictates what type of textfield usage this is for
    enum textFieldType {
        case name
        case phone_number
        case email
        case password
        case birthday
        case favorite_team
        case confirm_data
    }
    
    var textField: SkyFloatingLabelTextField!
    var checkView: UIImageView!
    var type: textFieldType
    var isValid: Bool = false
    private var error_message: String = ""
    private let base_color: UIColor
    private let second_color: UIColor
    private let mainText: String
    
    init(type: textFieldType, base_color: UIColor, second_color: UIColor, mainText: String){
        self.base_color = base_color
        self.second_color = second_color
        self.mainText = mainText
        self.type = type
        super.init(frame: .zero)
        customizeSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubviews(){
        customizeTextField()
        customizeCheckView()
    }
    
    private func constrainSubviews(){
        constrainTextField()
        constrainCheckView()
    }
    
    private func customizeTextField(){
        textField = SkyFloatingLabelTextField(frame: .zero)
        textField.lineColor = base_color
        textField.errorColor = base_color
        textField.lineErrorColor = base_color
        textField.textErrorColor = base_color
        textField.titleErrorColor = base_color
        textField.selectedLineColor = base_color
        textField.selectedTitleColor = base_color
        textField.textColor = base_color
        textField.titleColor = base_color
        textField.tintColor = base_color
        textField.placeholderColor = second_color
        textField.placeholder = mainText
        textField.selectedTitle = mainText
        textField.title = mainText
        textField.delegate = self
        textField.addTarget(self, action: #selector(checkReset), for: .editingChanged)
        configureSpecificTextFieldDetails()
        self.addSubview(textField)
    }
    
    private func customizeCheckView(){
        checkView = UIImageView()
        let checkImage = base_color == .white ? UIImage(named: "checkmark") : UIImage(named: "Red Checkmark")
        checkView.image = checkImage
        checkView.isHidden = !((textField.text?.count)! > 0)
        self.addSubview(checkView)
       
    }
    
    private func configureSpecificTextFieldDetails(){
        switch type{
        case .email:
            self.textField.keyboardType = .emailAddress
            self.textField.textContentType = .emailAddress
            self.textField.autocapitalizationType = .words
            self.textField.spellCheckingType = .yes
            break
        case .password:
            self.textField.textContentType = .password
            self.textField.isSecureTextEntry = true
            self.textField.spellCheckingType = .no
            break
        case .name:
            self.textField.textContentType = .name
            self.textField.autocapitalizationType = .words
            self.textField.spellCheckingType = .yes
            break
        case .phone_number:
            self.textField.textContentType = .telephoneNumber
            self.textField.keyboardType = .phonePad
            break
        case .birthday:
            self.textField.allowsEditingTextAttributes = false
            break
        case .favorite_team:
            self.textField.allowsEditingTextAttributes = false
            break
        case .confirm_data:
            if #available(iOS 12, *) {
                self.textField.textContentType = .oneTimeCode
            }
            break
        
        }
    }
    
    private func constrainTextField(){
        textField.anchor(equalTo: self)
    }
    
    private func constrainCheckView(){
        let horizantalPadding = UIScreen.main.bounds.width * 0.065
        let checkPadding: UIEdgeInsets = .init(top: horizantalPadding, left: 0, bottom: horizantalPadding/3.5, right: 0)
         checkView.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, width: self.checkView.heightAnchor, sizeMultiplier: .init(width: 1, height: 0), padding: checkPadding)
    }
    
 
    //Shows or hides check mark depending on yes: (Show is true, Hide is false)
    func showCheckMark(yes: Bool){
        checkView.isHidden = !yes
    }
    
    //Validates that this given textfield is valid by our validation methods
    func validateMe(showErrorMessage: Bool = false) -> Bool{
        let validate: Validate = Validate(field: self)
        var qualifier: Bool = validate.isFilled(showErrorMessage: showErrorMessage)

        if let text = textField.text{
            switch type{
            case .name:
                qualifier = text.count > 1
                error_message = qualifier ? "" : "At least 2 characters"
                break
                
            case .email:
                qualifier = validate.isEmailValid()
                error_message = qualifier ? "" : "Invalid Email"
                break
                
            case .password:
                textField.text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                error_message = validate.getPasswordVunerability()
                qualifier = error_message == ""
                break
                
            case .phone_number:
                let phone_validation:Validate = Validate(field: self)
                if let phone_number = phone_validation.format(phoneNumber: text){
                    if phone_number[0] != "+"{
                        error_message = phone_number
                        qualifier = false
                    }
                    else{
                        textField.text = phone_number
                        qualifier = true
                    }
                }
                break
                
            default:
                if qualifier {
                    error_message = ""
                    textField.errorMessage = error_message
                }
                else{
                    error_message = "Field is required"
                }
            }
        }
        isValid = qualifier
        showCheckMark(yes: qualifier)
        if showErrorMessage && error_message != "" && (textField.errorMessage == "" || textField.errorMessage == nil){
            self.textField.handleError(message: error_message)
        }
        return qualifier
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isValid = validateMe()
    }
    
    //Function that checks to see if a skyfloatinglabeltext field has changed values, if the value changes to have something remove error message
    @objc func checkReset(){
        if let text = textField.text{
            if text != ""{
                textField.errorMessage = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
