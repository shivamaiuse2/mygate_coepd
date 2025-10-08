# Database Schema and Selection for MyGate Clone

## Database Selection

### Primary Database: MongoDB

MongoDB is selected as the primary database for the following reasons:

1. **Flexibility**: Document-based structure allows for flexible schema design, which is crucial for a complex application like MyGate with various entity types.
2. **Scalability**: Horizontal scaling capabilities through sharding support large datasets and high traffic.
3. **Performance**: Indexing capabilities and in-memory storage engine provide excellent performance for read-heavy operations.
4. **Developer Productivity**: JSON-like documents align well with JavaScript/Node.js backend, reducing impedance mismatch.
5. **Geospatial Queries**: Built-in support for geospatial queries can be useful for location-based features.
6. **Aggregation Framework**: Powerful aggregation pipeline for complex reporting and analytics.

### Caching Layer: Redis

Redis is used for:
- Session management
- Caching frequently accessed data
- Rate limiting
- Real-time analytics

### Search Engine: Elasticsearch

Elasticsearch is used for:
- Full-text search capabilities
- Log analysis
- Complex reporting queries

## Database Schema Design

### 1. User Management Collections

#### a. societies
```json
{
  "_id": ObjectId,
  "name": String,
  "address": {
    "street": String,
    "city": String,
    "state": String,
    "pincode": String,
    "country": String
  },
  "contact": {
    "phone": String,
    "email": String
  },
  "admin": {
    "name": String,
    "phone": String,
    "email": String
  },
  "createdAt": Date,
  "updatedAt": Date
}
```

#### b. blocks
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "floors": Number,
  "createdAt": Date,
  "updatedAt": Date
}
```

#### c. flats
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "blockId": ObjectId,
  "flatNumber": String,
  "floor": Number,
  "type": String, // 1BHK, 2BHK, 3BHK, etc.
  "area": Number, // in sq ft
  "createdAt": Date,
  "updatedAt": Date
}
```

#### d. residents
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "flatId": ObjectId,
  "userId": ObjectId, // Reference to users collection
  "residentType": String, // Owner, Tenant
  "name": String,
  "phone": String,
  "email": String,
  "emergencyContacts": [
    {
      "name": String,
      "phone": String,
      "relationship": String
    }
  ],
  "vehicles": [
    {
      "registrationNumber": String,
      "type": String, // Car, Bike, etc.
      "parkingSlot": String
    }
  ],
  "status": String, // Active, Inactive, MovedOut
  "moveInDate": Date,
  "moveOutDate": Date,
  "createdAt": Date,
  "updatedAt": Date
}
```

#### e. familyMembers
```json
{
  "_id": ObjectId,
  "residentId": ObjectId,
  "name": String,
  "relationship": String, // Spouse, Child, Parent, etc.
  "phone": String,
  "email": String,
  "profilePicture": String, // URL to image
  "createdAt": Date,
  "updatedAt": Date
}
```

#### f. users
```json
{
  "_id": ObjectId,
  "phoneNumber": String,
  "email": String,
  "password": String, // Hashed
  "role": String, // Resident, Admin, Guard, SuperAdmin
  "fcmToken": String, // For push notifications
  "isActive": Boolean,
  "lastLogin": Date,
  "createdAt": Date,
  "updatedAt": Date
}
```

### 2. Visitor Management Collections

#### a. visitors
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "phone": String,
  "email": String,
  "photo": String, // URL to image
  "idProof": {
    "type": String, // Aadhar, Passport, Driving License, etc.
    "number": String,
    "photo": String // URL to image
  },
  "isFrequent": Boolean,
  "rating": Number, // For service providers
  "createdAt": Date,
  "updatedAt": Date
}
```

#### b. visitorEntries
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "visitorId": ObjectId,
  "flatId": ObjectId,
  "residentId": ObjectId,
  "entryType": String, // Invited, Unexpected, Delivery, DailyHelp, etc.
  "entryDateTime": Date,
  "exitDateTime": Date,
  "entryPhoto": String, // URL to image
  "exitPhoto": String, // URL to image
  "entryGuard": ObjectId, // Reference to guard
  "exitGuard": ObjectId, // Reference to guard
  "approvalStatus": String, // Pending, Approved, Rejected
  "approvedBy": ObjectId, // Reference to resident/admin who approved
  "approvalDateTime": Date,
  "passCode": String, // For daily helps
  "vehicleDetails": {
    "number": String,
    "type": String
  },
  "purpose": String,
  "temperature": Number,
  "maskWorn": Boolean,
  "notes": String,
  "createdAt": Date,
  "updatedAt": Date
}
```

#### c. preApprovals
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "residentId": ObjectId,
  "flatId": ObjectId,
  "visitorId": ObjectId,
  "visitorName": String,
  "visitorPhone": String,
  "validFrom": Date,
  "validTo": Date,
  "recurrence": {
    "type": String, // Daily, Weekly, Monthly
    "days": [String] // For weekly recurrence
  },
  "status": String, // Active, Inactive
  "createdAt": Date,
  "updatedAt": Date
}
```

### 3. Billing & Accounting Collections

#### a. maintenancePlans
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "description": String,
  "billingCycle": String, // Monthly, Quarterly, Half-Yearly, Yearly
  "components": [
    {
      "name": String,
      "amount": Number,
      "type": String // Fixed, PerSqFt
    }
  ],
  "applicableFrom": Date,
  "applicableTo": Date,
  "status": String, // Active, Inactive
  "createdAt": Date,
  "updatedAt": Date
}
```

#### b. maintenanceBills
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "flatId": ObjectId,
  "residentId": ObjectId,
  "billPeriod": {
    "from": Date,
    "to": Date
  },
  "dueDate": Date,
  "billingDate": Date,
  "maintenancePlanId": ObjectId,
  "lineItems": [
    {
      "componentName": String,
      "amount": Number,
      "description": String
    }
  ],
  "totalAmount": Number,
  "discount": Number,
  "tax": Number,
  "grandTotal": Number,
  "status": String, // Generated, Sent, PartiallyPaid, Paid, Overdue
  "paymentDate": Date,
  "paymentMethod": String,
  "transactionId": String,
  "reminders": [
    {
      "date": Date,
      "type": String // SMS, Email, Push
    }
  ],
  "createdAt": Date,
  "updatedAt": Date
}
```

#### c. payments
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "residentId": ObjectId,
  "billId": ObjectId,
  "amount": Number,
  "paymentMethod": String, // UPI, Card, NetBanking, Cash
  "transactionId": String,
  "paymentDate": Date,
  "status": String, // Success, Failed, Pending
  "receiptUrl": String,
  "createdAt": Date,
  "updatedAt": Date
}
```

#### d. expenses
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "category": String, // Salary, Maintenance, Utilities, etc.
  "description": String,
  "amount": Number,
  "date": Date,
  "paidTo": String,
  "paymentMethod": String,
  "transactionId": String,
  "receipt": String, // URL to receipt
  "approvedBy": ObjectId,
  "approvedDate": Date,
  "createdAt": Date,
  "updatedAt": Date
}
```

### 4. Maintenance Collections

#### a. complaints
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "residentId": ObjectId,
  "flatId": ObjectId,
  "title": String,
  "description": String,
  "category": String, // Plumbing, Electrical, Civil, Security, etc.
  "priority": String, // Low, Medium, High, Critical
  "status": String, // Open, Assigned, InProgress, Resolved, Closed
  "assignedTo": ObjectId, // Reference to staff/vendor
  "images": [String], // URLs to images
  "comments": [
    {
      "userId": ObjectId,
      "text": String,
      "timestamp": Date
    }
  ],
  "createdAt": Date,
  "updatedAt": Date,
  "resolvedAt": Date,
  "resolvedBy": ObjectId
}
```

#### b. vendors
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "contactPerson": String,
  "phone": String,
  "email": String,
  "address": String,
  "services": [String], // Plumbing, Electrical, etc.
  "rating": Number,
  "reviews": [
    {
      "userId": ObjectId,
      "rating": Number,
      "comment": String,
      "date": Date
    }
  ],
  "contractStartDate": Date,
  "contractEndDate": Date,
  "status": String, // Active, Inactive
  "createdAt": Date,
  "updatedAt": Date
}
```

#### c. staff
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "role": String, // Guard, Cleaner, Plumber, etc.
  "phone": String,
  "email": String,
  "address": String,
  "joiningDate": Date,
  "salary": Number,
  "status": String, // Active, Inactive
  "createdAt": Date,
  "updatedAt": Date
}
```

### 5. Amenity Booking Collections

#### a. amenities
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "description": String,
  "type": String, // Clubhouse, Gym, SwimmingPool, etc.
  "capacity": Number,
  "rules": [String],
  "photos": [String], // URLs to images
  "bookingFee": Number,
  "status": String, // Available, Maintenance, Unavailable
  "createdAt": Date,
  "updatedAt": Date
}
```

#### b. bookings
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "amenityId": ObjectId,
  "residentId": ObjectId,
  "flatId": ObjectId,
  "bookingDate": Date,
  "startTime": Date,
  "endTime": Date,
  "status": String, // Requested, Approved, Rejected, Cancelled, Completed
  "approvedBy": ObjectId,
  "approvedAt": Date,
  "paymentStatus": String, // Pending, Paid, Refunded
  "transactionId": String,
  "bookingFee": Number,
  "numberOfPeople": Number,
  "purpose": String,
  "createdAt": Date,
  "updatedAt": Date
}
```

### 6. Notification Collections

#### a. notifications
```json
{
  "_id": ObjectId,
  "userId": ObjectId,
  "title": String,
  "message": String,
  "type": String, // Info, Warning, Alert, Reminder
  "category": String, // Visitor, Maintenance, Payment, Booking, etc.
  "relatedEntityId": ObjectId,
  "relatedEntityType": String, // VisitorEntry, MaintenanceBill, Booking, etc.
  "isRead": Boolean,
  "readAt": Date,
  "createdAt": Date
}
```

### 7. Security Collections

#### a. guardDevices
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "deviceId": String,
  "deviceName": String,
  "location": String, // MainGate, Tower, Clubhouse, etc.
  "status": String, // Active, Inactive, Maintenance
  "lastActive": Date,
  "createdAt": Date,
  "updatedAt": Date
}
```

#### b. patrolRoutes
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "name": String,
  "checkpoints": [
    {
      "name": String,
      "location": {
        "latitude": Number,
        "longitude": Number
      },
      "order": Number
    }
  ],
  "frequency": String, // Hourly, Every2Hours, Every4Hours, etc.
  "assignedGuards": [ObjectId], // References to guards
  "createdAt": Date,
  "updatedAt": Date
}
```

#### c. patrolLogs
```json
{
  "_id": ObjectId,
  "societyId": ObjectId,
  "routeId": ObjectId,
  "guardId": ObjectId,
  "checkpointId": ObjectId,
  "timestamp": Date,
  "photo": String, // URL to image
  "notes": String,
  "createdAt": Date
}
```

## Indexing Strategy

To ensure optimal performance, the following indexes will be created:

1. **societies**: Index on societyId
2. **residents**: Compound index on societyId and flatId
3. **visitorEntries**: Compound index on societyId, entryDateTime, and exitDateTime
4. **maintenanceBills**: Compound index on societyId, residentId, and dueDate
5. **complaints**: Compound index on societyId, status, and priority
6. **bookings**: Compound index on amenityId, bookingDate, and status
7. **notifications**: Compound index on userId and isRead

## Data Sharding Strategy

For horizontal scaling, the following sharding approach will be used:

1. **Database Sharding**: Each society's data will be stored in a separate shard to ensure data isolation and improve performance.
2. **Collection Sharding**: Large collections like visitorEntries and maintenanceBills will be sharded based on date ranges.
3. **Geospatial Sharding**: For societies spread across different geographical regions, data will be sharded based on location.

## Backup and Recovery

1. **Automated Backups**: Daily backups of all databases with point-in-time recovery.
2. **Disaster Recovery**: Cross-region replication for critical data.
3. **Data Archival**: Archival of old data to reduce database size and improve performance.

## Security Considerations

1. **Encryption**: All data at rest will be encrypted using AES-256 encryption.
2. **Access Control**: Role-based access control with fine-grained permissions.
3. **Audit Logs**: All database operations will be logged for auditing purposes.
4. **Data Masking**: Sensitive information like phone numbers will be masked in non-production environments.