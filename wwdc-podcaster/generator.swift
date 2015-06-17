import Foundation

private let fileManager = NSFileManager.defaultManager()

internal func generateSessionPodcastFeed(year: String, sessions: [[String:AnyObject]]) {
    let feedDirectory = NSHomeDirectory()
        .stringByAppendingPathComponent(config.feedDirectory)
        .stringByAppendingPathComponent("wwdc-feeds")
    let feedFilePath = feedDirectory
        .stringByAppendingPathComponent(config.getFeedFileName(year))
    let feedData = createFeedDocument(year, sessions: sessions)
    
    createDirectoryIfNeeded(feedDirectory)
    createFeedDocumentFile(feedFilePath, data: feedData)
}

private func createDirectoryIfNeeded(directoryPath: String) {
    if fileManager.fileExistsAtPath(directoryPath) == false {
        do { try fileManager.createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil) } catch {}
    }
}

private func createFeedDocumentFile(filePath: String, data: NSData) {
    fileManager.createFileAtPath(filePath, contents: data, attributes: nil)
}

private func createFeedDocument(year: String, sessions: [[String:AnyObject]]) -> NSData {
    func newDocument() -> NSXMLDocument {
       let document = NSXMLDocument()
        document.version = "1.0"
        return document
    }
    
    func newRootElement() -> NSXMLElement {
        let rootElement = NSXMLElement()
        rootElement.name = "rss"
        rootElement.setAttributesWithDictionary([
            "xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd",
            "xmlns:xhtml": "http://www.w3.org/1999/xhtml",
            "xmlns:xs": "http://www.w3.org/2001/XMLSchema",
            "version": "2.0",
        ])
        return rootElement
    }
    
    func newChannelElement(title: String, description: String, url: String, author: String, image: String) -> NSXMLElement {
        func newImageElement(image: String) -> NSXMLElement {
            let imageElement = NSXMLElement()
            imageElement.name = "itunes:image"
            imageElement.setAttributesWithDictionary([
                "href": image
            ])
            return imageElement
        }
        
        let channelElement = NSXMLElement()
        channelElement.name = "channel"
        channelElement.setChildren([
            NSXMLElement(name: "title", stringValue: title),
            NSXMLElement(name: "description", stringValue: description),
            NSXMLElement(name: "link", stringValue: url),
            NSXMLElement(name: "language", stringValue: "en-US"),
            NSXMLElement(name: "itunes:complete", stringValue: "yes"),
            NSXMLElement(name: "itunes:author", stringValue: author),
            newImageElement(image),
        ])
        return channelElement
    }
    
    func newSessionElement(sessionInfo: [String:AnyObject]) -> NSXMLElement {
        func newVideoEnclosureElement(videoURL: String) -> NSXMLElement {
            let videoEnclosureElement = NSXMLElement()
            videoEnclosureElement.name = "enclosure"
            videoEnclosureElement.setAttributesWithDictionary([
                "url": videoURL,
                "type": "video/quicktime",
            ])
            return videoEnclosureElement
        }
        let sessionElement = NSXMLElement()
        sessionElement.name = "item"
        sessionElement.setChildren([
            NSXMLElement(name: "title", stringValue: sessionInfo["title"] as? String),
            NSXMLElement(name: "itunes:subtitle", stringValue: sessionInfo["description"] as? String),
            NSXMLElement(name: "itunes:summary", stringValue: sessionInfo["description"] as? String),
            newVideoEnclosureElement(sessionInfo["download_hd"] as! String),
            NSXMLElement(name: "guid", stringValue: sessionInfo["download_hd"] as? String),
            NSXMLElement(name: "pubDate", stringValue: sessionInfo["dateString"] as? String),
        ])
        return sessionElement
    }
    
    let document = newDocument()
    let documentRoot = newRootElement()
    let documentChannel = newChannelElement(
        config.getFeedTitle(year),
        description: config.getFeedDescription(year),
        url: config.getFeedLink(year),
        author: config.feedAuthor,
        image: config.getFeedImage(year)
    )
    
    document.setRootElement(documentRoot)
    documentRoot.addChild(documentChannel)
    
    for sessionInfo in sessions {
        documentChannel.addChild(newSessionElement(sessionInfo))
    }
    
    return document.XMLDataWithOptions(NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement)
}
