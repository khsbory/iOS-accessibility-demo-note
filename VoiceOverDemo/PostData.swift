import Foundation

struct Post: Identifiable {
    let id: Int
    let category: String
    let title: String
    let author: String
    let viewCount: String // Int로 받을 수도 있지만, 콤마 포맷팅 편의를 위해 String으로 처리
    let commentCount: Int
}

struct PostData {
    static let sampleData: [Post] = [
        Post(id: 1, category: "잡담", title: "아 진짜 오늘 날씨 갑자기 비 오는 거 실화냐? ㅠㅠ 우산 없는데", author: "비오네", viewCount: "1,205", commentCount: 34),
        Post(id: 2, category: "질문", title: "점심 메뉴 추천 좀 부탁드려요 (결정장애 옴..)", author: "배고파", viewCount: "542", commentCount: 12),
        Post(id: 3, category: "고민", title: "3년 사귄 여친이랑 헤어졌는데 새벽에 연락해도 될까", author: "익명", viewCount: "3,421", commentCount: 128),
        Post(id: 4, category: "후기", title: "다이소 자취 꿀템 추천합니다. 이거 보이면 무조건 집으세요", author: "프로자취러", viewCount: "8,902", commentCount: 56),
        Post(id: 5, category: "잡담", title: "하... 월요일 출근하기 싫다. 주말 순삭 당함;;", author: "직장인A", viewCount: "445", commentCount: 8),
        Post(id: 6, category: "정보", title: "이번 달 편의점 1+1 행사 정리해드림 (스압주의)", author: "할인요정", viewCount: "12,301", commentCount: 92),
        Post(id: 7, category: "질문", title: "윗집 층간소음 때문에 미치겠는데 쪽지 붙여도 법적으로 문제없나요?", author: "예민보스", viewCount: "2,100", commentCount: 45),
        Post(id: 8, category: "잡담", title: "다들 저녁 뭐 드셨나요? 야식으로 치킨 시킬까 고민 중", author: "치느님영접", viewCount: "678", commentCount: 19),
        Post(id: 9, category: "후기", title: "넷플릭스 신작 드라마 주말에 정주행 완료한 후기 (스포X)", author: "무비무비", viewCount: "1,560", commentCount: 23),
        Post(id: 10, category: "고민", title: "이직 고민입니다... 연봉 300 낮추고 워라밸 챙기기 vs 그냥 존버", author: "갈팡질팡", viewCount: "5,670", commentCount: 88)
    ]
}
