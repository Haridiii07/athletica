import { configureStore } from '@reduxjs/toolkit';
import authReducer from './authSlice';
import coachReducer from './coachSlice';
import { AppState } from '../types';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    coach: coachReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['persist/PERSIST'],
      },
    }),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
