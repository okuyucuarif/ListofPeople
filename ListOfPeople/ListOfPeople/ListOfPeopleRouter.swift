//
//  ListOfPeopleRouter.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import Foundation

protocol ListOfPersonRouterProtocol {

}

class ListOfPeopleRouter: ListOfPersonRouterProtocol {
    var view: ListOfPersonStartPointView?
    
    static let shared: ListOfPeopleRouter = {
        let listOfPeopleRouter = ListOfPeopleRouter()
        return listOfPeopleRouter
    }()

    private init() {
        
        self.view = ListOfPeopleViewController()
        let presenter = ListOfPeoplePresenter()
        let interactor = ListOfPeopleInteractor()

        self.view?.presenter = presenter

        interactor.presenter = presenter

        presenter.view = self.view
        presenter.router = self
        presenter.interactor = interactor
    }
}
