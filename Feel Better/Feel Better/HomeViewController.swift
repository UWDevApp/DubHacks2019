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
    
    @IBOutlet weak var homepageTableView: UITableView!
    
    let titles = ["Trends","Get Support", "Keywords"]
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var trends = [5,3,5,10,7,2,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview set up
        
        homepageTableView.delegate = self
        homepageTableView.dataSource = self
        
        homepageTableView.showsVerticalScrollIndicator = false
        homepageTableView.separatorStyle = .none
        homepageTableView.estimatedRowHeight = 187.0
        
        homepageTableView.allowsSelection = false
        
        // set background color
        
        homepageTableView.backgroundColor = .clear
        
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        self.title = "Home"
        self.navigationController?.navigationBar.topItem?.title = "Good Morning, Kevin"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomePageTableViewCell
        
        cell.titleLabel.text = titles[indexPath.section]
        cell.backgroundColor = .clear
        cell.containerView.backgroundColor = .white
        
        // trend chart
        if indexPath.section == 0{
            cell.containerView.noDataText = "No data for trend"
            
            // get last 7 weekdays labels in order (dayLabels)
            var dayLabels = [String]()
            
            
            let today = Date().dayNumberOfWeek()! // 4 = wednesday
            for i in today..<today+7{
                if i>7{
                    dayLabels.append(weekdays[i-7-1])
                }else{
                    dayLabels.append(weekdays[i-1])
                }
            }
            
            var lineChartEntry = [ChartDataEntry]()
            
            for i in 0..<trends.count{
                let value = ChartDataEntry(x: Double(i), y: Double(trends[i]))
                lineChartEntry.append(value)
            }
            let line1 = LineChartDataSet(entries: lineChartEntry, label: "sentiment")
            line1.colors = [NSUIColor.blue]
            
            let data = LineChartData()
            
            data.addDataSet(line1)
            
            cell.containerView.data = data
            
            
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
