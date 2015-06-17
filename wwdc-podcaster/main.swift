import Foundation

private let wwdcImages = [
    2015: "http://devstreaming.apple.com/videos/wwdc/2015/1014o78qhj07pbfxt9g7/101/images/101_600x600.jpg",
]

private let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}()

private func getSessionDate(sessionData: [String:AnyObject]) -> NSTimeInterval {
    return dateFormatter.dateFromString(sessionData["date"] as! String)!.timeIntervalSinceReferenceDate
}

private func getFileData(filePath: String) -> NSData {
    return NSData(contentsOfFile: filePath)!
}

private func getDataJSON(fileData: NSData) -> [String:AnyObject] {
    var sessionJSON: AnyObject? = nil
    do {
        sessionJSON = try NSJSONSerialization.JSONObjectWithData(fileData, options: NSJSONReadingOptions.AllowFragments)
    }
    catch _ {
        sessionJSON = nil
    }
    return sessionJSON as? [String:AnyObject] ?? [:]
}

private func getSessions(sessionJSON: [String:AnyObject], year: Int) -> [[String:AnyObject]] {
    let sessions: [[String:AnyObject]]
    if let sessionList = sessionJSON["sessions"] as? [[String:AnyObject]] {
        sessions = sessionList
            .filter({ return $0["year"] as? Int == year })
            .sort({ return getSessionDate($1) > getSessionDate($0) })
    }
    else {
        sessions = []
    }
    return sessions
}

private func main() {
    guard (Process.arguments.last?.hasSuffix("sessions.json") == true) else { return }
    
    let sessionFilePath = Process.arguments.last!
    let sessionFileFolder = sessionFilePath.stringByDeletingLastPathComponent
    let sessionFileData = getFileData(sessionFilePath)
    let sessionJSON = getDataJSON(sessionFileData)
    let sessionOutputFile = sessionFileFolder.stringByAppendingPathComponent("wwdc2015.rss")
    
    var wwdcPodcastFile = WWDCPodcastFile()
    wwdcPodcastFile.items = getSessions(sessionJSON, year: 2015)
    
    wwdcPodcastFile.generate(sessionOutputFile)
    
    
//    NSDate
    
//    let wwdcOutputRSS = sessionFileFolder.stringByAppendingPathComponent("wwdc2015.rss")
    
//    createOutputFile(wwdcOutputRSS)
}

main()
