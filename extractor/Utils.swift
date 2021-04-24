//
//  Utils.swift
//  extractor
//
//  Created by boB Rudis on 4/23/21.
//

import Foundation
import SwiftUI

struct HostingWindowFinder: NSViewRepresentable {
  var callback: (NSWindow?) -> ()
  
  func makeNSView(context: Self.Context) -> NSView {
    let view = NSView()
    DispatchQueue.main.async { [weak view] in
      self.callback(view?.window)
    }
    return view
  }
  func updateNSView(_ nsView: NSView, context: Context) {}
}
