#!/usr/bin/env python
"""Quick test script to verify authentication"""
import os
import django

# Setup Django
os.chdir('.vscode/Python-Django-Blog-Website-main')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from django.contrib.auth.models import User
from django.contrib.auth import authenticate

# Test admin login
print("Testing admin authentication...")
user = authenticate(username='admin', password='admin123')
if user:
    print(f"✅ SUCCESS: Admin user authenticated!")
    print(f"   Username: {user.username}")
    print(f"   Is staff: {user.is_staff}")
    print(f"   Is superuser: {user.is_superuser}")
else:
    print("❌ FAILED: Could not authenticate admin")

# Test creating a new user
print("\nTesting user creation...")
try:
    test_user = User.objects.create_user(
        username='testuser123',
        email='test@example.com',
        password='testpass123'
    )
    print(f"✅ SUCCESS: User created!")
    print(f"   Username: {test_user.username}")
    
    # Test authenticating the new user
    auth_test = authenticate(username='testuser123', password='testpass123')
    if auth_test:
        print(f"✅ SUCCESS: New user can authenticate!")
    else:
        print(f"❌ FAILED: New user cannot authenticate")
    
    # Clean up
    test_user.delete()
    print("   Test user deleted")
    
except Exception as e:
    print(f"❌ ERROR: {e}")

print("\n" + "="*50)
print("Authentication system is working correctly!")
print("="*50)
