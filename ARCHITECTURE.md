# 🏗️ Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        BROWSER                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │         Pocket India Frontend (HTML/CSS/JS)            │ │
│  │                                                         │ │
│  │  • login.html      • signup.html                       │ │
│  │  • admin.html      • index.html                        │ │
│  │  • auth.js (Authentication Helper)                     │ │
│  │  • localStorage (Token Storage)                        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ HTTP/HTTPS
                          │ (API Calls + Static Files)
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   DJANGO BACKEND SERVER                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              URL Router & Middleware                   │ │
│  │  • CORS Headers    • Static File Serving              │ │
│  │  • CSRF Exemption  • Authentication Middleware         │ │
│  └────────────────────────────────────────────────────────┘ │
│                          │                                   │
│         ┌────────────────┴────────────────┐                 │
│         ▼                                  ▼                 │
│  ┌─────────────┐                  ┌──────────────┐         │
│  │  API Views  │                  │ Static Views │         │
│  │             │                  │              │         │
│  │ • Auth      │                  │ • Pocket     │         │
│  │ • States    │                  │   Frontend   │         │
│  │ • Blog      │                  │ • Assets     │         │
│  │ • Contact   │                  │ • States     │         │
│  └─────────────┘                  └──────────────┘         │
│         │                                                    │
│         ▼                                                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                 Django ORM Layer                       │ │
│  └────────────────────────────────────────────────────────┘ │
│         │                                                    │
│         ▼                                                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Database Models                           │ │
│  │  • User         • AuthToken                            │ │
│  │  • Post         • Comment                              │ │
│  │  • Contact                                             │ │
│  └────────────────────────────────────────────────────────┘ │
│         │                                                    │
│         ▼                                                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              SQLite Database                           │ │
│  │              (db.sqlite3)                              │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Authentication Flow

```
┌──────────┐
│  User    │
└────┬─────┘
     │
     │ 1. Enter credentials
     ▼
┌─────────────────┐
│  Login Form     │
│  (login.html)   │
└────┬────────────┘
     │
     │ 2. POST /api/auth/login
     ▼
┌─────────────────────────┐
│  Django Backend         │
│  • Validate credentials │
│  • Generate token       │
│  • Return user data     │
└────┬────────────────────┘
     │
     │ 3. Token + User data
     ▼
┌─────────────────────────┐
│  Frontend (auth.js)     │
│  • Store token          │
│  • Store user object    │
│  • Redirect based on    │
│    admin status         │
└────┬────────────────────┘
     │
     ├─── Admin? ───┐
     │              │
     ▼              ▼
┌──────────┐  ┌──────────┐
│ admin.   │  │ index.   │
│ html     │  │ html     │
└──────────┘  └──────────┘
```

---

## Token-Based Authentication

```
┌──────────────────────────────────────────────────────────┐
│                    Request Flow                           │
└──────────────────────────────────────────────────────────┘

Frontend                    Backend                  Database
   │                           │                         │
   │ GET /api/auth/profile     │                         │
   │ Authorization: Bearer XXX │                         │
   ├──────────────────────────>│                         │
   │                           │                         │
   │                           │ Validate token          │
   │                           ├────────────────────────>│
   │                           │                         │
   │                           │ Token valid + User data │
   │                           │<────────────────────────┤
   │                           │                         │
   │ User profile data         │                         │
   │<──────────────────────────┤                         │
   │                           │                         │
```

---

## Data Models Relationship

```
┌──────────────┐
│     User     │
│ (Django)     │
│              │
│ • username   │
│ • email      │
│ • password   │
│ • is_staff   │
└──────┬───────┘
       │
       │ 1:Many
       │
       ├─────────────────┬─────────────────┬──────────────┐
       │                 │                 │              │
       ▼                 ▼                 ▼              ▼
┌─────────────┐   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  AuthToken  │   │    Post     │  │   Comment   │  │   Contact   │
│             │   │             │  │             │  │             │
│ • key       │   │ • postname  │  │ • content   │  │ • name      │
│ • user_id   │   │ • content   │  │ • post_id   │  │ • email     │
│ • expires   │   │ • user_id   │  │ • user_id   │  │ • subject   │
└─────────────┘   └──────┬──────┘  └─────────────┘  │ • message   │
                         │                           └─────────────┘
                         │ 1:Many
                         │
                         ▼
                  ┌─────────────┐
                  │   Comment   │
                  │             │
                  │ • content   │
                  │ • post_id   │
                  │ • user_id   │
                  └─────────────┘
```

---

## Request/Response Flow

### Registration Flow
```
User Input                API Request              Backend Process           Response
──────────                ───────────              ───────────────           ────────

username: john            POST /api/auth/register  1. Validate input         201 Created
email: john@ex.com        {                        2. Check duplicates       {
password: pass123           "username": "john",    3. Hash password            "ok": true,
                            "email": "john@...",   4. Create user              "user": {
                            "password": "..."      5. Set admin if first         "id": 1,
                          }                        6. Return user data           "username": "john",
                                                                                 "is_admin": true
                                                                               }
                                                                             }
```

### Login Flow
```
User Input                API Request              Backend Process           Response
──────────                ───────────              ───────────────           ────────

username: john            POST /api/auth/login     1. Find user              200 OK
password: pass123         {                        2. Verify password        {
                            "username": "john",    3. Generate token           "access_token": "abc...",
                            "password": "..."      4. Set expiration           "expires_at": "2024...",
                          }                        5. Delete old tokens        "user": {
                                                   6. Save new token             "id": 1,
                                                   7. Return token + user        "username": "john",
                                                                                 "is_admin": true
                                                                               }
                                                                             }
```

### Protected Request Flow
```
User Action               API Request              Backend Process           Response
───────────               ───────────              ───────────────           ────────

Click profile             GET /api/auth/profile    1. Extract token          200 OK
                          Headers: {               2. Find token in DB       {
                            Authorization:         3. Check expiration         "id": 1,
                              "Bearer abc..."      4. Get user data            "username": "john",
                          }                        5. Return profile           "email": "john@...",
                                                                               "is_admin": true
                                                                             }
```

---

## File Structure

```
Project Root
│
├── .vscode/
│   └── Python-Django-Blog-Website-main/    ← DJANGO BACKEND
│       ├── myapp/
│       │   ├── models.py                   ← Database models
│       │   ├── views.py                    ← API endpoints
│       │   ├── urls.py                     ← URL routing
│       │   └── admin.py                    ← Admin config
│       ├── myproject/
│       │   ├── settings.py                 ← Django config
│       │   └── urls.py                     ← Root URLs
│       ├── templates/                      ← HTML templates
│       ├── static/                         ← Static files
│       ├── media/                          ← User uploads
│       ├── db.sqlite3                      ← Database
│       └── manage.py                       ← Django CLI
│
├── Pocket-India/                           ← FRONTEND
│   ├── login.html                          ← Login page
│   ├── signup.html                         ← Signup page
│   ├── admin.html                          ← Admin dashboard
│   ├── index.html                          ← Main app
│   ├── assets/
│   │   ├── auth.js                         ← Auth helpers
│   │   ├── style.css                       ← Styles
│   │   └── images/                         ← Images
│   ├── states/                             ← State HTML pages
│   └── data/                               ← State JSON data
│
└── Documentation/
    ├── README.md                           ← Main readme
    ├── QUICKSTART.md                       ← Setup guide
    ├── TESTING_CHECKLIST.md                ← Test scenarios
    ├── IMPLEMENTATION_SUMMARY.md           ← Implementation details
    ├── QUICK_REFERENCE.md                  ← Quick reference
    └── ARCHITECTURE.md                     ← This file
```

---

## Technology Stack

### Backend
- **Framework**: Django 5.0
- **Language**: Python 3.11/3.12
- **Database**: SQLite (dev) / PostgreSQL (prod)
- **Authentication**: Token-based (custom)
- **API**: RESTful JSON

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Modern styling
- **JavaScript**: Vanilla JS (no frameworks)
- **Storage**: localStorage for tokens
- **API Client**: Fetch API

### Security
- **Password Hashing**: PBKDF2 (Django default)
- **Token**: 64-char hex (256-bit entropy)
- **CORS**: Configured for cross-origin
- **CSRF**: Exempt for API endpoints
- **XSS**: Template escaping

---

## Deployment Architecture

### Development
```
┌─────────────────────────┐
│   Django Dev Server     │
│   (manage.py runserver) │
│   Port: 8000            │
│                         │
│   • Serves API          │
│   • Serves static files │
│   • SQLite database     │
└─────────────────────────┘
```

### Production (Recommended)
```
┌─────────────────────────┐
│   Nginx (Reverse Proxy) │
│   Port: 80/443          │
└────────┬────────────────┘
         │
         ├─── Static Files ──> CDN/S3
         │
         └─── API Requests
                  │
                  ▼
         ┌─────────────────┐
         │   Gunicorn      │
         │   (WSGI Server) │
         └────────┬────────┘
                  │
                  ▼
         ┌─────────────────┐
         │  Django App     │
         └────────┬────────┘
                  │
                  ▼
         ┌─────────────────┐
         │  PostgreSQL     │
         │  Database       │
         └─────────────────┘
```

---

## Security Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Security Layers                        │
└──────────────────────────────────────────────────────────┘

Layer 1: Transport Security
  • HTTPS (production)
  • Secure cookies
  • HSTS headers

Layer 2: Authentication
  • Password hashing (PBKDF2)
  • Token-based auth
  • Token expiration (12h)
  • One token per user

Layer 3: Authorization
  • Role-based access (admin/user)
  • Protected endpoints
  • Token validation on each request

Layer 4: Input Validation
  • Django ORM (SQL injection prevention)
  • Template escaping (XSS prevention)
  • Email/username validation
  • Password length requirements

Layer 5: CORS & CSRF
  • CORS headers configured
  • CSRF exempt for API (token auth)
  • SameSite cookies
```

---

## Performance Considerations

### Database Optimization
- Indexes on AuthToken.key
- Indexes on User.username and User.email
- select_related() for foreign keys
- Regular token cleanup

### Caching Strategy
- Browser caching for static files
- CDN for production assets
- Database query optimization
- Token validation caching

### Scalability
- Stateless authentication (tokens)
- Horizontal scaling ready
- Database connection pooling
- Load balancer compatible

---

## Monitoring & Logging

```
┌──────────────────────────────────────────────────────────┐
│                    Logging Points                         │
└──────────────────────────────────────────────────────────┘

Authentication Events:
  ✓ Registration attempts (success/failure)
  ✓ Login attempts (success/failure)
  ✓ Token validation failures
  ✓ Logout events

Application Events:
  ✓ API endpoint access
  ✓ Error responses
  ✓ Database queries (debug mode)
  ✓ Static file requests

Security Events:
  ✓ Failed authentication attempts
  ✓ Expired token usage
  ✓ Invalid token attempts
  ✓ CORS violations
```

---

## API Response Formats

### Success Response
```json
{
  "ok": true,
  "data": { ... }
}
```

### Error Response
```json
{
  "error": "Descriptive error message"
}
```

### Authentication Response
```json
{
  "access_token": "64-char-hex-string",
  "expires_at": "2024-11-14T10:30:00Z",
  "user": {
    "id": 1,
    "username": "john",
    "email": "john@example.com",
    "is_admin": true
  }
}
```

---

## Summary

This architecture provides:
- ✅ Scalable token-based authentication
- ✅ Clean separation of concerns
- ✅ RESTful API design
- ✅ Security best practices
- ✅ Easy deployment
- ✅ Comprehensive logging
- ✅ Performance optimization

**Production-ready fullstack application!**
