import React from 'react';
import {
  Box,
  Typography,
  Container,
  Grid,
  Card,
  CardContent,
  IconButton,
  Avatar,
  Stack,
  Chip,
} from '@mui/material';
import {
  NotificationsOutlined,
  People,
  CheckCircle,
  AttachMoney,
  Analytics,
  PersonAdd,
  FitnessCenter,
  TrendingUp,
} from '@mui/icons-material';
import { useSelector } from 'react-redux';
import { RootState } from '../../store';
import { colors } from '../../theme';
import RevenueChart from '../charts/RevenueChart';
import StatCard from '../ui/StatCard';
import AnalyticsCard from '../ui/AnalyticsCard';
import ActionCard from '../ui/ActionCard';
import ActivityItem from '../ui/ActivityItem';

const HomeScreen: React.FC = () => {
  const { coach } = useSelector((state: RootState) => state.auth);
  const { 
    totalClients, 
    activeClients, 
    totalRevenue, 
    isLoading 
  } = useSelector((state: RootState) => state.coach);

  const recentActivities = [
    {
      icon: <PersonAdd sx={{ color: colors.successGreen }} />,
      title: 'New client registered',
      subtitle: 'Ahmed joined your program',
      time: '2 hours ago',
      color: colors.successGreen,
    },
    {
      icon: <FitnessCenter sx={{ color: colors.primaryBlue }} />,
      title: 'Workout plan completed',
      subtitle: 'Fat loss plan by Sarah',
      time: '4 hours ago',
      color: colors.primaryBlue,
    },
    {
      icon: <AttachMoney sx={{ color: colors.warningOrange }} />,
      title: 'Payment received',
      subtitle: '500 EGP from Mohamed',
      time: '1 day ago',
      color: colors.warningOrange,
    },
  ];

  return (
    <Box sx={{ minHeight: '100vh', backgroundColor: colors.darkBackground }}>
      <Container maxWidth="lg" sx={{ py: 3 }}>
        {/* Header */}
        <Box sx={{ mb: 4 }}>
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
              {coach?.name?.charAt(0).toUpperCase() || 'A'}
            </Avatar>
            <Box sx={{ flex: 1 }}>
              <Typography
                variant="body2"
                sx={{ color: colors.textSecondary }}
              >
                Welcome back,
              </Typography>
              <Typography
                variant="h5"
                sx={{
                  color: colors.textPrimary,
                  fontWeight: 'bold',
                }}
              >
                {coach?.name || 'Coach'}
              </Typography>
            </Box>
            <IconButton
              sx={{
                color: colors.textPrimary,
                backgroundColor: 'rgba(74, 103, 255, 0.1)',
                '&:hover': {
                  backgroundColor: 'rgba(74, 103, 255, 0.2)',
                }
              }}
            >
              <NotificationsOutlined />
            </IconButton>
          </Stack>
        </Box>

        {/* Quick Stats */}
        <Grid container spacing={2} sx={{ mb: 4 }}>
          <Grid size={{ xs: 12, sm: 4 }}>
            <StatCard
              title="Total Clients"
              value={totalClients.toString()}
              icon={<People />}
              color={colors.primaryBlue}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <StatCard
              title="Active Clients"
              value={activeClients.toString()}
              icon={<CheckCircle />}
              color={colors.successGreen}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <StatCard
              title="Revenue"
              value={`${totalRevenue.toFixed(0)} EGP`}
              icon={<AttachMoney />}
              color={colors.warningOrange}
            />
          </Grid>
        </Grid>

        {/* Revenue Chart */}
        <Card sx={{ mb: 4 }}>
          <CardContent sx={{ p: 3 }}>
            <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ mb: 3 }}>
              <Typography
                variant="h6"
                sx={{
                  color: colors.textPrimary,
                  fontWeight: 'bold',
                }}
              >
                Revenue Overview
              </Typography>
              <Chip
                label="View All"
                sx={{
                  backgroundColor: 'rgba(74, 103, 255, 0.1)',
                  color: colors.primaryBlue,
                  fontWeight: 'bold',
                  cursor: 'pointer',
                  '&:hover': {
                    backgroundColor: 'rgba(74, 103, 255, 0.2)',
                  }
                }}
              />
            </Stack>
            <RevenueChart />
          </CardContent>
        </Card>

        {/* Analytics Section */}
        <Box sx={{ mb: 4 }}>
          <Typography
            variant="h6"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 2,
            }}
          >
            Analytics & Reports
          </Typography>
          <Grid container spacing={2}>
            <Grid size={{ xs: 12, sm: 6 }}>
              <AnalyticsCard
                title="Analytics Dashboard"
                subtitle="Comprehensive overview"
                icon={<Analytics />}
                color={colors.primaryBlue}
                onClick={() => console.log('Analytics Dashboard')}
              />
            </Grid>
            <Grid size={{ xs: 12, sm: 6 }}>
              <AnalyticsCard
                title="Revenue Analytics"
                subtitle="Financial insights"
                icon={<TrendingUp />}
                color={colors.successGreen}
                onClick={() => console.log('Revenue Analytics')}
              />
            </Grid>
          </Grid>
        </Box>

        {/* Quick Actions */}
        <Box sx={{ mb: 4 }}>
          <Typography
            variant="h6"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 2,
            }}
          >
            Quick Actions
          </Typography>
          <Grid container spacing={2}>
            <Grid size={{ xs: 12, sm: 6 }}>
              <ActionCard
                title="Add Client"
                subtitle="Register new client"
                icon={<PersonAdd />}
                color={colors.primaryBlue}
                onClick={() => console.log('Add Client')}
              />
            </Grid>
            <Grid size={{ xs: 12, sm: 6 }}>
              <ActionCard
                title="Create Plan"
                subtitle="Design workout plan"
                icon={<FitnessCenter />}
                color={colors.successGreen}
                onClick={() => console.log('Create Plan')}
              />
            </Grid>
          </Grid>
        </Box>

        {/* Recent Activity */}
        <Box>
          <Typography
            variant="h6"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 2,
            }}
          >
            Recent Activity
          </Typography>
          <Card>
            <CardContent sx={{ p: 0 }}>
              {recentActivities.map((activity, index) => (
                <ActivityItem
                  key={index}
                  icon={activity.icon}
                  title={activity.title}
                  subtitle={activity.subtitle}
                  time={activity.time}
                  color={activity.color}
                  isLast={index === recentActivities.length - 1}
                />
              ))}
            </CardContent>
          </Card>
        </Box>
      </Container>
    </Box>
  );
};

export default HomeScreen;
