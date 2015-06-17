import Foundation

internal struct Config {
    internal let wwdcSessionInfoFile = Process.arguments.last ?? "null"
    internal let wwdcSessionInfoURL = "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/data/sessions.json"
    
    internal let feedAuthor = "Apple Developer Center"
    internal let feedDirectory = "Desktop"
    internal let feedYears = ["2011", "2012", "2013", "2014", "2015", ]
    
    private let feedDescription = "WWDC %%%% Session Videos - Apple Developer"
    private let feedFileName = "wwdc-%%%%.rss"
    private let feedLink = "https://developer.apple.com/videos/wwdc/%%%%/"
    private let feedTitle = "WWDC %%%% Session Videos - Apple Developer"
    private let feedImages = [
        "2011": "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/data/wwdc-2011.png",
        "2012": "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/data/wwdc-2012.png",
        "2013": "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/data/wwdc-2013.png",
        "2014": "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/data/wwdc-2014.png",
        "2015": "https://raw.githubusercontent.com/jakecast/WWDC-Session-Podcast-Generator/master/data/wwdc-2015.png",
    ]
    
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
        return self.feedImages[year]!
    }
    
    private func getFeedString(baseString: String, year: String) -> String {
        return baseString.stringByReplacingOccurrencesOfString("%%%%", withString: year)
    }
}

internal let config = Config()
