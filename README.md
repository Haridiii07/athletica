# 🏋️ Athletica Web - React Version

> **React web companion** to the Flutter Athletica fitness trainer platform

## 🚀 **Quick Start**

### **Live Demo**
- **Web App**: [https://haridiii07.github.io/athletica/](https://haridiii07.github.io/athletica/)

### **Local Development**

```bash
# Clone the repository
git clone https://github.com/Haridiii07/athletica.git
cd athletica

# Switch to web branch
git checkout web-version

# Install dependencies
npm install

# Start development server
npm run dev
```

## 🎯 **Features**

- ✅ **Authentication System** - Email/password + Social login (Google, Facebook, Apple)
- ✅ **Dashboard Home** - Revenue charts, analytics, quick stats
- ✅ **Client Management** - Search, filter, status tracking
- ✅ **Workout Plans** - Create, edit, manage fitness plans
- ✅ **Messages** - Client communication system
- ✅ **Profile Management** - Settings and preferences
- ✅ **Responsive Design** - Mobile-first approach
- ✅ **Dark Theme** - Professional design matching Flutter app

## 🏗️ **Tech Stack**

- **Frontend**: React 19 + TypeScript
- **Build Tool**: Vite
- **UI Framework**: Material-UI (MUI) v5
- **State Management**: Redux Toolkit + RTK Query
- **Routing**: React Router v6
- **Forms**: React Hook Form + Yup validation
- **Charts**: Recharts
- **Styling**: MUI styled components + CSS-in-JS
- **HTTP Client**: Axios
- **Date Handling**: date-fns

## 📱 **Design Fidelity**

This React web app is a **pixel-perfect replica** of the Flutter Athletica app:

- **Color Scheme**: 
  - Primary: `#4A67FF` (Blue)
  - Background: `#121212` (Dark)
  - Cards: `#1E1E1E`
  - Success: `#4CAF50` (Green)
  - Warning: `#FF9800` (Orange)

- **Typography**: Cairo font family
- **Theme**: Dark mode with Arabic-first design
- **Components**: Material Design 3 with custom theming

## 🧪 **Testing**

### **Demo Credentials**
- **Email**: `test@coach.com`
- **Password**: `password`

### **Test Features**
1. **Authentication** - Sign in/up, social login
2. **Dashboard** - Revenue charts, quick stats
3. **Client Management** - Add, edit, search clients
4. **Workout Plans** - Create and manage plans
5. **Responsive Design** - Test on mobile/desktop


## 🔄 **Data Integration**

- **Current**: Mock data service (perfect for demos)
- **Future**: Real backend API integration ready
- **API Spec**: Complete documentation in `docs/api/BACKEND_INTEGRATION.md`

## 🚀 **Deployment**

### **GitHub Pages** (Recommended)
- Automatic deployment via GitHub Actions
- Live at: `https://haridiii07.github.io/athletica/`

### **Manual Build**
```bash
npm run build
# Deploy dist/ folder to any static hosting
```

## 📁 **Project Structure**

```
src/
├── components/          # React components
│   ├── dashboard/       # Dashboard screens
│   ├── ui/             # Reusable UI components
│   └── ...             # Auth, landing screens
├── store/              # Redux store and slices
├── services/           # API services and mock data
├── types/              # TypeScript interfaces
├── theme/              # MUI theme configuration
└── utils/              # Helper functions
```

## 🔗 **Related Projects**

- **Flutter App**: Main mobile/desktop application
- **Backend API**: [youssef3092004/Athletica](https://github.com/youssef3092004/Athletica)
- **Documentation**: See `docs/` folder for complete guides

## 📝 **Development Notes**

- **Mock Data**: Uses comprehensive mock service for demos
- **Type Safety**: Full TypeScript coverage
- **Performance**: Optimized bundle size and lazy loading
- **Accessibility**: WCAG compliant components
- **Testing**: Ready for unit and integration tests

---

**Built with ❤️ for the Athletica fitness platform**
