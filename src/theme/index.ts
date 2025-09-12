import { createTheme } from '@mui/material/styles';

// Athletica Dark Theme - Matching Flutter AppTheme
export const athleticaTheme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#4A67FF', // Primary Blue from Flutter
      light: '#7B8AFF',
      dark: '#2E4BFF',
    },
    secondary: {
      main: '#4CAF50', // Success Green
    },
    background: {
      default: '#121212', // Dark Background
      paper: '#1E1E1E', // Card Background
    },
    text: {
      primary: '#FFFFFF', // Text Primary
      secondary: '#B3B3B3', // Text Secondary
    },
    error: {
      main: '#F44336', // Error Red
    },
    warning: {
      main: '#FF9800', // Warning Orange
    },
    success: {
      main: '#4CAF50', // Success Green
    },
    divider: '#2C2C2C', // Border Color
  },
  typography: {
    fontFamily: '"Cairo", "Roboto", "Helvetica", "Arial", sans-serif',
    h1: {
      fontSize: '32px',
      fontWeight: 'bold',
      color: '#FFFFFF',
    },
    h2: {
      fontSize: '28px',
      fontWeight: 'bold',
      color: '#FFFFFF',
    },
    h3: {
      fontSize: '24px',
      fontWeight: 'bold',
      color: '#FFFFFF',
    },
    h4: {
      fontSize: '22px',
      fontWeight: 'bold',
      color: '#FFFFFF',
    },
    h5: {
      fontSize: '20px',
      fontWeight: 600,
      color: '#FFFFFF',
    },
    h6: {
      fontSize: '18px',
      fontWeight: 600,
      color: '#FFFFFF',
    },
    body1: {
      fontSize: '16px',
      fontWeight: 'normal',
      color: '#FFFFFF',
    },
    body2: {
      fontSize: '14px',
      fontWeight: 'normal',
      color: '#FFFFFF',
    },
    caption: {
      fontSize: '12px',
      fontWeight: 'normal',
      color: '#B3B3B3',
    },
  },
  components: {
    MuiCard: {
      styleOverrides: {
        root: {
          backgroundColor: '#1E1E1E',
          borderRadius: '12px',
          border: '1px solid #2C2C2C',
          boxShadow: 'none',
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          textTransform: 'none',
          fontWeight: 600,
          padding: '12px 24px',
        },
        contained: {
          backgroundColor: '#4A67FF',
          color: '#FFFFFF',
          '&:hover': {
            backgroundColor: '#2E4BFF',
          },
        },
        outlined: {
          borderColor: '#4A67FF',
          color: '#4A67FF',
          '&:hover': {
            borderColor: '#2E4BFF',
            backgroundColor: 'rgba(74, 103, 255, 0.1)',
          },
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            backgroundColor: '#1E1E1E',
            borderRadius: '12px',
            '& fieldset': {
              borderColor: '#2C2C2C',
            },
            '&:hover fieldset': {
              borderColor: '#4A67FF',
            },
            '&.Mui-focused fieldset': {
              borderColor: '#4A67FF',
              borderWidth: '2px',
            },
          },
          '& .MuiInputLabel-root': {
            color: '#B3B3B3',
          },
          '& .MuiInputBase-input': {
            color: '#FFFFFF',
          },
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          fontWeight: 'bold',
        },
        colorPrimary: {
          backgroundColor: 'rgba(74, 103, 255, 0.1)',
          color: '#4A67FF',
          border: '1px solid rgba(74, 103, 255, 0.3)',
        },
        colorSuccess: {
          backgroundColor: 'rgba(76, 175, 80, 0.1)',
          color: '#4CAF50',
          border: '1px solid rgba(76, 175, 80, 0.3)',
        },
        colorError: {
          backgroundColor: 'rgba(244, 67, 54, 0.1)',
          color: '#F44336',
          border: '1px solid rgba(244, 67, 54, 0.3)',
        },
        colorWarning: {
          backgroundColor: 'rgba(255, 152, 0, 0.1)',
          color: '#FF9800',
          border: '1px solid rgba(255, 152, 0, 0.3)',
        },
      },
    },
    MuiBottomNavigation: {
      styleOverrides: {
        root: {
          backgroundColor: '#1E1E1E',
          borderTop: '1px solid #2C2C2C',
        },
      },
    },
    MuiBottomNavigationAction: {
      styleOverrides: {
        root: {
          color: '#B3B3B3',
          '&.Mui-selected': {
            color: '#4A67FF',
            backgroundColor: 'rgba(74, 103, 255, 0.1)',
            borderRadius: '12px',
          },
        },
      },
    },
  },
});

// Custom colors matching Flutter theme
export const colors = {
  primaryBlue: '#4A67FF',
  darkBackground: '#121212',
  cardBackground: '#1E1E1E',
  textPrimary: '#FFFFFF',
  textSecondary: '#B3B3B3',
  textGrey: '#808080',
  borderColor: '#2C2C2C',
  successGreen: '#4CAF50',
  errorRed: '#F44336',
  warningOrange: '#FF9800',
};

