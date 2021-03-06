import Foundation

// https://github.com/the-blue-alliance/the-blue-alliance/blob/364d6da2f3fc464deef5ba580ea37b6cd2816c4a/consts/notification_type.py
enum NotificationType: String, Codable {
    case upcomingMatch = "upcoming_match"
    case matchScore = "match_score"
    case levelStarting = "starting_comp_level"
    case allianceSelection = "alliance_selection"
    case awards = "awards_posted"
    case mediaPosted = "media_posted"
    case districtPointsUpdated = "district_points_updated"
    case scheduleUpdated = "schedule_updated"
    case finalResults = "final_results"
    case ping = "ping"
    case broadcast = "broadcast"
    case matchVideo = "match_video"
    case eventMatchVideo = "event_match_video"

    case updateFavorites = "update_favorites"
    case updateSubscription = "update_subscriptions"

    case verification = "verification"


    func displayString() -> String {
        switch self {
        case .upcomingMatch:
            return "Upcoming Match"
        case .matchScore:
            return "Match Score"
        case .levelStarting:
            return "Competition Level Starting"
        case .allianceSelection:
            return "Alliance Selection"
        case .awards:
            return "Awards Posted"
        case .mediaPosted:
            return "Media Posted"
        case .districtPointsUpdated:
            return "District Points Updated"
        case .scheduleUpdated:
            return "Event Schedule Updated"
        case .finalResults:
            return "Final Results"
        case .matchVideo:
            return "Match Video Added"
        case .eventMatchVideo:
            return "Match Video Added"
        default:
            return "" // These shouldn't render
        }
    }
}

struct MyTBASubscriptionsResponse: MyTBAResponse, Codable {
    var subscriptions: [MyTBASubscription]?
}

struct MyTBASubscription: MyTBAModel, Equatable, Codable {

    static var arrayKey: String {
        return "subscriptions"
    }

    var modelKey: String
    var modelType: MyTBAModelType
    var notifications: [NotificationType]

    static var fetch: (MyTBA) -> (@escaping ([MyTBAModel]?, Error?) -> Void) -> URLSessionDataTask = MyTBA.fetchSubscriptions
}

extension MyTBA {

    @discardableResult
    func fetchSubscriptions(_ completion: @escaping (_ subscriptions: [MyTBASubscription]?, _ error: Error?) -> Void) -> URLSessionDataTask {
        let method = "\(MyTBASubscription.arrayKey)/list"

        return callApi(method: method, completion: { (favoritesResponse: MyTBASubscriptionsResponse?, error) in
            completion(favoritesResponse?.subscriptions, error)
        })
    }

}
