//
//  AppRater.swift
//
//  Created by Bhavin Bhadani. 
//  skype: bhavin.bhadani
//  Copyright © 2017 appernaut. All rights reserved.
//

import UIKit

let APP_LAUNCHES = "com.appernaut.applaunches"
let APP_LAUNCHES_CHANGED = "com.appernaut.applaunches.changed"
let INSTALL_DATE = "com.appernaut.install_date"
let APP_RATING_SHOWN = "com.appernaut.app_rating_shown"

public class BBAppRater: NSObject {
    var application: UIApplication!
    var userdefaults = UserDefaults()
    public var requiredLaunchesBeforeRating = 0 // after how many launch you want to prompt rating dailog
    public var appId: String!
    
    public static var sharedInstance = BBAppRater()
    
    //MARK: - Initialize
    override init() {
        super.init()
        setup()
    }
    
    func setup(){
        NotificationCenter.default.addObserver(self, selector: #selector(BBAppRater.appDidFinishLaunching(notification:)) , name: .UIApplicationDidFinishLaunching, object: nil)
    }
    
    //MARK: - NSNotification Observers
    func appDidFinishLaunching(notification: NSNotification){
        if let _application = notification.object as? UIApplication{
            self.application = _application
            displayRatingsPromptIfRequired()
        }
    }
    
    //MARK: - App Launch count
    func getAppLaunchCount() -> Int {
        let launches = userdefaults.integer(forKey: APP_LAUNCHES)
        return launches
    }
    
    func incrementAppLaunches(){
        var launches = userdefaults.integer(forKey: APP_LAUNCHES)
        launches += 1
        userdefaults.set(launches, forKey: APP_LAUNCHES)
        userdefaults.synchronize()
    }
    
    func decrementAppLaunches(){
        var launches = userdefaults.integer(forKey: APP_LAUNCHES)
        launches -= 1
        userdefaults.set(launches, forKey: APP_LAUNCHES)
        userdefaults.synchronize()
    }
    
    func resetAppLaunches(){
        userdefaults.set(0, forKey: APP_LAUNCHES)
        userdefaults.synchronize()
    }
    
    //MARK: - First Launch Date
    func setFirstLaunchDate(){
        userdefaults.setValue(NSDate(), forKey: INSTALL_DATE)
        userdefaults.synchronize()
    }
    
    func getFirstLaunchDate()->NSDate{
        if let date = userdefaults.value(forKey: INSTALL_DATE) as? NSDate{
            return date
        }
        
        return NSDate()
    }
    
    //MARK: App Rating Shown
    func setAppRatingShown(){
        userdefaults.set(true, forKey: APP_RATING_SHOWN)
        userdefaults.synchronize()
    }
    
    func hasShownAppRating()->Bool{
        let shown = userdefaults.bool(forKey: APP_RATING_SHOWN)
        return shown
    }
    
    //MARK: - Rating the App
    private func displayRatingsPromptIfRequired(){
        incrementAppLaunches()
        let appLaunchCount = getAppLaunchCount()
        if appLaunchCount >= self.requiredLaunchesBeforeRating {
            rateTheApp()
        }
    }
    
    private func rateTheApp(){
        let app_name = Bundle(for: type(of: application.delegate!)).infoDictionary!["CFBundleName"] as? String
        let message = "Do you love the \(app_name!) app?  Please rate us!"
        let rateAlert = UIAlertController(title: "Rate Us", message: message, preferredStyle: .alert)
        let goToItunesAction = UIAlertAction(title: "Rate Us", style: .default, handler: { (action) -> Void in
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + self.appId) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            self.setAppRatingShown()
        })
        
        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel, handler: { (action) -> Void in
            self.resetAppLaunches()
        })
        
        let remindAction = UIAlertAction(title: "Remind me later", style: .default, handler: { (action) -> Void in
            self.decrementAppLaunches()
        })
        
        rateAlert.addAction(goToItunesAction)
        rateAlert.addAction(remindAction)
        rateAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            let window = self.application.windows[0]
            window.rootViewController?.present(rateAlert, animated: true, completion: nil)
        }
    }

}
