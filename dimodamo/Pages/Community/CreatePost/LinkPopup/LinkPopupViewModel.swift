//
//  LinkPopupViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import SwiftLinkPreview

class LinkPopupViewModel {
    
    /*
     업로드 링크
     */
    var uploadLink: String?
    var uploadLinks: [String] = [] // 링크만 가지고 있음 (최종적으로 글 작성시, 어레이가 필요하므로)
    
    let uploadLinkDataRelay = BehaviorRelay<PreviewResponse?>(value: nil)
    let uploadLinksDataRelay = BehaviorRelay<[PreviewResponse]>(value: []) // 링크에 있는 데이터를 해체해 가지고 있음
    let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    
    init() {
        
    }
    
    /*
     Link Setting
     */
    func linkViewSetting() {
        var linksData: [PreviewResponse] = [] // 이전 링크 데이터
        var linksString: [String] = [] // urlString만 담기 위해
        
        // 유저에게 입력받은 새로운 링크 데이터
        guard let newLinkData: PreviewResponse = uploadLinkDataRelay.value,
              let newLinkString: String = self.uploadLink else {
            return
        }
        
        print("\(newLinkString)")
        // 기존 데이터를 먼저 가져 온 뒤에
        linksData = self.uploadLinksDataRelay.value
        linksString = self.uploadLinks
        // 합침
        linksData.append(newLinkData)
        linksString.append(newLinkString)
        
        self.uploadLinksDataRelay.accept(linksData)
        self.uploadLinks = linksString
        
        print("uploadLinks = \(linksString)")
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
                            
                            uploadLinkDataRelay.accept(linkData) // 이미지 그리기 위한 용도 구조체
                            uploadLink = linkData.url.absoluteString // 게시글 업로드용
                            
                        }, onError: { error in
                            print("\(error)")
                        })
    }
    
    // 링크 체크만 하고 그대로 팝업 뷰를 꺼버렸을 경우 남아있는 데이터 삭제
    func uploadLinkDataRelayReset() {
        self.uploadLinkDataRelay.accept(nil)
        self.uploadLink = nil
    }
}
