import React, { useState } from 'react';
import {
  Box,
  Typography,
  Container,
  TextField,
  InputAdornment,
  Chip,
  Card,
  CardContent,
  Avatar,
  IconButton,
  Menu,
  MenuItem,
  ListItemIcon,
  ListItemText,
  Fab,
  Stack,
  Button,
} from '@mui/material';
import {
  Search,
  MoreVert,
  Visibility,
  Edit,
  Message,
  Delete,
  Add,
} from '@mui/icons-material';
import { useSelector, useDispatch } from 'react-redux';
import { RootState, AppDispatch } from '../../store';
import { colors } from '../../theme';
import { Client } from '../../types';

const ClientsScreen: React.FC = () => {
  const dispatch = useDispatch<AppDispatch>();
  const { clients, isLoading } = useSelector((state: RootState) => state.coach);
  
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [selectedClient, setSelectedClient] = useState<Client | null>(null);

  const filterOptions = ['All', 'Active', 'Inactive', 'Pending'];

  const filteredClients = clients.filter(client => {
    const matchesSearch = client.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         (client.email?.toLowerCase().includes(searchQuery.toLowerCase()) ?? false);
    
    const matchesFilter = selectedFilter === 'All' || 
                         (selectedFilter === 'Active' && client.status === 'active') ||
                         (selectedFilter === 'Inactive' && client.status === 'inactive') ||
                         (selectedFilter === 'Pending' && client.status === 'pending');
    
    return matchesSearch && matchesFilter;
  });

  const handleMenuOpen = (event: React.MouseEvent<HTMLElement>, client: Client) => {
    setAnchorEl(event.currentTarget);
    setSelectedClient(client);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
    setSelectedClient(null);
  };

  const handleClientAction = (action: string) => {
    if (!selectedClient) return;
    
    switch (action) {
      case 'view':
        console.log('View client:', selectedClient.name);
        break;
      case 'edit':
        console.log('Edit client:', selectedClient.name);
        break;
      case 'message':
        console.log('Message client:', selectedClient.name);
        break;
      case 'delete':
        console.log('Delete client:', selectedClient.name);
        break;
    }
    handleMenuClose();
  };

  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case 'active':
        return colors.successGreen;
      case 'inactive':
        return colors.errorRed;
      case 'pending':
        return colors.warningOrange;
      default:
        return colors.textGrey;
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  };

  if (isLoading) {
    return (
      <Box sx={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        minHeight: '50vh' 
      }}>
        <Typography sx={{ color: colors.textSecondary }}>Loading clients...</Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: '100vh', backgroundColor: colors.darkBackground }}>
      <Container maxWidth="lg" sx={{ py: 3 }}>
        {/* Header */}
        <Box sx={{ mb: 3 }}>
          <Stack direction="row" justifyContent="space-between" alignItems="center">
            <Typography
              variant="h5"
              sx={{
                color: colors.textPrimary,
                fontWeight: 'bold',
              }}
            >
              Clients
            </Typography>
            <Typography
              variant="body2"
              sx={{
                color: colors.textSecondary,
              }}
            >
              {clients.length} clients
            </Typography>
          </Stack>
        </Box>

        {/* Search and Filter */}
        <Box sx={{ mb: 3 }}>
          <TextField
            fullWidth
            placeholder="Search clients..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <Search sx={{ color: colors.textSecondary }} />
                </InputAdornment>
              ),
            }}
            sx={{
              mb: 2,
              '& .MuiOutlinedInput-root': {
                backgroundColor: colors.cardBackground,
              },
            }}
          />
          
          <Stack direction="row" spacing={1} sx={{ overflowX: 'auto', pb: 1 }}>
            {filterOptions.map((filter) => (
              <Chip
                key={filter}
                label={filter}
                onClick={() => setSelectedFilter(filter)}
                variant={selectedFilter === filter ? 'filled' : 'outlined'}
                sx={{
                  backgroundColor: selectedFilter === filter ? colors.primaryBlue : 'transparent',
                  color: selectedFilter === filter ? 'white' : colors.textPrimary,
                  borderColor: selectedFilter === filter ? colors.primaryBlue : colors.borderColor,
                  fontWeight: selectedFilter === filter ? 'bold' : 'normal',
                  cursor: 'pointer',
                  '&:hover': {
                    backgroundColor: selectedFilter === filter 
                      ? colors.primaryBlue 
                      : 'rgba(74, 103, 255, 0.1)',
                  },
                }}
              />
            ))}
          </Stack>
        </Box>

        {/* Client List */}
        {filteredClients.length === 0 ? (
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
              No clients found
            </Typography>
            <Typography
              variant="body2"
              sx={{
                color: colors.textSecondary,
                mb: 3,
              }}
            >
              Start by adding your first client
            </Typography>
            <Button
              variant="contained"
              startIcon={<Add />}
              sx={{
                backgroundColor: colors.primaryBlue,
                '&:hover': {
                  backgroundColor: '#2E4BFF',
                }
              }}
            >
              Add Client
            </Button>
          </Box>
        ) : (
          <Stack spacing={2}>
            {filteredClients.map((client) => (
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
                        {client.email || 'No email'}
                      </Typography>
                      <Stack direction="row" spacing={1} alignItems="center">
                        <Chip
                          label={getStatusLabel(client.status)}
                          size="small"
                          sx={{
                            backgroundColor: `${getStatusColor(client.status)}20`,
                            color: getStatusColor(client.status),
                            border: `1px solid ${getStatusColor(client.status)}40`,
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
                          {Math.round(client.subscriptionProgress * 100)}% progress
                        </Typography>
                      </Stack>
                    </Box>
                    
                    <IconButton
                      onClick={(e) => handleMenuOpen(e, client)}
                      sx={{ color: colors.textSecondary }}
                    >
                      <MoreVert />
                    </IconButton>
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

        {/* Context Menu */}
        <Menu
          anchorEl={anchorEl}
          open={Boolean(anchorEl)}
          onClose={handleMenuClose}
          PaperProps={{
            sx: {
              backgroundColor: colors.cardBackground,
              border: `1px solid ${colors.borderColor}`,
            },
          }}
        >
          <MenuItem onClick={() => handleClientAction('view')}>
            <ListItemIcon>
              <Visibility sx={{ color: colors.textSecondary }} />
            </ListItemIcon>
            <ListItemText>View Details</ListItemText>
          </MenuItem>
          <MenuItem onClick={() => handleClientAction('edit')}>
            <ListItemIcon>
              <Edit sx={{ color: colors.textSecondary }} />
            </ListItemIcon>
            <ListItemText>Edit</ListItemText>
          </MenuItem>
          <MenuItem onClick={() => handleClientAction('message')}>
            <ListItemIcon>
              <Message sx={{ color: colors.textSecondary }} />
            </ListItemIcon>
            <ListItemText>Send Message</ListItemText>
          </MenuItem>
          <MenuItem onClick={() => handleClientAction('delete')}>
            <ListItemIcon>
              <Delete sx={{ color: colors.errorRed }} />
            </ListItemIcon>
            <ListItemText sx={{ color: colors.errorRed }}>Delete</ListItemText>
          </MenuItem>
        </Menu>
      </Container>
    </Box>
  );
};

export default ClientsScreen;
