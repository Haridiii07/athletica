import React from 'react';
import {
  Box,
  Typography,
  Container,
  Card,
  CardContent,
  Stack,
  Chip,
  Fab,
} from '@mui/material';
import { Add } from '@mui/icons-material';
import { useSelector } from 'react-redux';
import { RootState } from '../../store';
import { colors } from '../../theme';

const PlansScreen: React.FC = () => {
  const { plans, isLoading } = useSelector((state: RootState) => state.coach);

  if (isLoading) {
    return (
      <Box sx={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        minHeight: '50vh' 
      }}>
        <Typography sx={{ color: colors.textSecondary }}>Loading plans...</Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: '100vh', backgroundColor: colors.darkBackground }}>
      <Container maxWidth="lg" sx={{ py: 3 }}>
        {/* Header */}
        <Box sx={{ mb: 3 }}>
          <Typography
            variant="h5"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
            }}
          >
            Workout Plans
          </Typography>
        </Box>

        {/* Plans List */}
        {plans.length === 0 ? (
          <Box sx={{ 
            textAlign: 'center', 
            py: 8,
            backgroundColor: colors.cardBackground,
            borderRadius: '12px',
            border: `1px solid ${colors.borderColor}`,
          }}>
            <Typography
              variant="h6"
              sx={{
                color: colors.textPrimary,
                fontWeight: 'bold',
                mb: 1,
              }}
            >
              No workout plans yet
            </Typography>
            <Typography
              variant="body2"
              sx={{
                color: colors.textSecondary,
                mb: 3,
              }}
            >
              Create your first workout plan to get started
            </Typography>
          </Box>
        ) : (
          <Stack spacing={2}>
            {plans.map((plan) => (
              <Card
                key={plan.id}
                sx={{
                  backgroundColor: colors.cardBackground,
                  border: `1px solid ${colors.borderColor}`,
                  borderRadius: '12px',
                  cursor: 'pointer',
                  transition: 'transform 0.2s ease-in-out',
                  '&:hover': {
                    transform: 'translateY(-2px)',
                    boxShadow: `0 8px 32px ${colors.primaryBlue}20`,
                  },
                }}
              >
                <CardContent sx={{ p: 3 }}>
                  <Stack direction="row" justifyContent="space-between" alignItems="flex-start">
                    <Box sx={{ flex: 1 }}>
                      <Typography
                        variant="h6"
                        sx={{
                          color: colors.textPrimary,
                          fontWeight: 'bold',
                          mb: 1,
                        }}
                      >
                        {plan.name}
                      </Typography>
                      <Typography
                        variant="body2"
                        sx={{
                          color: colors.textSecondary,
                          mb: 2,
                        }}
                      >
                        {plan.description}
                      </Typography>
                      <Stack direction="row" spacing={1} alignItems="center">
                        <Chip
                          label={plan.isActive ? 'Active' : 'Inactive'}
                          size="small"
                          sx={{
                            backgroundColor: plan.isActive 
                              ? `${colors.successGreen}20` 
                              : `${colors.textGrey}20`,
                            color: plan.isActive 
                              ? colors.successGreen 
                              : colors.textGrey,
                            border: `1px solid ${plan.isActive 
                              ? `${colors.successGreen}40` 
                              : `${colors.textGrey}40`}`,
                            fontWeight: 'bold',
                            fontSize: '11px',
                          }}
                        />
                        <Typography
                          variant="body2"
                          sx={{
                            color: colors.textSecondary,
                            fontSize: '14px',
                          }}
                        >
                          {plan.duration} days • {plan.price} EGP
                        </Typography>
                      </Stack>
                    </Box>
                    <Box sx={{ textAlign: 'right' }}>
                      <Typography
                        variant="h6"
                        sx={{
                          color: colors.primaryBlue,
                          fontWeight: 'bold',
                        }}
                      >
                        {plan.revenue} EGP
                      </Typography>
                      <Typography
                        variant="caption"
                        sx={{
                          color: colors.textGrey,
                          fontSize: '11px',
                        }}
                      >
                        Revenue
                      </Typography>
                    </Box>
                  </Stack>
                </CardContent>
              </Card>
            ))}
          </Stack>
        )}

        {/* Floating Action Button */}
        <Fab
          color="primary"
          sx={{
            position: 'fixed',
            bottom: 80,
            right: 16,
            backgroundColor: colors.primaryBlue,
            '&:hover': {
              backgroundColor: '#2E4BFF',
            },
          }}
        >
          <Add />
        </Fab>
      </Container>
    </Box>
  );
};

export default PlansScreen;
