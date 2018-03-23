//
//  SPMonthlyAppointmentsViewController.swift
//  PamperMoi
//
//  Created by Umair Afzal on 22/02/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

protocol CalendarViewControllerDeleagte {
    func didSelectDate(dateString: String)
}

class CalendarViewController: UIViewController {

    // MARK: - Variables & Constants

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var topMonthButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)

    var delegate: CalendarViewControllerDeleagte?

    // MARK: - UIVIewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerUI()
        setupCalendar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - UIVIewController helper Methods

    func setupCalendar() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentMonthIndex -= 1 // bcz apple calendar returns months starting from 1

        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()

        //for leap years, make february month of 29 days
        if currentMonthIndex == 1 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex] = 29
        }
        //end
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear

        // display current month name in title
        topMonthButton.setTitle("\(months[currentMonthIndex]) \(currentYear)", for: .normal)
        leftButton.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear) // Disable left button if user is on current month
    }

    func setupViewControllerUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        topView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.0862745098, blue: 0.1803921569, alpha: 1)
    }

    // MARK: - IBActions

    @IBAction func leftButtonTapped(_ sender: Any) {
        currentMonthIndex -= 1

        if currentMonthIndex < 0 {
            currentMonthIndex = 11
            currentYear -= 1
        }

        topMonthButton.setTitle("\(months[currentMonthIndex]) \(currentYear)", for: .normal)

        //for leap year, make february month of 29 days
        if currentMonthIndex == 1 {

            if currentYear % 4 == 0 {
                numOfDaysInMonth[currentMonthIndex] = 29

            } else {
                numOfDaysInMonth[currentMonthIndex] = 28
            }
        }
        //end

        leftButton.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)// Disable left button if user is on current month
        firstWeekDayOfMonth = getFirstWeekDay()
        collectionView.reloadData()
    }

    @IBAction func rightButtonTapped(_ sender: Any) {
        currentMonthIndex += 1

        if currentMonthIndex > 11 {
            currentMonthIndex = 0
            currentYear += 1
        }

        topMonthButton.setTitle("\(months[currentMonthIndex]) \(currentYear)", for: .normal)

        //for leap year, make february month of 29 days
        if currentMonthIndex == 1 {

            if currentYear % 4 == 0 {
                numOfDaysInMonth[currentMonthIndex] = 29

            } else {
                numOfDaysInMonth[currentMonthIndex] = 28
            }
        }
        //end
        leftButton.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)// Disable left button if user is on current month
        firstWeekDayOfMonth = getFirstWeekDay()
        collectionView.reloadData()
    }

    // Private Methods

    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex] + firstWeekDayOfMonth - 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DateCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)

        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
            return cell

        } else {

            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden = false
            cell.dateLabel.textColor = #colorLiteral(red: 0.5568627451, green: 0.3568627451, blue: 0.6156862745, alpha: 1)
            cell.dateLabel.text="\(calcDate)"

            if let date = String.dateFormatter.date(from: "\(currentYear)-\(currentMonthIndex+1)-\(calcDate)") {

                if date.isWeekend() { // Disable the cell if its a weekend
                    cell.isUserInteractionEnabled = false
                    cell.backgroundImageView.image = #imageLiteral(resourceName: "bg_date_dark")
                    cell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.eventView.isHidden = true

                } else { // enable cell for weekdays
                    cell.isUserInteractionEnabled = true
                    cell.backgroundImageView.image = #imageLiteral(resourceName: "bg_date_light")
                    cell.dateLabel.textColor = #colorLiteral(red: 0.5568627451, green: 0.3568627451, blue: 0.6156862745, alpha: 1)
                    cell.eventView.isHidden = false
                }
            }


            // If you want to disable the previous dates of current month
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                //cell.isUserInteractionEnabled=false

            } else {
                //cell.isUserInteractionEnabled=true
            }
        }

        return cell
    }

    // MARK: - UICollectionView Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell
        cell?.backgroundImageView.image = #imageLiteral(resourceName: "bg_date_color")
        cell?.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        if let date = cell?.dateLabel.text! {
            print("\(currentYear)-\(currentMonthIndex+1)-\(date)")

            // If you want to pass the selected date to previous viewController, use following delegate
            self.delegate?.didSelectDate(dateString: "\(currentYear)-\(currentMonthIndex+1)-\(date)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell
        cell?.backgroundImageView.image = #imageLiteral(resourceName: "bg_date_light")
        cell?.dateLabel.textColor = #colorLiteral(red: 0.5568627451, green: 0.3568627451, blue: 0.6156862745, alpha: 1)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7 , height: collectionView.frame.width/7 )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
