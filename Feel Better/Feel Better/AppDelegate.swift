//
//  AppDelegate.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    static func populateFakeData() {
        let data: [(String, String)] = [
            ("Good day", "It feels good today. Most of the activities done and the weather was good. I had enough sleep last night so woke up ready for all activities in the college. I was in the library quite early to finish up the many assignments given yesterday. The classes have been interesting with tutors covering much of the syllabus work and at the same time allowing us the time to relax. I caught up with old friends during the lunch hour and planned for a date over the weekend. We have known another for quite some time since our time in high school. They were always helpful in tough moments. The afternoon was interesting too, spending time in music class. I am making a nice progress in knowing to play the guitar. The day ends with catching up with my parents at home who have been on vacation for a week now."),
            ("tiresome day", "The day is so tiresome. Being a Monday, the tutors have many expectations from us. They pick up from previous classes and all the homework done over the weekend. By the time of class, I had not finished the psychology essay so I had to request for more time from the lecturer. Thank God he accepted my plea. Now I have the next 24 hours to finish this challenging essay. Besides, I went bicycle riding. It is always good to exercise often but today I did too much and I can feel the aching muscles. With more work from my tutor, I feel like someone should just offer a hand of assistance. But I will manage."),
            ("tiresome day", "The day is so tiresome. Being a Monday, the tutors have many expectations from us. They pick up from previous classes and all the homework done over the weekend. By the time of class, I had not finished the psychology essay so I had to request for more time from the lecturer. Thank God he accepted my plea. Now I have the next 24 hours to finish this challenging essay. Besides, I went bicycle riding. It is always good to exercise often but today I did too much and I can feel the aching muscles. With more work from my tutor, I feel like someone should just offer a hand of assistance. But I will manage."),
            ("blessed day", "It is a blessed day. I feel like my spiritual life is in good progress. The preacher gave a powerful summon that I feel touched spiritually. She talked perfectly about the life of Jesus and how it applies to our daily lives. It was interesting to have more converts joining the congregation with new enthusiasm. More interesting was the time in the Highlight restaurant. I loved the menu and the nice chocolate with friends after the church service. Save for small challenges of losing money after coming out of the restaurant, the day has been good. Hopefully I wake up with the same energy ready for classes."),
            ("free Saturday", "Being a Saturday and lots of free time, I spent the most time in the movies. Just before the movies, I worked partly on my assignments which I hope to finish before the next class. The movies were all great and I never wished time to move. It was more interesting in the company of my brother who is always funny. Time with him can never pass without laughter. We also went swimming with the hot weather. Time in the pool was so short because it was closed earlier than usual due to maintenance. I hope next time we shall have all the time. The evening has been quite dull with bad news covered of incidents in the Middle East. Innocent children have been affected directly by terrorism. I only hope these incidents will one day be eradicated by nations working together."),
            ("Got tutored", "The day started well with tutors attending the morning classes and setting the afternoon for assignments. I caught up with old friends and we spent a wonderful time in the Music concert. The concert had been advertised since the last fortnights. We, therefore, expected a lot which was surely available during the concert. The various bands gave their best and it was surely a nice way to end the tough week."),
            ("Upset!!!", """
            Dear Diary,


            I’m so upset!! I don’t even know where to begin!


            To start off, I think I completely failed my geometry quiz, which I know I should’ve studied more for...my dad’s not gonna be happy about that. :( Then, we had a pop quiz in history on the reading homework from last night, and I completely forgot most of what I read, which made me even more upset because I actually did the reading! But what really made me mad was the note that Sarah slipped into my locker during passing period. She said she was sad that I’ve been hanging out with Jane more lately and thinks that I don’t want to be her friend anymore. I can’t believe she thinks that, especially after talking with her on the phone for hours and hours last month while she was going through her breakup with Nick! Just because I’ve been hanging out with Jane a little more than usual doesn’t mean I’m not her friend anymore. She completely blew me off at lunch, and when I told Jane, she thought that Sarah was being a “drama queen.”


            This is just what I need! My parents are getting on my case about doing more extracurricular activities, I have a huge paper due for AP English soon, and I can’t understand a thing in advanced Spanish! The last thing I need is for my best friend to think I hate her and barely text me back anymore.


            Uggh! I can’t concentrate on anything right now because of it. I hope she gets over it!!!


            Love,

            Kate
            """),
        ]
        
        let today = Date()
        let cal = Calendar.current
        for (index, datium) in data.enumerated() {
            add(title: datium.0, content: datium.1, date: cal.date(byAdding: .day, value: index, to: today)!)
        }
    }

    static func add(title: String, content: String, date: Date) {
        TextAnalzyer.analyzeSentiment(of: content) { (result) in
            let sentiment = try! result.get().score
            let memory = LocalMemory(title: title, content: content, sentiment: sentiment,
                                     saveDate: date, image: nil)
            TextAnalzyer.keyPhrases(in: content) { (result) in
                let tags = try! result.get()
                Firebase.database.saveNewMemory(memory, tags: tags)
            }
        }
    }
}
