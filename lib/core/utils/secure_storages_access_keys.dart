String masterKeySaltSecureStorageAccessKey(String profileId) =>
    '${profileId}_master_key_salt';

String masterKeyHashSecureStorageAccessKey(String profileId) =>
    '${profileId}_master_key_hash';

String encryptionKeySaltSecureStorageAccessKey(String profileId) =>
    '${profileId}_encryption_key_salt';
