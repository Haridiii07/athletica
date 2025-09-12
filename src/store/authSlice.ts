import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { Coach, AuthState, SignInForm, SignUpForm } from '../types';
import mockApiService from '../services/mockApiService';

const initialState: AuthState = {
  coach: null,
  isLoading: false,
  error: null,
  isAuthenticated: false,
};

// Async thunks for authentication
export const signIn = createAsyncThunk(
  'auth/signIn',
  async (credentials: SignInForm, { rejectWithValue }) => {
    try {
      const response = await mockApiService.signIn(credentials);
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const signUp = createAsyncThunk(
  'auth/signUp',
  async (userData: SignUpForm, { rejectWithValue }) => {
    try {
      const response = await mockApiService.signUp(userData);
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const signOut = createAsyncThunk(
  'auth/signOut',
  async (_, { rejectWithValue }) => {
    try {
      await mockApiService.signOut();
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const forgotPassword = createAsyncThunk(
  'auth/forgotPassword',
  async (email: string, { rejectWithValue }) => {
    try {
      await mockApiService.forgotPassword(email);
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const signInWithGoogle = createAsyncThunk(
  'auth/signInWithGoogle',
  async (data: { googleToken: string; name?: string; email?: string; profilePhotoUrl?: string }, { rejectWithValue }) => {
    try {
      const response = await mockApiService.signInWithGoogle(data);
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const signInWithFacebook = createAsyncThunk(
  'auth/signInWithFacebook',
  async (data: { facebookToken: string; name?: string; email?: string; profilePhotoUrl?: string }, { rejectWithValue }) => {
    try {
      const response = await mockApiService.signInWithFacebook(data);
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

export const signInWithApple = createAsyncThunk(
  'auth/signInWithApple',
  async (data: { appleToken: string; name?: string; email?: string; profilePhotoUrl?: string }, { rejectWithValue }) => {
    try {
      const response = await mockApiService.signInWithApple(data);
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message);
    }
  }
);

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
    setCoach: (state, action: PayloadAction<Coach>) => {
      state.coach = action.payload;
      state.isAuthenticated = true;
    },
  },
  extraReducers: (builder) => {
    builder
      // Sign In
      .addCase(signIn.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signIn.fulfilled, (state, action) => {
        state.isLoading = false;
        state.coach = action.payload.coach;
        state.isAuthenticated = true;
        state.error = null;
      })
      .addCase(signIn.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
        state.isAuthenticated = false;
      })
      // Sign Up
      .addCase(signUp.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signUp.fulfilled, (state, action) => {
        state.isLoading = false;
        state.coach = action.payload.coach;
        state.isAuthenticated = true;
        state.error = null;
      })
      .addCase(signUp.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
        state.isAuthenticated = false;
      })
      // Sign Out
      .addCase(signOut.pending, (state) => {
        state.isLoading = true;
      })
      .addCase(signOut.fulfilled, (state) => {
        state.isLoading = false;
        state.coach = null;
        state.isAuthenticated = false;
        state.error = null;
      })
      .addCase(signOut.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Forgot Password
      .addCase(forgotPassword.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(forgotPassword.fulfilled, (state) => {
        state.isLoading = false;
        state.error = null;
      })
      .addCase(forgotPassword.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      // Google Sign In
      .addCase(signInWithGoogle.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signInWithGoogle.fulfilled, (state, action) => {
        state.isLoading = false;
        state.coach = action.payload.coach;
        state.isAuthenticated = true;
        state.error = null;
      })
      .addCase(signInWithGoogle.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
        state.isAuthenticated = false;
      })
      // Facebook Sign In
      .addCase(signInWithFacebook.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signInWithFacebook.fulfilled, (state, action) => {
        state.isLoading = false;
        state.coach = action.payload.coach;
        state.isAuthenticated = true;
        state.error = null;
      })
      .addCase(signInWithFacebook.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
        state.isAuthenticated = false;
      })
      // Apple Sign In
      .addCase(signInWithApple.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signInWithApple.fulfilled, (state, action) => {
        state.isLoading = false;
        state.coach = action.payload.coach;
        state.isAuthenticated = true;
        state.error = null;
      })
      .addCase(signInWithApple.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
        state.isAuthenticated = false;
      });
  },
});

export const { clearError, setCoach } = authSlice.actions;
export default authSlice.reducer;
