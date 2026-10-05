# SOMEA journal platform

Native Flutter plugin providing an app-private journal directory and backup-protection checks. No networking, analytics, account data, journal values, encryption keys or Firebase configuration.

Android uses Context.getNoBackupFilesDir()/somea-journal-v1. iOS uses Application Support/somea-journal-v1 and sets and verifies backup exclusion and complete file protection.

Channel `ge.somea/journal_privacy` provides `protectedDirectory` and `verifyProtection({path})`. Only the owned directory or direct owned ciphertext/generation/temporary/lock filenames are accepted. Failures return generic errors without paths or values.

Consumers must verify protection before writes, after save/rename and before reads. No fallback storage on failure. Encryption, key storage/migration, account authorization and deletion coordination are separate responsibilities. This plugin does not harden Keychain.

Validation: four mocked Flutter channel tests, two Android negative unit tests and Android example debug builds passed. The additional iOS protection readback is source-reviewed only; iOS compilation and physical-device backup/restore testing remain outstanding. This module is not a complete privacy guarantee or a production release of the SOMEA app.

Use a reviewed commit SHA when adding a Git dependency. Never embed access tokens in dependency URLs.

Copyright SOMEA. All rights reserved; public visibility does not grant a reuse license. See LICENSE.
