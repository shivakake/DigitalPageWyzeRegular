//
//  FromToDatePickerController.swift
//  FromToDatePicker
//
//  Created by Roushil singla on 11/26/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

public class FromToDatePickerController: NSViewController {

    
    @IBOutlet public weak var calendarDatePicker: NSDatePicker!
    @IBOutlet public weak var stepperDatePicker : NSDatePicker!
    @IBOutlet weak var fromDateButton           : NSButton!
    @IBOutlet weak var toDateButton             : NSButton!
    @IBOutlet weak var fromToDateStack          : NSStackView!
    @IBOutlet weak var datePickerStack          : NSStackView!
    @IBOutlet weak var calendarTitle            : NSButton!
    
    lazy var currentlySelectedButton    = 0
    lazy var isFromButtonSelected       = false
    public lazy var fromDate            = ""
    public lazy var toDate              = ""
    
    var selectedDateFromPicker  : Date?
    public var selectedDate     : ((Date?, Date?) -> Void)?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "FromToDatePickerController", bundle: Bundle(for: FromToDatePickerController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Hide Calendar View
    public override func viewDidLoad() {
        super.viewDidLoad()
        calendarDatePicker.isHidden  = true
        fromToDateStack.isHidden     = false
        datePickerStack.isHidden     = true
        fromDateButton.title         = fromDate
        toDateButton.title           = toDate
        stepperDatePicker.dateValue  = fromDate.fetchDateFromString(format: "dd-MMM-yy")
        isFromButtonSelected = !fromDate.isEmpty
    }
    
    
    ///* Applying Border To Buttons
    public override func viewWillLayout() {
        super.viewWillLayout()
        fromDateButton.setBorder(with: .gray)
        toDateButton.setBorder(with: .gray)
    }
    
    
    ///* Show Calendar Picker on Button Action and pass stepper date */
    @IBAction func showCalendarTapped(_ sender: NSButton) {
        if sender.state == .on {
            calendarDatePicker.isHidden     = false
            calendarDatePicker.dateValue    = stepperDatePicker.dateValue
        } else {
            calendarDatePicker.isHidden     = true
            stepperDatePicker.dateValue     = calendarDatePicker.dateValue
        }
    }
    
    
    ///* Submit Button and pass Date To Selected Button */
    @IBAction func submitDateTapped(_ sender: NSButton) {
        var date: Date?
        !calendarDatePicker.isHidden ?
            (date = calendarDatePicker.dateValue) :
            (date = stepperDatePicker.dateValue)
        
        selectedDateFromPicker = date ?? Date()
        fromToDateStack.isHidden    = false
        datePickerStack.isHidden    = true
        calendarTitle.title         = "Created"
        setDateToButton()
        
    }
    
    /// Hide Date Picker and Show From-To
    @IBAction func cancelTapped(_ sender: NSButton) {
        fromToDateStack.isHidden    = false
        datePickerStack.isHidden    = true
        calendarTitle.title         = "Created"
    }
    
    /// Close the popup
    @IBAction func crossTapped(_ sender: Any) {
        dismiss(self)
    }
    
    
    /// From Button Tapped to show Date Picker
    @IBAction func fromButtonTapped(_ sender: NSButton) {
        isFromButtonSelected        = true
        currentlySelectedButton     = sender.tag
        calendarTitle.title         = "From"
        fromToDateStack.isHidden    = true
        datePickerStack.isHidden    = false
        /// Make Sure the Date gets selected for till Today for From Filter
        calendarDatePicker.maxDate  = Date()
        stepperDatePicker.maxDate   = Date()
    }
    
    /// To Button Tapped to show Date Picker
    @IBAction func toButtonTapped(_ sender: NSButton) {
        /// Make Sure To button only opens up Date picker when From Date is already selected
        if isFromButtonSelected && !fromDateButton.title.isEmpty {
            currentlySelectedButton     = sender.tag
            calendarTitle.title         = "To"
            fromToDateStack.isHidden    = true
            datePickerStack.isHidden    = false
            /// Make Sure the minimum Date is from the date selected from the From Date
            stepperDatePicker.minDate   = selectedDateFromPicker
            calendarDatePicker.minDate  = selectedDateFromPicker
            /// Make Sure the Date does not gets selected for till Today for To Filter
            calendarDatePicker.maxDate  = nil
            stepperDatePicker.maxDate   = nil
        }
    }
    
    /// Clear all the applied Dates
    @IBAction func clearTapped(_ sender: NSButton) {
        fromDateButton.title = "From"
        toDateButton.title = "To"
    }
    
    
    /// Passing the seleced dates of From and To
    @IBAction func doneTapped(_ sender: NSButton) {

        let fetchedFromDate = fromDateButton.title.fetchDateFromString(format: "dd-MMM-yy")
        let fetchdToDate    = toDateButton.title.fetchDateFromString(format: "dd-MMM-yy")
        
        if fromDateButton.title == "From" && toDateButton.title == "To" {
            /// No Dates are selected
            selectedDate?(nil, nil)
        } else if fromDateButton.title == "From" {
            /// Only toDate is selected
            selectedDate?(nil, fetchdToDate)
        } else if toDateButton.title == "To" {
            /// Only fromDate is selected
            selectedDate?(fetchedFromDate, nil)
        } else {
            /// All Dates are selected
            selectedDate?(fetchedFromDate, fetchdToDate)
        }
        
        dismiss(self)
    }
    
        
    /// Assigning the Dates to From and To based on Selected Button
    fileprivate func setDateToButton() {
        ///* Get String Value From Date
        let selectedDateString = selectedDateFromPicker?.getFormattedStringFromDate(format: "dd-MMM-yy")
        if currentlySelectedButton == 0 {
            fromDateButton.title = selectedDateString ?? "From"
        } else {
            toDateButton.title = selectedDateString ?? "To"
        }
    }
    
    /* Set Titles to From and To Date to get previously selected dates */
    public func setTitleToDates(fromDate: String, toDate: String) {
        self.fromDate         = fromDate.isEmpty ? "From" : fromDate
        self.toDate           = toDate.isEmpty   ? "To"   : toDate
    }
    
}

extension String {
    ///* Fetch Date From String during the sorting of products from date
        public func fetchDateFromString(format: String?) -> Date {
            
            //* Formatting String into Date
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = format ?? "yyyy-MM-dd"
            let date                 = dateFormatter.date(from: self)
            return date ?? Date()
        }
}
extension Date {
    
    ///* Return formatted date in String from Fetched Date */
    public func getFormattedStringFromDate(format: String?) -> String {
        
        //* Formatting the Date into String
        let formatter           = DateFormatter()
        formatter.dateFormat    = format ?? "yyyy-MM-dd"
        let dateString          = formatter.string(from: self)
        return dateString
    }
}
