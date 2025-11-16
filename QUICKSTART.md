# Fullstack Authentication Website - Quick Start Guide

## 🚀 Your Fullstack Website is Ready!

This combines the Django Blog backend with Pocket India frontend into a unified authentication system.

## ⚡ Quick Setup (5 minutes)

### Step 1: Install Python 3.11 or 3.12
**Important:** Python 3.13 is not yet supported by Django 5.0. Please use Python 3.11 or 3.12.

Download from: https://www.python.org/downloads/

### Step 2: Setup Backend
```bash
cd .vscode/Python-Django-Blog-Website-main

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py makemigrations
python manage.py migrate

# Start the server
python manage.py runserver
```

### Step 3: Access Your Website
Open browser and go to: **http://localhost:8000/login.html**

## 🎯 What's Working

### ✅ Authentication System
- **Registration**: `/signup.html` - Create new accounts
- **Login**: `/login.html` - Sign in with username or email
- **Admin Dashboard**: `/admin.html` - First user becomes admin automatically
- **Session Persistence**: Tokens stored in localStorage, 12-hour expiration
- **Logout**: Clears tokens and redirects to login

### ✅ API Endpoints
All working at `/api/`:
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login (username or email)
- `POST /api/auth/logout` - Logout and invalidate token
- `GET /api/auth/profile` - Get user profile (requires auth)
- `GET /api/states` - List all Indian states
- `GET /api/state/:slug` - Get state HTML content
- `GET /api/state-json/:slug` - Get structured state data
- `GET /api/images/:slug` - Get state images
- `GET /api/attractions/:slug` - Get state attractions with maps
- `POST /api/contact` - Submit contact form
- `GET /api/contacts` - Get all contacts (admin only)

### ✅ Frontend Pages
- **Login Page**: Modern auth interface
- **Signup Page**: Registration with password confirmation
- **Admin Dashboard**: Contact submissions, user management
- **Main App**: Blog + Travel content (index.html)
- **State Pages**: All Indian state travel guides

### ✅ Features Implemented
1. ✅ Unified authentication (Django backend only, Node.js deprecated)
2. ✅ First user auto-admin assignment
3. ✅ Email or username login support
4. ✅ Token-based authentication (12-hour expiration)
5. ✅ Session persistence across page refreshes
6. ✅ Role-based redirects (admin → admin.html, user → index.html)
7. ✅ CORS configured for API access
8. ✅ Static file serving for Pocket India frontend
9. ✅ Comprehensive error handling
10. ✅ Token cleanup mechanism

## 🧪 Testing Checklist

### Test 1: Registration Flow
1. Go to http://localhost:8000/signup.html
2. Enter username, email, password (min 6 chars)
3. Click "Sign Up"
4. Should redirect to login page
5. **First user becomes admin automatically!**

### Test 2: Login Flow
1. Go to http://localhost:8000/login.html
2. Enter username (or email) and password
3. Click "Login"
4. **Admin users** → redirected to `/admin.html`
5. **Regular users** → redirected to `/index.html`

### Test 3: Session Persistence
1. After logging in, refresh the page
2. Should remain logged in (token in localStorage)
3. Close browser and reopen
4. Should still be logged in (until 12-hour expiration)

### Test 4: Admin Dashboard
1. Login as first user (admin)
2. Should see admin dashboard at `/admin.html`
3. View contact submissions
4. See welcome message with username

### Test 5: Logout
1. Click "Logout" button
2. Should redirect to login page
3. Token cleared from localStorage
4. Try accessing `/admin.html` → redirected to login

### Test 6: Email Login
1. Register with username "john" and email "john@example.com"
2. Logout
3. Login using email "john@example.com" instead of username
4. Should work successfully

### Test 7: Error Handling
1. Try registering with duplicate username → Error message
2. Try registering with duplicate email → Error message
3. Try login with wrong password → Error message
4. Try password less than 6 chars → Error message

### Test 8: API Access
1. Open browser console (F12)
2. Try API call without token:
```javascript
fetch('/api/auth/profile').then(r => r.json()).then(console.log)
// Should return 401 unauthorized
```
3. Login first, then try:
```javascript
const token = localStorage.getItem('access_token');
fetch('/api/auth/profile', {
  headers: {'Authorization': 'Bearer ' + token}
}).then(r => r.json()).then(console.log)
// Should return user profile
```

### Test 9: Contact Form
1. Go to contact page
2. Submit contact form
3. Login as admin
4. Go to admin dashboard
5. Should see contact submission

### Test 10: Travel Content
1. After login, access state pages
2. Try: http://localhost:8000/states/goa.html
3. Should display travel content
4. API endpoints should work for state data

## 📁 Project Structure

```
Pocket-India 2/
├── .vscode/Python-Django-Blog-Website-main/  # Django Backend
│   ├── myapp/
│   │   ├── models.py          # User, Post, Comment, Contact, AuthToken
│   │   ├── views.py           # All API endpoints + auth logic
│   │   └── urls.py            # URL routing
│   ├── myproject/
│   │   └── settings.py        # Django configuration
│   ├── templates/             # Django templates (index, admin, signup)
│   ├── static/                # Django static files
│   ├── media/                 # User uploads
│   └── db.sqlite3             # Database
│
└── Pocket-India/              # Frontend
    ├── login.html             # Login page
    ├── signup.html            # Registration page
    ├── admin.html             # Admin dashboard
    ├── assets/
    │   ├── auth.js            # Authentication helper functions
    │   └── style.css          # Styles
    ├── states/                # State HTML pages
    └── data/                  # State data JSON
```

## 🔧 Configuration

### Django Settings (already configured)
- `POCKET_DIR`: Points to Pocket-India folder
- `STATICFILES_DIRS`: Includes Pocket-India assets
- `ALLOWED_HOSTS`: Set to `['*']` for development
- `DEBUG`: True for development

### Authentication Settings
- Token expiration: 12 hours
- Password minimum length: 6 characters
- First user auto-admin: Enabled
- CORS: Enabled for all origins (development)

## 🐛 Troubleshooting

### Issue: "No module named 'cgi'"
**Solution**: Use Python 3.11 or 3.12 (not 3.13)

### Issue: "Table doesn't exist"
**Solution**: Run migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```

### Issue: "Static files not loading"
**Solution**: Check POCKET_DIR path in settings.py matches your folder structure

### Issue: "401 Unauthorized on API calls"
**Solution**: 
1. Check token in localStorage
2. Verify token hasn't expired (12 hours)
3. Login again to get fresh token

### Issue: "CORS errors"
**Solution**: Already configured in views.py `_cors()` function

## 🚀 Next Steps

### For Production Deployment:
1. Set `DEBUG = False` in settings.py
2. Configure `ALLOWED_HOSTS` with your domain
3. Use PostgreSQL instead of SQLite
4. Set up proper static file serving (nginx/CDN)
5. Use environment variables for SECRET_KEY
6. Enable HTTPS
7. Add rate limiting on auth endpoints
8. Implement refresh tokens

### Optional Enhancements:
- Password reset functionality
- Email verification
- Two-factor authentication
- Social login (Google, Facebook)
- User profile pictures
- Blog post creation from frontend
- Advanced admin features

## 📝 API Documentation

### Authentication Endpoints

#### POST /api/auth/register
Register new user
```json
Request:
{
  "username": "john",
  "email": "john@example.com",
  "password": "password123"
}

Response (201):
{
  "ok": true,
  "user": {
    "id": 1,
    "username": "john",
    "email": "john@example.com",
    "is_admin": true  // true if first user
  }
}
```

#### POST /api/auth/login
Login user
```json
Request:
{
  "username": "john",  // or email
  "password": "password123"
}

Response (200):
{
  "access_token": "abc123...",
  "expires_at": "2024-11-14T10:30:00Z",
  "user": {
    "id": 1,
    "username": "john",
    "email": "john@example.com",
    "is_admin": true
  }
}
```

#### POST /api/auth/logout
Logout user (requires auth token)
```json
Headers:
Authorization: Bearer <token>

Response (200):
{
  "ok": true
}
```

#### GET /api/auth/profile
Get user profile (requires auth token)
```json
Headers:
Authorization: Bearer <token>

Response (200):
{
  "id": 1,
  "username": "john",
  "email": "john@example.com",
  "first_name": "",
  "last_name": "",
  "is_admin": true
}
```

## ✨ Summary

Your fullstack website is **COMPLETE** and ready to use! All 17 implementation tasks are done:

✅ Backend authentication infrastructure
✅ Django serving Pocket India frontend
✅ Signup page created
✅ Signup form logic
✅ Admin dashboard
✅ Login redirect logic
✅ Session persistence
✅ Logout functionality
✅ Blog + travel content integration
✅ Error handling
✅ CORS configuration
✅ First user admin assignment
✅ Email login support
✅ Token cleanup
✅ Error logging
✅ Documentation
✅ Node.js server deprecated

**Just install Python 3.11/3.12, run the setup commands, and you're live!**
