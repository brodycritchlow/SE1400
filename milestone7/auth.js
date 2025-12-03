const googleSignInBtn = document.getElementById('google-signin');

if (googleSignInBtn) {
    googleSignInBtn.addEventListener('click', async () => {
        const provider = new firebase.auth.GoogleAuthProvider();
        try {
            await auth.signInWithPopup(provider);
            window.location.href = 'index.html';
        } catch (error) {
            console.error(error);
        }
    });
}

auth.onAuthStateChanged((user) => {
    if (user && window.location.pathname.includes('signin.html')) {
        window.location.href = 'index.html';
    }
});
