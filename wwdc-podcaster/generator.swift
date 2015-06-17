import Foundation

internal struct WWDCPodcastFile {
    internal var title: String = "WWDC Session Videos"
    internal var websiteURL: String = "https://developer.apple.com/"
    internal var imageURL: String = "http://devstreaming.apple.com/videos/wwdc/2015/1014o78qhj07pbfxt9g7/101/images/101_600x600.jpg"
    internal var items: [[String:AnyObject]] = []
    
    static func createImageElement(imageURL: String) -> NSXMLElement {
        let imageElement = NSXMLElement()
        imageElement.name = "itunes:image"
        imageElement.setAttributesWithDictionary([
            "href": imageURL
        ])
        return imageElement
    }
    
    static func createEnclosureElement(videoURL: String) -> NSXMLElement {
        let enclosureElement = NSXMLElement()
        enclosureElement.name = "enclosure"
        enclosureElement.setAttributesWithDictionary([
            "url": videoURL,
            "type": "video/quicktime",
        ])
        return enclosureElement
    }
    
    internal func generate(filePath: String) {
        let xmlFileURL = NSURL(fileURLWithPath: filePath)
        let xmlDocument = self.createDocument()
        let xmlDocumentData = xmlDocument.XMLDataWithOptions(NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement)
        
        NSFileManager
            .defaultManager()
            .createFileAtPath(xmlFileURL.path!, contents: xmlDocumentData, attributes: nil)
    }
    
    private func createDocument() -> NSXMLDocument {
        let xmlDocument = NSXMLDocument()
        xmlDocument.version = "1.0"
        xmlDocument.setRootElement(self.createRootElement())
        return xmlDocument
    }
    
    private func createRootElement() -> NSXMLElement {
        let rootElement = NSXMLElement()
        rootElement.name = "rss"
        rootElement.setAttributesWithDictionary([
            "xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd",
            "xmlns:xhtml": "http://www.w3.org/1999/xhtml",
            "xmlns:xs": "http://www.w3.org/2001/XMLSchema",
            "version": "2.0",
        ])
        rootElement.addChild(self.createChannelElement())
        return rootElement
    }
    
    private func createChannelElement() -> NSXMLElement {
        let channelElement = NSXMLElement()
        channelElement.name = "channel"
        channelElement.addChild(NSXMLElement(name: "title", stringValue: self.title))
        channelElement.addChild(NSXMLElement(name: "description", stringValue: self.title))
        channelElement.addChild(NSXMLElement(name: "link", stringValue: self.websiteURL))
        channelElement.addChild(NSXMLElement(name: "language", stringValue: "en-US"))
        channelElement.addChild(NSXMLElement(name: "itunes:complete", stringValue: "yes"))
        channelElement.addChild(NSXMLElement(name: "itunes:author", stringValue: "Jake Kirshner"))
        channelElement.addChild(WWDCPodcastFile.createImageElement(self.imageURL))
        
        for item in self.items {
            channelElement.addChild(self.createItemElement(item))
        }
        
        return channelElement
    }
    
    private func createItemElement(itemData: [String:AnyObject]) -> NSXMLElement {
        let itemElement = NSXMLElement()
        itemElement.name = "item"
        itemElement.addChild(NSXMLElement(name: "title", stringValue: itemData["title"] as? String))
        itemElement.addChild(NSXMLElement(name: "itunes:subtitle", stringValue: itemData["description"] as? String))
        itemElement.addChild(NSXMLElement(name: "itunes:summary", stringValue: itemData["description"] as? String))
        itemElement.addChild(WWDCPodcastFile.createEnclosureElement(itemData["download_hd"] as! String))
        itemElement.addChild(NSXMLElement(name: "guid", stringValue: itemData["download_hd"] as? String))
        itemElement.addChild(NSXMLElement(name: "pubDate", stringValue: NSDate().description))
        return itemElement
    }
}
