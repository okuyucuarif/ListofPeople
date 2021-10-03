//
//  ListOfPeopleTableView.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import UIKit

class ListOfPeopleTableView: UITableView {
    
    var people = [Person]()
    let reuseIdentifier = "ListOfPerson"
    var pullToRefresh: (() -> Void)?
    var loadMore: (() -> Void)?
    var isPulledDown = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        setRefreshControl()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(with data: [Person]) {
        self.people = data
        refreshControl?.endRefreshing()
        tableFooterView = nil
        isPulledDown = false
        reloadData()
    }
    
    func setRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl?.tintColor = .gray
    }
    
    @objc func refresh(_ sender: AnyObject) {
        isPulledDown = true
        if let pullToRefresh = pullToRefresh {
            pullToRefresh()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !isPulledDown else { return }
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) {
            if let loadMore = loadMore {
                isPulledDown = true
                tableFooterView = createSpinnerFooter()
                loadMore()
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
}

// MARK: - Table View Delegate
extension ListOfPeopleTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
    }
    
}
// MARK: - Table View Data Source
extension ListOfPeopleTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(people[indexPath.row].fullName) \(people[indexPath.row].id)"
        return cell
    }
}
