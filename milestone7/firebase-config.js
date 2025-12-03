const firebaseConfig = {
    apiKey: "AIzaSyC1kW1LDVsjimEpMNiVOBSpfNA60cy59sk",
    authDomain: "daisy-45ae0.firebaseapp.com",
    projectId: "daisy-45ae0",
    storageBucket: "daisy-45ae0.firebasestorage.app",
    messagingSenderId: "495686144748",
    appId: "1:495686144748:web:42b3292ef0422373da0bc9",
    measurementId: "G-BRF22HDJPQ"
};

firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();

auth.onAuthStateChanged((user) => {
    const authButton = document.getElementById('auth-button');
    const userDisplay = document.getElementById('user-display');

    if (user) {
        if (authButton) {
            authButton.textContent = 'Sign Out';
            authButton.onclick = signOut;
        }
        if (userDisplay) {
            userDisplay.textContent = user.email || 'User';
            userDisplay.style.display = 'inline';
        }
        console.log('User signed in:', user.email);
    } else {
        if (authButton) {
            authButton.textContent = 'Sign In';
            authButton.onclick = () => window.location.href = 'signin.html';
        }
        if (userDisplay) {
            userDisplay.style.display = 'none';
        }
        console.log('User signed out');
    }
});

function signOut() {
    auth.signOut().then(() => {
        console.log('User signed out successfully');
        window.location.href = 'index.html';
    }).catch((error) => {
        console.error('Sign out error:', error);
    });
}
