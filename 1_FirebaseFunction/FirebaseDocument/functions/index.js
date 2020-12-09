const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

// exports.documentCommentCounter = functions.firestore
//     .document('hongik/article/comment/{commentId}')
//     .onCreate(event => {
//         const commentId = event.params.commentId;
//         const postId = event.params.post_id;
//         const userId = event.params.user_id;

//         const docRef = admin.firestore().collection('hongik/article/posts').doc(postId);

//         return docRef.get().then(snap => {

//             const commentCount = snap.data().comment_count + 1;

//             const data = { commentCount }

//             return docRef.update(data)
//         })
//     });

// Article (디모아 아트보드) 에 댓글달 경우에 카운트 증가
exports.documentCommentCounter_artboard = functions.firestore
    .document('hongik/article/comments/{comment_id}')
    .onCreate(async (snap, context) => {
        try {
            const newValue = snap.data();

            // 작성한 댓글 UID
            const commentId = context.params.comment_id;
            // 댓글 작성자 닉네임
            const commentNickname = newValue.nickname;
            // 댓글 내용
            const commentDesc = newValue.comment
            // 댓글이 달린 게시글 UID
            const postId = newValue.post_id;

    
            console.log(postId + ": postID입니다.");
            console.log(commentId + " : commentID입니다.");
    
            const postDocRefSnapshot = await admin.firestore().collection('hongik/article/posts').doc(postId).get();
            const data = postDocRefSnapshot.data();

            // 작성자 UID -> 알림 보내야할 목표 대상
            const postUserId = data.user_id;
            console.log("postUserID : " + postUserId);
            console.log("수정될 코멘트 카운트 : " + (data.comment_count + 1));

            // 댓글 작성자와 게시글 작성자가 같지 않을 때만 알림 가도록
            if (postUserId !== commentId) {
                // 작성자의 FCM 토큰을 불러옴
                const fcmIdDocRefSnapshot = await admin.firestore().collection('FcmId').doc(postUserId).get();
                const fcmIdData = fcmIdDocRefSnapshot.data();
                console.log("fcmIdData : " + fcmIdData);
                // 정상적으로 FCM 토큰을 가지고 왔을 때만 알림을 보내도록 설정
                if (fcmIdData) {
                    
                    const fcmToken = fcmIdData.FCM;
                    console.log("fcmToken : " + fcmToken);
    
                    // 알림 내용
                    const payload = {
                        notification: {
                        title: '작성하신 글에 새 댓글이 달렸습니다!',
                        body: `${commentNickname} : ${commentDesc}`
                        }
                    };
    
                    // 알림 발송
                    const response = await admin.messaging().sendToDevice(fcmToken, payload);
                }
            }

            // 게시글 코멘트 +1
            admin.firestore().collection('hongik/article/posts').doc(postId).update( {comment_count : data.comment_count + 1});

        } catch (error) {
            console.log("Error : ", error);
        }
    });

// Information (디모레이어) 에 댓글달 경우에 카운트 증가
exports.documentCommentCounter_layer = functions.firestore
    .document('hongik/information/comments/{comment_id}')
    .onCreate(async (snap, context) => {
        try {
            const newValue = snap.data();

            // 작성한 댓글 UID
            const commentId = context.params.comment_id;
            // 댓글 작성자 닉네임
            const commentNickname = newValue.nickname;
            // 댓글 내용
            const commentDesc = newValue.comment
            // 댓글이 달린 게시글 UID
            const postId = newValue.post_id;

    
            console.log(postId + ": postID입니다.");
            console.log(commentId + " : commentID입니다.");
    
            const postDocRefSnapshot = await admin.firestore().collection('hongik/information/posts').doc(postId).get();
            const data = postDocRefSnapshot.data();

            // 작성자 UID -> 알림 보내야할 목표 대상
            const postUserId = data.user_id;
            console.log("postUserID : " + postUserId);
            console.log("수정될 코멘트 카운트 : " + (data.comment_count + 1));

            // 댓글 작성자와 게시글 작성자가 같지 않을 때만 알림 가도록
            if (postUserId !== commentId) {
                // 작성자의 FCM 토큰을 불러옴
                const fcmIdDocRefSnapshot = await admin.firestore().collection('FcmId').doc(postUserId).get();
                const fcmIdData = fcmIdDocRefSnapshot.data();
                console.log("fcmIdData : " + fcmIdData);
                // 정상적으로 FCM 토큰을 가지고 왔을 때만 알림을 보내도록 설정
                if (fcmIdData) {
                    
                    const fcmToken = fcmIdData.FCM;
                    console.log("fcmToken : " + fcmToken);
    
                    // 알림 내용
                    const payload = {
                        notification: {
                        title: '작성하신 글에 새 댓글이 달렸습니다!',
                        body: `${commentNickname} : ${commentDesc}`
                        }
                    };
    
                    // 알림 발송
                    const response = await admin.messaging().sendToDevice(fcmToken, payload);
                }
            }

            // 게시글 코멘트 +1
            admin.firestore().collection('hongik/information/posts').doc(postId).update( {comment_count : data.comment_count + 1});

        } catch (error) {
            console.log("Error : ", error);
        }
    });


// 신고당할때 카운트 증가
exports.documentCommentCounter_layer = functions.firestore
.document('report/{report_id}')
.onCreate(async (snap, context) => {
    try {
        const newValue = snap.data();

        // 레포트 doc id
        const reportId = context.params.report_id;
        // 신고 대상 게시판
        const targetBoard = newValue.target_board;
        // 신고 대상 UID
        const targetId = newValue.target_id;
        // 신고한 대상이 게시글(post)인지 코멘트(comment)인지 유저(user)인지
        const targetType = newValue.target_type
        // 신고 대상 유저 UID
        const targetUserId = newValue.target_user_id;

        console.log(targetBoard + ": targetBoard입니다.");
        console.log(targetType + " : targetType입니다.");

        // 신고 타입이 post일 경우
        if (targetType === "post") {
            const postDocRefSnapshot = await admin.firestore().collection('hongik/'+ targetBoard +'/posts').doc(targetId).get();
            const data = postDocRefSnapshot.data();
            const reportCount = Number(data.report + 1)
            console.log("레포트 전 : " + (data.report) + "레포트 후 : " + Number(data.report + 1));
            admin.firestore().collection('hongik/' + targetBoard + '/posts').doc(targetId).update( {report : reportCount});
        }

    } catch (error) {
        console.log("Error : ", error);
    }
});