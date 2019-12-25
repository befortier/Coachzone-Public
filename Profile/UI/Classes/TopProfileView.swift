import UIKit
import Foundation

class TopProfileView: UIView{
    private let fontSize = UIScreen.main.bounds.width * 0.065
    private var profilePictureContainer: CircleView!
    private var profilePicture: CircleImage!
    private var userNameLabel: AutoAdjustedLabel!
    private var userPointsLabel: AutoAdjustedLabel!
    private var user: User
    init(user: User){
        self.user = user
        super.init(frame:.zero)
        customizeSubViews()
        constrainSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func customizeSubViews(){
        customizeProfilePictureContainer()
        customizeProfilePicture()
        customizeUserNameLabel()
        customizeUserPointsLabel()
    }
    
    private func constrainSubViews(){
        constrainProfilePictureContainer()
        constrainProfilePicture()
        constrainUserNameLabel()
        constrainUserPointsLabel()
    }
    
    private func customizeProfilePictureContainer(){
        profilePictureContainer = CircleView(shouldBeWhite: false)
        let redBackground = UIColor.init(red: 223/255, green: 0/255, blue: 46/255, alpha: 1)
        profilePictureContainer.backgroundColor = redBackground
        self.addSubview(profilePictureContainer)
    }
    
    private func customizeProfilePicture(){
        profilePicture = CircleImage()
        self.profilePictureContainer.addSubview(profilePicture)
        self.profilePicture.image = user.profile_picture
        profilePicture.backgroundColor = .white
    }
    
    private func customizeUserNameLabel(){
        userNameLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: user.getFullName(), color: .white, notBold: false)
        userNameLabel.textAlignment = .left
        self.addSubview(userNameLabel)
    }

    private func customizeUserPointsLabel(){
        let points = user.login_token + " Points"
        userPointsLabel = AutoAdjustedLabel(numberOfLines: 0, fontSize: fontSize * 0.8, text: points, color: .lightGray, notBold: true)
        userPointsLabel.textAlignment = .left
        userPointsLabel.sizeToFit()
        self.addSubview(userPointsLabel)
    }

    private func constrainProfilePictureContainer(){
        let leftOffset = UIScreen.main.bounds.width * 0.04
        let verticalOffset = UIScreen.main.bounds.height * 0.02
        let profilePictureContainerPadding: UIEdgeInsets = .init(top: verticalOffset, left: leftOffset, bottom: verticalOffset, right: 0)
        profilePictureContainer.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, width: self.profilePictureContainer.heightAnchor, sizeMultiplier: .init(width: 1.0, height: 0), padding: profilePictureContainerPadding)
    }
    
    private func constrainProfilePicture(){
        let offSet = UIScreen.main.bounds.height * 0.005
        let profilePicturePadding: UIEdgeInsets = .init(top: offSet, left: offSet, bottom: offSet, right: offSet)
        profilePicture.anchor(equalTo: profilePictureContainer, padding: profilePicturePadding, sizeMultiplier: .zero)
        
    }
    
    private func constrainUserNameLabel(){
        let leftPadding = UIScreen.main.bounds.width * 0.06
        let topPadding = UIScreen.main.bounds.height * 0.03
        let userNameLabelPadding:UIEdgeInsets = .init(top: topPadding, left: leftPadding, bottom: 0, right: 0)
        userNameLabel.anchor(top: self.topAnchor, leading: profilePictureContainer.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, height: self.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.3), padding: userNameLabelPadding)
    }
    
    private func constrainUserPointsLabel(){
        userPointsLabel.anchor(top: userNameLabel.bottomAnchor, leading: userNameLabel.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, height: self.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2))
    }
    
    //Takes a user and updates the name, points, and picture section of the top profile view
    func configureUI(user: User){
        self.user = user
        DispatchQueue.main.async {
            self.userNameLabel.text = self.user.getFullName()
            self.userPointsLabel.text = (self.user.total_points_scored.toFormattedString() ?? String(self.user.total_points_scored)) + " Points"
            self.profilePicture.image = user.profile_picture
            self.layoutSubviews()
        }
    }
}
