//
//  APIService.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RxSwift

import FirebaseFirestore

class APIService {
    
    // Firestore
    static var fireStore = Firestore.firestore()

    // MARK: - Local Json Parsing

    static func fetchLocalJson(fileName : String ,onComplete : @escaping (Result<Data, Error>) -> Void) {
        if let path = Bundle.main.path(forResource: "\(fileName)", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: [])
                
                onComplete(.success(data))
            } catch {
                onComplete(.failure(error))
            }
        }
    }
    
    static func fetchLocalJsonRx(fileName : String) -> Observable<Data> {
        return Observable.create() { emitter in
            fetchLocalJson(fileName : fileName) { result in
                switch result {
                case let .success(data):
                    print("넘겼습니다")
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - HomeVC 공지 Json Parsing
    
    

    
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


// MARK: - API

class API {
    // 심사 제출할 때는 바꿀 것
    static let admobKey = API.admobKey_banner
    
    static let admobKey_banner = "ca-app-pub-7521278168972722/4086329917"
    static let admobKey_test = "ca-app-pub-3940256099942544/2934735716"
}
