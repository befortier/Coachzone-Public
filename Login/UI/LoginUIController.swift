import UIKit
import AWSAuthCore
import AWSUserPoolsSignIn
import FBSDKLoginKit
import GoogleSignIn
class LoginUIController: LoginRegisterController {
    
    var emailView: TextFieldCheckView!
    var passwordView: TextFieldCheckView!
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    var facebookLoginButton: FBLoginButton!
    var googleLoginButton: GIDSignInButton!
    var facebookUIButton: RegistrationButton!
    var googleUIButton: RegistrationButton!
    var orLabel: AutoAdjustedLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeSubviews()
        constrainSubviews()
    }
    
    private func customizeSubviews(){
        customizeEmailView()
        customizePasswordView()
        customizeFacebookButton()
        customizeGoogleButton()
        customizeOrLabel()
    }
    
    private func constrainSubviews(){
        constrainEmailView()
        constrainActionButton()
        constrainPasswordView()
        constrainTopImageView()
        constrainFacebookLoginButton()
        constrainOrLabel()
        constrainGoogleButton()
    }
    
    
    private func customizeFacebookButton(){
        facebookLoginButton = FBLoginButton(type: .custom)
        facebookLoginButton.permissions = ["email", "public_profile"]
        facebookUIButton = RegistrationButton(type: .facebook, invert: false)
        let fbBlue = UIColor.init(red: 59/255, green: 89/255, blue: 252/255, alpha: 1)
        facebookUIButton.setTitleColor(fbBlue, for: .normal)
        self.view.addSubview(facebookUIButton)
    }
    
 
    
    private func customizeGoogleButton(){
        googleLoginButton = GIDSignInButton(frame: .zero)
        googleUIButton = RegistrationButton(type: .google, invert: false)
        self.view.addSubview(googleUIButton)
    }
    
    private func customizeOrLabel(){
        let fontSize = UIScreen.main.bounds.width * 0.06
        orLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "OR", color: .white, notBold: false)
        self.view.addSubview(orLabel)
    }
    
    private func customizeEmailView(){
        let second_color:UIColor = .init(red: 128/255, green: 0, blue: 46/255, alpha: 1)
        emailView = TextFieldCheckView(type: .email, base_color: .white, second_color: second_color, mainText: "EMAIL")
        allFields.append(emailView)
        self.view.addSubview(emailView)
    }
    
    private func customizePasswordView(){
        let second_color:UIColor = .init(red: 128/255, green: 0, blue: 46/255, alpha: 1)
        passwordView = TextFieldCheckView(type: .password, base_color: .white, second_color: second_color, mainText: "PASSWORD")
        allFields.append(passwordView)
        self.view.addSubview(passwordView)
    }
    
    private func constrainEmailView(){
        let horizantalPadding = UIScreen.main.bounds.width * 0.085
        let topPadding = UIScreen.main.bounds.height * 0.085
        let emailViewPadding: UIEdgeInsets = .init(top: topPadding, left: horizantalPadding, bottom: 0, right: horizantalPadding)
        emailView.anchor(top: topImageView.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, height: self.view.heightAnchor, sizeMultiplier: CGSize.init(width: 0, height: 0.07), padding: emailViewPadding)
    }
    
    private func constrainPasswordView(){
        let topPadding = UIScreen.main.bounds.height * 0.1
        let passwordViewPadding: UIEdgeInsets = .init(top: topPadding, left: 0, bottom: 0, right: 0)
        passwordView.anchor(top: emailView.topAnchor, leading: emailView.leadingAnchor, bottom: nil, trailing: emailView.trailingAnchor, height: emailView.heightAnchor, sizeMultiplier: .init(width: 0, height: 1.0), padding: passwordViewPadding)
    }
    
    private func constrainTopImageView(){
        topImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, height: self.view.heightAnchor, sizeMultiplier: CGSize.init(width: 0, height: 0.15))
    }
    
    private func constrainActionButton(){
        let horizantalPadding = UIScreen.main.bounds.width * 0.05
        let topPadding = UIScreen.main.bounds.height * 0.045
        let loginButtonPadding: UIEdgeInsets = .init(top: topPadding, left: horizantalPadding, bottom: 0, right: horizantalPadding)
        actionButton.anchor(top: passwordView.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, height: self.view.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.09), padding: loginButtonPadding)
    }
    
    private func constrainFacebookLoginButton(){
        let horizantalPadding = UIScreen.main.bounds.width * 0.05
        let bottomPadding = UIScreen.main.bounds.height * 0.025
        let loginButtonPadding: UIEdgeInsets = .init(top: 0, left: horizantalPadding, bottom: bottomPadding, right: horizantalPadding)
        facebookUIButton.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, height: self.view.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.09), padding: loginButtonPadding)
    }
    
    private func constrainGoogleButton(){
        let bottomPadding = UIScreen.main.bounds.height * 0.025
        let googleButtonPadding: UIEdgeInsets = .init(top: 0, left: 0, bottom: bottomPadding, right: 0)
        googleUIButton.anchor(top: nil, leading: actionButton.leadingAnchor, bottom: facebookUIButton.topAnchor, trailing: actionButton.trailingAnchor, height: actionButton.heightAnchor, sizeMultiplier: .init(width: 0, height: 1), padding: googleButtonPadding)
    }
    
    private func constrainOrLabel(){
        orLabel.anchor(top: actionButton.bottomAnchor, leading: actionButton.leadingAnchor, bottom: googleUIButton.topAnchor, trailing: actionButton.trailingAnchor)
    }
    
    override func animateLoadingFeedback() {
        self.facebookUIButton.alpha = 0
        self.orLabel.alpha = 0
        self.googleUIButton.alpha = 0
        super.animateLoadingFeedback()
    }
}









