import React from 'react';
import {
  Box,
  Typography,
  Container,
  Card,
  CardContent,
  Stack,
  Avatar,
  Button,
  Divider,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
} from '@mui/material';
import {
  Person,
  Email,
  Phone,
  Settings,
  Help,
  Logout,
  Edit,
} from '@mui/icons-material';
import { useSelector, useDispatch } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { RootState, AppDispatch } from '../../store';
import { signOut } from '../../store/authSlice';
import { colors } from '../../theme';

const ProfileScreen: React.FC = () => {
  const navigate = useNavigate();
  const dispatch = useDispatch<AppDispatch>();
  const { coach } = useSelector((state: RootState) => state.auth);

  const handleSignOut = async () => {
    await dispatch(signOut());
    navigate('/signin');
  };

  const menuItems = [
    { icon: <Edit />, label: 'Edit Profile', onClick: () => console.log('Edit Profile') },
    { icon: <Settings />, label: 'Settings', onClick: () => console.log('Settings') },
    { icon: <Help />, label: 'Help & Support', onClick: () => console.log('Help') },
    { icon: <Logout />, label: 'Sign Out', onClick: handleSignOut, color: colors.errorRed },
  ];

  return (
    <Box sx={{ minHeight: '100vh', backgroundColor: colors.darkBackground }}>
      <Container maxWidth="sm" sx={{ py: 3 }}>
        {/* Profile Header */}
        <Card sx={{ mb: 3 }}>
          <CardContent sx={{ p: 3, textAlign: 'center' }}>
            <Avatar
              sx={{
                width: 80,
                height: 80,
                backgroundColor: colors.primaryBlue,
                fontSize: '32px',
                fontWeight: 'bold',
                margin: '0 auto 16px',
              }}
            >
              {coach?.name?.charAt(0).toUpperCase() || 'A'}
            </Avatar>
            
            <Typography
              variant="h5"
              sx={{
                color: colors.textPrimary,
                fontWeight: 'bold',
                mb: 1,
              }}
            >
              {coach?.name || 'Coach'}
            </Typography>
            
            <Typography
              variant="body2"
              sx={{
                color: colors.textSecondary,
                mb: 2,
              }}
            >
              {coach?.bio || 'Fitness Trainer'}
            </Typography>
            
            <Button
              variant="outlined"
              startIcon={<Edit />}
              sx={{
                borderColor: colors.primaryBlue,
                color: colors.primaryBlue,
                '&:hover': {
                  borderColor: '#2E4BFF',
                  backgroundColor: 'rgba(74, 103, 255, 0.1)',
                }
              }}
            >
              Edit Profile
            </Button>
          </CardContent>
        </Card>

        {/* Contact Information */}
        <Card sx={{ mb: 3 }}>
          <CardContent sx={{ p: 3 }}>
            <Typography
              variant="h6"
              sx={{
                color: colors.textPrimary,
                fontWeight: 'bold',
                mb: 2,
              }}
            >
              Contact Information
            </Typography>
            
            <Stack spacing={2}>
              <Stack direction="row" alignItems="center" spacing={2}>
                <Email sx={{ color: colors.textSecondary }} />
                <Typography sx={{ color: colors.textPrimary }}>
                  {coach?.email || 'No email'}
                </Typography>
              </Stack>
              
              <Stack direction="row" alignItems="center" spacing={2}>
                <Phone sx={{ color: colors.textSecondary }} />
                <Typography sx={{ color: colors.textPrimary }}>
                  {coach?.phone || 'No phone'}
                </Typography>
              </Stack>
            </Stack>
          </CardContent>
        </Card>

        {/* Account Information */}
        <Card sx={{ mb: 3 }}>
          <CardContent sx={{ p: 3 }}>
            <Typography
              variant="h6"
              sx={{
                color: colors.textPrimary,
                fontWeight: 'bold',
                mb: 2,
              }}
            >
              Account Information
            </Typography>
            
            <Stack spacing={2}>
              <Stack direction="row" justifyContent="space-between">
                <Typography sx={{ color: colors.textSecondary }}>Subscription Tier</Typography>
                <Typography sx={{ color: colors.textPrimary, fontWeight: 'bold' }}>
                  {coach?.subscriptionTier || 'Free'}
                </Typography>
              </Stack>
              
              <Stack direction="row" justifyContent="space-between">
                <Typography sx={{ color: colors.textSecondary }}>Client Limit</Typography>
                <Typography sx={{ color: colors.textPrimary, fontWeight: 'bold' }}>
                  {coach?.clientLimit || 3}
                </Typography>
              </Stack>
              
              <Stack direction="row" justifyContent="space-between">
                <Typography sx={{ color: colors.textSecondary }}>Member Since</Typography>
                <Typography sx={{ color: colors.textPrimary, fontWeight: 'bold' }}>
                  {coach?.createdAt ? new Date(coach.createdAt).toLocaleDateString() : 'N/A'}
                </Typography>
              </Stack>
            </Stack>
          </CardContent>
        </Card>

        {/* Menu Items */}
        <Card>
          <CardContent sx={{ p: 0 }}>
            <List>
              {menuItems.map((item, index) => (
                <React.Fragment key={index}>
                  <ListItem
                    onClick={item.onClick}
                    sx={{
                      py: 2,
                      px: 3,
                      cursor: 'pointer',
                      '&:hover': {
                        backgroundColor: 'rgba(74, 103, 255, 0.1)',
                      },
                    }}
                  >
                    <ListItemIcon>
                      {React.cloneElement(item.icon, {
                        sx: { 
                          color: item.color || colors.textSecondary,
                          fontSize: 20,
                        },
                      })}
                    </ListItemIcon>
                    <ListItemText
                      primary={item.label}
                      primaryTypographyProps={{
                        sx: {
                          color: item.color || colors.textPrimary,
                          fontWeight: item.color ? 'bold' : 'normal',
                        },
                      }}
                    />
                  </ListItem>
                  {index < menuItems.length - 1 && (
                    <Divider sx={{ borderColor: colors.borderColor }} />
                  )}
                </React.Fragment>
              ))}
            </List>
          </CardContent>
        </Card>
      </Container>
    </Box>
  );
};

export default ProfileScreen;
