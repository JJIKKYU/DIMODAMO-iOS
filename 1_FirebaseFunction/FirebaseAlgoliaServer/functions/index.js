const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = "N13Z39TVCC";
const ALGOLIA_ADMIN_KEY = "a61ca167a4f8cd2463ce8d0d886c2f65";
const ALGOLIA_INDEX_NAME = "hongik_users";

admin.initializeApp(functions.config().firebase);

exports.firestoreToAlgolia = functions.https.onRequest((req, res) => {
    const arr = [];
    admin.firestore().collection('users')
    .where('school', '==', '홍익대학교')
    .get().then(docs => {
        docs.forEach(doc => {
            const verb = doc.data();
            verb.objectID = doc.id;
            arr.push(verb);
        });

        const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        const index =  client.initIndex(ALGOLIA_INDEX_NAME);
        
        index.saveObjects(arr, (err, content) => {
            if (err) res.status(500);
            
            res.status(200).send(content);
        });
    });
});