import Foundation

extension String{
  
  var enfanged : String {
    self.replacingOccurrences(of: "[.]", with: ".")
  }
  
  func groups(pattern: String) -> [String] {
    
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
      let all = NSRange(location: 0, length: count)
      var matches = [String]()
      regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
        (result : NSTextCheckingResult?, _, _) in
        if let r = result {
          let nsstr = self as NSString
          let result = nsstr.substring(with: r.range) as String
          matches.append(result)
        }
      }
      return matches
    } catch {
      return([String]())
    }
    
  }
  
  func matches(_ regex: String) -> Bool {
    return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
  }
  
}

extension Array where Element == String {
  func notin(_ list: [String]) -> [String] {
    return(Array(Set(self).subtracting(list)))
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
  }
}


extension Data {
  
  var htmlToAttributedString: NSAttributedString? {
    do {
      return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      print("error:", error)
      return(nil)
    }
  }
  
  var htmlToString: String { htmlToAttributedString?.string ?? "" }
  
}

extension StringProtocol {
  
  var htmlToAttributedString: NSAttributedString? {
    Data(utf8).htmlToAttributedString
  }
  
  var htmlToString: String {
    htmlToAttributedString?.string ?? ""
  }
  
}
