//
//  DDooingWidget.swift
//  DDooingWidget
//
//  Created by Doran on 5/22/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import Firebase
import AppIntents

struct Provider : TimelineProvider {
    
    // 본격적으로 위젯에 표시될 placeholder
    // 데이터를 불러오기 전(getSnapshot)에 보여줄 placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    // 데이터를 가져와서 표출해주는 getSnapshot
    // 위젯 갤러리에서 위젯을 고를 때 보이는 샘플 데이터를 보여줄때 해당 메소드 호출
    // API를 통해서 데이터를 fetch하여 보여줄때 딜레이가 있는 경우 여기서 샘플 데이터를 하드코딩해서 보여주는 작업도 가능
    // context.isPreview가 true인 경우 위젯 갤러리에 위젯이 표출되는 상태
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        
        completion(entry)
    }
    
    // 타임라인 설정 관련된 getTimeLine
    // 홈화면에 있는 위젯을 언제 업데이트 시킬것인지 구현하는 부분
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)
        // .atEnd: 마지막 date가 끝난 후 타임라인 reloading
       // .after: 다음 data가 지난 후 타임라인 reloading
       // .never: 즉시 타임라인 reloading
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
    
}

// TimelineEntry를 준수하는 구조체
// 위젯을 표시할 Date를 정하고, 그 Date에 표시할 데이터를 나타냄
struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DDooingWidget: Widget {
    
    let kind: String = "DDooingWidget"
    
    // body 안에 사용하는 Configuration
    // IntentConfiguration: 사용자가 위젯에서 Edit을 통해 위젯에 보여지는 내용 변경이 가능
    // StaticConfiguration: 사용자가 변경 불가능한 정적 데이터 표출
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            // 위젯에 표출될 뷰
            DDooingWidgetEntryView(entry: entry).modelContainer(for: MessageModel.self)
        }
        .configurationDisplayName("DDooing Widget")
        .description("This is a DDooing widget.")
    }
}

// struct Widget에서 사용되었듯이 위젯 뷰를 표출
struct DDooingWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Button(intent: SendMessageIntent()){
                Image("WidgetButton")
                    .resizable()
                    .frame(width: 130,height: 118)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .containerBackground((LinearGradient(gradient: Gradient(colors: [Color.widgetTopColor, Color.widgetBottomColor]), startPoint: .top, endPoint: .bottom)), for: .widget)
    }
    
}

class MessagingService {
    @Query private var messages: [MessageModel]
    var partnerUID: String? = nil
    var randomMessages: String = ""
    
    init(partnerUID: String?) {
        self.partnerUID = partnerUID
        self.randomMessages = self.fetchRandomMessage()
    }
    
    func fetchRandomMessage() -> String {
        if let randomMessage = messages.randomElement() {
            return randomMessage.message
        } else {
            return ""
        }
    }
    
    // 비동기적으로 partnerUID를 가져오는 메소드
    func fetchPartnerUIDAsync() async throws -> String {
        guard let currentUser = Auth.auth().currentUser else { throw NSError() }
        let currentUserUID = currentUser.uid
        
        let db = Firestore.firestore()
        
        let document = try await db.collection("Users").document(currentUserUID).getDocument()
        if document.exists {
            if let code = document.data()?["code"] as? String {
                let querySnapshot = try await db.collection("Users").whereField("code", isEqualTo: code).getDocuments()
                let filteredDocuments = querySnapshot.documents.filter { $0.documentID != currentUserUID }
                if let partnerDocument = filteredDocuments.first {
                    self.partnerUID = partnerDocument.documentID
                    return partnerDocument.documentID
                }
            }
        }
        throw NSError()
    }
    

    func saveRandomMessage() {
        guard let partnerUID = partnerUID else { return }
        sendMessage(messageText: randomMessages, isStarred: false)
    }
    
    func sendMessage(messageText: String, isStarred: Bool) {
        let db = Firestore.firestore()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let currentUserRef = db.collection("Received-Messages")
            .document(currentUid).collection(partnerUID ?? "").document()
        
        let partnerRef = db.collection("Received-Messages")
            .document(partnerUID ?? "").collection(currentUid)
        
        let recentPartnerRef = db.collection("Received-Messages")
            .document(partnerUID ?? "").collection("recent-messages")
            .document(currentUid)
        
        let messageId = currentUserRef.documentID
        
        let messageData: [String: Any] = [
            "fromId": currentUid,
            "toId": partnerUID ?? "",
            "messageText": messageText,
            "timeStamp": Timestamp(date: Date()),
            "isStarred": isStarred,
            "messageId": messageId
        ]
        
        // 메시지 데이터를 Firestore에 저장
        partnerRef.document(messageId).setData(messageData)
        recentPartnerRef.setData(messageData)
    }
}

// Intent에서 사용
struct SendMessageIntent: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "DDooing Send Message")
    
    func perform() async throws -> some IntentResult {
        // MessagingService의 인스턴스 생성
        let messagingService = MessagingService(partnerUID: nil)
        
        // 비동기적으로 partnerUID를 설정
        do {
            _ = try await messagingService.fetchPartnerUIDAsync()
            
            let randomMessage = messagingService.fetchRandomMessage()
            
            print(randomMessage)
            // 랜덤 메시지 설정
            messagingService.randomMessages = randomMessage
            // 메시지 보내기
            messagingService.sendMessage(messageText: messagingService.randomMessages, isStarred: false)
            
        } catch {
            // 오류 처리
            print("Partner UID를 가져오는 데 실패했습니다.")
        }
        
        return .result()
    }
}
