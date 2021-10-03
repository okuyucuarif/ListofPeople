//
//  ListOfPeopleRouter.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import Foundation

protocol IListOfPersonRouter {
    var view: ListOfPersonStartPointView? { get set }
}

class ListOfPeopleRouter: IListOfPersonRouter {
    var view: ListOfPersonStartPointView?
    
    static let shared: IListOfPersonRouter = {
        let listOfPeopleRouter = ListOfPeopleRouter()
        return listOfPeopleRouter
    }()

    private init() {
        self.view = ListOfPeopleViewController()
        var presenter: IListOfPersonPresenter = ListOfPeoplePresenter()
        var interactor: IListOfPersonInteractor = ListOfPeopleInteractor()

        self.view?.presenter = presenter

        interactor.presenter = presenter

        presenter.view = self.view
        presenter.router = self
        presenter.interactor = interactor
    }
}
