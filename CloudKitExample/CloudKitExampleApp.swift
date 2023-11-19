//
//  CloudKitExampleApp.swift
//  CloudKitExample
//
//  Created by Marcelo de Araújo on 18/11/23.
//

import SwiftUI

@main
struct CloudKitExampleApp: App {
  var body: some Scene {
    WindowGroup {
      let _ = print("Path: \(URL.documentsDirectory.path())")
      ContentView()
    }
  }
}
