# Athletica Website

A simple, clean company website for Athletica - an Arabic-first platform for fitness coaches.

## Project Structure

```
athletica-site/
├── index.html          # Main HTML file with all sections
├── styles.css          # Stylesheet with responsive design
├── script.js           # JavaScript for navigation and interactions
├── assets/
│   └── logo.svg        # Logo placeholder
└── README.md           # This file
```

## Features

- Clean, minimal design
- Fully responsive (mobile, tablet, desktop)
- Smooth scrolling navigation
- Mobile hamburger menu
- Netlify form integration
- Fast loading (no frameworks, pure HTML/CSS/JS)

## Deployment on Netlify

### Step 1: Push to GitHub

1. Initialize a git repository (if not already done):
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Athletica website"
   ```

2. Create a new repository on GitHub and push:
   ```bash
   git remote add origin https://github.com/yourusername/athletica-site.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Deploy on Netlify

1. Go to [Netlify](https://www.netlify.com/) and sign in
2. Click **"Add new site"** → **"Import an existing project"**
3. Select **"Deploy with GitHub"** and authorize Netlify
4. Choose your repository (`athletica-site`)
5. Configure build settings:
   - **Build command:** (leave empty - no build step needed)
   - **Publish directory:** `./` (root directory)
6. Click **"Deploy site"**

### Step 3: Configure Netlify Forms

1. After deployment, go to **Site settings** → **Forms**
2. Netlify will automatically detect the form in `index.html` (it has the `netlify` attribute)
3. Form submissions will appear in the Netlify dashboard under **Forms** → **Active forms**

### Step 4: Custom Domain (Optional)

1. Go to **Site settings** → **Domain management**
2. Click **"Add custom domain"**
3. Follow the instructions to configure your domain (e.g., `athletica.fit`)

## Local Development

Simply open `index.html` in a web browser, or use a local server:

```bash
# Using Python
python -m http.server 8000

# Using Node.js (http-server)
npx http-server

# Using PHP
php -S localhost:8000
```

Then visit `http://localhost:8000` in your browser.

## Notes

- The contact form uses Netlify Forms and will work automatically after deployment
- All styling is in `styles.css` - no external dependencies
- JavaScript is minimal and handles navigation and mobile menu only
- The site is optimized for fast loading and good performance

## Deployment on Replit

1. **Import to Replit**:
   - Create a new Repl by importing this repository (`https://github.com/Haridiii07/athletica`).
2. **Run**:
   - Click the "Run" button. The valid configuration is now at the root of the repository, so no manual setup is needed.

## Support

For issues or questions, contact: contact@athletica.fit
