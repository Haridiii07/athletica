import React from 'react';
import {
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Area,
  ComposedChart,
} from 'recharts';
import { Box } from '@mui/material';
import { colors } from '../../theme';

const data = [
  { name: 'Mon', revenue: 1500 },
  { name: 'Tue', revenue: 2200 },
  { name: 'Wed', revenue: 1800 },
  { name: 'Thu', revenue: 3100 },
  { name: 'Fri', revenue: 2500 },
  { name: 'Sat', revenue: 3800 },
  { name: 'Sun', revenue: 2900 },
];

const RevenueChart: React.FC = () => {
  return (
    <Box sx={{ height: 200, width: '100%' }}>
      <ResponsiveContainer width="100%" height="100%">
        <ComposedChart data={data}>
          <CartesianGrid 
            strokeDasharray="3 3" 
            stroke={colors.borderColor}
            strokeOpacity={0.3}
          />
          <XAxis 
            dataKey="name" 
            axisLine={false}
            tickLine={false}
            tick={{ 
              fill: colors.textSecondary, 
              fontSize: 12, 
              fontWeight: 'bold' 
            }}
          />
          <YAxis 
            axisLine={false}
            tickLine={false}
            tick={{ 
              fill: colors.textSecondary, 
              fontSize: 12, 
              fontWeight: 'bold' 
            }}
            tickFormatter={(value) => `${value}K`}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: colors.cardBackground,
              border: `1px solid ${colors.borderColor}`,
              borderRadius: '8px',
              color: colors.textPrimary,
            }}
            labelStyle={{ color: colors.textPrimary }}
            formatter={(value: number) => [`${value} EGP`, 'Revenue']}
          />
          <Area
            type="monotone"
            dataKey="revenue"
            stroke={colors.primaryBlue}
            fill={`url(#colorGradient)`}
            strokeWidth={3}
            dot={{
              fill: colors.primaryBlue,
              stroke: colors.cardBackground,
              strokeWidth: 2,
              r: 4,
            }}
          />
          <defs>
            <linearGradient id="colorGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor={colors.primaryBlue} stopOpacity={0.3}/>
              <stop offset="95%" stopColor={colors.primaryBlue} stopOpacity={0.1}/>
            </linearGradient>
          </defs>
        </ComposedChart>
      </ResponsiveContainer>
    </Box>
  );
};

export default RevenueChart;
