import UIKit
import Foundation

class ProfileControllerUI: LoggedInController {
    var safeZone: UIView!
    var topProfileView:TopProfileView!
    var favoriteTeamSection: FavoriteTeamSection!
    var leaderboardView: LeaderboardView!
    var profileTableView: ProfileTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func preloadController(){
        customizeSubViews()
        constrainSubViews()
    }
    
    private func customizeSubViews(){
        customizeSafeZone()
        customizeTopView()
        customizeFavoriteTeamSection()
        customizeLeaderboardView()
        customizeProfileTableView()
        
    }
    
    private func constrainSubViews(){
        constrainSafeZone()
        constrainTopView()
        constrainFavoriteTeamSection()
        constrainLeaderboardView()
        constrainProfileTableView()
    }
    
    private func customizeSafeZone(){
        self.view.backgroundColor = .black
        safeZone = UIView()
        self.view.addSubview(safeZone)
    }
    
    private func customizeTopView(){
        topProfileView = TopProfileView(user: activeUser)
        self.safeZone.addSubview(topProfileView)
    }
    
    private func customizeFavoriteTeamSection(){
        favoriteTeamSection = FavoriteTeamSection(team: activeUser.getFavoriteTeam())
        self.safeZone.addSubview(favoriteTeamSection)
    }
    
    private func customizeLeaderboardView(){
        leaderboardView = LeaderboardView(user: activeUser)
        self.safeZone.addSubview(leaderboardView)
    }
    
    private func customizeProfileTableView(){
        profileTableView = ProfileTableView(activeUser: activeUser)
        self.safeZone.addSubview(profileTableView)
    }
    
    private func constrainSafeZone(){
        let safeZoneHorizantalOffset: CGFloat = UIScreen.main.bounds.width/40
        let safeZonePadding: UIEdgeInsets = .init(top: 0, left: safeZoneHorizantalOffset, bottom: 0, right: safeZoneHorizantalOffset)
        safeZone.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: safeZonePadding)
    }
    
    private func constrainTopView(){
        topProfileView.anchor(top: safeZone.topAnchor, leading: safeZone.leadingAnchor, bottom: nil, trailing: safeZone.trailingAnchor, height: safeZone.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2))
    }
    
    private func constrainFavoriteTeamSection(){
        favoriteTeamSection.anchor(top: topProfileView.bottomAnchor, leading: safeZone.leadingAnchor, bottom: nil, trailing: safeZone.trailingAnchor, height: safeZone.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2))
    }
    
    private func constrainLeaderboardView(){
        let topPadding = UIScreen.main.bounds.height * 0.01
        let leaderboardViewPadding: UIEdgeInsets = .init(top: topPadding, left: 0, bottom: 0, right: 0)
        leaderboardView.anchor(top: favoriteTeamSection.bottomAnchor, leading: safeZone.leadingAnchor, bottom: nil, trailing: safeZone.trailingAnchor, height: safeZone.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.15), padding: leaderboardViewPadding)
        
    }
    
    private func constrainProfileTableView(){
        profileTableView.anchor(top: leaderboardView.bottomAnchor, leading: self.view.leadingAnchor, bottom: safeZone.bottomAnchor, trailing: safeZone.trailingAnchor)
    }
    
    func reconfigureAllUI(){
        topProfileView.configureUI(user: activeUser)
        favoriteTeamSection.configureUI(team: activeUser.getFavoriteTeam())
    }
    
    
    
}
