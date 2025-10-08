# API Documentation for MyGate Clone

## Overview

This document provides comprehensive API documentation for the MyGate clone application. The API follows RESTful principles and uses JSON for request/response payloads. All endpoints require appropriate authentication unless otherwise specified.

## Base URL

```
https://api.mygate-clone.com/v1
```

## Authentication

### JWT Token
Most endpoints require a JWT token for authentication, which should be included in the Authorization header:

```
Authorization: Bearer <token>
```

### API Keys
Some endpoints may require API keys for server-to-server communication:

```
X-API-Key: <api_key>
```

## Common HTTP Status Codes

- `200 OK` - Successful request
- `201 Created` - Resource successfully created
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Access denied
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict
- `422 Unprocessable Entity` - Validation errors
- `500 Internal Server Error` - Server error

## Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

## API Endpoints

### Authentication Service

#### POST /auth/register
Register a new user

**Request:**
```json
{
  "phoneNumber": "+919876543210",
  "societyCode": "SOC123",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "phoneNumber": "+919876543210",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "role": "resident",
    "isActive": false
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### POST /auth/login
User login

**Request:**
```json
{
  "phoneNumber": "+919876543210",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "phoneNumber": "+919876543210",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "role": "resident",
    "isActive": true
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### POST /auth/verify-otp
Verify OTP for phone number verification

**Request:**
```json
{
  "phoneNumber": "+919876543210",
  "otp": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Phone number verified successfully"
}
```

#### POST /auth/forgot-password
Initiate password reset

**Request:**
```json
{
  "phoneNumber": "+919876543210"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP sent to your phone number"
}
```

#### POST /auth/reset-password
Reset password

**Request:**
```json
{
  "phoneNumber": "+919876543210",
  "otp": "123456",
  "newPassword": "NewSecurePass123!"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

### User Management Service

#### GET /users/profile
Get user profile

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439011",
  "phoneNumber": "+919876543210",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "role": "resident",
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### PUT /users/profile
Update user profile

**Request:**
```json
{
  "name": "John Smith",
  "email": "john.smith@example.com"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439011",
  "phoneNumber": "+919876543210",
  "name": "John Smith",
  "email": "john.smith@example.com",
  "role": "resident",
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### GET /residents
Get resident information (Admin only)

**Query Parameters:**
- `societyId` (optional)
- `blockId` (optional)
- `flatId` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "residents": [
    {
      "id": "507f1f77bcf86cd799439013",
      "societyId": "507f1f77bcf86cd799439012",
      "flatId": "507f1f77bcf86cd799439014",
      "userId": "507f1f77bcf86cd799439011",
      "residentType": "owner",
      "name": "John Doe",
      "phone": "+919876543210",
      "email": "john.doe@example.com",
      "status": "active",
      "moveInDate": "2023-01-01T00:00:00.000Z",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### POST /residents
Create new resident (Admin only)

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "flatId": "507f1f77bcf86cd799439014",
  "residentType": "owner",
  "name": "John Doe",
  "phone": "+919876543210",
  "email": "john.doe@example.com"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439013",
  "societyId": "507f1f77bcf86cd799439012",
  "flatId": "507f1f77bcf86cd799439014",
  "userId": "507f1f77bcf86cd799439011",
  "residentType": "owner",
  "name": "John Doe",
  "phone": "+919876543210",
  "email": "john.doe@example.com",
  "status": "active",
  "moveInDate": "2023-01-01T00:00:00.000Z",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

### Visitor Management Service

#### GET /visitors
Get visitor list

**Query Parameters:**
- `societyId` (required)
- `dateFrom` (optional)
- `dateTo` (optional)
- `residentId` (optional)
- `status` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "visitors": [
    {
      "id": "507f1f77bcf86cd799439015",
      "societyId": "507f1f77bcf86cd799439012",
      "name": "Jane Smith",
      "phone": "+919876543211",
      "email": "jane.smith@example.com",
      "isFrequent": false,
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### POST /visitors
Create new visitor

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "name": "Jane Smith",
  "phone": "+919876543211",
  "email": "jane.smith@example.com"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439015",
  "societyId": "507f1f77bcf86cd799439012",
  "name": "Jane Smith",
  "phone": "+919876543211",
  "email": "jane.smith@example.com",
  "isFrequent": false,
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### GET /visitor-entries
Get visitor entries

**Query Parameters:**
- `societyId` (required)
- `dateFrom` (optional)
- `dateTo` (optional)
- `residentId` (optional)
- `visitorId` (optional)
- `status` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "entries": [
    {
      "id": "507f1f77bcf86cd799439016",
      "societyId": "507f1f77bcf86cd799439012",
      "visitorId": "507f1f77bcf86cd799439015",
      "flatId": "507f1f77bcf86cd799439014",
      "residentId": "507f1f77bcf86cd799439013",
      "entryType": "invited",
      "entryDateTime": "2023-01-01T10:00:00.000Z",
      "exitDateTime": "2023-01-01T12:00:00.000Z",
      "approvalStatus": "approved",
      "passCode": "1234",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### POST /visitor-entries
Create new visitor entry

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "visitorId": "507f1f77bcf86cd799439015",
  "flatId": "507f1f77bcf86cd799439014",
  "residentId": "507f1f77bcf86cd799439013",
  "entryType": "invited",
  "passCode": "1234"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439016",
  "societyId": "507f1f77bcf86cd799439012",
  "visitorId": "507f1f77bcf86cd799439015",
  "flatId": "507f1f77bcf86cd799439014",
  "residentId": "507f1f77bcf86cd799439013",
  "entryType": "invited",
  "entryDateTime": "2023-01-01T10:00:00.000Z",
  "approvalStatus": "pending",
  "passCode": "1234",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### PUT /visitor-entries/{id}/exit
Mark visitor exit

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439016",
  "societyId": "507f1f77bcf86cd799439012",
  "visitorId": "507f1f77bcf86cd799439015",
  "flatId": "507f1f77bcf86cd799439014",
  "residentId": "507f1f77bcf86cd799439013",
  "entryType": "invited",
  "entryDateTime": "2023-01-01T10:00:00.000Z",
  "exitDateTime": "2023-01-01T12:00:00.000Z",
  "approvalStatus": "approved",
  "passCode": "1234",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### POST /pre-approvals
Create pre-approval

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "visitorName": "Jane Smith",
  "visitorPhone": "+919876543211",
  "validFrom": "2023-01-01T00:00:00.000Z",
  "validTo": "2023-01-31T00:00:00.000Z"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439017",
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "visitorName": "Jane Smith",
  "visitorPhone": "+919876543211",
  "validFrom": "2023-01-01T00:00:00.000Z",
  "validTo": "2023-01-31T00:00:00.000Z",
  "status": "active",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

### Billing & Accounting Service

#### GET /maintenance-plans
Get maintenance plans

**Query Parameters:**
- `societyId` (required)
- `status` (optional)

**Response:**
```json
{
  "plans": [
    {
      "id": "507f1f77bcf86cd799439018",
      "societyId": "507f1f77bcf86cd799439012",
      "name": "Monthly Maintenance",
      "description": "Monthly maintenance charges",
      "billingCycle": "monthly",
      "components": [
        {
          "name": "Common Area Maintenance",
          "amount": 1000,
          "type": "fixed"
        },
        {
          "name": "Security",
          "amount": 500,
          "type": "fixed"
        }
      ],
      "status": "active",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ]
}
```

#### POST /maintenance-plans
Create maintenance plan

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "name": "Monthly Maintenance",
  "description": "Monthly maintenance charges",
  "billingCycle": "monthly",
  "components": [
    {
      "name": "Common Area Maintenance",
      "amount": 1000,
      "type": "fixed"
    },
    {
      "name": "Security",
      "amount": 500,
      "type": "fixed"
    }
  ]
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439018",
  "societyId": "507f1f77bcf86cd799439012",
  "name": "Monthly Maintenance",
  "description": "Monthly maintenance charges",
  "billingCycle": "monthly",
  "components": [
    {
      "name": "Common Area Maintenance",
      "amount": 1000,
      "type": "fixed"
    },
    {
      "name": "Security",
      "amount": 500,
      "type": "fixed"
    }
  ],
  "status": "active",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### GET /maintenance-bills
Get maintenance bills

**Query Parameters:**
- `societyId` (required)
- `residentId` (optional)
- `status` (optional)
- `dateFrom` (optional)
- `dateTo` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "bills": [
    {
      "id": "507f1f77bcf86cd799439019",
      "societyId": "507f1f77bcf86cd799439012",
      "flatId": "507f1f77bcf86cd799439014",
      "residentId": "507f1f77bcf86cd799439013",
      "billPeriod": {
        "from": "2023-01-01T00:00:00.000Z",
        "to": "2023-01-31T00:00:00.000Z"
      },
      "dueDate": "2023-02-10T00:00:00.000Z",
      "billingDate": "2023-01-01T00:00:00.000Z",
      "maintenancePlanId": "507f1f77bcf86cd799439018",
      "lineItems": [
        {
          "componentName": "Common Area Maintenance",
          "amount": 1000,
          "description": "Common Area Maintenance"
        },
        {
          "componentName": "Security",
          "amount": 500,
          "description": "Security"
        }
      ],
      "totalAmount": 1500,
      "grandTotal": 1500,
      "status": "generated",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### POST /maintenance-bills
Generate maintenance bill

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "flatId": "507f1f77bcf86cd799439014",
  "residentId": "507f1f77bcf86cd799439013",
  "billPeriod": {
    "from": "2023-01-01T00:00:00.000Z",
    "to": "2023-01-31T00:00:00.000Z"
  },
  "dueDate": "2023-02-10T00:00:00.000Z",
  "maintenancePlanId": "507f1f77bcf86cd799439018"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439019",
  "societyId": "507f1f77bcf86cd799439012",
  "flatId": "507f1f77bcf86cd799439014",
  "residentId": "507f1f77bcf86cd799439013",
  "billPeriod": {
    "from": "2023-01-01T00:00:00.000Z",
    "to": "2023-01-31T00:00:00.000Z"
  },
  "dueDate": "2023-02-10T00:00:00.000Z",
  "billingDate": "2023-01-01T00:00:00.000Z",
  "maintenancePlanId": "507f1f77bcf86cd799439018",
  "lineItems": [
    {
      "componentName": "Common Area Maintenance",
      "amount": 1000,
      "description": "Common Area Maintenance"
    },
    {
      "componentName": "Security",
      "amount": 500,
      "description": "Security"
    }
  ],
  "totalAmount": 1500,
  "grandTotal": 1500,
  "status": "generated",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### POST /payments
Make payment

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "billId": "507f1f77bcf86cd799439019",
  "amount": 1500,
  "paymentMethod": "upi",
  "transactionId": "txn_1234567890"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439020",
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "billId": "507f1f77bcf86cd799439019",
  "amount": 1500,
  "paymentMethod": "upi",
  "transactionId": "txn_1234567890",
  "paymentDate": "2023-01-05T00:00:00.000Z",
  "status": "success",
  "createdAt": "2023-01-05T00:00:00.000Z",
  "updatedAt": "2023-01-05T00:00:00.000Z"
}
```

### Maintenance Service

#### GET /complaints
Get complaints

**Query Parameters:**
- `societyId` (required)
- `residentId` (optional)
- `status` (optional)
- `category` (optional)
- `priority` (optional)
- `dateFrom` (optional)
- `dateTo` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "complaints": [
    {
      "id": "507f1f77bcf86cd799439021",
      "societyId": "507f1f77bcf86cd799439012",
      "residentId": "507f1f77bcf86cd799439013",
      "flatId": "507f1f77bcf86cd799439014",
      "title": "Water Leakage",
      "description": "Water is leaking from the ceiling in the living room",
      "category": "plumbing",
      "priority": "high",
      "status": "open",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### POST /complaints
Create complaint

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "title": "Water Leakage",
  "description": "Water is leaking from the ceiling in the living room",
  "category": "plumbing",
  "priority": "high"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439021",
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "title": "Water Leakage",
  "description": "Water is leaking from the ceiling in the living room",
  "category": "plumbing",
  "priority": "high",
  "status": "open",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### PUT /complaints/{id}
Update complaint

**Request:**
```json
{
  "status": "in_progress",
  "assignedTo": "507f1f77bcf86cd799439022"
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439021",
  "societyId": "507f1f77bcf86cd799439012",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "title": "Water Leakage",
  "description": "Water is leaking from the ceiling in the living room",
  "category": "plumbing",
  "priority": "high",
  "status": "in_progress",
  "assignedTo": "507f1f77bcf86cd799439022",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

### Amenity Booking Service

#### GET /amenities
Get amenities

**Query Parameters:**
- `societyId` (required)
- `type` (optional)
- `status` (optional)

**Response:**
```json
{
  "amenities": [
    {
      "id": "507f1f77bcf86cd799439023",
      "societyId": "507f1f77bcf86cd799439012",
      "name": "Swimming Pool",
      "description": "Community swimming pool",
      "type": "swimming_pool",
      "capacity": 50,
      "bookingFee": 100,
      "status": "available",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ]
}
```

#### POST /amenities
Create amenity

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "name": "Swimming Pool",
  "description": "Community swimming pool",
  "type": "swimming_pool",
  "capacity": 50,
  "bookingFee": 100
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439023",
  "societyId": "507f1f77bcf86cd799439012",
  "name": "Swimming Pool",
  "description": "Community swimming pool",
  "type": "swimming_pool",
  "capacity": 50,
  "bookingFee": 100,
  "status": "available",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### GET /bookings
Get bookings

**Query Parameters:**
- `societyId` (required)
- `residentId` (optional)
- `amenityId` (optional)
- `status` (optional)
- `dateFrom` (optional)
- `dateTo` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "bookings": [
    {
      "id": "507f1f77bcf86cd799439024",
      "societyId": "507f1f77bcf86cd799439012",
      "amenityId": "507f1f77bcf86cd799439023",
      "residentId": "507f1f77bcf86cd799439013",
      "flatId": "507f1f77bcf86cd799439014",
      "bookingDate": "2023-01-15T00:00:00.000Z",
      "startTime": "2023-01-15T10:00:00.000Z",
      "endTime": "2023-01-15T12:00:00.000Z",
      "status": "approved",
      "bookingFee": 100,
      "numberOfPeople": 4,
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### POST /bookings
Create booking

**Request:**
```json
{
  "societyId": "507f1f77bcf86cd799439012",
  "amenityId": "507f1f77bcf86cd799439023",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "bookingDate": "2023-01-15T00:00:00.000Z",
  "startTime": "2023-01-15T10:00:00.000Z",
  "endTime": "2023-01-15T12:00:00.000Z",
  "numberOfPeople": 4
}
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439024",
  "societyId": "507f1f77bcf86cd799439012",
  "amenityId": "507f1f77bcf86cd799439023",
  "residentId": "507f1f77bcf86cd799439013",
  "flatId": "507f1f77bcf86cd799439014",
  "bookingDate": "2023-01-15T00:00:00.000Z",
  "startTime": "2023-01-15T10:00:00.000Z",
  "endTime": "2023-01-15T12:00:00.000Z",
  "status": "requested",
  "bookingFee": 100,
  "numberOfPeople": 4,
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

### Notification Service

#### GET /notifications
Get user notifications

**Query Parameters:**
- `userId` (required)
- `isRead` (optional)
- `category` (optional)
- `page` (default: 1)
- `limit` (default: 10)

**Response:**
```json
{
  "notifications": [
    {
      "id": "507f1f77bcf86cd799439025",
      "userId": "507f1f77bcf86cd799439011",
      "title": "Visitor Arrival",
      "message": "Jane Smith has arrived at the gate",
      "type": "info",
      "category": "visitor",
      "isRead": false,
      "createdAt": "2023-01-01T10:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1
  }
}
```

#### PUT /notifications/{id}/read
Mark notification as read

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439025",
  "userId": "507f1f77bcf86cd799439011",
  "title": "Visitor Arrival",
  "message": "Jane Smith has arrived at the gate",
  "type": "info",
  "category": "visitor",
  "isRead": true,
  "readAt": "2023-01-01T10:05:00.000Z",
  "createdAt": "2023-01-01T10:00:00.000Z"
}
```

### Reports Service

#### GET /reports/visitor-logs
Get visitor logs report

**Query Parameters:**
- `societyId` (required)
- `dateFrom` (required)
- `dateTo` (required)
- `residentId` (optional)
- `visitorId` (optional)

**Response:**
```json
{
  "report": {
    "title": "Visitor Logs Report",
    "period": {
      "from": "2023-01-01T00:00:00.000Z",
      "to": "2023-01-31T00:00:00.000Z"
    },
    "data": [
      {
        "date": "2023-01-01",
        "totalVisitors": 25,
        "approvedVisitors": 20,
        "rejectedVisitors": 2,
        "pendingVisitors": 3
      }
    ]
  }
}
```

#### GET /reports/financial-summary
Get financial summary report

**Query Parameters:**
- `societyId` (required)
- `dateFrom` (required)
- `dateTo` (required)

**Response:**
```json
{
  "report": {
    "title": "Financial Summary Report",
    "period": {
      "from": "2023-01-01T00:00:00.000Z",
      "to": "2023-01-31T00:00:00.000Z"
    },
    "summary": {
      "totalIncome": 500000,
      "totalExpenses": 300000,
      "netIncome": 200000
    },
    "incomeBreakdown": [
      {
        "category": "Maintenance Fees",
        "amount": 400000
      },
      {
        "category": "Amenity Booking Fees",
        "amount": 100000
      }
    ],
    "expenseBreakdown": [
      {
        "category": "Staff Salaries",
        "amount": 150000
      },
      {
        "category": "Maintenance",
        "amount": 100000
      },
      {
        "category": "Utilities",
        "amount": 50000
      }
    ]
  }
}
```

## Rate Limiting

API endpoints are rate-limited to prevent abuse:
- 100 requests per minute per IP for unauthenticated endpoints
- 1000 requests per minute per user for authenticated endpoints

## Versioning

The API uses URL versioning with the current version being v1. Future versions will be available at /v2/, /v3/, etc.

## Webhooks

The system supports webhooks for real-time notifications:
- Visitor entry/exit notifications
- Payment confirmation
- Complaint status updates
- Booking confirmations

Webhook endpoints can be configured in the admin panel with appropriate security measures.

This comprehensive API documentation provides all the necessary information for developers to integrate with the MyGate clone application effectively.