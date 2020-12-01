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

            // 작성자의 FCM 토큰을 불러옴
            const fcmIdDocRefSnapshot = await admin.firestore().collection('FcmId').doc(postUserId).get();
            const fcmIdData = fcmIdDocRefSnapshot.data();
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

            // 게시글 코멘트 +1
            admin.firestore().collection('hongik/article/posts').doc(postId).update( {comment_count : data.comment_count + 1});

        } catch (error) {
            console.log("Error : ", error);
        }
    });

// Information (디모레이어) 에 댓글달 경우에 카운트 증가
exports.documentCommentCounter_layer = functions.firestore
.document('hongik/information/comments/{comment_id}')
.onCreate((snap, context) => {
    const newValue = snap.data();

    const commentId = context.params.comment_id;
    const postId = newValue.post_id;

    console.log(postId + ": postID입니다.");
    console.log(commentId + " : commentID입니다.");

    const postDocRef = admin.firestore().collection('hongik/information/posts').doc(postId);
    return postDocRef.get().then(snap => {
        const commentCount = snap.data().comment_count + 1;
        console.log("수정될 코멘트 카운트 : " + commentCount);

        return postDocRef.update( {comment_count : commentCount});
    })
});