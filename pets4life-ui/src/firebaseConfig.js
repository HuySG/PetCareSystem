import { initializeApp } from "firebase/app";
import { getStorage } from "firebase/storage";
 
// Initialize Firebase
const app = initializeApp ({
    apiKey: "AIzaSyAZH1ntw11eyRTzJBJwP4CljfUlUgp-ae0",
    authDomain: "upload-pets4life.firebaseapp.com",
    projectId: "upload-pets4life",
    storageBucket: "upload-pets4life.appspot.com",
    messagingSenderId: "850918154320",
    appId: "1:850918154320:web:79188090aeaf8a09ac7155"
});
 
// Firebase storage reference
const storage = getStorage(app);
export default storage;