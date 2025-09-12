# Font Assets Optimization

## 🎯 **Font Optimization Strategy**

### **Current Setup:**

- Using Google Fonts with Arabic subset
- Only loading required weights (400, 700)
- Font display swap for better performance

### **Optimized Font Loading:**

```html
<!-- In web/index.html -->
<link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700&subset=arabic&display=swap" rel="stylesheet">
```

### **Font Subset Optimization:**

- **Arabic subset only** - Reduces font size by ~60%
- **Required weights only** - 400 (regular), 700 (bold)
- **Display swap** - Better loading performance

### **Local Font Fallback:**

If you want to use local fonts instead of Google Fonts:

1. Download Cairo font files
2. Place in this directory:
   - `Cairo-Regular.ttf` (400 weight)
   - `Cairo-Bold.ttf` (700 weight)
3. Update `pubspec.yaml` font configuration
4. Update theme to use local fonts

### **Font Size Comparison:**

- **Full Google Fonts**: ~200KB
- **Arabic subset**: ~80KB
- **Local fonts**: ~60KB (if optimized)

### **Performance Impact:**

- **Faster loading** - Smaller font files
- **Better caching** - Local fonts cache better
- **Reduced dependencies** - No external requests
