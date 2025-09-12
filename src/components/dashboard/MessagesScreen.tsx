import React from 'react';
import {
  Box,
  Typography,
  Container,
  Card,
  CardContent,
  Stack,
  Avatar,
  Chip,
} from '@mui/material';
import { useSelector } from 'react-redux';
import { RootState } from '../../store';
import { colors } from '../../theme';

const MessagesScreen: React.FC = () => {
  const { clients } = useSelector((state: RootState) => state.coach);

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
            Messages
          </Typography>
        </Box>

        {/* Messages List */}
        {clients.length === 0 ? (
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
              No messages yet
            </Typography>
            <Typography
              variant="body2"
              sx={{
                color: colors.textSecondary,
                mb: 3,
              }}
            >
              Start a conversation with your clients
            </Typography>
          </Box>
        ) : (
          <Stack spacing={2}>
            {clients.map((client) => (
              <Card
                key={client.id}
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
                <CardContent sx={{ p: 2 }}>
                  <Stack direction="row" alignItems="center" spacing={2}>
                    <Avatar
                      sx={{
                        width: 48,
                        height: 48,
                        backgroundColor: colors.primaryBlue,
                        fontSize: '18px',
                        fontWeight: 'bold',
                      }}
                    >
                      {client.name.charAt(0).toUpperCase()}
                    </Avatar>
                    
                    <Box sx={{ flex: 1 }}>
                      <Typography
                        variant="h6"
                        sx={{
                          color: colors.textPrimary,
                          fontWeight: 'bold',
                          mb: 0.5,
                        }}
                      >
                        {client.name}
                      </Typography>
                      <Typography
                        variant="body2"
                        sx={{
                          color: colors.textSecondary,
                          mb: 1,
                        }}
                      >
                        Last message: "Thanks for the workout plan!"
                      </Typography>
                      <Stack direction="row" spacing={1} alignItems="center">
                        <Chip
                          label={client.status}
                          size="small"
                          sx={{
                            backgroundColor: `${colors.successGreen}20`,
                            color: colors.successGreen,
                            border: `1px solid ${colors.successGreen}40`,
                            fontWeight: 'bold',
                            fontSize: '11px',
                          }}
                        />
                        <Typography
                          variant="caption"
                          sx={{
                            color: colors.textGrey,
                            fontSize: '11px',
                          }}
                        >
                          2 hours ago
                        </Typography>
                      </Stack>
                    </Box>
                    
                    <Box sx={{ textAlign: 'right' }}>
                      <Chip
                        label="2"
                        size="small"
                        sx={{
                          backgroundColor: colors.primaryBlue,
                          color: 'white',
                          fontWeight: 'bold',
                          fontSize: '11px',
                        }}
                      />
                    </Box>
                  </Stack>
                </CardContent>
              </Card>
            ))}
          </Stack>
        )}
      </Container>
    </Box>
  );
};

export default MessagesScreen;
