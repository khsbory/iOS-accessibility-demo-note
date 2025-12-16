import SwiftUI

struct SwiftUIFocusTestView: View {
    let posts: [Post] = PostData.sampleData
    
    var body: some View {
        List {
            ForEach(posts) { post in
                PostRowView(post: post)
                    // 리스트의 기본 선택 스타일 제거를 위해 빈 버튼 스타일 적용
                    .buttonStyle(PlainButtonStyle()) 
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("SwiftUI 초점 테스트")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PostRowView: View {
    let post: Post
    @State private var isDetailActive = false
    
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
                    isDetailActive = true
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(8) // 터치 영역 확보
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("게시글 상세 보기")
                .accessibilityHint("이동하려면 이중 탭하세요")
                // 숨겨진 네비게이션 링크 트리거
                .background(
                    NavigationLink(destination: PostDetailView(post: post), isActive: $isDetailActive) {
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

                .accessibilityLabel("조회수 \(post.viewCount)")
                
                HStack(spacing: 4) {
                    Image(systemName: "message")
                        .font(.caption2)
                    Text("\(post.commentCount)")
                        .font(.caption)
                }
                .foregroundColor(.gray)

                .accessibilityLabel("댓글수 \(post.commentCount)")
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(.default) {
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
