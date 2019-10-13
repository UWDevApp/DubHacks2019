//
//  HomeViewController.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Charts
import Firebase

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: Outlet
    
    @IBOutlet weak var homepageTableView: UITableView!
    
    // MARK: Properties
    
    let titles = ["Trends","Get Support", "Keywords"]
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var trends = [0] {
        didSet {
            
        }
    }
    
    var keywordDictionary = ["Lost":5,"Hello":3,"Happy":10,"Chicken":1,"Food":8,"WOW":50] {
        didSet {
            homepageTableView.reloadData()
        }
    }
    
    
    
    // MARK: Check Login
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            print("has user")
            // print(Auth.auth().currentUser!.email)
            // AppDelegate.populateFakeData()
            let today = Date()
            let begin = Calendar.current.date(byAdding: .day, value: -7, to: today)!
            Firebase.database.sentiments(between: begin, and: today) { (result) in
                switch result {
                case .success(let trends):
                    self.trends = trends
                case .failure(let error):
                    print(error)
                }
            }
            Firebase.database.keywords(between: begin, and: today) { (result) in
                switch result {
                case .success(let keywordDictionary):
                    self.keywordDictionary = keywordDictionary
                case .failure(let error):
                    print(error)
                }
            }            
        } else {
            print("doesn't have user")
            self.performSegue(withIdentifier: "SignPage", sender: self)
        }
        
        print(keywordDictionary)
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        homepageTableView.delegate = self
        homepageTableView.dataSource = self
        homepageTableView.showsVerticalScrollIndicator = false
        homepageTableView.separatorStyle = .none
        homepageTableView.estimatedRowHeight = 187.0
        homepageTableView.allowsSelection = false
        homepageTableView.backgroundColor = .clear
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.title = "Home"
        self.navigationController?.navigationBar.topItem?.title = "Good Morning, Kevin"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "SignPage", sender: self)
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
    
    // MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Trends
        if indexPath.section == 0 {
            return makeTrendsCell(for: indexPath)
        } else if indexPath.section == 1 {
            // Get Support
            return makeGetHelpCell(for: indexPath)
        } else {
            return makeWordsCell(for: indexPath)
        }
    }
    
    private func makeTrendsCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homepageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HomePageTableViewCell
        
        cell.titleLabel.text = titles[indexPath.section]
        cell.containerView.backgroundColor = .white
        
        print("trends \(trends)")
        cell.containerView.graphPoints = self.trends
        
        cell.layer.cornerRadius = 15.0
        cell.clipsToBounds = true
        
        return cell
    }
    
    private func makeWordsCell(for indexPath: IndexPath) -> UITableViewCell {
        // Keywords
        
        let cell = homepageTableView.dequeueReusableCell(withIdentifier: "keywordsCell", for: indexPath)
            as! HomePageTableViewCell
        cell.keywordsLabel.text = "Keywords"

        // set up word cloud

        let canvas = Canvas(size: cell.wordCloudImageView.frame.size)

        for i in 0..<keywordDictionary.count {
            let textFont: UIFont = .systemFont(ofSize: CGFloat(Int.random(in: 9...20)))
            canvas.add(word: .init(text: Array(keywordDictionary.keys)[i], font: textFont, color: .random()))
        }


        cell.layer.cornerRadius = 15.0
        cell.clipsToBounds = true

        cell.wordCloudImageView.image = UIImage(cgImage: canvas.currentImage)
        return cell
    }
    
    private func makeGetHelpCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = homepageTableView.dequeueReusableCell(withIdentifier: "supportCell", for: indexPath)
            as! HomePageTableViewCell
        
        // set appearances
        cell.supportTitleLabel.text = "Get Support"
        
        cell.bestFriendButton.setTitle("Apollo Zhu", for: .normal)
        cell.bestFriendButton.titleLabel?.numberOfLines = 0
        cell.bestFriendButton.setTitleColor(.white, for: .normal)
        
        cell.spButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        cell.etButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        
        cell.bestFriendButton.titleLabel?.font =  UIFont(name: "SFUIDisplay-Semibold", size: 22)
        cell.etButton.titleLabel?.font =  UIFont(name: "SFUIDisplay-Semibold", size: 17)
        cell.spButton.titleLabel?.font =  UIFont(name: "SFUIDisplay-Semibold", size: 17)
        
        cell.spButton.setTitleColor(.white, for: .normal)
        cell.etButton.setTitleColor(.white, for: .normal)
        
        cell.bestFriendButton.layer.cornerRadius = 5.0
        cell.spButton.layer.cornerRadius = 5.0
        cell.etButton.layer.cornerRadius = 5.0
        cell.bestFriendButton.clipsToBounds = true
        cell.spButton.clipsToBounds = true
        cell.etButton.clipsToBounds = true
        
        cell.layer.cornerRadius = 15.0
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func call(_ phoneNumber: Int) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: Call
    @IBAction func callBestFriend(_ sender: Any) {
        call(5714354643)
    }
    @IBAction func callET(_ sender: Any) {
        call(2069139126)
    }
    
    @IBAction func callSP(_ sender: Any) {
        call(2067416106)
    }
    
    private func sortedKeywords(_ keywords: [String:Int])->[(key:String,value:Int)]{
        return keywords.sorted(by: { $0.value < $1.value })
    }
}
