import Foundation
import PDFKit
import SwiftShell

extension NSNotification.Name {
  public static let NSPasteboardModified: NSNotification.Name = .init(rawValue: "pasteboardModified")
}

class ExtractorModel: ObservableObject {
  
  @Published var txt = "Enter URL above, paste text here, or use the File menu to open a document."
  
  @Published var findCIDRs = true
  @Published var findIPv4s = true
  @Published var findURLs = true
  @Published var findEmails = true
  @Published var findHosts = true
  
  @Published var monitorPasteboard = false

  @Published var isLoading = false
  @Published var progress = 1.0

  let cidr = "\\b(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,3})\\b"
  let ipv4 = "\\b(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\b"
  let email = "\\b([a-z][_a-z0-9-.]+@[a-z0-9-]+\\.[a-z]+)\\b"
  let url = "\\b(?:(?:https?|ftp):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?\\b"
  let host = "\\b(([a-z0-9\\-]{2,}\\[?\\.\\]?)+(abogado|ac|academy|accountants|active|actor|ad|adult|ae|aero|af|ag|agency|ai|airforce|al|allfinanz|alsace|am|amsterdam|an|android|ao|aq|aquarelle|ar|archi|army|arpa|as|asia|associates|at|attorney|au|auction|audio|autos|aw|ax|axa|az|ba|band|bank|bar|barclaycard|barclays|bargains|bayern|bb|bd|be|beer|berlin|best|bf|bg|bh|bi|bid|bike|bingo|bio|biz|bj|black|blackfriday|bloomberg|blue|bm|bmw|bn|bnpparibas|bo|boo|boutique|br|brussels|bs|bt|budapest|build|builders|business|buzz|bv|bw|by|bz|bzh|ca|cal|camera|camp|cancerresearch|canon|capetown|capital|caravan|cards|care|career|careers|cartier|casa|cash|cat|catering|cc|cd|center|ceo|cern|cf|cg|ch|channel|chat|cheap|christmas|chrome|church|ci|citic|city|ck|cl|claims|cleaning|click|clinic|clothing|club|cm|cn|co|coach|codes|coffee|college|cologne|com|community|company|computer|condos|construction|consulting|contractors|cooking|cool|coop|country|cr|credit|creditcard|cricket|crs|cruises|cu|cuisinella|cv|cw|cx|cy|cymru|cz|dabur|dad|dance|dating|day|dclk|de|deals|degree|delivery|democrat|dental|dentist|desi|design|dev|diamonds|diet|digital|direct|directory|discount|dj|dk|dm|dnp|do|docs|domains|doosan|durban|dvag|dz|eat|ec|edu|education|ee|eg|email|emerck|energy|engineer|engineering|enterprises|equipment|er|es|esq|estate|et|eu|eurovision|eus|events|everbank|exchange|expert|exposed|fail|farm|fashion|feedback|fi|finance|financial|firmdale|fish|fishing|fit|fitness|fj|fk|flights|florist|flowers|flsmidth|fly|fm|fo|foo|forsale|foundation|fr|frl|frogans|fund|furniture|futbol|ga|gal|gallery|garden|gb|gbiz|gd|ge|gent|gf|gg|ggee|gh|gi|gift|gifts|gives|gl|glass|gle|global|globo|gm|gmail|gmo|gmx|gn|goog|google|gop|gov|gp|gq|gr|graphics|gratis|green|gripe|gs|gt|gu|guide|guitars|guru|gw|gy|hamburg|hangout|haus|healthcare|help|here|hermes|hiphop|hiv|hk|hm|hn|holdings|holiday|homes|horse|host|hosting|house|how|hr|ht|hu|ibm|id|ie|ifm|il|im|immo|immobilien|in|industries|info|ing|ink|institute|insure|int|international|investments|io|iq|ir|irish|is|it|iwc|jcb|je|jetzt|jm|jo|jobs|joburg|jp|juegos|kaufen|kddi|ke|kg|kh|ki|kim|kitchen|kiwi|km|kn|koeln|kp|kr|krd|kred|kw|ky|kyoto|kz|la|lacaixa|land|lat|latrobe|lawyer|lb|lc|lds|lease|legal|lgbt|li|lidl|life|lighting|limited|limo|link|lk|loans|london|lotte|lotto|lr|ls|lt|ltda|lu|luxe|luxury|lv|ly|ma|madrid|maison|management|mango|market|marketing|marriott|mc|md|me|media|meet|melbourne|meme|memorial|menu|mg|mh|miami|mil|mini|mk|ml|mm|mn|mo|mobi|moda|moe|monash|money|mormon|mortgage|moscow|motorcycles|mov|mp|mq|mr|ms|mt|mu|museum|mv|mw|mx|my|mz|na|nagoya|name|navy|nc|ne|net|network|neustar|new|nexus|nf|ng|ngo|nhk|ni|ninja|nl|no|np|nr|nra|nrw|ntt|nu|nyc|nz|okinawa|om|one|ong|onl|ooo|org|organic|osaka|otsuka|ovh|pa|paris|partners|parts|party|pe|pf|pg|ph|pharmacy|photo|photography|photos|physio|pics|pictures|pink|pizza|pk|pl|place|plumbing|pm|pn|pohl|poker|porn|post|pr|praxi|press|pro|prod|productions|prof|properties|property|ps|pt|pub|pw|qa|qpon|quebec|re|realtor|recipes|red|rehab|reise|reisen|reit|ren|rentals|repair|report|republican|rest|restaurant|reviews|rich|rio|rip|ro|rocks|rodeo|rs|rsvp|ru|ruhr|rw|ryukyu|sa|saarland|sale|samsung|sarl|sb|sc|sca|scb|schmidt|schule|schwarz|science|scot|sd|se|services|sew|sexy|sg|sh|shiksha|shoes|shriram|si|singles|sj|sk|sky|sl|sm|sn|so|social|software|sohu|solar|solutions|soy|space|spiegel|sr|st|style|su|supplies|supply|support|surf|surgery|suzuki|sv|sx|sy|sydney|systems|sz|taipei|tatar|tattoo|tax|tc|td|technology|tel|temasek|tennis|tf|tg|th|tienda|tips|tires|tirol|tj|tk|tl|tm|tn|to|today|tokyo|tools|top|toshiba|town|toys|tp|tr|trade|training|travel|trust|tt|tui|tv|tw|tz|ua|ug|uk|university|uno|uol|us|uy|uz|va|vacations|vc|ve|vegas|ventures|versicherung|vet|vg|vi|viajes|video|villas|vision|vlaanderen|vn|vodka|vote|voting|voto|voyage|vu|wales|wang|watch|webcam|website|wed|wedding|wf|whoswho|wien|wiki|williamhill|wme|work|works|world|ws|wtc|wtf|xyz|yachts|yandex|ye|yoga|yokohama|youtube|yt|za|zm|zone|zuerich|zw))\\b"

  let validURL = "^(?:(?:https?|ftp):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?$"
  
  var timer: Timer!
  let pasteboard: NSPasteboard = .general
  var changeCount: Int = 0
  
  var things: String { 
    
    var find: [String] = []
    
    find.reserveCapacity(5)
    
    if (model.findCIDRs) { find.append(cidr) }
    if (model.findIPv4s) { find.append(ipv4) }
    if (model.findURLs) { find.append(url) }
    if (model.findEmails) { find.append(email) }
    if (model.findHosts) { find.append(host) }

    return(find.joined(separator: "|"))
    
  }
  
  func isValidURL(_ url: String) -> Bool {
    return(url.matches(validURL))
  }
  
  func extract() {
    txt = txt.enfanged.groups(pattern: things).unique().joined(separator: "\n")
  }
  
  func startMonitoringPasteboard() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
      if self.changeCount != self.pasteboard.changeCount {
        self.changeCount = self.pasteboard.changeCount
        NotificationCenter.default.post(
          name: .NSPasteboardModified,
          object: self.pasteboard
        )
      }
    }
  }
  
  func stopMonitoringPasteboard() {
    timer?.invalidate()
  }
  
  @objc
  func onPasteboardModified(_ notification: Notification) {
    guard let pb = notification.object as? NSPasteboard else { return }
    guard let items = pb.pasteboardItems else { return }
    guard let item = items.first?.string(forType: .string) else { return } // you should handle multiple types

    txt = item.enfanged.groups(pattern: things).unique().joined(separator: "\n")

  }
  
  init() {
    NotificationCenter
      .default
      .addObserver(
        self,
        selector: #selector(onPasteboardModified),
        name: .NSPasteboardModified,
        object: nil
    )
  }
  
  deinit {
    timer?.invalidate()
  }
  
  func extractFromPDF(_ url: URL) {
    
    if let pdf = PDFDocument(url: url) {
      
      progress = 0.0
      isLoading = true
      
      let pageCount = pdf.pageCount
      let documentContent = NSMutableAttributedString()
      
      for i in 0 ..< pageCount {
        
        guard let page = pdf.page(at: i) else { continue }
        guard let pageContent = page.attributedString else { continue }
        
        progress = Double(i) / Double(pageCount)
        
        documentContent.append(pageContent)
        
      }
      
      progress = 1.0
      
      txt = documentContent.string.enfanged.groups(pattern: things).unique().joined(separator: "\n")

      isLoading = false
      progress = 0.0
      
    }
    
  }
  
  func extractFromTextFile(_ url: URL) {
    do {
      let documentContent = try String(contentsOf: url)
      txt = documentContent.enfanged.groups(pattern: things).unique().joined(separator: "\n")
    } catch {
    }
  }

  func extractFromHTMLFile(_ url: URL) {
    DispatchQueue.main.async {
      do {
        let rawContent = try Data(contentsOf: url)
        let documentContent = rawContent.htmlToString
        self.txt = documentContent.enfanged.groups(pattern: self.things).unique().joined(separator: "\n")
      } catch {
      }
    }
  }
  
  func extractFromURL(_ url: String) {
    let urlToFetch: URL? = URL(string: url)
    if (urlToFetch != nil) {
      DispatchQueue.main.async {
        do {
          let rawContent = try Data(contentsOf: urlToFetch!)
          let documentContent = rawContent.htmlToString
          self.txt = documentContent.enfanged.groups(pattern: self.things).unique().joined(separator: "\n")
        } catch {
        }
      }
    }
  }

  func magic(_ url: URL) -> String {
    let task = run("/usr/bin/file", "--brief", "--mime-type", url.path)
    print(task.stdout)
    return(task.stdout)
  }
  
  func openAndExtractFile(_ url: URL) {
    
    let fileType = magic(url)
    
    if (fileType == "application/pdf") {
      extractFromPDF(url)
    } else if (fileType == "text/plain") {
      extractFromTextFile(url)
    } else if (fileType == "text/html") {
      extractFromHTMLFile(url)
    }

  }
  
  func saveIOCs(_ url: URL) {
    do {
      try txt.write(to: url, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
    }
  }
  
}
