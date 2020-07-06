//
//  SceneDelegate.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 7/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseAuth
import GoogleSignIn
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GIDSignInDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            if Auth.auth().currentUser != nil {
                // redirect to the home controller
                self.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainController")
                self.window!.makeKeyAndVisible()
            } else {
                // redirect to the login controller
                self.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeController")
                self.window!.makeKeyAndVisible()
            }
        }
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        
//        if Auth.auth().currentUser != nil {
//             DispatchQueue.main.async {
//                self.window = UIWindow(windowScene: windowScene)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                //let homeViewController = (storyboard.instantiateViewController(identifier: "MainController"))
//                guard let rootVC = storyboard.instantiateViewController(identifier: "MainController") as? ViewController else {
//                    print("ViewController not found")
//                    return
//                }
//                let rootNC = UINavigationController(rootViewController: rootVC)
//                self.window?.rootViewController = rootNC
//                self.window?.makeKeyAndVisible()
////                 self.view.window?.rootViewController = homeViewController
////                 self.present(homeViewController!, animated: true)
//
//             }
//         }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...
        print("Email: \(email) Fullname: \(fullName) logged in")
        // Firebase sign in
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error")
                print(error)
                return
            }
            print("User is signed in")
            let storyboard =  UIStoryboard(name: "Main", bundle: nil)

            self.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainController")
            self.window!.makeKeyAndVisible()

        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("User has disconnected")
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

