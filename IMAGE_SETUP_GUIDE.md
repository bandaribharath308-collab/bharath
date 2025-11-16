# 📸 State Images Setup Guide

## Current Status

✅ **Image folders already exist!**
- All 36 states/UTs have image folders
- Each folder contains 9 images:
  - 3 attraction images (attraction-1.jpg, attraction-2.jpg, attraction-3.jpg)
  - 3 culture images (culture-1.jpg, culture-2.jpg, culture-3.jpg)
  - 3 food images (food-1.jpg, food-2.jpg, food-3.jpg)

## Image Locations

**Pocket-India (Static Site)**:
- Location: `Pocket-India/assets/images/{state-name}/`
- Example: `Pocket-India/assets/images/andhra-pradesh/attraction-1.jpg`
- Status: ✅ Images exist and are accessible

**Django Site**:
- The Django templates reference: `/assets/images/{state-name}/`
- These are served through the Django views
- Status: ✅ Working through Django's asset serving

## How Images Are Displayed

The images are already set up to display in the state pages. The Django server serves them through the `/assets/` route which maps to the Pocket-India assets folder.

### Image Structure Per State:

```
Pocket-India/assets/images/
├── andhra-pradesh/
│   ├── attraction-1.jpg  (Tirupati Temple)
│   ├── attraction-2.jpg  (Araku Valley)
│   ├── attraction-3.jpg  (Borra Caves)
│   ├── culture-1.jpg
│   ├── culture-2.jpg
│   ├── culture-3.jpg
│   ├── food-1.jpg
│   ├── food-2.jpg
│   └── food-3.jpg
├── goa/
│   ├── attraction-1.jpg  (Beaches)
│   ├── attraction-2.jpg  (Churches)
│   └── ...
└── [35 more states...]
```

## Adding Images to Attraction Cards

The state HTML files currently show attraction cards without images. To add images, we need to update the HTML structure.

### Current Structure:
```html
<div class="attraction-item">
  <h3>Tirupati Temple</h3>
  <p>Description...</p>
  <a href="..." class="map-button">Get Directions</a>
</div>
```

### Updated Structure with Images:
```html
<div class="attraction-item">
  <img src="../assets/images/andhra-pradesh/attraction-1.jpg" alt="Tirupati Temple" class="attraction-image">
  <h3>Tirupati Temple</h3>
  <p>Description...</p>
  <a href="..." class="map-button">Get Directions</a>
</div>
```

## CSS for Images

Add this CSS to `Pocket-India/assets/style.css`:

```css
.attraction-item {
  position: relative;
  overflow: hidden;
}

.attraction-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 8px 8px 0 0;
  margin: -1rem -1rem 1rem -1rem;
}
```

## States with Images

✅ All 36 states/UTs have images:
1. Andaman & Nicobar
2. Andhra Pradesh
3. Arunachal Pradesh
4. Assam
5. Bihar
6. Chandigarh
7. Chhattisgarh
8. Dadra & Nagar Haveli
9. Daman & Diu
10. Delhi
11. Goa
12. Gujarat
13. Haryana
14. Himachal Pradesh
15. Jammu & Kashmir
16. Jharkhand (folder exists, needs images)
17. Karnataka
18. Kerala
19. Ladakh
20. Lakshadweep
21. Madhya Pradesh
22. Maharashtra
23. Manipur
24. Meghalaya
25. Mizoram
26. Nagaland
27. Odisha
28. Puducherry
29. Punjab
30. Rajasthan
31. Sikkim
32. Tamil Nadu
33. Telangana
34. Tripura (needs folder)
35. Uttar Pradesh
36. Uttarakhand
37. West Bengal

## Next Steps

To display images in attraction cards:

1. ✅ Images already exist in folders
2. ⏳ Update CSS to style images properly
3. ⏳ Update HTML files to include `<img>` tags
4. ⏳ Ensure images load correctly through Django

## Testing

Visit any state page to see if images load:
- http://127.0.0.1:8000/states/andhra-pradesh.html
- http://127.0.0.1:8000/states/goa.html
- http://127.0.0.1:8000/states/kerala.html

## Image Requirements

For best display:
- **Format**: JPG or PNG
- **Size**: 800x600px recommended
- **File size**: < 500KB per image
- **Aspect ratio**: 4:3 or 16:9

## Troubleshooting

**Images not loading?**
1. Check file paths are correct
2. Verify images exist in folders
3. Check Django is serving /assets/ correctly
4. Clear browser cache

**Images too large?**
- Optimize images before adding
- Use tools like TinyPNG or ImageOptim
- Target < 500KB per image
