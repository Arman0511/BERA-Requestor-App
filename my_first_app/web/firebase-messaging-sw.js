importScripts('https://www.gstatic.com/firebasejs/9.1.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.1.2/firebase-messaging.js');


firebase.initializeApp({
  apiKey: "AIzaSyDki0tWKKFDaasfd2Cu5nqy8AacSYjRVUE",
  authDomain: "bera-7e072.firebaseapp.com",
  projectId: "bera-7e072",
  storageBucket: "bera-7e072.appspot.com",
  messagingSenderId: "712554653780",
  appId: "1:712554653780:web:937e03becbb5fabef165c1",
  measurementId: "G-WEXRPCM3KV"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});