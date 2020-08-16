//
//  ExampleOptionsViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView

protocol OptionsViewDelegate: class {
    func finishUpdate(selectedData: OptionsSelectedData)
}

class ExampleOptionsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel: OptionsViewModel!
    weak var delegate: OptionsViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        setupBasic()
        setupTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    func setupBasic() {
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        navigationItem.title = "Options"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onBtnDoneTapped))
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.sectionHeaderHeight = 44
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: OptionsTableViewCell.className, bundle: nil), forCellReuseIdentifier: OptionsTableViewCell.className)
        tableView.register(UINib(nibName: ExpandableHeaderView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: ExpandableHeaderView.className)
    }

    @objc func onBtnDoneTapped() {
        var optionalScrollType: JZScrollType?
        var optionalHourGridDivision: JZHourGridDivision?
        var firstDayOfWeek: DayOfWeek?
        let dataList = viewModel.optionsData

        let scrollableRange: (Date?, Date?)
        if dataList[1].selectedValue as? Int == 7 {
            firstDayOfWeek = dataList[2].selectedValue as? DayOfWeek
            optionalScrollType = dataList[3].selectedValue as? JZScrollType
            optionalHourGridDivision = dataList[4].selectedValue as? JZHourGridDivision
            scrollableRange = (dataList[5].selectedValue as? Date, dataList[6].selectedValue as? Date)
        } else {
            optionalScrollType = dataList[2].selectedValue as? JZScrollType
            optionalHourGridDivision = dataList[3].selectedValue as? JZHourGridDivision
            scrollableRange = (dataList[4].selectedValue as? Date, dataList[5].selectedValue as? Date)
        }
        guard
            let scrollType = optionalScrollType,
            let hourGridDivision = optionalHourGridDivision,
            let date = dataList[0].selectedValue as? Date,
            let numOfDays = dataList[1].selectedValue as? Int else { return }

        let selectedData = OptionsSelectedData(date: date,numOfDays: numOfDays,
        scrollType: scrollType,
        firstDayOfWeek: firstDayOfWeek,
        hourGridDivision: hourGridDivision,
        scrollableRange: scrollableRange)

        delegate?.finishUpdate(selectedData: selectedData)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExampleOptionsViewController: UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate, OptionsCellDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.optionsData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.optionsData[indexPath.section].isExpanded ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.className, for: indexPath) as? OptionsTableViewCell else {
            preconditionFailure("OptionsTableViewCell should be casted")
        }
        cell.updateCell(data: viewModel.optionsData[indexPath.section], section: indexPath.section)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandableHeaderView.className) as? ExpandableHeaderView else {
            preconditionFailure("ExpandableHeaderView should be casted")
        }
        headerView.updateHeaderView(section: section, title: viewModel.optionsData[section].subject.rawValue, subTitle: viewModel.getHeaderViewSubtitle(section))
        headerView.delegate = self
        return headerView
    }

    func toggleSection(section: Int) {
        viewModel.optionsData[section].isExpanded = !viewModel.optionsData[section].isExpanded
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        tableView.endUpdates()
    }

    func selectedValueChanged(section: Int) {
        guard let headerView = tableView.headerView(forSection: section) as? ExpandableHeaderView else { return }
        headerView.lblSelectedValue.text = viewModel.getHeaderViewSubtitle(section)

        if section == 2 {
            if viewModel.optionsData[2].selectedIndex == 6 && viewModel.optionsData[3].subject != .firstDayOfWeek {
                viewModel.insertDayOfWeekToData(firstDayOfWeek: .Sunday)
                tableView.reloadData()
            }
            if viewModel.optionsData[2].selectedIndex != 6 && viewModel.optionsData[3].subject == .firstDayOfWeek {
                viewModel.removeDayOfWeekInData()
                tableView.reloadData()
            }
        }
    }
}
