import SwiftUI

struct SwiftUIFocusTestView: View {
    let posts: [Post] = PostData.sampleData
    
    // 1. 상태 변수 정의 (초점용)
    @State private var lastFocusedID: Int?
    @AccessibilityFocusState private var focus: Int?
    
    var body: some View {
        List {
            ForEach(posts) { post in
                PostRowView(post: post, lastFocusedID: $lastFocusedID)
                    // 리스트의 기본 선택 스타일 제거를 위해 빈 버튼 스타일 적용
                    .buttonStyle(PlainButtonStyle())
                    // 2. 초점 연결: post.id를 기준으로 초점 매핑
                    .accessibilityFocused($focus, equals: post.id)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("SwiftUI 초점 테스트")
        .navigationBarTitleDisplayMode(.inline)
        // 3. 화면 복귀 시 초점 복구
        .onAppear {
            if let lastID = lastFocusedID {
                // 1.0초 지연 후 복구
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    focus = lastID
                }
            }
        }
    }
}

struct PostRowView: View {
    let post: Post
    // 상위 뷰의 마지막 포커스 ID를 업데이트하기 위한 바인딩
    @Binding var lastFocusedID: Int?
    @State private var isDetailActive = false
    
    // 커스텀 바인딩: 네비게이션이 활성화될 때 ID를 저장
    private var detailActiveBinding: Binding<Bool> {
        Binding(
            get: { isDetailActive },
            set: { newValue in
                if newValue {
                    // 화면 진입 시 ID 저장
                    lastFocusedID = post.id
                }
                isDetailActive = newValue
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단: 카테고리, 제목, 화살표 버튼
            HStack(alignment: .top, spacing: 8) {
                Text("[\(post.category)]")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("카테고리: \(post.category)")
                
                Text(post.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .layoutPriority(1)
                    .accessibilityLabel("제목: \(post.title)")
                
                Spacer()
                
                // 화살표 버튼 (이 버튼을 눌러야만 이동)
                Button(action: {
                    lastFocusedID = post.id // 버튼 액션으로도 확실하게 ID 저장
                    isDetailActive = true
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(8) // 터치 영역 확보
                        .contentShape(Rectangle())
                }
                .accessibilityHidden(true)
                // 숨겨진 네비게이션 링크 트리거
                .background(
                    NavigationLink(destination: PostDetailView(post: post), isActive: detailActiveBinding) {
                        EmptyView()
                    }
                    .hidden()
                )
            }
            
            // 하단: 작성자, 조회수, 댓글수
            HStack(spacing: 12) {
                Text(post.author)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .accessibilityLabel("작성자: \(post.author)")
                
                HStack(spacing: 4) {
                    Image(systemName: "eye")
                        .font(.caption2)
                    Text(post.viewCount)
                        .font(.caption)
                }
                .foregroundColor(.gray)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("조회수 \(post.viewCount)")
                
                HStack(spacing: 4) {
                    Image(systemName: "message")
                        .font(.caption2)
                    Text("\(post.commentCount)")
                        .font(.caption)
                }
                .foregroundColor(.gray)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("댓글수 \(post.commentCount)")
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        // 보이스오버 더블탭 액션
        .accessibilityAction(.default) {
            lastFocusedID = post.id // 액션 실행 시에도 ID 저장
            isDetailActive = true
        }
    }
}

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        VStack(spacing: 20) {
            Text("게시글 상세입니다")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(post.title)
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

struct SwiftUIFocusTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiftUIFocusTestView()
        }
    }
}
