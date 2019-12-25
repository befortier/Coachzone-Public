import UIKit
import Foundation

struct ProfileTableCellInfo {
    enum Profile_Type{
        case edit_profile
        case change_favorite_team
        case feedback
        case logout
        case help
        case scoring_help
    }
    let logo: UIImage
    let title: String
    let type: Profile_Type
    var popup: AbstractPopup!

    init(logo: String, title: String, type: Profile_Type, delegate: ProfileTableView, user: User){
        self.logo = UIImage(named: logo)!
        self.title = title
        self.type = type
        initPopover(delegate: delegate, user: user)
    }
    
    //Initalizes the popover as the correct subclass and sets delegate if neccesary
    mutating func initPopover(delegate: ProfileTableView, user: User){
        switch self.type{
        case .edit_profile:
            self.popup = EditProfilePopup(user: user)
            (popup as! EditProfilePopup).delegate = delegate
            break
            
        case .change_favorite_team:
            popup = FavoriteTeamPopup(favorite_team: user.getFavoriteTeam())
            (popup as! FavoriteTeamPopup).delegate = delegate
            break
            
        case .feedback:
            popup = FeedbackPopup()
            (popup as! FeedbackPopup).delegate = delegate
            break
            
        case .logout:
            popup = LogoutPopup()
            (popup as! LogoutPopup).delegate = delegate
            break
            
        case .help:
            popup = GetHelpPopup()
            break
        default:
            break
        }
    }
    
}
