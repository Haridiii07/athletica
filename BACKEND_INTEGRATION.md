# Backend Integration Guide for Athletica

## Overview

The Athletica Flutter app has been updated to work with your Node.js backend instead of Firebase directly. This provides better control over the API and allows for custom business logic.

## Backend Repository

Your backend is available at: [https://github.com/youssef3092004/Athletica](https://github.com/youssef3092004/Athletica)

## Setup Instructions

### 1. Backend Setup

1. **Clone the backend repository:**
   ```bash
   git clone https://github.com/youssef3092004/Athletica
   cd Athletica
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   Create a `.env` file in the backend root:
   ```env
   PORT=3000
   MONGODB_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret_key
   NODE_ENV=development
   ```

4. **Start the backend server:**
   ```bash
   npm start
   # or for development
   npm run dev
   ```

### 2. Flutter App Configuration

1. **Update backend URL:**
   Edit `lib/config/app_config.dart`:
   ```dart
   static const String baseUrl = 'http://localhost:3000/api';
   ```

2. **For production deployment:**
   ```dart
   static const String baseUrl = 'https://your-backend-domain.com/api';
   ```

### 3. API Endpoints

The Flutter app expects these endpoints from your backend:

#### Authentication
- `POST /api/auth/signup` - Register new coach
- `POST /api/auth/signin` - Login coach
- `POST /api/auth/signout` - Logout coach

#### Coach Management
- `GET /api/coaches/profile` - Get coach profile
- `PUT /api/coaches/profile` - Update coach profile

#### Client Management
- `GET /api/clients` - Get all clients for coach
- `POST /api/clients` - Add new client
- `PUT /api/clients/:id` - Update client
- `DELETE /api/clients/:id` - Delete client

#### Plan Management
- `GET /api/plans` - Get all plans for coach
- `POST /api/plans` - Add new plan
- `PUT /api/plans/:id` - Update plan
- `DELETE /api/plans/:id` - Delete plan

#### Analytics
- `GET /api/analytics/dashboard` - Get dashboard statistics

### 4. Data Models

The Flutter app uses these data models that should match your backend:

#### Coach Model
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "profilePhotoUrl": "string?",
  "bio": "string",
  "certificates": ["string"],
  "subscriptionTier": "free|basic|pro|elite",
  "clientLimit": 3,
  "createdAt": "ISO8601 string",
  "lastActive": "ISO8601 string?",
  "settings": {}
}
```

#### Client Model
```json
{
  "id": "string",
  "coachId": "string",
  "name": "string",
  "profilePhotoUrl": "string?",
  "status": "active|inactive|pending",
  "subscriptionProgress": 0.0,
  "joinedAt": "ISO8601 string",
  "lastSession": "ISO8601 string?",
  "goals": {},
  "stats": {},
  "sessionHistory": [],
  "phone": "string?",
  "email": "string?"
}
```

#### Plan Model
```json
{
  "id": "string",
  "coachId": "string",
  "name": "string",
  "description": "string",
  "imageUrl": "string?",
  "duration": 30,
  "price": 500.0,
  "features": ["string"],
  "createdAt": "ISO8601 string",
  "expiresAt": "ISO8601 string?",
  "status": "active|expired|draft",
  "clientCount": 0,
  "successRate": 0.0,
  "revenue": 0.0
}
```

### 5. Authentication

The app uses JWT tokens for authentication:

1. **Token Storage:** Tokens are stored securely using `SharedPreferences`
2. **Authorization Header:** All authenticated requests include:
   ```
   Authorization: Bearer <token>
   ```
3. **Token Refresh:** Implement token refresh logic in your backend if needed

### 6. Error Handling

The Flutter app expects consistent error responses:

```json
{
  "message": "Error description",
  "code": "ERROR_CODE",
  "details": {}
}
```

### 7. Testing the Integration

1. **Start the backend server**
2. **Run the Flutter app:**
   ```bash
   flutter run
   ```
3. **Test authentication flow:**
   - Sign up with a new account
   - Sign in with existing account
   - Check if profile loads correctly

### 8. Development Workflow

1. **Backend Development:**
   - Make changes to your Node.js backend
   - Test endpoints with Postman or similar tool
   - Update API documentation if needed

2. **Flutter Development:**
   - Update API service if endpoints change
   - Test with running backend
   - Update models if data structure changes

### 9. Deployment

#### Backend Deployment
1. Deploy your Node.js backend to your preferred platform
2. Update the `baseUrl` in Flutter app configuration
3. Set up environment variables in production

#### Flutter App Deployment
1. Build the app for production:
   ```bash
   flutter build apk --release
   ```
2. Test with production backend URL
3. Deploy to Google Play Store

### 10. Troubleshooting

#### Common Issues:

1. **Connection refused:**
   - Check if backend server is running
   - Verify the correct port (default: 3000)
   - Check firewall settings

2. **CORS errors:**
   - Ensure backend has proper CORS configuration
   - Add Flutter app's domain to allowed origins

3. **Authentication errors:**
   - Check JWT token format
   - Verify token expiration
   - Check authorization headers

4. **Data format errors:**
   - Ensure backend returns data in expected format
   - Check date format (ISO8601)
   - Verify required fields are present

### 11. Security Considerations

1. **HTTPS in Production:** Always use HTTPS for production
2. **Token Security:** Implement proper token validation
3. **Input Validation:** Validate all inputs on backend
4. **Rate Limiting:** Implement rate limiting for API endpoints
5. **Data Encryption:** Encrypt sensitive data in transit and at rest

### 12. Monitoring

1. **Backend Monitoring:**
   - Monitor API response times
   - Track error rates
   - Monitor database performance

2. **Flutter App Monitoring:**
   - Track app crashes
   - Monitor API call success rates
   - Track user engagement metrics

## Support

For backend-specific issues, contact your backend developer.
For Flutter app issues, refer to the main README.md file.
