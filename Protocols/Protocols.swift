//
//  Protocols.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//


import Foundation
import UIKit
import RxSwift


 protocol CoordinatorProtocol {
    associatedtype ElementForObservableStart = Observable<Void>
    associatedtype ElementForObservableCoordinate = Observable<Void>


    func start(from nc: UINavigationController) -> ElementForObservableStart
    func coordinate< Coordinator: CoordinatorProtocol>(to coordinator: Coordinator, from nc: UINavigationController)  -> ElementForObservableCoordinate
}
