import Foundation
import CoreData
import UIKit

class TeamAtEventViewController: ContainerViewController {

    private let teamKey: TeamKey
    private let event: Event

    // Where should we push to, when clicking the navigation bar from the top. Should be the opposite of what view sent us here
    // Ex: A EventStats VC is contexted as an Event view controller, so showDetailTeam should be true
    private let showDetailEvent: Bool
    private let showDetailTeam: Bool

    private let statusService: StatusService
    private let urlOpener: URLOpener
    private let myTBA: MyTBA

    // MARK: - Init

    init(teamKey: TeamKey, event: Event, myTBA: MyTBA, showDetailEvent: Bool, showDetailTeam: Bool, statusService: StatusService, urlOpener: URLOpener, persistentContainer: NSPersistentContainer, tbaKit: TBAKit, userDefaults: UserDefaults) {
        self.teamKey = teamKey
        self.event = event
        self.showDetailEvent = showDetailEvent
        self.showDetailTeam = showDetailTeam
        self.statusService = statusService
        self.urlOpener = urlOpener
        self.myTBA = myTBA

        let summaryViewController: TeamSummaryViewController = TeamSummaryViewController(teamKey: teamKey, event: event, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
        let matchesViewController: MatchesViewController = MatchesViewController(event: event, teamKey: teamKey, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
        let statsViewController: TeamStatsViewController = TeamStatsViewController(teamKey: teamKey, event: event, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
        let awardsViewController: EventAwardsViewController = EventAwardsViewController(event: event, teamKey: teamKey, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)

        let navigationTitle: String = {
            var navigationTitle = "Team \(teamKey.teamNumber)"
            if showDetailTeam {
                navigationTitle.append(" >")
            }
            return navigationTitle
        }()

        let navigationSubtitle: String = {
            var navigationSubtitle = "@ \(event.friendlyNameWithYear)"
            if showDetailEvent {
                navigationSubtitle.append(" >")
            }
            return navigationSubtitle
        }()

        super.init(viewControllers: [summaryViewController, matchesViewController, statsViewController, awardsViewController],
                   navigationTitle: navigationTitle,
                   navigationSubtitle: navigationSubtitle,
                   segmentedControlTitles: ["Summary", "Matches", "Stats", "Awards"],
                   persistentContainer: persistentContainer,
                   tbaKit: tbaKit,
                   userDefaults: userDefaults)

        navigationTitleDelegate = self
        summaryViewController.delegate = self
        matchesViewController.delegate = self
        awardsViewController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TeamAtEventViewController: NavigationTitleDelegate {

    func navigationTitleTapped() {
        if showDetailEvent {
            // Push to Event
            let eventViewController = EventViewController(event: event, statusService: statusService, urlOpener: urlOpener, myTBA: myTBA, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
            navigationController?.pushViewController(eventViewController, animated: true)
        } else if showDetailTeam {
            // Push to Team
            let eventViewController = TeamViewController(teamKey: teamKey, statusService: statusService, urlOpener: urlOpener, myTBA: myTBA, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
            navigationController?.pushViewController(eventViewController, animated: true)
        }
    }

}

extension TeamAtEventViewController: MatchesViewControllerDelegate, TeamSummaryViewControllerDelegate {

    func awardsSelected() {
        // TODO: Suspect....
        let awardsViewController = EventAwardsContainerViewController(event: event, teamKey: teamKey, myTBA: myTBA, statusService: statusService, urlOpener: urlOpener, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
        self.navigationController?.pushViewController(awardsViewController, animated: true)
    }

    func matchSelected(_ match: Match) {
        let matchViewController = MatchViewController(match: match, teamKey: teamKey, myTBA: myTBA, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
        self.navigationController?.pushViewController(matchViewController, animated: true)
    }

}

extension TeamAtEventViewController: EventAwardsViewControllerDelegate {

    func teamKeySelected(_ teamKey: TeamKey) {
        // Don't push to team@event for team we're already showing team@event for
        if self.teamKey == teamKey {
            return
        }

        let teamAtEventViewController = TeamAtEventViewController(teamKey: teamKey, event: event, myTBA: myTBA, showDetailEvent: showDetailEvent, showDetailTeam: showDetailTeam, statusService: statusService, urlOpener: urlOpener, persistentContainer: persistentContainer, tbaKit: tbaKit, userDefaults: userDefaults)
        self.navigationController?.pushViewController(teamAtEventViewController, animated: true)
    }

}
