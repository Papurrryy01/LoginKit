# LoginKit

Created by Carlos Vera.

A SwiftUI login exercise for iOS, macOS, and visionOS. Demo credentials: `test@mail.com` / `test1234`.

## Behavior

- Login requires a nonblank email and a password; repeated submissions are ignored while loading.
- The eye button shows or hides the password.
- Three invalid credential attempts disable login for 30 seconds, then automatically allow retry. This is an in-memory demonstration lockout, reset by restarting the app.
- Remember Me persists only the email. Passwords are cleared on logout and never saved.
- Authentication and dashboard readiness use simulated variable delays.

## Tests

Run Product > Test in Xcode with an iPhone simulator selected. Swift Testing covers validation, lockout and recovery, persistence, cancellation, and concurrent requests. UI tests cover login, errors, logout, validation, password visibility, and remembered email across relaunch.

UI tests use `-UITesting-Reset` to clear saved email before each test and `-UITesting-NoAnimations` to disable animations and the dashboard entrance delay. The persistence test removes only the reset flag for its second launch. Helpers wait for controls to exist, be enabled, and be hittable before interaction.

## Continuous integration

`.github/workflows/ios-ci.yml` runs the project tests on push and pull requests to `main`, or manually through GitHub Actions. It uses the GitHub-hosted `xcode-27` image, selects an available iPhone simulator, runs tests serially, and uploads the result bundle. A remote CI run requires pushing this workflow to your repository.
