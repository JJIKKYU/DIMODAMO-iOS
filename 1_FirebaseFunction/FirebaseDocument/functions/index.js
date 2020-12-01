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
    .onCreate((snap, context) => {
        const newValue = snap.data();

        const commentId = context.params.comment_id;
        const postId = newValue.post_id;

        console.log(postId + ": postID입니다.");
        console.log(commentId + " : commentID입니다.");

        const postDocRef = admin.firestore().collection('hongik/article/posts').doc(postId);
        return postDocRef.get().then(snap => {
            const commentCount = snap.data().comment_count + 1;
            console.log("수정될 코멘트 카운트 : " + commentCount);

            return postDocRef.update( {comment_count : commentCount});
        })
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