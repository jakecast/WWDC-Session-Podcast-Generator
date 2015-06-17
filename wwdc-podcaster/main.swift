import Foundation

private func main() {
    var wwdcSessionInfo: [String:[[String:AnyObject]]]?
    if config.wwdcSessionInfoFile.hasSuffix("json") == true {
        wwdcSessionInfo = getSessionInfoFromFile(config.wwdcSessionInfoFile)
    }
    else {
        wwdcSessionInfo = getSessionInfoFromURL(config.wwdcSessionInfoURL)
    }
    
    for wwdcYear in config.feedYears {
        if let wwdcSessions = wwdcSessionInfo?[wwdcYear] {
            generateSessionPodcastFeed(wwdcYear, sessions: wwdcSessions)
        }
    }
}

main()
