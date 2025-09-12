import React from 'react';
import { 
  Box, 
  Typography, 
  Container, 
  Button, 
  Stack,
  Card,
  CardContent,
  Grid,
  IconButton,
  AppBar,
  Toolbar
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { 
  FitnessCenter, 
  People, 
  Analytics, 
  Message,
  ArrowBack,
  Language
} from '@mui/icons-material';
import { colors } from '../theme';

const LandingScreen: React.FC = () => {
  const navigate = useNavigate();

  const features = [
    {
      icon: <People sx={{ fontSize: 40, color: colors.primaryBlue }} />,
      title: 'Client Management',
      description: 'Manage your clients, track progress, and monitor subscriptions'
    },
    {
      icon: <FitnessCenter sx={{ fontSize: 40, color: colors.successGreen }} />,
      title: 'Workout Plans',
      description: 'Create and customize workout plans for your clients'
    },
    {
      icon: <Analytics sx={{ fontSize: 40, color: colors.warningOrange }} />,
      title: 'Analytics',
      description: 'Track revenue, client performance, and business insights'
    },
    {
      icon: <Message sx={{ fontSize: 40, color: colors.errorRed }} />,
      title: 'Communication',
      description: 'Stay connected with your clients through messaging'
    }
  ];

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
            onClick={() => navigate('/')}
            sx={{ color: colors.textPrimary }}
          >
            <ArrowBack />
          </IconButton>
          <Typography variant="h6" sx={{ color: colors.textPrimary, flexGrow: 1 }}>
            Athletica
          </Typography>
          <IconButton sx={{ color: colors.textPrimary }}>
            <Language />
          </IconButton>
        </Toolbar>
      </AppBar>

      <Container maxWidth="lg" sx={{ py: 8 }}>
        {/* Hero Section */}
        <Box sx={{ textAlign: 'center', mb: 8 }}>
          <Typography
            variant="h2"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 3,
              fontSize: { xs: '32px', md: '48px' }
            }}
          >
            Guide the challenge, inspire the journey
          </Typography>
          
          <Typography
            variant="h6"
            sx={{
              color: colors.textSecondary,
              mb: 4,
              maxWidth: '600px',
              margin: '0 auto',
              fontSize: { xs: '16px', md: '20px' }
            }}
          >
            The ultimate platform for fitness trainers to manage clients, create workout plans, 
            and grow their business with powerful analytics and communication tools.
          </Typography>

          <Stack 
            direction={{ xs: 'column', sm: 'row' }} 
            spacing={2} 
            justifyContent="center"
            sx={{ mt: 4 }}
          >
            <Button
              variant="contained"
              size="large"
              onClick={() => navigate('/signup')}
              sx={{
                backgroundColor: colors.primaryBlue,
                px: 4,
                py: 1.5,
                fontSize: '16px',
                fontWeight: 'bold',
                '&:hover': {
                  backgroundColor: '#2E4BFF',
                }
              }}
            >
              Get Started
            </Button>
            
            <Button
              variant="outlined"
              size="large"
              onClick={() => navigate('/signin')}
              sx={{
                borderColor: colors.primaryBlue,
                color: colors.primaryBlue,
                px: 4,
                py: 1.5,
                fontSize: '16px',
                fontWeight: 'bold',
                '&:hover': {
                  borderColor: '#2E4BFF',
                  backgroundColor: 'rgba(74, 103, 255, 0.1)',
                }
              }}
            >
              Sign In
            </Button>
          </Stack>
        </Box>

        {/* Features Section */}
        <Box sx={{ mb: 8 }}>
          <Typography
            variant="h3"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              textAlign: 'center',
              mb: 6
            }}
          >
            Everything you need to succeed
          </Typography>

          <Grid container spacing={4}>
            {features.map((feature, index) => (
              <Grid size={{ xs: 12, sm: 6, md: 3 }} key={index}>
                <Card
                  sx={{
                    height: '100%',
                    backgroundColor: colors.cardBackground,
                    border: `1px solid ${colors.borderColor}`,
                    transition: 'transform 0.2s ease-in-out',
                    '&:hover': {
                      transform: 'translateY(-4px)',
                      boxShadow: `0 8px 32px ${colors.primaryBlue}20`,
                    }
                  }}
                >
                  <CardContent sx={{ textAlign: 'center', p: 3 }}>
                    <Box sx={{ mb: 2 }}>
                      {feature.icon}
                    </Box>
                    <Typography
                      variant="h6"
                      sx={{
                        color: colors.textPrimary,
                        fontWeight: 'bold',
                        mb: 1
                      }}
                    >
                      {feature.title}
                    </Typography>
                    <Typography
                      variant="body2"
                      sx={{
                        color: colors.textSecondary,
                        fontSize: '14px'
                      }}
                    >
                      {feature.description}
                    </Typography>
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
        </Box>

        {/* CTA Section */}
        <Box
          sx={{
            textAlign: 'center',
            backgroundColor: colors.cardBackground,
            borderRadius: '16px',
            p: 6,
            border: `1px solid ${colors.borderColor}`,
          }}
        >
          <Typography
            variant="h4"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 2
            }}
          >
            Ready to transform your fitness business?
          </Typography>
          
          <Typography
            variant="body1"
            sx={{
              color: colors.textSecondary,
              mb: 4,
              maxWidth: '500px',
              margin: '0 auto'
            }}
          >
            Join thousands of fitness trainers who are already using Athletica 
            to grow their business and help their clients achieve their goals.
          </Typography>

          <Button
            variant="contained"
            size="large"
            onClick={() => navigate('/signup')}
            sx={{
              backgroundColor: colors.primaryBlue,
              px: 6,
              py: 2,
              fontSize: '18px',
              fontWeight: 'bold',
              '&:hover': {
                backgroundColor: '#2E4BFF',
              }
            }}
          >
            Start Your Free Trial
          </Button>
        </Box>
      </Container>
    </Box>
  );
};

export default LandingScreen;
