//
//  ListOfPeopleViewController.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import UIKit

typealias ListOfPersonStartPointView = ListOfPersonViewProtocol & ListOfPeopleViewController

protocol ListOfPersonViewProtocol: AnyObject {
    func setTableViewData(list: [Person])
    func setNoOneViewVisible()
    func showAlert()
    func noMoreData()
    func cleanSpinners()
}

class ListOfPeopleViewController: UIViewController, ListOfPersonViewProtocol {
    var presenter: ListOfPersonPresenterProtocol?
    
    lazy var tableView: ListOfPeopleTableView = {
        let tableView = ListOfPeopleTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pullToRefresh = pullToRefresh
        tableView.loadMore = loadMore
        return tableView
    }()
    
    lazy var noOneHereView: NoOneView = {
        let view = NoOneView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.didTapRetry = didTapRetry
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.notifyViewDidLoad()
    }
    
    func setupView() {
        title = "List Of People"
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(noOneHereView)
        view.addSubview(activityIndicator)
        setupConstraint()
    }
    
    func setupConstraint()  {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            noOneHereView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            noOneHereView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            noOneHereView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            noOneHereView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        activityIndicator.center = view.center
    }
    
    func setTableViewData(list: [Person]) {
        if tableView.isHidden {
            tableView.isHidden = false
            noOneHereView.isHidden = true
        }
        tableView.setData(with: list)
    }
    
    func setNoOneViewVisible() {
        tableView.isHidden = true
        noOneHereView.isHidden = false
    }
    
    func noMoreData() {
        showToastMessage(message: "No More Data :)")
        tableView.tableFooterView?.isHidden = true
    }
    
    func cleanSpinners() {
        tableView.tableFooterView?.isHidden = true
        view.isUserInteractionEnabled = true
        tableView.refreshControl?.endRefreshing()
        tableView.isPulledDown = false
        activityIndicator.stopAnimating()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error occured",
                                      message: "Error occured when data fethed",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] action in
            self?.didTapRetry()
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            self?.presenter?.notifyDidTapOkButtonOnAlertView()
        }))
        present(alert, animated: true)
    }
    
    func pullToRefresh() {
        presenter?.pulledForRefresh()
    }
    
    func loadMore() {
        presenter?.fetchData()
    }
    
    func didTapRetry() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        presenter?.fetchData()
    }
}
