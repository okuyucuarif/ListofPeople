//
//  ListOfPeoplePresenter.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import Foundation

protocol IListOfPersonPresenter {
    var view: IListOfPersonView? { get set }
    var router: IListOfPersonRouter? {get set}
    var interactor: IListOfPersonInteractor? {get set}
    
    func notifyViewDidLoad()
    func fetchData()
    func pulledForRefresh()
    func errorOccured()
    func setData(response: FetchResponse)
}

class ListOfPeoplePresenter:  IListOfPersonPresenter{
    var view: IListOfPersonView?
    
    var router: IListOfPersonRouter?
    
    var interactor: IListOfPersonInteractor?
    
    var people = [Person]()
    var next: String? = nil
    var isPullToRefreshing = false
    
    func notifyViewDidLoad() {
        fetchData()
    }
    
    func fetchData() {
        interactor?.fetchData(next: next)
    }

    func setData(response: FetchResponse) {
        defer {
            view?.cleanSpinners()
            isPullToRefreshing = false
        }
        self.next = response.next
       
        if people.isEmpty && response.people.isEmpty {
            if isPullToRefreshing {
                // error occured when refreshing
                errorOccured()
            }else {
                // initial result is empty
                view?.setNoOneViewVisible()
            }
            return
        }
        let isAnyDataAdded = addFetchedDataToList(fetchedData: response.people)
        if isAnyDataAdded {
            view?.setTableViewData(list: people)
        }else {
            view?.noMoreData()
        }
        
    }
    
    /// Add fetched data to people array if array contains same data, donot add.
    /// Return a bool value that indicates any data  be added or not to array
    func addFetchedDataToList(fetchedData: [Person]) -> Bool {
        var isAnyDataAdded = false
        for person in fetchedData {
            if !people.contains { $0.id == person.id } {
                isAnyDataAdded = true
                people.append(person)
            }
        }
        return isAnyDataAdded
    }
    
    func pulledForRefresh() {
        isPullToRefreshing = true
        next = nil
        people = []
        fetchData()
    }
    
    func errorOccured() {
        view?.cleanSpinners()
        view?.showAlert()
    }
    
}
