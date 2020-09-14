//
//  APIService.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RxSwift

class APIService {
    
    // DptiResult Fetch json
//    static func fetchAllResults(onComplete : (Result<Data, Error>) -> Void) {
//
//        let path = Bundle.main.path(forResource: "Result", ofType: "json")
//        if let data = try? String(contentsOfFile: path!).data(using: .utf8) {
//            _ = try! JSONSerialization.jsonObject(with: data, options: [])
//            onComplete(.success(data))
//            print("###fetchAllResults" + "\(data)")
//        }
//    }
    
//    static func fetchAllResults(onComplete : @escaping (Result<String, Error>) -> Void) {]
    static func fetchAllResults() {
        if let path = Bundle.main.path(forResource: "Results", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: [])
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [[String : Any]]]
                let printTest = json!["Result"]?[0]
                print("\(printTest)")
            } catch {

            }
        }
        
        
    }

    
//    static func questionTitleParsing(onComplete : (Result<[String : Any], Error>) -> Void) {
//        let path = Bundle.main.path(forResource: "Reslt", ofType: "json")
//        print("path입니다")
//        if let data = try? String(contentsOfFile: path!).data(using: .utf8) {
//            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
//            print(json)
//            onComplete(.success(json))
//        }
//    }
//
//    static func fetchAllResultsRx() -> Observable<[String : Any]> {
//        return Observable.create() { emitter in
//            questionTitleParsing() { result in
//                switch result {
//                case let .success(data):
//                    print(data)
//                    break
//                case let .failure(err):
//                    break
//                }
//            }
//            return Disposables.create()
//        }
//    }

}
