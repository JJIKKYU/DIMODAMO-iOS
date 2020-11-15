/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


exports.createUser = functions.firestore
    .document('hongik/article/comments/{commentUid}')
    .onCreate( (snap, context) => {
      
      const newValue = snap.data();

      const user_uid = newValue.user_id;  // 댓글의 작성자
      const post_uid = newValue.post_id;  // 댓글을 작성한 포스트
      const nickname = newValue.nickname; // 댓글을 작성한 사람의 닉네임
      const comment = newValue.comment;   // 댓글 본문

      // const getDeviceTokenPromise = admin.firestore.document('users/',{user_uid}).once('value'); // 디바이스 토큰을 찾습니다.
      // const getPostUserIdPromise = admin.firestore.document('hongik/article/posts/${post_uid}'); // 포스트의 uid를 찾습니다.
      // const results = Promise.all([getDeviceTokenPromise]);
      // let deviceToken;
      // deviceToken = results[0];
      // let postUserId = results[1];

      // perform desired operations ...

      console.log("asdasdasd");

      // This registration token comes from the client FCM SDKs.
      var registrationToken = 'eQJPZjDLRkpgsgxF-gRnwQ:APA91bHCsez6xLoBHAv2W7shM14PjynWfBmet0g7gjdedaX4-kc9WiZM9riawxg_VI8r9U8WrmY-MRshXbJdN5mHxcGsyFpZ_8akUx2x5tEbSLjWHbOB9aJHekYxHR4KpbVTxEjqD-yZ';

      const payload = {
        notification: {
          title: '작성하신 글에 댓글이 달렸습니다!',
          body: `${nickname} : ${user_uid}`
        }
      };

      // Send a message to the device corresponding to the provided
      // registration token.
      admin.messaging().sendToDevice(registrationToken ,payload);

      // perform desired operations ...
    });

/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */

// database.ref('/followers/{followedUid}/{followerUid}')
exports.sendFollowerNotification = functions.database.ref('/followers/{followedUid}/{followerUid}')
// exports.sendFollowerNotification = functions.firestore.document('hongik/article/comments')
    .onWrite(async (change, context) => {
      const followerUid = context.params.followerUid;
      const followedUid = context.params.followedUid;
      // If un-follow we exit the function.
      if (!change.after.val()) {
        return console.log('User ', followerUid, 'un-followed user', followedUid);
      }
      console.log('We have a new follower UID:', followerUid, 'for user:', followedUid);

      // Get the list of device notification tokens.
      const getDeviceTokensPromise = admin.database()
          .ref(`/users/${followedUid}/notificationTokens`).once('value');

      // Get the follower profile.
      const getFollowerProfilePromise = admin.auth().getUser(followerUid);

      // The snapshot to the user's tokens.
      let tokensSnapshot;

      // The array containing all the user's tokens.
      let tokens;

      const results = await Promise.all([getDeviceTokensPromise, getFollowerProfilePromise]);
      tokensSnapshot = results[0];
      const follower = results[1];

      // Check if there are any device tokens.
      if (!tokensSnapshot.hasChildren()) {
        return console.log('There are no notification tokens to send to.');
      }
      console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
      console.log('Fetched follower profile', follower);

      // Notification details.
      const payload = {
        notification: {
          title: 'You have a new follower!',
          body: `${follower.displayName} is now following you.`,
          icon: follower.photoURL
        }
      };

      // Listing all tokens as an array.
      tokens = Object.keys(tokensSnapshot.val());
      // tokens = "fIsKyWAUNUbkpBxH9KxK2Y:APA91bH7WFMujXo6EM74C04lc4EZ391cqRHiqAfTSLLaCD2ZJsi71y_mfoOmzGpzYFESRXNZkEPBep88PDlN1QV91qqXmbfoFKkg1leNua8Ldo9iDDm4hkixcrJWNoKP332rhbiWCwLL"
      // Send notifications to all tokens.
      const response = await admin.messaging().sendToDevice(tokens, payload);
      // For each message check if there was an error.
      const tokensToRemove = [];
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          console.error('Failure sending notification to', tokens[index], error);
          // Cleanup the tokens who are not registered anymore.
          if (error.code === 'messaging/invalid-registration-token' ||
              error.code === 'messaging/registration-token-not-registered') {
            tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
          }
        }
      });
      return Promise.all(tokensToRemove);
    });
