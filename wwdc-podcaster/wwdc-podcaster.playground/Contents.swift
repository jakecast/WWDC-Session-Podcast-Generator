import Foundation

let sessionDateFormatter = NSDateFormatter()
sessionDateFormatter.dateFormat = "EEE, dd MMM YYYY HH:mm:ss ZZZ"

let date = NSDate()

//Sun, 15 Jun 2014 19:00:00 +0000
sessionDateFormatter.stringFromDate(date)
