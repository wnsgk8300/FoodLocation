//
//  LogINViewController.swift
//  FoodLocation
//
//  Created by 신민희 on 2021/03/25.
//

import UIKit
import Firebase
import GoogleSignIn

class LogINViewController: UIViewController {
    
    let backgroundView = UIView()
    let logInLabel = UILabel()
    let closeButton = UIImageView()
    let googleLoginButton = GIDSignInButton()
    var emptyNickName: String? = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 자동로그인
//        GIDSignIn.sharedInstance()?.signIn() // 로그인
//        GIDSignIn.sharedInstance()?.signOut() // 로그아웃
//        GIDSignIn.sharedInstance()?.disconnect() // 연동해제
        setUI()
        configureUI()
        setGoogleSignInButton()
    }
    func asd() {
        if Auth.auth().currentUser?.uid == nil {
            
        } else {
            configureUI()
        }
    }
    
    @objc
    func closeTaped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension LogINViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
            
        // 사용자 정보 가져오기
        if let userId = user.userID,
            let idToken = user.authentication.idToken,
            let fullName = user.profile.name,
            let givenName = user.profile.givenName,
            let familyName = user.profile.familyName,
            let email = user.profile.email {
                
            print("Token : \(idToken)")
            print("User ID : \(userId)")
            print("User Email : \(email)")
            print("User Name : \((fullName))")
            let nickNameVC = NickNameViewController()
            nickNameVC.modalPresentationStyle = .fullScreen
//            nickNameVC.delegate = self
            present(nickNameVC,animated: true, completion: nil)
        } else {
            print("Error : User Data Not Found")
        }
    }
        
    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}

//extension LogINViewController: NickNameViewControllerDelegate {
//    func startButtonPressed() {
//        let personalVC = PersonalViewController()
//        let nickNameVC = NickNameViewController()
//        self.emptyNickName = String(nickNameVC.nickNameTextField.text ?? "")
//        personalVC.logInLabel.text = "안녕하세요 \n\(String(describing: self.emptyNickName))님"
//        dismiss(animated: true, completion: nil)
//    }
//}

extension LogINViewController {
    private func configureUI() {
        view.addSubview(googleLoginButton)
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            googleLoginButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setGoogleSignInButton() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    func setUI() {
        view.addSubview(backgroundView)
        [backgroundView, logInLabel, closeButton].forEach { (view) in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 100),
            
            logInLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            logInLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            logInLabel.heightAnchor.constraint(equalToConstant: 30),
            logInLabel.widthAnchor.constraint(equalToConstant: 100),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowColor = UIColor.gray.cgColor // 색깔
        backgroundView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        backgroundView.layer.shadowRadius = 5 // 반경
        backgroundView.layer.shadowOpacity = 0.3 // alpha값
        
        
        logInLabel.text = "로그인"
        logInLabel.textAlignment = .center
        logInLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        closeButton.image = UIImage(systemName: "xmark")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let searchBarTaped = UITapGestureRecognizer(target: self, action: #selector(closeTaped(_:)))
        searchBarTaped.numberOfTouchesRequired = 1
        searchBarTaped.numberOfTapsRequired = 1
        closeButton.addGestureRecognizer(searchBarTaped)
        closeButton.isUserInteractionEnabled = true
    }
}

