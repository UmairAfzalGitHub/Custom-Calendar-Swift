//
//  ViewController.swift
//  SwiftCustomCalendar
//
//  Created by Umair Afzal on 3/19/18.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calendarButtonTapped(_ sender: Any) {
        let calendarViewController = CalendarViewController()
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    }
    
}

