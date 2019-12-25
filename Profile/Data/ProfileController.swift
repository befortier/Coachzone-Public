import UIKit
import Foundation

class ProfileController: ProfileControllerUI {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshPlaceValues()
        self.topProfileView.configureUI(user: activeUser)
    }
    
    //Gets newest DB, update the leaderboardview's franchise and total places
    func refreshPlaceValues(){
        refreshLeaderboard(){ success in
            if success{
                let total_leaderboard = self.getTotalLeaderboard()
                let franchise_leaderboard = self.getFranchiseLeaderboard()
                var total_place = 0
                var franchise_place = 0
                for entry in total_leaderboard{
                    if entry.user_id == self.activeUser.id{
                        total_place = entry.place
                    }
                }
                for entry in franchise_leaderboard{
                    if entry.user_id == self.activeUser.id{
                        franchise_place = entry.place
                    }
                }
                self.leaderboardView.configureUI(franchise_place: franchise_place, total_place: total_place)
            }
        }
    }
}
