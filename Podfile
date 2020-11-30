# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
end

target 'dimodamo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for dimodamo
  pod 'Alamofire', '~> 5.2'
  
  pod 'lottie-ios'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewController'

  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Messaging'
  
  pod 'Kingfisher', '~> 5.0'
  
  # 링크 첨부할 때 가져오는 정보
  pod 'SwiftLinkPreview', '~> 3.2.0'
  
  pod 'LayoutHelper'
  
  # 글 작성할 때 태그 관련
  pod 'Tagging'
  
  # For Swift 5 use: 슬라이드 메뉴용
  pod 'SideMenu', '~> 6.0'
  
  # Alert / 글 쓸 때 밑에서 링크 추가할 때 사용
  pod 'STPopup'

  # 키보드
  pod 'IQKeyboardManagerSwift'
  
  # 구글 광고
  pod 'Google-Mobile-Ads-SDK'

  # Json
  pod 'SwiftyJSON', '~> 4.0'

  # 검색
  pod 'AlgoliaSearchClient', '~> 8.2'
  
  # 드롭다운 메뉴
  pod 'YNDropDownMenu'
  pod 'McPicker', '~> 3.0.0'
  
  # 검색
  pod 'YNSearch'
  
  # 데이터베이스
  pod 'RealmSwift'
  
end
