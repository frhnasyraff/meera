# Private access setup

Google sign-in is enabled, the Netlify domain is authorized, and private
Firestore rules are deployed for the two approved accounts. The website also
needs the login-enabled Git deployment before users can sign in.

## Configure the two accounts

1. Put the two Google account email addresses in local `private-access.json`
   (ignored by Git), using `{ "allowedEmails": ["first@example.com", "second@example.com"] }`.
2. Run `node scripts/build-private-access.cjs`. This generates both the browser
   allowlist and `firestore.rules` from the same source. Published files contain
   SHA-256 identifiers instead of plaintext email addresses; this does not replace
   Firebase verification or make guessable addresses impossible to identify.
3. In Firebase project `meerandpaan`, open Authentication, get started if needed,
   and enable the Google sign-in provider. Select the project's support email.
4. In Authentication settings, add `meerandpaan.netlify.app` to Authorized domains.
   Add a custom domain too if one is used. For development, authorize `localhost`.
5. Deploy the rules with:

   ```sh
   firebase deploy --only firestore:rules --project meerandpaan
   ```

6. Push the website changes and wait for the Netlify deployment.
7. Test the hosted HTTPS link: signed out, an unlisted Google account, and each
   allowed Google account. Only the two listed accounts should load gallery data.
   Test login and logout on the actual iPhone Home Screen app as well.

Rules allow verified Google accounts on the list to access only the albums,
photos, trips and songs collections. Other collections and nested subcollections
are denied. UI checks complement the deployed rules; they do not replace them.

Do not ship the new page while leaving the previous public rules in place.
Deploying rules first will temporarily block the previous page's anonymous data
reads until the login-enabled page is deployed.

The historical `full-site-backup.html` route redirects to the protected entry
point on Netlify via `_redirects`.

## Cloudinary media remains public

Existing images and videos use public Cloudinary delivery URLs. Firebase login
and Firestore Rules do not revoke those URLs. The unsigned upload preset also
remains usable outside this page; the browser's login check cannot secure it.

Full media protection needs a separate server-side change: authenticated assets,
Firebase ID-token verification, signed uploads, and authorized delivery URLs.
Cloudinary's API secret must only be stored in server environment variables.
Existing assets and stored URLs need a coordinated migration before public
delivery and the unsigned preset are disabled. Do not disable them now, since
that would break the current gallery and uploads.

References:
- https://firebase.google.com/docs/auth/web/google-signin
- https://firebase.google.com/docs/rules/rules-and-auth
- https://cloudinary.com/documentation/control_access_to_media
