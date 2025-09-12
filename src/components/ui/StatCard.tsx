import React from 'react';
import { Card, CardContent, Box, Typography } from '@mui/material';
import { colors } from '../../theme';

interface StatCardProps {
  title: string;
  value: string;
  icon: React.ReactNode;
  color: string;
}

const StatCard: React.FC<StatCardProps> = ({ title, value, icon, color }) => {
  return (
    <Card
      sx={{
        backgroundColor: colors.cardBackground,
        border: `1px solid ${colors.borderColor}`,
        borderRadius: '12px',
        height: '100%',
      }}
    >
      <CardContent sx={{ p: 2 }}>
        <Box sx={{ display: 'flex', alignItems: 'flex-start', mb: 1 }}>
          <Box
            sx={{
              p: 1,
              backgroundColor: `${color}20`,
              borderRadius: '8px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            <Box sx={{ color, fontSize: 20 }}>
              {icon}
            </Box>
          </Box>
        </Box>
        
        <Typography
          variant="h5"
          sx={{
            color: colors.textPrimary,
            fontWeight: 'bold',
            mb: 0.5,
          }}
        >
          {value}
        </Typography>
        
        <Typography
          variant="body2"
          sx={{
            color: colors.textSecondary,
            fontSize: '12px',
          }}
        >
          {title}
        </Typography>
      </CardContent>
    </Card>
  );
};

export default StatCard;
