# Firestore Backend Design

## Overview
FiyatAtlas uses Cloud Firestore as its primary NoSQL database. Below is the schema design for the core collections.

## Collections

### 1. `users`
Stores user profile information, gamification stats, and authentication metadata.

- **Document ID**: `uid` (from Firebase Auth)
- **Fields**:
  - `name` (string): Display name.
  - `email` (string): Email address.
  - `avatarUrl` (string): Profile picture URL.
  - `points` (number): User's trust score/gamification points.
  - `rank` (string): Title based on points (e.g., "Gezgin", "Kaşif").
  - `entryCount` (number): Total number of prices contributed.
  - `joinDate` (timestamp): Account creation date.
  - `earnedBadgeIds` (array<string>): List of badge IDs owned by the user.

### 2. `products`
Stores immutable product data (barcodes, names, brands).

- **Document ID**: `barcode` (e.g., "8690000000012")
- **Fields**:
  - `barcode` (string): Unique identifier.
  - `name` (string): Product name.
  - `brand` (string): Brand name.
  - `category` (string): Product category (e.g., "Süt ve Kahvaltılık").
  - `imageUrl` (string, optional): Product image URL.
  - `updatedAt` (timestamp): Last time metadata was updated.

### 3. `markets`
Stores market branches and location data.

- **Document ID**: `marketBranchId` (UUID) or Auto-ID
- **Fields**:
  - `chainName` (string): e.g., "BİM", "A101".
  - `branchName` (string): e.g., "Kadıköy Merkez".
  - `location` (GeoPoint): Latitude/Longitude.
  - `district` (string): Administrative district.
  - `city` (string): City.
  - `address` (string): Full address line.

### 4. `price_logs` (Raw Entries)
Stores every single price entry submission by users. This is the "Audit Trail".

- **Document ID**: Auto-ID
- **Fields**:
  - `userId` (string): Reference to `users/{uid}`.
  - `barcode` (string): Reference to `products/{barcode}`.
  - `marketBranchId` (string): Reference to `markets/{id}`.
  - `price` (number): The reported price.
  - `currency` (string): e.g., "TRY".
  - `hasReceipt` (boolean): Whether a receipt photo was uploaded.
  - `receiptImageUrl` (string, optional): URL to the receipt image.
  - `entryDate` (timestamp): When the price was logged.
  - `status` (string): `pendingPrivate` | `awaitingConsensus` | `verifiedPublic`.
  - `confidenceScore` (number): Calculated trust score (0-100).

### 5. `verified_prices` (Aggregated View)
Stores the current *active* and *verified* price for a product at a specific market. Used for fast reading and display on maps/lists.

- **Document ID**: Composite `barcode_marketBranchId`
- **Fields**:
  - `barcode` (string)
  - `marketBranchId` (string)
  - `price` (number): The confirmed price.
  - `lastVerifiedAt` (timestamp): Date of the entry that confirmed this price.
  - `reportedBy` (string): ID of the user who provided the verified price (or "consensus").
  - `entryCount` (number): How many people confirmed this price recently.

---

## Security Rules (Brief)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can only read public profiles and write their own
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Products are readable by all, writable only by trusted users/admin
    match /products/{document=**} {
      allow read: if true;
      allow write: if request.auth != null; // Refine later
    }
    
    // Price logs can be created by authenticated users
    match /price_logs/{logId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null;
      // Update only by admin or server-side functions (Confidence Engine)
    }
  }
}
```
