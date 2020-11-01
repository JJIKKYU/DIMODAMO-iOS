//
//  CreatePostViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

import SwiftLinkPreview

class CreatePostViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    // 제목
    let titleRelay = BehaviorRelay<String>(value: "")
    var titleLimit: String { return "\(titleRelay.value.count)/20" }
    
    // 태그
    let tagsRelay = BehaviorRelay<String>(value: "")
    var tags: [String] = ["", "", ""]
    var tagsLimit: String {
        // # 태그가 있는 단어들을 찾아서 태그 때고  다 소문자로 해주기
        let sliceArray = tagsRelay.value.getArrayAfterRegex(regex:"#[^ ]+").map { (slice) in
            slice.replacingOccurrences(of: "#", with: "").lowercased()
        }
        tags = sliceArray
        print(tags)
        return "\(sliceArray.count)/3"
    }
    var tagsLimitCount: Int {
        let sliceArray = tagsRelay.value.getArrayAfterRegex(regex:"#[^ ]+").map { (slice) in
            slice.replacingOccurrences(of: "#", with: "").lowercased()
        }
        
        return sliceArray.count
    }
    
    // 내용
    let descriptionRelay = BehaviorRelay<String>(value: "")
    var descriptionLimit: String {
        return "\(descriptionRelay.value.count)/1000"
    }
    
    
    /*
     
     업로드 이미지
     */
    let uploadImagesRelay = BehaviorRelay<[UIImage]>(value: []) // 유저가 사진을 찍거나, 앨범에서 선택할 때마다 이쪽으로 넘길 예정
    var uploadImageUrlArr: [String] = [] // 업로드 하기 전에 파이어베이스 링크를 넣음
    
    /*
     업로드 링크
     */
    let uploadLinksRelay = BehaviorRelay<[String]>(value: []) // 링크만 가지고 있음
    let uploadLinkDataRelay = BehaviorRelay<PreviewResponse?>(value: nil)
    let uploadLinksDataRelay = BehaviorRelay<[PreviewResponse]>(value: []) // 링크에 있는 데이터를 해체해 가지고 있음
    let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    init() {
        
    }
    
    func sendPost() {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        
        // 유저 디폹트에서 닉네임을 불러옴
        let userDefaults = UserDefaults.standard
        let userNickname: String = userDefaults.string(forKey: "nickname") ?? "익명"
        let userDpti: String = userDefaults.string(forKey: "dpti") ?? "M_TI"
        
        // DocumentID를 미리 불러오기 위해
        
        let document = db.collection("hongik/information/posts").document()
        let id: String = document.documentID
        
        // 이미지 업로드 프로세스
//        uploadImage(documentID: document.documentID)
        
        let board: Board = Board(boardId: id,
                                 boardTitle: titleRelay.value,
                                 bundleId: unixTimestamp,
                                 category: "magazine",
                                 commentCount: 0,
                                 createdAt: "\(strDate)",
                                 description: "\(descriptionRelay.value)",
                                 images: [],
                                 links: [],
                                 nickname: userNickname,
                                 scrapCount: 0,
                                 tags: tags,
                                 userDpti: userDpti,
                                 userId: Auth.auth().currentUser?.uid,
                                 videos: [])
        
        _ = document.setData(board.dictionary) { err in
            if let err = err {
                print("게시글을 작성하는데 오류가 발생했습니다. \(err.localizedDescription)")
            } else {
                print("정상적으로 글이 작성되었습니다. \(id)")
            }
        }
    }
    
    
    /*
     Link Setting
     */
    func linkViewSetting() {
        var linksData: [PreviewResponse] = [] // 이전 링크 데이터
        // 유저에게 입력받은 새로운 링크 데이터
        guard let newLinkData: PreviewResponse = uploadLinkDataRelay.value else {
            return
        }
        // 기존 데이터를 먼저 가져 온 뒤에
        linksData = self.uploadLinksDataRelay.value
        // 합침
        linksData.append(newLinkData)
        
        self.uploadLinksDataRelay.accept(linksData)
    }
    
    func linkCheck(url: String) {
        slp.previewLink("\(url)",
                         onSuccess: { [self] result in
                            let resultArr = result
                            let linkData: PreviewResponse =
                                PreviewResponse(url: (resultArr["url"] as? URL) ?? URL(string: "dimodamo.com")!,
                                                title: resultArr["title"] as? String ?? "",
                                                image: resultArr["image"] as? String ?? "",
                                                icon: resultArr["icon"] as? String ?? ""
                                )
                            
                            uploadLinkDataRelay.accept(linkData)
                            
                         }, onError: { error in
                            print("\(error)")
                         })
    }
    
    // TODO : 도큐먼트 아이디를 받아서 for문 돌려서
    func uploadImage(documentID: String) {
        
        guard let uploadData = self.uploadImagesRelay.value[0].jpegData(compressionQuality: 0.5) else {
            return
        }
        let storageRef = storage.child("hongik/information/posts/\(documentID).png")
        
        storageRef.putData(uploadData, metadata: nil) { _, error in
                        guard error == nil else {
                            print("Failed to upload")
                            return
                        }
                        
                        storageRef.downloadURL(completion: { url, error in
                            guard let url = url, error == nil else {
                                return
                            }
                            
                            let urlString = url.absoluteString
                            print("DownloadURL : \(urlString)")
                            self.uploadImageUrlArr.append(urlString)
                            //                            UserDefaults.standard.set(urlString, forKey: "url")
                        })
                     }
    }
}



// MARK: - 정규식 익스텐션
// https://eunjin3786.tistory.com/12

extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
