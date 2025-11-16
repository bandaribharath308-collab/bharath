# Pocket India - Admin Panel Setup

## Django Admin Panel

Your Django admin panel is fully configured and ready to use!

### Access URLs

1. **Django Admin Panel**: http://127.0.0.1:8000/admin/
   - Full-featured Django admin interface
   - Manage Posts, Comments, Contacts, and Auth Tokens
   - Professional interface with search, filters, and sorting

2. **Custom Admin Dashboard**: http://127.0.0.1:8000/admin.html
   - Modern custom dashboard with orange/blue theme
   - View contact submissions
   - API-based authentication

---

## Creating a Superuser (Admin Account)

To access the Django admin panel, you need to create a superuser account:

### Step 1: Open Terminal in the Django Project Directory
```powershell
cd .vscode\Python-Django-Blog-Website-main
```

### Step 2: Activate Virtual Environment
```powershell
.\venv\Scripts\activate
```

### Step 3: Create Superuser
```powershell
python manage.py createsuperuser
```

### Step 4: Follow the Prompts
- **Username**: Choose an admin username (e.g., `admin`)
- **Email**: Enter your email (optional, can press Enter to skip)
- **Password**: Enter a secure password
- **Password (again)**: Confirm your password

**Example:**
```
Username: admin
Email address: admin@pocketindia.com
Password: ********
Password (again): ********
Superuser created successfully.
```

---

## Accessing the Admin Panel

### Django Admin (Recommended)
1. Go to: http://127.0.0.1:8000/admin/
2. Login with your superuser credentials
3. You can now:
   - ✅ View and manage all blog posts
   - ✅ Moderate comments
   - ✅ View contact form submissions
   - ✅ Manage user accounts
   - ✅ View authentication tokens

### Custom Admin Dashboard
1. First, create an account at: http://127.0.0.1:8000/signup.html
2. Make your account an admin by running:
   ```powershell
   python manage.py shell
   ```
   Then in the Python shell:
   ```python
   from django.contrib.auth.models import User
   user = User.objects.get(username='your_username')
   user.is_staff = True
   user.is_superuser = True
   user.save()
   exit()
   ```
3. Login at: http://127.0.0.1:8000/login.html
4. You'll be redirected to: http://127.0.0.1:8000/admin.html

---

## Admin Features

### Django Admin Panel Features:
- 📊 **Posts Management**: View, edit, delete blog posts
- 💬 **Comments Moderation**: Manage user comments
- 📧 **Contact Submissions**: View messages from contact form
- 👥 **User Management**: Manage user accounts and permissions
- 🔐 **Auth Tokens**: Monitor API authentication tokens
- 🔍 **Search & Filter**: Advanced search and filtering options
- 📈 **Sorting**: Sort by date, likes, category, etc.

### Custom Admin Dashboard Features:
- 🎨 Beautiful modern interface with Pocket India branding
- 📬 View contact form submissions
- 🔄 Real-time data loading via API
- 📱 Responsive design

---

## Quick Commands

### Create Superuser
```powershell
cd .vscode\Python-Django-Blog-Website-main
.\venv\Scripts\activate
python manage.py createsuperuser
```

### Make Existing User Admin
```powershell
python manage.py shell
```
```python
from django.contrib.auth.models import User
user = User.objects.get(username='username_here')
user.is_staff = True
user.is_superuser = True
user.save()
exit()
```

### Check Existing Superusers
```powershell
python manage.py shell
```
```python
from django.contrib.auth.models import User
User.objects.filter(is_superuser=True).values('username', 'email')
```

---

## Troubleshooting

### Can't Access Admin Panel?
1. Make sure the server is running: `python manage.py runserver`
2. Verify you created a superuser account
3. Check you're using the correct URL: http://127.0.0.1:8000/admin/

### Forgot Admin Password?
```powershell
python manage.py changepassword admin
```

### Need to Reset Everything?
```powershell
# Delete database and start fresh
del db.sqlite3
python manage.py migrate
python manage.py createsuperuser
```

---

## Summary

✅ **Django Admin**: http://127.0.0.1:8000/admin/ (Full-featured, recommended)
✅ **Custom Dashboard**: http://127.0.0.1:8000/admin.html (Modern UI)
✅ **Create Superuser**: `python manage.py createsuperuser`
✅ **Server Running**: http://127.0.0.1:8000/

Your admin panel is ready to use! 🚀
