//
//  ParsingResponse.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 30.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import WebKit
import RxSwift


class ParsingResponse{

    static let Shared = ParsingResponse.init()

    private init(){
        print("init ParsingResponse")
    }
    deinit {
        print("deinit ParsingResponse")
    }

    func getObservableCodeToGetTokenFromResponse(response: HTTPURLResponse) -> Observable<String>? {
        guard let stringResponse = response.url?.absoluteString else{
            return nil
        }
        if stringResponse.range(of: "code=") == nil {
            return nil
        }
        let start = stringResponse.index(stringResponse.endIndex, offsetBy: -7)
        let end = stringResponse.endIndex
        let substringCode = String(stringResponse[start..<end])
        print(substringCode)
        return Observable<String>.of(substringCode)
    }


//    func getTokenFromResponse(response: HTTPURLResponse) -> String? {
//        guard let stringResponse = response.url?.absoluteString else{
//            return nil
//        }
//        if stringResponse.range(of: "code=") != nil {
//            return nil
//        }
//        let start = stringResponse.index(stringResponse.endIndex, offsetBy: -7)
//        let end = stringResponse.endIndex
//        let substringCode = String(stringResponse[start..<end])
//        return Observable<String>.of(substringCode)
//    }
    
}

