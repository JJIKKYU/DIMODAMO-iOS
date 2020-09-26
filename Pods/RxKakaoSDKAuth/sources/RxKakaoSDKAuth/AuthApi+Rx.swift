//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import RxKakaoSDKCommon

import KakaoSDKCommon
import KakaoSDKAuth

/// 카카오 로그인의 주요 기능을 제공하는 클래스입니다.
///
/// 이 클래스를 이용하여 **카카오톡 간편로그인** 또는 **카카오계정 로그인** 으로 로그인을 수행할 수 있습니다.
///
/// 카카오톡 간편로그인 예제입니다.
///
///     // 로그인 버튼 클릭
///     if (AuthApi.isKakaoTalkLoginAvailable()) {
///         AuthApi.shared.rx.loginWithKakaoTalk()
///             .subscribe(onNext: { (token) in
///                 print(token)
///             }, onError: { (error) in
///                 print(error)
///             })
///             .disposed(by: self.disposeBag)
///     }
///
///     // AppDelegate
///     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
///         if (AuthController.isKakaoTalkLoginUrl(url)) {
///             if AuthController.handleOpenUrl(url: url, options: options) {
///                 return true
///             }
///         }
///         ...
///     }
///
/// 카카오계정 로그인 예제입니다.
///
///     AuthApi.shared.rx.loginWithKakaoAccount()
///         .subscribe(onNext: { (token) in
///             print(token.accessToken)
///         }, onError: { (error) in
///             print(error)
///         })
///         .disposed(by: self.disposeBag)


extension AuthApi: ReactiveCompatible {}

extension Reactive where Base: AuthApi {
   
    // MARK: Methods
    
    // MARK: Login with Kakao Account
    
    /// iOS 11 이상에서 제공되는 (SF/ASWeb)AuthenticationSession 을 이용하여 로그인 페이지를 띄우고 쿠키 기반 로그인을 수행합니다. 이미 사파리에에서 로그인하여 카카오계정의 쿠키가 있다면 이를 활용하여 ID/PW 입력 없이 간편하게 로그인할 수 있습니다.
    public func loginWithKakaoAccount() -> Observable<OAuthToken> {
        return AuthController.shared.rx.authorizeWithAuthenticationSession()
    }
    
    // MARK: Login with KakaoTalk
    
    /// 카카오톡 간편로그인을 실행합니다.
    /// - note: AuthApi.isKakaoTalkLoginAvailable() 메소드로 실행 가능한 상태인지 확인이 필요합니다. 카카오톡을 실행할 수 없을 경우 loginWithKakaoAccount() 메소드로 웹 로그인을 시도할 수 있습니다.
    public func loginWithKakaoTalk(channelPublicIds: [String]? = nil,
                                   serviceTerms: [String]? = nil) -> Observable<OAuthToken> {
        
        return AuthController.shared.rx.authorizeWithTalk(channelPublicIds: channelPublicIds,
                                                          serviceTerms: serviceTerms)
        
    }
    
    // MARK: New Agreement
    
    /// 사용자로부터 카카오가 보유중인 사용자 정보 제공에 대한 동의를 받습니다.
    ///
    /// 카카오로부터 사용자의 정보를 제공 받거나 카카오서비스 접근권한이 필요한 경우, 사용자로부터 해당 정보 제공에 대한 동의를 받지 않았다면 이 메소드를 사용하여 **추가 항목 동의**를 받아야 합니다.
    /// 필요한 동의항목과 매칭되는 scope id를 배열에 담아 파라미터로 전달해야 합니다. 동의항목과 scope id는 카카오 디벨로퍼스의 [내 애플리케이션] > [제품 설정] > [카카오 로그인] > [동의항목]에서 확인할 수 있습니다.
    ///
    /// ## 사용자 동의 획득 시나리오
    /// 간편로그인 또는 웹 로그인을 수행하면 최초 로그인 시 카카오 디벨로퍼스에 설정된 동의항목 설정에 따라 사용자의 동의를 받습니다. 동의항목을 설정해도 상황에 따라 동의를 받지 못할 수 있습니다. 대표적인 케이스는 아래와 같습니다.
    /// - **선택 동의** 로 설정된 동의항목이 최초 로그인시 선택받지 못한 경우
    /// - **필수 동의** 로 설정하였지만 해당 정보가 로그인 시점에 존재하지 않아 카카오에서 동의항목을 보여주지 못한 경우
    /// - 사용자가 해당 동의항목이 설정되기 이전에 로그인한 경우
    ///
    /// 이외에도 다양한 여건에 따라 동의받지 못한 항목이 발생할 수 있습니다.
    ///
    /// ## 추가 항목 동의 받기 시 주의사항
    /// **선택 동의** 으로 설정된 동의항목에 대한 **추가 항목 동의 받기**는, 반드시 **사용자가 동의를 거부하더라도 서비스 이용이 지장이 없는** 시나리오에서 요청해야 합니다.
    
    public func loginWithKakaoAccount(scopes:[String]) -> Observable<OAuthToken> {
        return AuthController.shared.rx.authorizeWithAuthenticationSession(scopes:scopes)
    }
    
    /// :nodoc: 카카오싱크 전용입니다. 자세한 내용은 카카오싱크 전용 개발가이드를 참고하시기 바랍니다.
    public func loginWithKakaoAccount(channelPublicIds: [String]? = nil,
                                      serviceTerms: [String]? = nil) -> Observable<OAuthToken> {
        
        return AuthController.shared.rx.authorizeWithAuthenticationSession(channelPublicIds: channelPublicIds,
                                                                           serviceTerms: serviceTerms)
    }
    
    /// :nodoc: 추가 항목 동의 받기 요청시 인증값으로 사용되는 임시토큰 발급 요청입니다. SDK 내부 전용입니다.
    public func agt() -> Single<String?> {
        return API.rx.responseData(.post, Urls.compose(.Kauth, path:Paths.authAgt),
                                parameters: ["client_id":try! KakaoSDKCommon.shared.appKey(),
                                             "access_token":AUTH.tokenManager.getToken()?.accessToken].filterNil(),
                                sessionType:.RxAuthApi)
            .compose(API.rx.checkKAuthErrorComposeTransformer())
            .map({ (response, data) -> String? in
                if let json = (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String: Any] {
                    return json["agt"] as? String
                }
                else {
                    return nil
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 사용자 인증코드를 이용하여 신규 토큰 발급을 요청합니다.
    public func token(grantType: String = "authorization_code",
                      clientId: String = try! KakaoSDKCommon.shared.appKey(),
                      redirectUri: String = try! KakaoSDKCommon.shared.redirectUri(),
                      code: String) -> Single<OAuthToken> {
        return API.rx.responseData(.post,
                                Urls.compose(.Kauth, path:Paths.authToken),
                                parameters: ["grant_type":grantType,
                                             "client_id":clientId,
                                             "redirect_uri":redirectUri,
                                             "code":code,
                                             "ios_bundle_id":Bundle.main.bundleIdentifier].filterNil(),
                                sessionType:.RxAuthApi)
            .compose(API.rx.checkKAuthErrorComposeTransformer())
            .map({ (response, data) -> OAuthToken in
                return try SdkJSONDecoder.custom.decode(OAuthToken.self, from: data)
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
            .do(onSuccess: { (oauthToken) in
                AUTH.tokenManager.setToken(oauthToken)
            })
    }
    
    /// 기존 토큰을 갱신합니다.
    public func refreshAccessToken(clientId: String = try! KakaoSDKCommon.shared.appKey(),
                                   refreshToken: String? = nil) -> Single<OAuthToken> {
        return API.rx.responseData(.post,
                                Urls.compose(.Kauth, path:Paths.authToken),
                                parameters: ["grant_type":"refresh_token",
                                             "client_id":clientId,
                                             "refresh_token":refreshToken ?? AUTH.tokenManager.getToken()?.refreshToken,
                                             "ios_bundle_id":Bundle.main.bundleIdentifier].filterNil(),
                                sessionType:.RxAuthApi)
            .compose(API.rx.checkKAuthErrorComposeTransformer())
            .map({ (response, data) -> OAuthToken in
                let newToken = try SdkJSONDecoder.custom.decode(Token.self, from: data)
                
                //oauthtoken 객체가 없으면 에러가 나야함.
                guard let oldOAuthToken = AUTH.tokenManager.getToken() else { throw SdkError(reason: .TokenNotFound) }
                
                var newRefreshToken: String {
                    if let refreshToken = newToken.refreshToken {
                        return refreshToken
                    }
                    else {
                        return oldOAuthToken.refreshToken
                    }
                }
                
                var newRefreshTokenExpiresIn : TimeInterval {
                    if let refreshTokenExpiresIn = newToken.refreshTokenExpiresIn {
                        return refreshTokenExpiresIn
                    }
                    else {
                        return oldOAuthToken.refreshTokenExpiresIn
                    }
                }
                
                let oauthToken = OAuthToken(accessToken: newToken.accessToken,
                                            expiresIn: newToken.expiresIn,
                                            tokenType: newToken.tokenType,
                                            refreshToken: newRefreshToken,
                                            refreshTokenExpiresIn: newRefreshTokenExpiresIn,
                                            scope: newToken.scope,
                                            scopes: newToken.scopes)
                return oauthToken
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
            .do(onSuccess: { (oauthToken) in
                AUTH.tokenManager.setToken(oauthToken)
            })
    }
}
