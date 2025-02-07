//
//  ViewController.swift
//  MatchYou
//
//  Created by 김견 on 2/5/25.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var googleLoginButton: GoogleLoginButton!
    @IBOutlet weak var logo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        logo.font = UIFont(name: "OTSBAggroB", size: 60)

        googleLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleLoginButtonTap)))
    }

    @objc func googleLoginButtonTap() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            
            guard error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [unowned self] result, error in
                guard error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                
            }
        }
    }
}

