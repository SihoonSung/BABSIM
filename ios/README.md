# BABSIM iOS (밥심)

SwiftUI + SwiftData 기반 로컬 전용 앱. 서버/로그인 없음.

## 실행 방법
1. Xcode 16 이상에서 `Babsim.xcodeproj` 열기
2. Signing & Capabilities에서 Team 선택 (bundle id `com.sihoon.babsim`는 필요시 변경)
3. 아이폰 연결 후 Run

## 구조
- `Babsim/Models` — SwiftData 모델 (Recipe, RecipeIngredient, FridgeItem, CookLog) + 최초 실행 시 seed 임포트
- `Babsim/Core` — 추천 로직(Recommender), 재료 마스터(IngredientCatalog)
- `Babsim/Features` — 홈 / 냉장고 / 레시피(목록·상세·등록폼) / 마이
- `Babsim/Resources/seed_data.json` — 기존 백엔드 seed에서 변환한 레시피 41개 + 재료 마스터 132개

## 나중에 할 것
- 재료 사진 인식: AddIngredientSheet의 "사진으로 재료 인식" 자리에 Vision/CoreML on-device 모델 연결 (API 과금 없음)
