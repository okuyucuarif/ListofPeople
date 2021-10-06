//
//  ListOfPeopleInteractor.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import Foundation

protocol ListOfPersonInteractorInputProtocol {
    func fetchData(next: String?)
}

class ListOfPeopleInteractor: ListOfPersonInteractorInputProtocol {
    var presenter: ListOfPersonInteractorOutputProtocol?
    var isAPICalling = false
    
    func fetchData(next: String?) {
        guard !isAPICalling else {
            return
        }
        isAPICalling = true
        DataSource.fetch(next: next) { [weak self] response, error in
            guard let self = self else { return }
            defer {
                self.isAPICalling = false
            }
            guard error == nil, let response = response else {
                self.presenter?.errorOccured()
                return
            }
     
            self.presenter?.setData(response: response)
        }
    }
    
}

