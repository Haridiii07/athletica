import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { CoachState, Client, Plan, ClientForm, PlanForm } from '../types';
import mockApiService from '../services/mockApiService';

const initialState: CoachState = {
  clients: [],
  plans: [],
  isLoading: false,
  error: null,
  totalClients: 0,
  activeClients: 0,
  pendingClients: 0,
  averageSubscriptionProgress: 0,
  totalPlans: 0,
  activePlans: 0,
  totalRevenue: 0,
};

// Async thunks for coach data
export const loadClients = createAsyncThunk(
  'coach/loadClients',
  async (_, { rejectWithValue }) => {
    try {
      const clients = await mockApiService.getClients();
      return clients;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const loadPlans = createAsyncThunk(
  'coach/loadPlans',
  async (_, { rejectWithValue }) => {
    try {
      const plans = await mockApiService.getPlans();
      return plans;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const addClient = createAsyncThunk(
  'coach/addClient',
  async (clientData: ClientForm, { rejectWithValue }) => {
    try {
      const newClient = await mockApiService.addClient({
        ...clientData,
        status: 'pending',
        subscriptionProgress: 0,
        goals: clientData.goals || {},
        stats: clientData.stats || {},
        sessionHistory: [],
      });
      return newClient;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const updateClient = createAsyncThunk(
  'coach/updateClient',
  async (client: Client, { rejectWithValue }) => {
    try {
      const updatedClient = await mockApiService.updateClient(client);
      return updatedClient;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const deleteClient = createAsyncThunk(
  'coach/deleteClient',
  async (clientId: string, { rejectWithValue }) => {
    try {
      await mockApiService.deleteClient(clientId);
      return clientId;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const addPlan = createAsyncThunk(
  'coach/addPlan',
  async (planData: PlanForm, { rejectWithValue }) => {
    try {
      const newPlan = await mockApiService.addPlan({
        ...planData,
        isActive: true,
        revenue: 0,
      });
      return newPlan;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const updatePlan = createAsyncThunk(
  'coach/updatePlan',
  async (plan: Plan, { rejectWithValue }) => {
    try {
      const updatedPlan = await mockApiService.updatePlan(plan);
      return updatedPlan;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const deletePlan = createAsyncThunk(
  'coach/deletePlan',
  async (planId: string, { rejectWithValue }) => {
    try {
      await mockApiService.deletePlan(planId);
      return planId;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

// Helper function to calculate statistics
const calculateStats = (clients: Client[], plans: Plan[]) => {
  const totalClients = clients.length;
  const activeClients = clients.filter(client => client.status === 'active').length;
  const pendingClients = clients.filter(client => client.status === 'pending').length;
  const averageSubscriptionProgress = totalClients > 0 
    ? clients.reduce((sum, client) => sum + client.subscriptionProgress, 0) / totalClients
    : 0;
  const totalPlans = plans.length;
  const activePlans = plans.filter(plan => plan.isActive).length;
  const totalRevenue = plans.reduce((sum, plan) => sum + plan.revenue, 0);

  return {
    totalClients,
    activeClients,
    pendingClients,
    averageSubscriptionProgress,
    totalPlans,
    activePlans,
    totalRevenue,
  };
};

const coachSlice = createSlice({
  name: 'coach',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
    clearData: (state) => {
      state.clients = [];
      state.plans = [];
      state.totalClients = 0;
      state.activeClients = 0;
      state.pendingClients = 0;
      state.averageSubscriptionProgress = 0;
      state.totalPlans = 0;
      state.activePlans = 0;
      state.totalRevenue = 0;
    },
  },
  extraReducers: (builder) => {
    builder
      // Load Clients
      .addCase(loadClients.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(loadClients.fulfilled, (state, action) => {
        state.isLoading = false;
        state.clients = action.payload;
        const stats = calculateStats(action.payload, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(loadClients.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Load Plans
      .addCase(loadPlans.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(loadPlans.fulfilled, (state, action) => {
        state.isLoading = false;
        state.plans = action.payload;
        const stats = calculateStats(state.clients, action.payload);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(loadPlans.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Add Client
      .addCase(addClient.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(addClient.fulfilled, (state, action) => {
        state.isLoading = false;
        state.clients.unshift(action.payload);
        const stats = calculateStats(state.clients, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(addClient.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Update Client
      .addCase(updateClient.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(updateClient.fulfilled, (state, action) => {
        state.isLoading = false;
        const index = state.clients.findIndex(client => client.id === action.payload.id);
        if (index !== -1) {
          state.clients[index] = action.payload;
        }
        const stats = calculateStats(state.clients, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(updateClient.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Delete Client
      .addCase(deleteClient.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(deleteClient.fulfilled, (state, action) => {
        state.isLoading = false;
        state.clients = state.clients.filter(client => client.id !== action.payload);
        const stats = calculateStats(state.clients, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(deleteClient.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Add Plan
      .addCase(addPlan.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(addPlan.fulfilled, (state, action) => {
        state.isLoading = false;
        state.plans.unshift(action.payload);
        const stats = calculateStats(state.clients, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(addPlan.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Update Plan
      .addCase(updatePlan.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(updatePlan.fulfilled, (state, action) => {
        state.isLoading = false;
        const index = state.plans.findIndex(plan => plan.id === action.payload.id);
        if (index !== -1) {
          state.plans[index] = action.payload;
        }
        const stats = calculateStats(state.clients, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(updatePlan.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Delete Plan
      .addCase(deletePlan.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(deletePlan.fulfilled, (state, action) => {
        state.isLoading = false;
        state.plans = state.plans.filter(plan => plan.id !== action.payload);
        const stats = calculateStats(state.clients, state.plans);
        Object.assign(state, stats);
        state.error = null;
      })
      .addCase(deletePlan.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      });
  },
});

export const { clearError, clearData } = coachSlice.actions;
export default coachSlice.reducer;
