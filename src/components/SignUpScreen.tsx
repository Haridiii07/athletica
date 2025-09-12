import React, { useState } from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  Container,
  Stack,
  Divider,
  IconButton,
  InputAdornment,
  Alert,
  Snackbar,
  AppBar,
  Toolbar,
} from '@mui/material';
import {
  Visibility,
  VisibilityOff,
  ArrowBack,
  Google,
  Facebook,
  Apple,
} from '@mui/icons-material';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, Link } from 'react-router-dom';
import { AppDispatch, RootState } from '../store';
import { signUp, signInWithGoogle, signInWithFacebook, signInWithApple, clearError } from '../store/authSlice';
import { colors } from '../theme';

interface SignUpForm {
  name: string;
  email: string;
  phone: string;
  password: string;
  confirmPassword: string;
}

const schema = yup.object({
  name: yup.string().min(2, 'Name must be at least 2 characters').required('Name is required'),
  email: yup.string().email('Please enter a valid email').required('Email is required'),
  phone: yup.string().min(10, 'Please enter a valid phone number').required('Phone is required'),
  password: yup.string().min(6, 'Password must be at least 6 characters').required('Password is required'),
  confirmPassword: yup.string()
    .oneOf([yup.ref('password')], 'Passwords must match')
    .required('Please confirm your password'),
});

const SignUpScreen: React.FC = () => {
  const navigate = useNavigate();
  const dispatch = useDispatch<AppDispatch>();
  const { isLoading, error } = useSelector((state: RootState) => state.auth);
  
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [showSnackbar, setShowSnackbar] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<SignUpForm>({
    resolver: yupResolver(schema),
  });

  const onSubmit = async (data: SignUpForm) => {
    const { confirmPassword, ...signUpData } = data;
    const result = await dispatch(signUp(signUpData));
    if (signUp.fulfilled.match(result)) {
      navigate('/dashboard');
    } else {
      setShowSnackbar(true);
    }
  };

  const handleSocialSignIn = async (provider: 'google' | 'facebook' | 'apple') => {
    try {
      let result;
      const mockToken = `mock_${provider}_token_${Date.now()}`;
      
      switch (provider) {
        case 'google':
          result = await dispatch(signInWithGoogle({
            googleToken: mockToken,
            name: 'Google User',
            email: 'google@example.com',
          }));
          break;
        case 'facebook':
          result = await dispatch(signInWithFacebook({
            facebookToken: mockToken,
            name: 'Facebook User',
            email: 'facebook@example.com',
          }));
          break;
        case 'apple':
          result = await dispatch(signInWithApple({
            appleToken: mockToken,
            name: 'Apple User',
            email: 'apple@example.com',
          }));
          break;
      }

      if (result.type.endsWith('/fulfilled')) {
        navigate('/dashboard');
      } else {
        setShowSnackbar(true);
      }
    } catch (error) {
      setShowSnackbar(true);
    }
  };

  const handleCloseSnackbar = () => {
    setShowSnackbar(false);
    dispatch(clearError());
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
            onClick={() => navigate('/landing')}
            sx={{ color: colors.textPrimary }}
          >
            <ArrowBack />
          </IconButton>
          <Typography variant="h6" sx={{ color: colors.textPrimary, flexGrow: 1 }}>
            Sign Up
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
            Create Account
          </Typography>
          
          <Typography
            variant="body1"
            sx={{
              color: colors.textSecondary,
              mb: 4,
              textAlign: 'center'
            }}
          >
            Join Athletica and start growing your fitness business
          </Typography>

          {/* Sign Up Form */}
          <Box component="form" onSubmit={handleSubmit(onSubmit)} sx={{ mb: 4 }}>
            <Stack spacing={3}>
              {/* Name Field */}
              <TextField
                {...register('name')}
                label="Full Name"
                fullWidth
                error={!!errors.name}
                helperText={errors.name?.message}
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <Typography sx={{ color: colors.textSecondary }}>👤</Typography>
                    </InputAdornment>
                  ),
                }}
              />

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
                      <Typography sx={{ color: colors.textSecondary }}>@</Typography>
                    </InputAdornment>
                  ),
                }}
              />

              {/* Phone Field */}
              <TextField
                {...register('phone')}
                label="Phone Number"
                type="tel"
                fullWidth
                error={!!errors.phone}
                helperText={errors.phone?.message}
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <Typography sx={{ color: colors.textSecondary }}>📱</Typography>
                    </InputAdornment>
                  ),
                }}
              />

              {/* Password Field */}
              <TextField
                {...register('password')}
                label="Password"
                type={showPassword ? 'text' : 'password'}
                fullWidth
                error={!!errors.password}
                helperText={errors.password?.message}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowPassword(!showPassword)}
                        edge="end"
                        sx={{ color: colors.textSecondary }}
                      >
                        {showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />

              {/* Confirm Password Field */}
              <TextField
                {...register('confirmPassword')}
                label="Confirm Password"
                type={showConfirmPassword ? 'text' : 'password'}
                fullWidth
                error={!!errors.confirmPassword}
                helperText={errors.confirmPassword?.message}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                        edge="end"
                        sx={{ color: colors.textSecondary }}
                      >
                        {showConfirmPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />

              {/* Sign Up Button */}
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
                {isLoading ? 'Creating Account...' : 'Create Account'}
              </Button>
            </Stack>
          </Box>

          {/* Sign In Link */}
          <Box sx={{ textAlign: 'center', mb: 4 }}>
            <Typography sx={{ color: colors.textSecondary }}>
              Already have an account?{' '}
              <Button
                component={Link}
                to="/signin"
                sx={{
                  color: colors.primaryBlue,
                  fontWeight: 'bold',
                  textTransform: 'none',
                  '&:hover': {
                    backgroundColor: 'transparent',
                  }
                }}
              >
                Sign In
              </Button>
            </Typography>
          </Box>

          {/* Divider */}
          <Box sx={{ display: 'flex', alignItems: 'center', mb: 4 }}>
            <Divider sx={{ flexGrow: 1, borderColor: colors.borderColor }} />
            <Typography sx={{ px: 2, color: colors.textSecondary }}>
              or continue with
            </Typography>
            <Divider sx={{ flexGrow: 1, borderColor: colors.borderColor }} />
          </Box>

          {/* Social Sign In Buttons */}
          <Stack spacing={2}>
            {/* Apple Sign In */}
            <Button
              variant="outlined"
              size="large"
              onClick={() => handleSocialSignIn('apple')}
              startIcon={<Apple />}
              sx={{
                borderColor: colors.borderColor,
                color: colors.textPrimary,
                py: 1.5,
                '&:hover': {
                  borderColor: colors.primaryBlue,
                  backgroundColor: 'rgba(74, 103, 255, 0.1)',
                }
              }}
            >
              Continue with Apple
            </Button>

            {/* Google and Facebook Row */}
            <Stack direction="row" spacing={2}>
              <Button
                variant="outlined"
                size="large"
                onClick={() => handleSocialSignIn('google')}
                startIcon={<Google />}
                sx={{
                  flex: 1,
                  borderColor: colors.borderColor,
                  color: colors.textPrimary,
                  py: 1.5,
                  '&:hover': {
                    borderColor: colors.primaryBlue,
                    backgroundColor: 'rgba(74, 103, 255, 0.1)',
                  }
                }}
              >
                Google
              </Button>
              
              <Button
                variant="outlined"
                size="large"
                onClick={() => handleSocialSignIn('facebook')}
                startIcon={<Facebook />}
                sx={{
                  flex: 1,
                  borderColor: colors.borderColor,
                  color: colors.textPrimary,
                  py: 1.5,
                  '&:hover': {
                    borderColor: colors.primaryBlue,
                    backgroundColor: 'rgba(74, 103, 255, 0.1)',
                  }
                }}
              >
                Facebook
              </Button>
            </Stack>
          </Stack>
        </Box>
      </Container>

      {/* Error Snackbar */}
      <Snackbar
        open={showSnackbar}
        autoHideDuration={5000}
        onClose={handleCloseSnackbar}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      >
        <Alert
          onClose={handleCloseSnackbar}
          severity="error"
          sx={{
            backgroundColor: colors.errorRed,
            color: 'white',
            '& .MuiAlert-icon': {
              color: 'white',
            }
          }}
        >
          {error || 'Sign up failed. Please try again.'}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default SignUpScreen;
