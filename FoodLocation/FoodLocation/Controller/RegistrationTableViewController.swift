//
//  RegistrationTableViewController.swift
//  FoodLocation
//
//  Created by 신민희 on 2021/03/27.
//

import UIKit

class Store {
    var storeName: String?
    var detailName: [String]?
    
    init(storeName: String, detailName: [String]) {
        self.storeName = storeName
        self.detailName = detailName
    }
}

class RegistrationTableViewController: UIViewController {
    
    let backgroundView = UIView()
    let logInLabel = UILabel()
    let closeButton = UIImageView()
    let menuTableView = UITableView(frame: .zero, style: .grouped)
    let textField = UITextField()
    let Button = UIButton()
    var store = [Store]()
    var naverText = String()
    weak var delegate: RegistrationTableViewControllerDelegate?
    var storeNameText: String = ""
    var locationNameText: String = ""
    var detailLocationText: String = ""
    var explanationText: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        //        menuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setUI()
        setTableView()
        
        store.append(Store.init(storeName: "가게 이름", detailName: ["0"]))
        store.append(Store.init(storeName: "위치", detailName: ["0", "1"]))
        store.append(Store.init(storeName: "메뉴", detailName: ["0"]))
        store.append(Store.init(storeName: "맛/수량/가격 \n상세설명", detailName: ["0"]))
        store.append(Store.init(storeName: "", detailName: ["0"]))
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
        self.menuTableView.endEditing(true)
   }
    @objc
    func closeTaped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    @objc
    func setLocationButton(_ sender: UIButton) {
        let naverVC = NaverMapViewController()
        naverVC.delegate = self
        naverVC.modalPresentationStyle = .fullScreen
        present(naverVC, animated: true, completion: nil)
        print(123)
    }
    @objc
    func okButtonTaped(_ sender: UIButton) {
        let mapView = MapAndStoreViewController()
        mapView.modalPresentationStyle = .fullScreen
        mapView.delegate = self
        mapView.storeName.text = storeNameText
        mapView.location.text = locationNameText
        mapView.detail.text = explanationText
        present(mapView, animated: true, completion: nil)
        guard let cell = menuTableView.cellForRow(at: [3, 0]) as? RegistrationTableViewCell else { fatalError() }
        print(cell.detailLocationTextField.text)
    }
}

protocol RegistrationTableViewControllerDelegate: class {
    func textFieldDidChangeSelection(_ textField: UITextField)
}

extension RegistrationTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return store.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store[section].detailName?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RegistrationTableViewCell()
        switch indexPath {
        case [0, 0]:
            cell.setStoreTextField()
            cell.storeTextField.delegate = self
            cell.storeTextField.tag = 1
        case [1, 0]:
            cell.setLocationTextField()
            cell.locationTextField.delegate = self
            cell.locationTextField.tag = 2
        case [1, 1]:
            cell.setDetailLocationTextField()
            cell.detailLocationTextField.delegate = self
            cell.detailLocationTextField.tag = 3
        case [2, 0]:
            cell.setCollectionView()
            cell.locationTextField.delegate = self
        case [3, 0]:
            cell.setExplanationTextField()
            cell.explanationTextField.delegate = self
            cell.explanationTextField.tag = 4
        case [4, 0]:
            cell.setOkButton()
        default:
            fatalError()
        }
        cell.locationButton.addTarget(self, action: #selector(setLocationButton(_:)), for: .touchUpInside)
        cell.okButton.addTarget(self, action: #selector(okButtonTaped(_:)), for: .touchUpInside)
        
        cell.backgroundColor = view.backgroundColor
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return store[section].storeName
    }
    
}

extension RegistrationTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case [2, 0]:
            return 290
        case [3, 0]:
            return 100
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//                guard let firstVC = presentingViewController as? MapAndStoreViewController else { fatalError() }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell1 = cell as? RegistrationTableViewCell else { fatalError() }
        print(cell1.storeTextField.text)
    }
}


extension RegistrationTableViewController: NaverMapViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, MapAndStoreViewControllerDelegate {
    func textFieldInput(text: String) {
        guard let label1 = menuTableView.cellForRow(at: [1, 0]) as? RegistrationTableViewCell else { fatalError() }
        print(text)
        label1.locationTextField.text = text
        locationNameText = text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            guard let cell = menuTableView.cellForRow(at: [0, 0]) as? RegistrationTableViewCell else { fatalError() }
            storeNameText = cell.storeTextField.text ?? ""
        case 2:
            guard let cell = menuTableView.cellForRow(at: [1, 0]) as? RegistrationTableViewCell else { fatalError() }
            locationNameText = cell.locationTextField.text ?? ""
        case 3:
            guard let cell = menuTableView.cellForRow(at: [1, 1]) as? RegistrationTableViewCell else { fatalError() }
            detailLocationText = cell.detailLocationTextField.text ?? ""
        case 4:
            guard let cell = menuTableView.cellForRow(at: [3, 0]) as? RegistrationTableViewCell else { fatalError() }
            explanationText = cell.explanationTextField.text ?? ""
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RegistrationTableViewCell else { fatalError() }
        switch indexPath {
        case [0, 0]:
            cell.storeTextField.text = storeNameText
        case [1, 0]:
            cell.locationTextField.text = locationNameText
        case [1, 1]:
            cell.detailLocationTextField.text = detailLocationText
        case [3, 0]:
            cell.explanationTextField.text = explanationText
        default:
            return
        }
        
    }
}

extension RegistrationTableViewController {
    func setTableView() {
        view.addSubview(menuTableView)
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuTableView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 10),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(RegistrationTableViewCell.self, forCellReuseIdentifier: "RegistrationTableViewCell")
        menuTableView.rowHeight = 50     
    }
    
    func setUI() {
        view.addSubview(backgroundView)
        [backgroundView, logInLabel, closeButton, menuTableView].forEach { (view) in
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
        
        
        logInLabel.text = "등록하기"
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

//    private func tableView(_ tableView: UITableView, viewForHeaterInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height:30))
//        view.backgroundColor = .red
//        //        view.backgroundColor = UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
//        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
//        lbl.text = store[section].storeName
//        lbl.numberOfLines = 0
//        view.addSubview(lbl)
//        return view
//    }
