//
//  ViewController.swift
//  ios-study-firebase-remote-config
//
//  Created by Shinichiro Shimoda on 2018/07/14.
//  Copyright © 2018年 Shinichiro Shimoda. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    let welcomeMessageConfigKey     = "welcome_message"
    let welcomeMessageCapsConfigKey = "welcome_message_caps"
    let loadingPhraseConfigKey      = "loading_phrase"

    var remoteConfig: RemoteConfig!

    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        fetchConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchConfig() {

        welcomeLabel.text = remoteConfig[loadingPhraseConfigKey].stringValue

        var expirationDuration = 3600

        // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
        // retrieve values from the service.
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }

        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        // [END fetch_config_with_callback]
    }

    func displayWelcome() {
        // [START get_config_value]
        var welcomeMessage = remoteConfig[welcomeMessageConfigKey].stringValue
        // [END get_config_value]

        if remoteConfig[welcomeMessageCapsConfigKey].boolValue {
            welcomeMessage = welcomeMessage?.uppercased()
        }
        welcomeLabel.text = welcomeMessage
    }

    @IBAction func update(_ sender: Any) {
        self.fetchConfig()
    }
}

