import SwiftUI
import Foundation

struct ContentView: View {
  
  @EnvironmentObject var model: ExtractorModel
  @Namespace private var namespace
  @State private var urlInput: String = ""
  @State private var urlIsValid: Bool = false

  var body: some View {
    
    ZStack {
      HostingWindowFinder { window in
        window?.standardWindowButton(.closeButton)?.isHidden = true
      }
      
      VStack {
        
        HStack {
          Text("Find:")
          Toggle("CIDRs", isOn: $model.findCIDRs)
          Toggle("IPv4s", isOn: $model.findIPv4s)
          Toggle("URLs", isOn: $model.findURLs)
          Toggle("Hosts", isOn: $model.findHosts)
          Toggle("Emails", isOn: $model.findEmails)
        }
        
        Toggle("Monitor Pasteboard", isOn: $model.monitorPasteboard)
          .toggleStyle(SwitchToggleStyle())
          .onChange(of: model.monitorPasteboard) { value in
            value ? model.startMonitoringPasteboard() : model.stopMonitoringPasteboard()
          }
        
        Spacer()
        
        HStack {
          TextField("Enter URL to extract IoCs from", text: $urlInput)
            .onChange(of: urlInput) { value in
              urlIsValid = model.isValidURL(value)
            }
          Button("Fetch") {
            model.extractFromURL(urlInput)
          }
          .disabled(!urlIsValid)
        }
        
        Spacer()
        
        ZStack {
          
          if (model.isLoading) {
            ProgressView(value: model.progress)
              .zIndex(1)
          }
          
          TextEditor(text: $model.txt)
            .font(.system(.body, design: .monospaced))
            .padding()
            .border(Color.primary, width: 0.5)
            .focusable()
            .onChange(of: model.txt) { value in
              model.extract()
            }
          
        }
        .zIndex(0)
        
      }.padding()
    }
  }
  
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//      .padding()
//
//  }
//}

