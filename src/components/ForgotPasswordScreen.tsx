import React, { useState } from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  Container,
  Stack,
  IconButton,
  InputAdornment,
  Alert,
  Snackbar,
  AppBar,
  Toolbar,
} from '@mui/material';
import {
  ArrowBack,
  Email,
} from '@mui/icons-material';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { AppDispatch, RootState } from '../store';
import { forgotPassword, clearError } from '../store/authSlice';
import { colors } from '../theme';

interface ForgotPasswordForm {
  email: string;
}

const schema = yup.object({
  email: yup.string().email('Please enter a valid email').required('Email is required'),
});

const ForgotPasswordScreen: React.FC = () => {
  const navigate = useNavigate();
  const dispatch = useDispatch<AppDispatch>();
  const { isLoading, error } = useSelector((state: RootState) => state.auth);
  
  const [showSnackbar, setShowSnackbar] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ForgotPasswordForm>({
    resolver: yupResolver(schema),
  });

  const onSubmit = async (data: ForgotPasswordForm) => {
    const result = await dispatch(forgotPassword(data.email));
    if (forgotPassword.fulfilled.match(result)) {
      setIsSuccess(true);
      setShowSnackbar(true);
    } else {
      setShowSnackbar(true);
    }
  };

  const handleCloseSnackbar = () => {
    setShowSnackbar(false);
    dispatch(clearError());
    if (isSuccess) {
      navigate('/signin');
    }
  };

  return (
    <Box sx={{ minHeight: '100vh', backgroundColor: colors.darkBackground }}>
      {/* Header */}
      <AppBar 
        position="static" 
        sx={{ 
          backgroundColor: 'transparent', 
          boxShadow: 'none',
          borderBottom: `1px solid ${colors.borderColor}`
        }}
      >
        <Toolbar>
          <IconButton 
            edge="start" 
            color="inherit" 
            onClick={() => navigate('/signin')}
            sx={{ color: colors.textPrimary }}
          >
            <ArrowBack />
          </IconButton>
          <Typography variant="h6" sx={{ color: colors.textPrimary, flexGrow: 1 }}>
            Forgot Password
          </Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="sm" sx={{ py: 4 }}>
        <Box sx={{ maxWidth: '400px', mx: 'auto' }}>
          {/* Header */}
          <Typography
            variant="h3"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 1,
              textAlign: 'center'
            }}
          >
            Reset Password
          </Typography>
          
          <Typography
            variant="body1"
            sx={{
              color: colors.textSecondary,
              mb: 4,
              textAlign: 'center'
            }}
          >
            Enter your email address and we'll send you a link to reset your password
          </Typography>

          {/* Forgot Password Form */}
          <Box component="form" onSubmit={handleSubmit(onSubmit)} sx={{ mb: 4 }}>
            <Stack spacing={3}>
              {/* Email Field */}
              <TextField
                {...register('email')}
                label="Email Address"
                type="email"
                fullWidth
                error={!!errors.email}
                helperText={errors.email?.message}
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <Email sx={{ color: colors.textSecondary }} />
                    </InputAdornment>
                  ),
                }}
              />

              {/* Reset Password Button */}
              <Button
                type="submit"
                variant="contained"
                size="large"
                disabled={isLoading}
                sx={{
                  backgroundColor: colors.primaryBlue,
                  py: 2,
                  fontSize: '16px',
                  fontWeight: 'bold',
                  '&:hover': {
                    backgroundColor: '#2E4BFF',
                  },
                  '&:disabled': {
                    backgroundColor: colors.textGrey,
                  }
                }}
              >
                {isLoading ? 'Sending...' : 'Send Reset Link'}
              </Button>
            </Stack>
          </Box>

          {/* Back to Sign In */}
          <Box sx={{ textAlign: 'center' }}>
            <Button
              onClick={() => navigate('/signin')}
              sx={{
                color: colors.textSecondary,
                textTransform: 'none',
                '&:hover': {
                  backgroundColor: 'transparent',
                  color: colors.primaryBlue,
                }
              }}
            >
              ← Back to Sign In
            </Button>
          </Box>
        </Box>
      </Container>

      {/* Success/Error Snackbar */}
      <Snackbar
        open={showSnackbar}
        autoHideDuration={5000}
        onClose={handleCloseSnackbar}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      >
        <Alert
          onClose={handleCloseSnackbar}
          severity={isSuccess ? 'success' : 'error'}
          sx={{
            backgroundColor: isSuccess ? colors.successGreen : colors.errorRed,
            color: 'white',
            '& .MuiAlert-icon': {
              color: 'white',
            }
          }}
        >
          {isSuccess 
            ? 'Password reset link sent to your email!' 
            : error || 'Failed to send reset link. Please try again.'
          }
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default ForgotPasswordScreen;
