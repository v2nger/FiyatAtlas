// offline_first_policy.md

/*
 * OFFLINE-FIRST POLICY & ARCHITECTURE
 * 
 * 1. Single Source of Truth: Isar (Local DB)
 *    - All write operations MUST commit to Isar first.
 *    - UI reads data primarily from Isar or generic Repository Interfaces, never directly from Firestore.
 * 
 * 2. Sync Strategy
 *    - Write: Isar -> (Background Sync) -> Firestore
 *    - Success Definition: If Isar write succeeds, the user operation is "Successful".
 *    - Connectivity: Network failures during write are swallowed by the Repository layer 
 *      and handled by the SyncManager via a "pending" status.
 * 
 * 3. Confidence & Verification
 *    - Frontend: Dumb Data Collector. It knows nothing about trust.
 *    - Backend: Cloud Functions calculate confidence scores.
 *    - Reason: Prevents hacked clients from injecting "verified" prices.
 *    - Flow: User submits Log -> Cloud Function triggers -> Verification Logic -> writes 'VerifiedPrice'.
 * 
 * 4. Anti-Abuse
 *    - Local guards prevent rapid-fire submissions (rate limiting).
 *    - Device fingerprints (not implemented in MVP but planned) strictly limit per-device votes.
 * 
 * 5. State Management
 *    - Riverpod is the sole DI and State management solution.
 *    - No legacy Provider or GetIt usage allowed.
 */
