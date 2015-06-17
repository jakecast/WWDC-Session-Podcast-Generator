import Foundation

private let sessionDateFormatter: NSDateFormatter = createSessionDateFormatter()
private let pubDateFormatter: NSDateFormatter = createPubDateFormatter()

internal func getSessionInfoFromFile(filePath: String) -> [String:[[String:AnyObject]]]? {
    var wwdcSessionInfo: [String:[[String:AnyObject]]]?
    if let sessionData = NSData(contentsOfFile: filePath), let sessionInfo = decodeJSON(sessionData) {
        wwdcSessionInfo = processSessionInfo(sessionInfo)
    }
    else {
        wwdcSessionInfo = nil
    }
    
    return wwdcSessionInfo
}

internal func getSessionInfoFromURL(url: String) -> [String:[[String:AnyObject]]]? {
    var wwdcSessionInfo: [String:[[String:AnyObject]]]?
    if let sessionURL = NSURL(string: url), let sessionData = NSData(contentsOfURL: sessionURL), let sessionInfo = decodeJSON(sessionData) {
        wwdcSessionInfo = processSessionInfo(sessionInfo)
    }
    else {
        wwdcSessionInfo = nil
    }
    
    return wwdcSessionInfo
}

private func createSessionDateFormatter() -> NSDateFormatter {
    let sessionDateFormatter = NSDateFormatter()
    sessionDateFormatter.dateFormat = "yyyy-MM-dd"
    return sessionDateFormatter
}

private func createPubDateFormatter() -> NSDateFormatter {
    let pubDateFormatter = NSDateFormatter()
    pubDateFormatter.dateFormat = "EEE, dd MMM YYYY HH:mm:ss ZZZ"
    return pubDateFormatter
}

private func decodeJSON(jsonData: NSData) -> [String:AnyObject]? {
    var json: AnyObject?
    do {
        json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
    }
    catch {
        json = nil
    }
    return json as? [String:AnyObject]
}

private func processSessionInfo(sessionInfo: [String:AnyObject]) -> [String:[[String:AnyObject]]] {
    var wwdcSessionInfo: [String:[[String:AnyObject]]] = [:]
    
    if let sessionList = sessionInfo["sessions"] as? [[String:AnyObject]] {
        for session in sessionList {
            var sessionData = session
            let sessionYear = String(sessionData["year"]! as! Int)
            
            if wwdcSessionInfo[sessionYear] == nil {
                wwdcSessionInfo[sessionYear] = []
            }
            
            if let sessionDateString = sessionData["date"] as? String, let sessionDate = sessionDateFormatter.dateFromString(sessionDateString) {
                sessionData["date"] = sessionDate.timeIntervalSinceReferenceDate
                sessionData["dateString"] = pubDateFormatter.stringFromDate(sessionDate)
            }
            
            if sessionData["download_hd"] is String == false {
                sessionData["download_hd"] = sessionData["url"]
            }
            
            if sessionData["download_sd"] is String == false {
                sessionData["download_sd"] = sessionData["url"]
            }
            
            wwdcSessionInfo[sessionYear]?.append(sessionData)
        }
    }
    
    for (year, sessions) in wwdcSessionInfo {
        let sessionsSorted = sessions.sort({(firstSession, secondSession) -> Bool in
            var isOrderedBefore: Bool = false
            if let firstSessionDate = firstSession["date"] as? NSTimeInterval, let secondSessionDate = secondSession["date"] as? NSTimeInterval {
                if firstSessionDate != secondSessionDate {
                    isOrderedBefore = firstSessionDate < secondSessionDate
                }
                else if let firstSessionID = firstSession["id"] as? Int, let secondSessionID = secondSession["id"] as? Int {
                    isOrderedBefore = firstSessionID < secondSessionID
                }
            }
            else {
                isOrderedBefore = false
            }
            
            return isOrderedBefore
        })
        wwdcSessionInfo[year] = sessionsSorted
    }
    
    return wwdcSessionInfo
}
