//
//  denmokuplusApp.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/25.
//  
//

import SwiftUI

@main
struct denmokuplusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppManager())
                .font(.HiraginoSans_W6, size: 16)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        return true
    }
}
