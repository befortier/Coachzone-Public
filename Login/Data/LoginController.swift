import UIKit
import Alamofire
import SwiftyJSON
import AWSAuthCore
import AWSAuthUI
import AWSUserPoolsSignIn
import AWSMobileClient
import AWSCognitoIdentityProviderASF
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginController: LoginUIController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButtons()
        addNotifications()
    }
    
    //Sets neccesary delegates and targets for buttons
    private func customizeButtons(){
        self.facebookLoginButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookUIButton.addTarget(self, action: #selector(loginFb) , for: .touchUpInside)
        googleUIButton.addTarget(self, action: #selector(loginGoogle) , for: .touchUpInside)
    }
    
    //Adds an observer to a notification called by app delegate for when Google login was succesful or not. Calls googleDidLogin upon a succesful login notification, and googleFailedToLogin for an unsuccesful login notification
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(googleDidLogin), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleFailedToLogin), name: NSNotification.Name("CouldNotSignInNotification"), object: nil)
    }
   
    //Called when text fields are validated and user presses Login Button.
    override func mainControllerAction() {
        super.mainControllerAction()
        animateLoadingFeedback()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            self.signInAWS()
        }
    }
    
    //When the LoginUIbutton is pressed, press the actual FBSigninButton.
    @objc func loginFb(){
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    //When the LoginUIbutton is pressed, press the actual GoogleSigninButton.
    @objc func loginGoogle(){
        print("HERE")
        googleLoginButton.sendActions(for: .touchUpInside)
    }

    
    //Takes an email and password and signs into AWS through following steps:
        //1) Calls getUserId(email) which returns the user's id
        //2) Takes the id returned and creates a AWS session
        //3) If no error, calls signInDynmoDb
        //4) Any error happens, abort and provides the feedback
    private func signInAWS(emailString: String = "", passwordString: String = ""){
        var email = emailString
        var password = passwordString
        if emailString == ""{
            email = self.emailView.textField.text!
        }
        if passwordString == ""{
            password = self.passwordView.textField.text!
        }
        getUserId(email: email) { (response) -> (Void) in
            if let userId = response{
                let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: userId, password: password)
                let awsUser = self.pool.getUser(userId)
                self.passwordAuthenticationCompletion?.set(result: authDetails)
                awsUser.getSession(userId, password: password, validationData: nil).continueWith(block: { (task: AWSTask) -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error as NSError?{
                            print("AWS Sign in Error: ", error)
                            var messageString = "Your email or password was incorrect"
                            if error.code == 34{
                                messageString = "Your email is not in our system, try registering"
                            }
                            self.presentRegistrationFeedback(success: false, message:  messageString)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                self.registerFail()
                            })
                        }
                        else {
                            self.signInDynamoDb(email: email, password: password, isValidated: "no")
                        }
                    }
                })
            }
            else{
                let messageString: String = "Email does not exist in our system, try registering"
                DispatchQueue.main.async {
                    self.presentRegistrationFeedback(success: false, message: messageString)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        self.registerFail()
                    })
                }
            }
        }
    }
    
    //Makes request to backend to get the ID associated with the email put in.
    fileprivate func getUserId(email: String, completion:@escaping(String?) -> (Void)){
        let parameters : [String: Any] = [
            "email" : email,
        ]
        self.requester.request(server: .API, parameters: parameters, address_extension: "/email_exists") { (error, result) -> (Void) in
            if let err = error{
                var messageString = "Please check the credentials, there was an error"
                if err == "User already exists"{
                    messageString = "There is already an account with that email, try logging in."
                }
                self.presentRegistrationFeedback(success: false, message:  messageString)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.registerFail()
                })
            }
            else if let data = result{
                if let userId = data["id"]{
                    completion(userId.string)
                    return
                }
            }
        }
    }
    
    //Signs into the DynamoDb, sets the users access token. If success present the feedback, create and save the user to the defaults and the active user, and call segue home.
    private func signInDynamoDb(email: String, password: String, isValidated: String){
        let parameters = [
            "email" : email,
            "password": password,
            "isValidated": isValidated
        ]
        self.requester.request(server: .API, parameters: parameters, address_extension: "/login") { (error, result) -> (Void) in
            if let messageString = error{
                self.presentRegistrationFeedback(success: false, message: messageString)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.registerFail()
                })
            }
            else if let data = result{
                if let user = data["user"] {
                    self.presentRegistrationFeedback(success: true, message: "Welcome back!", title: "Logged In")
                    self.succesfulLogin(user: user)
                    self.segueHome()
                    
                }
            }
        }
    }
    
    
    //Function that handles if the user wants to sign in through facebook or google. Takes in the email of account, and a dictionary of information associated with account ("Birthday", "Email", "Name", "Picture" <- (PICTURE NOT IMPLEMENTED YET). First checks to see if the email exists in our databse already, implying they have registered an account with us. If the email already exists, just log them in by calling socialUserExists. If the user, force them to finish out registration, and push a registration controller on the view, already with textfields preloaded with the information we know through the profile paramter. Any error is handled through handleSocialLoginError
    private func handleSocialLogin(_ email: String, _ profile: [String: String]){
        self.doesEmailExist(email: email, completion: { (userExists, error) -> (Void) in
            if let _ = error{
                self.handleSocialLoginError("Our system is currently having trouble accesing our database, pleae try again later. Sorry")
            }
            else if userExists{
                if let token = AccessToken.current{
                  self.handleSocialUserExists(email, token.tokenString)
                }
                else if let token = GIDSignIn.sharedInstance().currentUser.authentication.accessToken{
                    self.handleSocialUserExists(email, token)
                }
                else{
                    self.handleSocialLoginError("Your attempt to log into Facebook was unsuccesful.")
                }
            }
            else{
                self.pushPreloadRegisterController(profile)
            }
        })
    }
    
    //Handles social login error by logging out of the social platform and letting users know there was an error
    private func handleSocialLoginError(_ message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        LoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
    }

    //If the user already exists and their just logging in, sign them into DyanmoDB
    private func handleSocialUserExists(_ email: String, _ tokenString: String){
        let poolId = "us-east-2:1334487c-5543-4782-8d58-d2f37b95b199"
        let provider = MyProvider(tokens: ["graph.facebook.com" : tokenString])
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoIdentityUserPoolRegion, identityPoolId: poolId, identityProviderManager: provider)
        let configuration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        self.signInDynamoDb(email: email, password:"", isValidated: "yes")
    }
    
    //If the user's email was non existentin our system, create a registerController and prefill the textfields with information we know about them through the social platform.
    private func pushPreloadRegisterController(_ profile: [String: String]){
        let registerController = RegisterController()
        registerController.preloadController()
        registerController.loadPreConfiguredInfo(profile: profile)
        self.navigationController?.pushViewController(registerController, animated: false)
        self.navigationController?.navigationBar.tintColor = .white
    }

}





extension LoginController: AWSCognitoIdentityPasswordAuthentication {
//IGNORE
    
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
    
    
    public func didCompleteStepWithError(_ error: Error?) {}
}


extension LoginController: LoginButtonDelegate{
    //User is logging in through facebook. If error, lets user know. Else, fetches user profile information to create the profile dictionary and calls to handleSocialLogin
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error{
            print("Facebook login error:", error)
            let alertController = UIAlertController(title: "Error", message: "There was an error establishing a connection with the Facebook servers, please try logging in with email and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            DispatchQueue.main.async {
                self.fetchUserProfileData(){(profile) -> (Void) in
                    if let email = profile["email"]{
                      self.handleSocialLogin(email, profile)
                    }
                }
            }
        }
    }
    
    //Not really called, just here.
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out")
    }
    
    
    // Fetch User's Public Facebook Profile Data
    func fetchUserProfileData(completion:@escaping([String:String]) -> (Void)) {
        let params = ["fields": "email, first_name, last_name"]
        GraphRequest(graphPath: "me", parameters: params).start(completionHandler: { connection, results, error in
            if let error = error{
                print("ERROR fetching fb data:", error)
                completion([:])
            }
            else{
                var profile: [String: String] = [:]
                let result = results as! NSDictionary
                if let email = result["email"] as? String{
                    profile["email"] = email
                }
                if let id = result["id"] as? String{
                    profile["id"] = id
                }
              
                if let birthday = result["birthday"] as? String{
                    profile["birthday"] = birthday
                }
                if let first_name = result["first_name"] as? String{
                    if let last_name = result["last_name"] as? String{
                        profile["name"] =  "\(first_name) \(last_name)"
                    }
                    else{
                        profile["name"] =  first_name
                    }
                }
                else if let last_name = result["last_name"] as? String{
                    profile["name"] =  last_name
                }
                completion(profile)
            }
        })
    }
}

extension LoginController: GIDSignInUIDelegate{
    //Next three functions are taken directly off google website, shouldn't need to toy with them
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {}
    
    private func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Logs into google and creates profile dictionary with the email and name
    @objc private func googleDidLogin(){
        if let user = GIDSignIn.sharedInstance()?.currentUser{
            var profile: [String: String] = [:]
            profile["email"] = user.profile.email
            profile["name"] = user.profile.name
            self.handleSocialLogin(user.profile.email, profile)
        }
        else{
            print("NOT SIGNED IN")
        }
    }
    
    //Reports error about logging into Google
    @objc private func googleFailedToLogin(){
        print("Failed to login")
        let alertController = UIAlertController(title: "Error", message: "There was an error establishing a connection with the Google servers, please try logging in with email and password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}







class MyProvider: NSObject, AWSIdentityProviderManager {
    
    var keytokens: [String:String]?
    
    init (tokens: [String:String]) {
        keytokens = tokens
    }
    
    func logins () -> AWSTask<NSDictionary> {
        
        let task = AWSTask(result: keytokens as AnyObject?)
        return task as! AWSTask<NSDictionary>
    }
    
}
