//
//  DefaultViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DefaultViewController1: UIViewController {

    var projectItem : Project?
    @IBOutlet weak var calendarWeekView: DefaultWeekView!
    let viewModel = DefaultViewModel()
    var popoverstatus = 0
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden=true
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismisspopover")
            view.addGestureRecognizer(tap)
        print((projectItem?.projectId!)!)
        viewModel.events = ProjectEventDataManager.loadProjecteventsbyprojectiddefault(projectid: (projectItem?.projectId!)!)
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        setupBasic()
        setupCalendarView()
    }
    //set up calendar and load event data
    override func viewDidAppear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self, selector: #selector(sendtodefaultview(_:)), name: Notification.Name(rawValue: "sendtodefaultview"), object: nil)
        //recieved notificationcenter from defaultweekview to act as a listener for on click
            viewModel.events = ProjectEventDataManager.loadProjecteventsbyprojectiddefault(projectid: (projectItem?.projectId!)!)
                  viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
                  setupBasic()
                  setupCalendarView()
       }
    // setup the calendar
    @objc func sendtodefaultview(_ notification: Notification) {
           let data = notification.userInfo!["taskid"]! as! Int
        if (ProjectTaskDataManager.loadtaskbyid(taskid: data).isEmpty == false){
           let taskitem = ProjectTaskDataManager.loadtaskbyid(taskid: data)

           let projectitem = ProjectDataManager.loadProjectsbyid(projectid: taskitem[0].projectid!)
            guard let optionsVC = UIStoryboard(name: "Seb_Main", bundle: nil).instantiateViewController(withIdentifier: "projecttaskdetailViewController") as? projecttaskdetailViewController else {
                      return
                  }
                  optionsVC.projectItem = projectitem[0]
                  optionsVC.projecttask = taskitem[0]
                  //let navigationVC = UINavigationController(rootViewController: optionsVC)
                self.navigationController?.pushViewController(optionsVC, animated: true)
        }
           
           
       }
    @IBAction func optionbtn(_ sender: Any) {
           presentOptionsVC()
       }
       override var preferredStatusBarStyle: UIStatusBarStyle{
           .lightContent
       }
       
        @IBOutlet var popover: UIView!
    @IBAction func managepressed(_ sender: Any) {
       }
       @IBAction func closedpopover(_ sender: Any) {
            self.popover.removeFromSuperview()
       }
    @objc func dismisspopover() {
           popover.removeFromSuperview()
           if popover.isDescendant(of: view){
               popover.removeFromSuperview()
           }
       }
       @IBAction func popoverpressed(_ sender: Any) {
                      if popoverstatus == 1{
                          self.popover.removeFromSuperview()
                          popoverstatus = 0
                      }
                      if popoverstatus == 0{
                          self.view.addSubview(popover)
                          let superView = self.view.superview
                          superView!.addSubview(popover)
                          popover.translatesAutoresizingMaskIntoConstraints = false

                          NSLayoutConstraint.activate([

                                  // 5
                                  NSLayoutConstraint(item: popover, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 60),

                                  // 6
                                  NSLayoutConstraint(item: popover, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 160),

                                  // 7
                                  popover.heightAnchor.constraint(equalToConstant:70),
                      
                                  //8
                                  popover.widthAnchor.constraint(equalToConstant: 300)
                              ])
                          popoverstatus = 1
           }
       }
    override func prepare(for segue: UIStoryboardSegue,
           sender: Any?){
             if(segue.identifier == "seguetoprojectdetail")
                     {
                    let detailViewController = segue.destination as!
                     projectdetail1ViewController
                        detailViewController.projectItem = projectItem
                   
                    }
            if(segue.identifier == "seguetoeditcalender")
              {
             let detailViewController = segue.destination as!
              LongPressViewController
                 detailViewController.projectItem = projectItem
            
             }

       }
    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }

    private func setupCalendarView() {
        calendarWeekView.baseDelegate = self

   
        if viewModel.currentSelectedData != nil {
            setupCalendarViewWithSelectedData()
            return
        }
        // Basic setup
        calendarWeekView.setupCalendar(numOfDays: 3,
                                       setDate: Date(),
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: .pageScroll)
        // Optional
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: JZHourGridDivision.noneDiv))
    }
//setup calendar and the default setting

    private func setupCalendarViewWithSelectedData() {
        guard let selectedData = viewModel.currentSelectedData else { return }
        calendarWeekView.setupCalendar(numOfDays: selectedData.numOfDays,
                                       setDate: selectedData.date,
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: selectedData.scrollType,
                                       firstDayOfWeek: selectedData.firstDayOfWeek)
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
    }
}
//get selected data
extension DefaultViewController1: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNaviBarTitle()
    }
}


extension DefaultViewController1: OptionsViewDelegate {

    func setupBasic() {
        // Add this to fix lower than iOS11 problems
        self.automaticallyAdjustsScrollViewInsets = false
    }


    @objc func presentOptionsVC() {
        guard let optionsVC = UIStoryboard(name: "Seb_Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsViewController") as? ExampleOptionsViewController else {
            return
        }
        let optionsViewModel = OptionsViewModel(selectedData: getSelectedData())
        optionsVC.viewModel = optionsViewModel
        optionsVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: optionsVC)
        self.present(navigationVC, animated: true, completion: nil)
    }

    private func getSelectedData() -> OptionsSelectedData {
        let numOfDays = calendarWeekView.numOfDays!
        let firstDayOfWeek = numOfDays == 7 ? calendarWeekView.firstDayOfWeek : nil
        viewModel.currentSelectedData = OptionsSelectedData(
                                                            date: calendarWeekView.initDate.add(component: .day, value: numOfDays),
                                                            numOfDays: numOfDays,
                                                            scrollType: calendarWeekView.scrollType,
                                                            firstDayOfWeek: firstDayOfWeek,
                                                            hourGridDivision: calendarWeekView.flowLayout.hourGridDivision,
                                                            scrollableRange: calendarWeekView.scrollableRange)
        return viewModel.currentSelectedData
    }

    func finishUpdate(selectedData: OptionsSelectedData) {

        // Update numOfDays
        if selectedData.numOfDays != viewModel.currentSelectedData.numOfDays {
            calendarWeekView.numOfDays = selectedData.numOfDays
            calendarWeekView.refreshWeekView()
        }
        // Update Date
        if selectedData.date != viewModel.currentSelectedData.date {
            calendarWeekView.updateWeekView(to: selectedData.date)
        }
        // Update Scroll Type
        if selectedData.scrollType != viewModel.currentSelectedData.scrollType {
            calendarWeekView.scrollType = selectedData.scrollType
            // If you want to change the scrollType without forceReload, you should call setHorizontalEdgesOffsetX
            calendarWeekView.setHorizontalEdgesOffsetX()
        }
        // Update FirstDayOfWeek
        if selectedData.firstDayOfWeek != viewModel.currentSelectedData.firstDayOfWeek {
            calendarWeekView.updateFirstDayOfWeek(setDate: selectedData.date, firstDayOfWeek: selectedData.firstDayOfWeek)
        }
        // Update hourGridDivision
        if selectedData.hourGridDivision != viewModel.currentSelectedData.hourGridDivision {
            calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
        }
        // Update scrollableRange
        if selectedData.scrollableRange != viewModel.currentSelectedData.scrollableRange {
            calendarWeekView.scrollableRange = selectedData.scrollableRange
        }
    }

    private func updateNaviBarTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        self.navigationItem.title = dateFormatter.string(from: calendarWeekView.initDate.add(component: .day, value: calendarWeekView.numOfDays))
    }
}
