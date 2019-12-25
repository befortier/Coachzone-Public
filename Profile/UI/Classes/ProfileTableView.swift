import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import GoogleSignIn

class ProfileTableView: UIView, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView!
    var tableCellInfo: [ProfileTableCellInfo]!
    let reuseIdentifier = "ProfileTableViewCell"
    var activeUser: User
    init(activeUser: User){
        self.activeUser = activeUser
        super.init(frame:.zero)
        customizeSubViews()
        constrainSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubViews(){
        customizeTableCellInfo()
        customizeTableView()
        
    }
    
    private func constrainSubViews(){
            tableView.anchor(equalTo: self)
    }
    
    //Initalizes the 5 different cell's info neccsesary for profile view
    private func customizeTableCellInfo(){
        let edit = ProfileTableCellInfo(logo: "Edit", title: "Edit Profile", type: .edit_profile, delegate: self, user: activeUser)
        let changeFavoriteTeam = ProfileTableCellInfo(logo: "Heart", title: "Change Favorite Team", type: .change_favorite_team, delegate: self, user: activeUser)
        let help = ProfileTableCellInfo(logo: "Help", title: "Get Help", type: .help, delegate: self, user: activeUser)
        let feedback = ProfileTableCellInfo(logo: "Feedback", title: "Give Feedback", type: .feedback, delegate: self, user: activeUser)
        let logout = ProfileTableCellInfo(logo: "Logout", title: "Logout", type: .logout, delegate: self, user: activeUser)
        let scoring_help = ProfileTableCellInfo(logo: "Score_Help", title: "Scoring Rules", type: .scoring_help, delegate: self, user: activeUser)
        tableCellInfo = [edit, changeFavoriteTeam, scoring_help, logout, feedback,help]
    }

    private func customizeTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ProfileTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.isScrollEnabled = true
        self.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileTableCell
        let cellInfo = tableCellInfo[indexPath.row]
        cell.configure(info: cellInfo)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = UIScreen.main.bounds.height * 0.08
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProfileTableCell{
            if cell.info.type == .scoring_help{
                if let parentController = self.parentViewController{
                    let helpController = ScoreHelpController()
                    parentController.navigationController?.pushViewController(helpController, animated: false)
                }
            }
            else{
                if cell.info.type == .edit_profile{
                    if let edit_profile_popup = cell.info.popup as? EditProfilePopup{
                        edit_profile_popup.profilePicture.image = activeUser.profile_picture
                    }
                }
                cell.info.popup.showPopup()
            }
        
        }
    }
    
    //Actually goes and updates the DB with active user, called after change was made to activeUser's profile
    func updateUserBackend(){
        let requestString = URL(string: "\(API_Server_Adress)/update_profile")!
        let parameters : [String: Any] = [
            "user_id": activeUser.id,
            "email" : activeUser.email,
            "name": activeUser.name,
            "phone_number": activeUser.phone_number,
            "favorite_team": activeUser.favorite_team,
            "login_token": activeUser.login_token,
            "birthday": activeUser.birthday
        ]
        let headers = [
            "Content-Type" : "application/json",
            "API-KEY": API_KEY
        ]
        
        Alamofire.request(requestString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let res = response.result.value {
                
                let json = JSON(res)
                if let err = json["errors"].dictionary{
                    print("ERROR", err)
                }
                if let _ = json["data"].dictionary {
                    print("success")
                }
            }
        }
    }
    
}


extension ProfileTableView: FavoriteTeamPopupDelegate{
    func cancelChoice(sender: FavoriteTeamPopup) {
        sender.setFocusedIndex()
    }
    //User wants to change NFL team, changes activeUser's favorite team to be new team, reconfigures the UI of the profile, then updates the database, then updates the front end by saving to defaults and updating TabBar activeUser. Lastly refreshes place values to show the newest franchise scores
    func updateChoice(team: NFLTeam){
        activeUser.favorite_team = team.abbr
        let profileController = self.parentViewController as! ProfileController
        profileController.reconfigureAllUI()
        updateUserBackend()
        profileController.updateUserFrontend(user: activeUser)
        profileController.refreshPlaceValues()
    }
}

extension ProfileTableView: FeedbackPopupDelegate{
    //Puts the feedback into our system
    func sendFeedback(feedback: String) {
        let params : [String: Any] = ["user_id": activeUser.id, "feedback": feedback]
        Requester().request(server: .API, parameters: params, address_extension: "/add_feedback") { (err, res) -> (Void) in
            if let error = err{
                print("UNHANDLED ERROR handling feedback", error)
            }
        }
    }
}

extension ProfileTableView: EditProfilePopupDelegate{
    //User saved information, update profile picture, local and db
    func updateUserProfile(user: User) {
        activeUser = user
        activeUser.updateProfilePicture(activeUser.profile_picture)
        let profileController = self.parentViewController as! ProfileController
        profileController.reconfigureAllUI()
        updateUserBackend()
        profileController.updateUserFrontend(user: activeUser)
    }
}

extension ProfileTableView: LogoutPopupDelegate{
    //Logs user out and brings them back home and lets them know they have been logged out
    func logout(){
        GIDSignIn.sharedInstance().signOut()
        let loginManager = LoginManager()
        loginManager.logOut()
        UserDefaults.standard.removeObject(forKey: "user")
        let openScreen = UINavigationController(rootViewController: OpenScreen())
        self.parentViewController!.present(openScreen, animated: true, completion: {
            self.parentViewController!.presentRegistrationFeedback(success: true, message: "Hope to see you again soon!", title: "Logged Out")
        })
    }
}



