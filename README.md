# BookSeeker 📚

IT 도서 검색 및 상세 정보 조회 앱

## 📱 앱 소개

BookSeeker는 IT Book Store API를 활용하여 기술 서적을 검색하고 상세 정보를 확인할 수 있는 iOS 애플리케이션입니다.

### 주요 기능

- 📖 **도서 검색**: 키워드로 IT 도서 검색 (디바운싱 적용)
- 📄 **무한 스크롤**: 페이지네이션을 통한 검색 결과 로드
- 🔍 **상세 정보**: 책 제목, 저자, 출판사, ISBN, 가격, 설명 등 확인
- 🖼️ **이미지 캐싱**: 메모리 캐싱을 통한 빠른 이미지 로딩
- 🌐 **외부 링크**: IT Book Store 웹사이트로 이동

## 🏗️ 아키텍처

Clean Architecture를 기반으로 설계되었습니다.

```
BookSeeker/
├── Domain/                      # 비즈니스 로직
│   ├── Entity/                  # 도메인 엔티티
│   │   ├── BookEntity.swift
│   │   └── SearchResultEntity.swift
│   ├── SearchRepository.swift   # Repository
│   └── SearchUseCase.swift      # UseCase
│
├── Data/                        # 외부 데이터 처리
│   ├── Network/                 # Network
│   │   ├── APIService.swift     # API 통신
│   │   └── ImageManager.swift   # 이미지 다운로드 & 캐싱
│   ├── BookResponse.swift       # DTO
│   └── SearchResponse.swift     # DTO
│
├── Presentation/
│   ├── Search/                  # 검색 화면
│   │   └── SearchMainViewController.swift
│   └── Book/                    # 상세 화면
│       ├── BookDetailViewController.swift
│       └── BookTableViewCell.swift
│
└── Delegate/
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```

## 🌐 API

[IT Bookstore API](https://api.itbook.store/)를 사용합니다.

- **검색 API**: `GET /1.0/search/{query}/{page}`
- **상세 조회**: `GET /1.0/books/{isbn13}`

## 📦 Requirements

- iOS 16.0+
- Swift 5.0+

## 👤 Author

**강지우**

## 📄 License

이 프로젝트는 개인 학습 목적으로 만들어졌습니다.
