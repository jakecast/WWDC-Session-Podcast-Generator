import Foundation

internal struct Config {
    internal let wwdcSessionInfoFile = Process.arguments.last ?? "null"
    internal let wwdcSessionInfoURL = "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/wwdc-podcaster/sessions.json"
    
    internal let feedAuthor = "Apple Developer Center"
    internal let feedDirectory = "Desktop"
    internal let feedYears = ["2011", "2012", "2013", "2014", "2015", ]
    
    private let feedDescription = "WWDC %%%% Session Videos - Apple Developer"
    private let feedFileName = "wwdc-%%%%-feed.rss"
    private let feedLink = "https://developer.apple.com/videos/wwdc/%%%%/"
    private let feedTitle = "WWDC %%%% Session Videos - Apple Developer"
    
    internal func getFeedFileName(year: String) -> String {
        return self.getFeedString(self.feedFileName, year: year)
    }
    
    internal func getFeedTitle(year: String) -> String {
        return self.getFeedString(self.feedTitle, year: year)
    }
    
    internal func getFeedDescription(year: String) -> String {
        return self.getFeedString(self.feedDescription, year: year)
    }
    
    internal func getFeedLink(year: String) -> String {
        return self.getFeedString(self.feedLink, year: year)
    }
    
    internal func getFeedImage(year: String) -> String {
        return "http://devstreaming.apple.com/videos/wwdc/2015/1014o78qhj07pbfxt9g7/101/images/101_600x600.jpg"
    }
    
    private func getFeedString(baseString: String, year: String) -> String {
        return baseString.stringByReplacingOccurrencesOfString("%%%%", withString: year)
    }
}

internal let config = Config()
