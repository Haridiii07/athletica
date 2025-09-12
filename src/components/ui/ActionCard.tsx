import React from 'react';
import { Card, CardContent, Box, Typography } from '@mui/material';
import { colors } from '../../theme';

interface ActionCardProps {
  title: string;
  subtitle: string;
  icon: React.ReactNode;
  color: string;
  onClick: () => void;
}

const ActionCard: React.FC<ActionCardProps> = ({ 
  title, 
  subtitle, 
  icon, 
  color, 
  onClick 
}) => {
  return (
    <Card
      onClick={onClick}
      sx={{
        backgroundColor: colors.cardBackground,
        border: `1px solid ${colors.borderColor}`,
        borderRadius: '12px',
        cursor: 'pointer',
        transition: 'transform 0.2s ease-in-out',
        '&:hover': {
          transform: 'translateY(-2px)',
          boxShadow: `0 8px 32px ${color}20`,
        },
      }}
    >
      <CardContent sx={{ p: 2 }}>
        <Box
          sx={{
            p: 1,
            backgroundColor: `${color}20`,
            borderRadius: '8px',
            display: 'inline-flex',
            alignItems: 'center',
            justifyContent: 'center',
            mb: 1.5,
          }}
        >
          <Box sx={{ color, fontSize: 24 }}>
            {icon}
          </Box>
        </Box>
        
        <Typography
          variant="subtitle2"
          sx={{
            color: colors.textPrimary,
            fontWeight: 'bold',
            mb: 0.5,
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
      </CardContent>
    </Card>
  );
};

export default ActionCard;
