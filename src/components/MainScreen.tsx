import React, { useState, useEffect } from 'react';
import {
  Box,
  BottomNavigation,
  BottomNavigationAction,
  Paper,
} from '@mui/material';
import {
  Home,
  People,
  FitnessCenter,
  Message,
  Person,
} from '@mui/icons-material';
import { useDispatch } from 'react-redux';
import { Routes, Route } from 'react-router-dom';
import { AppDispatch } from '../store';
import { loadClients, loadPlans } from '../store/coachSlice';
import { colors } from '../theme';
import { TabValue } from '../types';

// Import screen components
import HomeScreen from './dashboard/HomeScreen';
import ClientsScreen from './dashboard/ClientsScreen';
import PlansScreen from './dashboard/PlansScreen';
import MessagesScreen from './dashboard/MessagesScreen';
import ProfileScreen from './dashboard/ProfileScreen';

const MainScreen: React.FC = () => {
  const dispatch = useDispatch<AppDispatch>();
  const [currentTab, setCurrentTab] = useState<TabValue>('home');

  useEffect(() => {
    // Load initial data when component mounts
    dispatch(loadClients());
    dispatch(loadPlans());
  }, [dispatch]);

  const handleTabChange = (event: React.SyntheticEvent, newValue: TabValue) => {
    setCurrentTab(newValue);
  };

  const renderScreen = () => {
    switch (currentTab) {
      case 'home':
        return <HomeScreen />;
      case 'clients':
        return <ClientsScreen />;
      case 'plans':
        return <PlansScreen />;
      case 'messages':
        return <MessagesScreen />;
      case 'profile':
        return <ProfileScreen />;
      default:
        return <HomeScreen />;
    }
  };

  return (
    <Box sx={{ 
      minHeight: '100vh', 
      backgroundColor: colors.darkBackground,
      display: 'flex',
      flexDirection: 'column'
    }}>
      {/* Main Content */}
      <Box sx={{ 
        flex: 1, 
        pb: 7, // Space for bottom navigation
        overflow: 'auto'
      }}>
        {renderScreen()}
      </Box>

      {/* Bottom Navigation */}
      <Paper
        elevation={8}
        sx={{
          position: 'fixed',
          bottom: 0,
          left: 0,
          right: 0,
          backgroundColor: colors.cardBackground,
          borderTop: `1px solid ${colors.borderColor}`,
          zIndex: 1000,
        }}
      >
        <BottomNavigation
          value={currentTab}
          onChange={handleTabChange}
          sx={{
            backgroundColor: 'transparent',
            '& .MuiBottomNavigationAction-root': {
              color: colors.textSecondary,
              '&.Mui-selected': {
                color: colors.primaryBlue,
                backgroundColor: 'rgba(74, 103, 255, 0.1)',
                borderRadius: '12px',
                margin: '8px 4px',
              },
            },
          }}
        >
          <BottomNavigationAction
            label="Home"
            value="home"
            icon={<Home />}
            sx={{
              '& .MuiBottomNavigationAction-label': {
                fontSize: '12px',
                fontWeight: currentTab === 'home' ? 'bold' : 'normal',
              },
            }}
          />
          <BottomNavigationAction
            label="Clients"
            value="clients"
            icon={<People />}
            sx={{
              '& .MuiBottomNavigationAction-label': {
                fontSize: '12px',
                fontWeight: currentTab === 'clients' ? 'bold' : 'normal',
              },
            }}
          />
          <BottomNavigationAction
            label="Plans"
            value="plans"
            icon={<FitnessCenter />}
            sx={{
              '& .MuiBottomNavigationAction-label': {
                fontSize: '12px',
                fontWeight: currentTab === 'plans' ? 'bold' : 'normal',
              },
            }}
          />
          <BottomNavigationAction
            label="Messages"
            value="messages"
            icon={<Message />}
            sx={{
              '& .MuiBottomNavigationAction-label': {
                fontSize: '12px',
                fontWeight: currentTab === 'messages' ? 'bold' : 'normal',
              },
            }}
          />
          <BottomNavigationAction
            label="Profile"
            value="profile"
            icon={<Person />}
            sx={{
              '& .MuiBottomNavigationAction-label': {
                fontSize: '12px',
                fontWeight: currentTab === 'profile' ? 'bold' : 'normal',
              },
            }}
          />
        </BottomNavigation>
      </Paper>
    </Box>
  );
};

export default MainScreen;
