# 🔧 Backend Integration Guide

## 📋 **Overview**

This guide explains how to integrate your backend with the Athletica Flutter app. The app is currently configured to use a mock API service for frontend testing, but can easily be switched to use a real backend.

## 🔄 **Switching to Real Backend**

### **Step 1: Update Configuration**
In `lib/config/app_config.dart`:
```dart
// Change this line:
static const bool useMockApi = true;

// To:
static const bool useMockApi = false;
```

### **Step 2: Update Backend URL**
```dart
// For development:
static const String baseUrl = 'http://localhost:3000/api';

// For production:
static const String baseUrl = 'https://your-backend-domain.com/api';
```

## 🛠 **Required API Endpoints**

Your backend must implement these endpoints:

### **Authentication Endpoints**

#### **1. User Registration**
```
POST /api/auth/signup
Content-Type: application/json

{
  "name": "string",
  "email": "string",
  "phone": "string",
  "password": "string"
}

Response:
{
  "token": "jwt_token",
  "coach": {
    "id": "string",
    "name": "string",
    "email": "string",
    "phone": "string",
    "bio": "string",
    "certificates": ["string"],
    "subscriptionTier": "string",
    "clientLimit": number,
    "createdAt": "ISO_date",
    "lastActive": "ISO_date"
  }
}
```

#### **2. User Login**
```
POST /api/auth/signin
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}

Response: Same as signup
```

#### **3. User Logout**
```
POST /api/auth/signout
Authorization: Bearer <token>

Response: { "message": "Logged out successfully" }
```

#### **4. Forgot Password**
```
POST /api/auth/forgot-password
Content-Type: application/json

{
  "email": "string"
}

Response: { "message": "Password reset email sent" }
```

#### **5. Google Sign-In**
```
POST /api/auth/google-signin
Content-Type: application/json

{
  "googleToken": "string",
  "name": "string",
  "email": "string",
  "profilePhotoUrl": "string"
}

Response: Same as signup
```

#### **6. Facebook Sign-In**
```
POST /api/auth/facebook-signin
Content-Type: application/json

{
  "facebookToken": "string",
  "name": "string",
  "email": "string",
  "profilePhotoUrl": "string"
}

Response: Same as signup
```

#### **7. Apple Sign-In**
```
POST /api/auth/apple-signin
Content-Type: application/json

{
  "appleToken": "string",
  "name": "string",
  "email": "string"
}

Response: Same as signup
```

### **Coach Management Endpoints**

#### **8. Get Coach Profile**
```
GET /api/coaches/profile
Authorization: Bearer <token>

Response: Coach object (same as signup response)
```

#### **9. Update Coach Profile**
```
PUT /api/coaches/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "bio": "string",
  "profilePhotoUrl": "string"
}

Response: Updated coach object
```

### **Client Management Endpoints**

#### **10. Get All Clients**
```
GET /api/clients
Authorization: Bearer <token>

Response:
[
  {
    "id": "string",
    "coachId": "string",
    "name": "string",
    "status": "active|pending|inactive",
    "subscriptionProgress": number,
    "joinedAt": "ISO_date",
    "lastSession": "ISO_date",
    "goals": { "key": "value" },
    "stats": { "height": number, "weight": number, "age": number },
    "phone": "string",
    "email": "string"
  }
]
```

#### **11. Add New Client**
```
POST /api/clients
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "phone": "string",
  "email": "string",
  "goals": { "key": "value" },
  "stats": { "height": number, "weight": number, "age": number }
}

Response: Created client object
```

#### **12. Update Client**
```
PUT /api/clients/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "status": "string",
  "goals": { "key": "value" },
  "stats": { "key": "value" }
}

Response: Updated client object
```

#### **13. Delete Client**
```
DELETE /api/clients/:id
Authorization: Bearer <token>

Response: { "message": "Client deleted successfully" }
```

### **Plan Management Endpoints**

#### **14. Get All Plans**
```
GET /api/plans
Authorization: Bearer <token>

Response:
[
  {
    "id": "string",
    "coachId": "string",
    "name": "string",
    "description": "string",
    "duration": number,
    "price": number,
    "features": ["string"],
    "createdAt": "ISO_date",
    "status": "active|inactive",
    "clientCount": number,
    "successRate": number,
    "revenue": number
  }
]
```

#### **15. Add New Plan**
```
POST /api/plans
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "description": "string",
  "duration": number,
  "price": number,
  "features": ["string"]
}

Response: Created plan object
```

#### **16. Update Plan**
```
PUT /api/plans/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "description": "string",
  "duration": number,
  "price": number,
  "features": ["string"],
  "status": "active|inactive"
}

Response: Updated plan object
```

#### **17. Delete Plan**
```
DELETE /api/plans/:id
Authorization: Bearer <token>

Response: { "message": "Plan deleted successfully" }
```

### **Analytics Endpoints**

#### **18. Get Dashboard Stats**
```
GET /api/analytics/dashboard
Authorization: Bearer <token>

Response:
{
  "totalClients": number,
  "activeClients": number,
  "pendingClients": number,
  "totalRevenue": number,
  "monthlyRevenue": number,
  "averageProgress": number,
  "totalPlans": number,
  "activePlans": number
}
```

## 🔐 **Authentication & Security**

### **JWT Token Handling**
- All authenticated endpoints require `Authorization: Bearer <token>` header
- Tokens should be validated on every request
- Implement token refresh mechanism
- Set appropriate token expiration times

### **CORS Configuration**
```javascript
// Example CORS setup for Express.js
app.use(cors({
  origin: ['http://localhost:3000', 'https://haridiii07.github.io'],
  credentials: true
}));
```

### **Rate Limiting**
Implement rate limiting for authentication endpoints:
```javascript
// Example with express-rate-limit
const rateLimit = require('express-rate-limit');

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5 // limit each IP to 5 requests per windowMs
});

app.use('/api/auth', authLimiter);
```

## 📊 **Database Schema Examples**

### **Coaches Table**
```sql
CREATE TABLE coaches (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  bio TEXT,
  profile_photo_url VARCHAR(500),
  certificates JSON,
  subscription_tier VARCHAR(50) DEFAULT 'free',
  client_limit INTEGER DEFAULT 3,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **Clients Table**
```sql
CREATE TABLE clients (
  id VARCHAR(255) PRIMARY KEY,
  coach_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  status VARCHAR(50) DEFAULT 'pending',
  subscription_progress DECIMAL(5,2) DEFAULT 0.00,
  goals JSON,
  stats JSON,
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_session TIMESTAMP,
  FOREIGN KEY (coach_id) REFERENCES coaches(id)
);
```

### **Plans Table**
```sql
CREATE TABLE plans (
  id VARCHAR(255) PRIMARY KEY,
  coach_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  duration INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  features JSON,
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coach_id) REFERENCES coaches(id)
);
```

## 🧪 **Testing Your Backend**

### **1. Test Authentication Flow**
```bash
# Test signup
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Coach","email":"test@example.com","phone":"+1234567890","password":"password123"}'

# Test signin
curl -X POST http://localhost:3000/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### **2. Test Protected Endpoints**
```bash
# Test coach profile
curl -X GET http://localhost:3000/api/coaches/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### **3. Test with Flutter App**
1. Set `useMockApi = false` in `app_config.dart`
2. Update `baseUrl` to your backend URL
3. Run the Flutter app and test all features

## 🚀 **Deployment Considerations**

### **Environment Variables**
```bash
# Production environment
NODE_ENV=production
PORT=3000
DATABASE_URL=your_database_url
JWT_SECRET=your_jwt_secret
GOOGLE_CLIENT_ID=your_google_client_id
FACEBOOK_APP_ID=your_facebook_app_id
```

### **Health Check Endpoint**
```javascript
// Add health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});
```

### **Monitoring & Logging**
- Implement request logging
- Set up error monitoring (Sentry, etc.)
- Monitor API response times
- Track authentication failures

## 📞 **Support**

If you need help with backend integration:
1. Check the [Flutter app logs](https://flutter.dev/docs/testing/debugging)
2. Verify API endpoints with tools like Postman
3. Test with mock API first (`useMockApi = true`)
4. Check network connectivity and CORS settings

---

**Your backend is ready for Athletica integration! 🚀**