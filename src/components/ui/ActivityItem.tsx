import React from 'react';
import { Box, Typography, Divider } from '@mui/material';
import { colors } from '../../theme';

interface ActivityItemProps {
  icon: React.ReactNode;
  title: string;
  subtitle: string;
  time: string;
  color: string;
  isLast?: boolean;
}

const ActivityItem: React.FC<ActivityItemProps> = ({ 
  icon, 
  title, 
  subtitle, 
  time, 
  color,
  isLast = false 
}) => {
  return (
    <>
      <Box sx={{ p: 2, display: 'flex', alignItems: 'center' }}>
        <Box
          sx={{
            p: 1,
            backgroundColor: `${color}20`,
            borderRadius: '8px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            mr: 1.5,
          }}
        >
          <Box sx={{ color, fontSize: 20 }}>
            {icon}
          </Box>
        </Box>
        
        <Box sx={{ flex: 1 }}>
          <Typography
            variant="body2"
            sx={{
              color: colors.textPrimary,
              fontWeight: 'bold',
              mb: 0.25,
            }}
          >
            {title}
          </Typography>
          <Typography
            variant="body2"
            sx={{
              color: colors.textSecondary,
              fontSize: '12px',
            }}
          >
            {subtitle}
          </Typography>
        </Box>
        
        <Typography
          variant="caption"
          sx={{
            color: colors.textGrey,
            fontSize: '11px',
          }}
        >
          {time}
        </Typography>
      </Box>
      
      {!isLast && (
        <Divider 
          sx={{ 
            borderColor: colors.borderColor,
            opacity: 0.5,
          }} 
        />
      )}
    </>
  );
};

export default ActivityItem;
