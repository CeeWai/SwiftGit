//
//  DefaultViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView
import FirebaseAuth
class DefaultViewController2: UIViewController {

    // similar to default viewcontroller 2
    var projectItem : Project?
    @IBOutlet weak var calendarWeekView: DefaultWeekView!
    let viewModel = DefaultViewModel()
    var currentuser = ""
    var popoverstatus = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        currentuser = Auth.auth().currentUser?.uid as! String
//        var projectgroupList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe1(userid: user.userid!)
//                        var stringquery = ""
//                        var lastremoved = ""
//                        for item in projectgroupList{
//                            stringquery = stringquery + String(item.projectid!) + ","
//                        }
//                        lastremoved = String(stringquery.dropLast())
//                        print(lastremoved)
//                        var itemlist = ProjectEventDataManager.loadProjecteventsbyprojectidin(projectid: lastremoved)
//                        for item in itemlist{
//                            if (item.projectid != 1){
//                              item.title = user.username!
//                            }
//                        }
//                  projectevents.append(contentsOf: itemlist)
//              }
//              viewModel.events = projectevents
        var projectgroupList : [Projectgroup] = []
        var projectList : [Project] = []
        var projectevents  : [DefaultEvent] = []
        projectgroupList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe1(userid: currentuser)
        if projectgroupList.isEmpty{
        }
        else{
            for project in projectgroupList{
                var projectitem: [Project] = ProjectDataManager.loadProjectsbyid(projectid: project.projectid!)
                projectList.append(projectitem[0])
            }
        }
        var stringquery = ""
        for item in projectList{
            
               stringquery = stringquery + String(item.projectId!) + ","
        }
        var lastremoved = String(stringquery.dropLast())
        print(lastremoved)
        var itemlist = ProjectEventDataManager.loadProjecteventsbyprojectidindefault(projectid: lastremoved)
        projectevents.append(contentsOf: itemlist)
        //viewModel.events = ProjectEventDataManager.loadProjecteventsbyprojectiddefault(projectid: 1)
        viewModel.events = projectevents
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        setupBasic()
        setupCalendarView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
           NotificationCenter.default.addObserver(self, selector: #selector(sendtodefaultview(_:)), name: Notification.Name(rawValue: "sendtodefaultview2"), object: nil)
       }
    @objc func sendtodefaultview(_ notification: Notification) {
           let data = notification.userInfo!["projectid"]! as! Int
        if (ProjectDataManager.loadProjectsbyid(projectid: data).isEmpty == false){
           let projectitem = ProjectDataManager.loadProjectsbyid(projectid: data)
            guard let optionsVC = UIStoryboard(name: "Seb_Main", bundle: nil).instantiateViewController(withIdentifier: "detailtodo") as? projectdetail1ViewController else {
                      return
                  }
                  optionsVC.projectItem = projectitem[0]
                  //let navigationVC = UINavigationController(rootViewController: optionsVC)
                  //optionsVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(optionsVC, animated: true)
                  //self.present(optionsVC, animated: true, completion: nil)
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
                                  popover.heightAnchor.constraint(equalToConstant:110),
                      
                                  //8
                                  popover.widthAnchor.constraint(equalToConstant: 300)
                              ])
                          popoverstatus = 1
           }
       }
    override func prepare(for segue: UIStoryboardSegue,
              sender: Any?){
                if(segue.identifier == "seguetoproject")
                        {
                       let detailViewController = segue.destination as!
                        ProjectViewController
                           //detailViewController.projectItem = ""
                      
                       }

          }
    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }

    private func setupCalendarView() {
        calendarWeekView.baseDelegate = self

        // For example only
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

    /// For example only
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

extension DefaultViewController2: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNaviBarTitle()
    }
}

// For example only
extension DefaultViewController2: OptionsViewDelegate {

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
