import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider } from '@mui/material/styles';
import { CssBaseline } from '@mui/material';
import { Provider } from 'react-redux';
import { store } from './store';
import { athleticaTheme } from './theme';
import { useSelector } from 'react-redux';
import { RootState } from './store';

// Components
import SplashScreen from './components/SplashScreen';
import LandingScreen from './components/LandingScreen';
import SignInScreen from './components/SignInScreen';
import SignUpScreen from './components/SignUpScreen';
import ForgotPasswordScreen from './components/ForgotPasswordScreen';
import MainScreen from './components/MainScreen';

// Protected Route Component
const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const isAuthenticated = useSelector((state: RootState) => state.auth.isAuthenticated);
  return isAuthenticated ? <>{children}</> : <Navigate to="/signin" replace />;
};

// Public Route Component (redirect if authenticated)
const PublicRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const isAuthenticated = useSelector((state: RootState) => state.auth.isAuthenticated);
  return !isAuthenticated ? <>{children}</> : <Navigate to="/dashboard" replace />;
};

function App() {
  return (
    <Provider store={store}>
      <ThemeProvider theme={athleticaTheme}>
        <CssBaseline />
        <Router>
          <Routes>
            {/* Splash Screen */}
            <Route path="/" element={<SplashScreen />} />
            
            {/* Landing Screen */}
            <Route path="/landing" element={<LandingScreen />} />
            
            {/* Authentication Routes */}
            <Route 
              path="/signin" 
              element={
                <PublicRoute>
                  <SignInScreen />
                </PublicRoute>
              } 
            />
            <Route 
              path="/signup" 
              element={
                <PublicRoute>
                  <SignUpScreen />
                </PublicRoute>
              } 
            />
            <Route 
              path="/forgot-password" 
              element={
                <PublicRoute>
                  <ForgotPasswordScreen />
                </PublicRoute>
              } 
            />
            
            {/* Protected Dashboard Routes */}
            <Route 
              path="/dashboard/*" 
              element={
                <ProtectedRoute>
                  <MainScreen />
                </ProtectedRoute>
              } 
            />
            
            {/* Default redirect */}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </Router>
      </ThemeProvider>
    </Provider>
  );
}

export default App;