import SwiftUI

let model = ExtractorModel()

@main
struct extractorApp: App {
  
  var body: some Scene {
    
    WindowGroup {
      ContentView()
        .environmentObject(model)
    }.commands() {
      
      CommandGroup(replacing: .newItem) {

        Divider()
        
        Button("Open File…") {
          
          let panel = NSOpenPanel()
          
          panel.title = "Select file"
          panel.allowsMultipleSelection = false
          panel.canChooseDirectories = false
          panel.allowedContentTypes = [ .pdf, .text, .html ]

          if panel.runModal() == .OK {
            if (panel.url != nil) {
              model.openAndExtractFile(panel.url!)
            }
          }
          
        }.keyboardShortcut("o")
        
        Divider()

        Button("Save…") {
          
          let panel = NSSavePanel()
          
          panel.title = "Select directory"

          if panel.runModal() == .OK {
            if (panel.url != nil) {
              model.saveIOCs(panel.url!)
            }
          }
          
        }.keyboardShortcut("s")
        
      }
    }
  }
}
