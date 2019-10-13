//
//  HomeViewController.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Charts

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
    var trends = [5,3,5,10,7,2,1]
    
    let keywordDictionary = ["Lost":5,"Hello":3,"Happy":10,"Chicken":1,"Food":8,"WOW":50]
    
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
    
    // MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Trends
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomePageTableViewCell
            
            cell.titleLabel.text = titles[indexPath.section]
            cell.containerView.backgroundColor = .white
            
            cell.layer.cornerRadius = 15.0
            cell.clipsToBounds = true
            
            return cell
            
        }else if indexPath.section == 1{
            // Get Support
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "supportCell", for: indexPath) as! HomePageTableViewCell
            
            // set appearances
            cell.supportTitleLabel.text = "Get Support"
            cell.bestFriendButton.setTitle("Apollo Zhu", for: .normal)
            cell.bestFriendButton.setTitleColor(.white, for: .normal)
            cell.spButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1.0)
            cell.etButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1.0)
            cell.etButton.titleLabel?.font =  UIFont(name: "SFUIDisplay-Semibold", size: 17)
            cell.spButton.titleLabel?.font =  UIFont(name: "SFUIDisplay-Semibold", size: 17)
            cell.spButton.setTitleColor(.white, for: .normal)
            cell.etButton.setTitleColor(.white, for: .normal)
            cell.bestFriendButton.titleLabel?.numberOfLines = 0
            cell.bestFriendButton.titleLabel?.font =  UIFont(name: "SFUIDisplay-Semibold", size: 22)
            
            cell.layer.cornerRadius = 15.0
            cell.clipsToBounds = true
            
        }else{
            // Keywords
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "keywordsCell", for: indexPath) as! HomePageTableViewCell
            cell.keywordsLabel.text = "Keywords"
            
            // set up word cloud

            let canvas = Canvas(size: cell.wordCloudImageView.frame.size)
            
            for i in 0..<keywordDictionary.count {
                
                let interval = 50 / keywordDictionary.count
                let sorted = sortedKeywords(keywordDictionary)
                
                let textFont: UIFont = .systemFont(ofSize: CGFloat(Int.random(in: 50-((i+1)*interval) ... 50-(i*interval))))
                
                canvas.add(word: .init(text: sorted[keywordDictionary.count - i - 1].key, font: textFont, color: UIColor.blue))
            }
            
            
            cell.layer.cornerRadius = 15.0
            cell.clipsToBounds = true
            
            cell.wordCloudImageView.image = UIImage(cgImage: canvas.currentImage)
            //cell.wordCloudImageView.contentMode = .scaleAspectFill
        }
        return UITableViewCell()
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





