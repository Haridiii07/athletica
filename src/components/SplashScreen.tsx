import React, { useEffect, useState } from 'react';
import { Box, Typography, Container, Fade } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { colors } from '../theme';

const SplashScreen: React.FC = () => {
  const navigate = useNavigate();
  const [showContent, setShowContent] = useState(false);

  useEffect(() => {
    // Show content after a brief delay
    const timer = setTimeout(() => {
      setShowContent(true);
    }, 500);

    // Navigate to landing screen after 3 seconds
    const navigateTimer = setTimeout(() => {
      navigate('/landing');
    }, 3000);

    return () => {
      clearTimeout(timer);
      clearTimeout(navigateTimer);
    };
  }, [navigate]);

  return (
    <Box
      sx={{
        minHeight: '100vh',
        backgroundColor: colors.darkBackground,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'column',
      }}
    >
      <Fade in={showContent} timeout={1000}>
        <Container maxWidth="sm" sx={{ textAlign: 'center' }}>
          {/* Logo/Icon */}
          <Box
            sx={{
              width: 120,
              height: 120,
              backgroundColor: colors.primaryBlue,
              borderRadius: '30px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              margin: '0 auto 24px',
              boxShadow: `0 8px 32px ${colors.primaryBlue}40`,
            }}
          >
            <Typography
              sx={{
                fontSize: '60px',
                color: 'white',
                fontWeight: 'bold',
              }}
            >
              💪
            </Typography>
          </Box>

          {/* App Name */}
          <Typography
            variant="h1"
            sx={{
              color: colors.primaryBlue,
              fontWeight: 'bold',
              marginBottom: '12px',
              fontSize: { xs: '28px', sm: '32px' },
            }}
          >
            Athletica
          </Typography>

          {/* Subtitle */}
          <Typography
            variant="body1"
            sx={{
              color: colors.textSecondary,
              fontSize: '16px',
            }}
          >
            App is now running!
          </Typography>
        </Container>
      </Fade>
    </Box>
  );
};

export default SplashScreen;
