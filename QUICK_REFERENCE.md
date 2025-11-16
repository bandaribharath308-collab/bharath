# 🚀 Quick Reference Card

## ⚡ Start Your Website (3 Steps)

### 1. Setup (First Time Only)
```bash
cd .vscode\Python-Django-Blog-Website-main
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
```

### 2. Run Server
```bash
python manage.py runserver
```

### 3. Open Browser
```
http://localhost:8000/login.html
```

---

## 🔑 Key URLs

| Page | URL | Description |
|------|-----|-------------|
| Login | `/login.html` | User login |
| Signup | `/signup.html` | New user registration |
| Admin | `/admin.html` | Admin dashboard |
| Home | `/index.html` | Main application |

---

## 🔌 API Quick Reference

### Authentication
```javascript
// Register
POST /api/auth/register
Body: {username, email, password}

// Login
POST /api/auth/login
Body: {username, password}  // username can be email

// Logout
POST /api/auth/logout
Headers: Authorization: Bearer <token>

// Get Profile
GET /api/auth/profile
Headers: Authorization: Bearer <token>
```

### Content
```javascript
// Get all states
GET /api/states

// Get state content
GET /api/state/:slug

// Submit contact
POST /api/contact
Body: {name, email, subject, message}
```

---

## 🎯 First Time Use

1. **Register First User** → Becomes admin automatically
2. **Login** → Redirected to admin dashboard
3. **Register Second User** → Regular user
4. **Login as Regular User** → Redirected to main app

---

## 🔐 Authentication Flow

```
Register → Login → Token Stored → Access Protected Pages
                      ↓
                  12 Hours Later
                      ↓
                Token Expires → Re-login Required
```

---

## 🐛 Quick Fixes

| Problem | Solution |
|---------|----------|
| "No module named 'cgi'" | Use Python 3.11 or 3.12 |
| "Table doesn't exist" | Run `python manage.py migrate` |
| "401 Unauthorized" | Login again (token expired) |
| Static files not loading | Check POCKET_DIR in settings.py |

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `views.py` | All API endpoints |
| `models.py` | Database models |
| `urls.py` | URL routing |
| `settings.py` | Django configuration |
| `auth.js` | Frontend auth helpers |
| `db.sqlite3` | Database file |

---

## ✅ Status Check

**All Tasks Complete**: 17/17 core + 1/1 validation ✅

**Ready to Use**: YES ✅

**Documentation**: Complete ✅

---

## 🎉 You're Ready!

Just run the server and start using your fullstack website!

**First user = Admin automatically!**
