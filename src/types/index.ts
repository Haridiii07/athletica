// TypeScript types matching Flutter models

export interface Coach {
  id: string;
  name: string;
  email: string;
  phone: string;
  profilePhotoUrl?: string;
  bio: string;
  certificates: string[];
  subscriptionTier: 'free' | 'basic' | 'pro' | 'elite';
  clientLimit: number;
  createdAt: string;
  lastActive?: string;
  settings: Record<string, any>;
}

export interface Client {
  id: string;
  coachId: string;
  name: string;
  profilePhotoUrl?: string;
  status: 'active' | 'inactive' | 'pending' | 'new';
  subscriptionProgress: number; // 0.0 to 1.0
  joinedAt: string;
  lastSession?: string;
  goals: Record<string, any>;
  stats: Record<string, any>;
  sessionHistory: Session[];
  phone?: string;
  email?: string;
}

export interface Session {
  id: string;
  name: string;
  type: string;
  date: string;
  data: Record<string, any>;
}

export interface Plan {
  id: string;
  coachId: string;
  name: string;
  description: string;
  price: number;
  duration: number; // in days
  features: string[];
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
  revenue: number;
}

export interface Message {
  id: string;
  senderId: string;
  receiverId: string;
  content: string;
  timestamp: string;
  isRead: boolean;
}

export interface AuthState {
  coach: Coach | null;
  isLoading: boolean;
  error: string | null;
  isAuthenticated: boolean;
}

export interface CoachState {
  clients: Client[];
  plans: Plan[];
  isLoading: boolean;
  error: string | null;
  totalClients: number;
  activeClients: number;
  pendingClients: number;
  averageSubscriptionProgress: number;
  totalPlans: number;
  activePlans: number;
  totalRevenue: number;
}

export interface AppState {
  auth: AuthState;
  coach: CoachState;
}

// API Response types
export interface AuthResponse {
  coach: Coach;
  token?: string;
}

export interface ApiError {
  message: string;
  code?: string;
  details?: any;
}

// Form types
export interface SignInForm {
  email: string;
  password: string;
}

export interface SignUpForm {
  name: string;
  email: string;
  phone: string;
  password: string;
}

export interface ClientForm {
  name: string;
  email?: string;
  phone?: string;
  goals?: Record<string, any>;
  stats?: Record<string, any>;
}

export interface PlanForm {
  name: string;
  description: string;
  price: number;
  duration: number;
  features: string[];
}

// Chart data types
export interface ChartData {
  name: string;
  value: number;
  color?: string;
}

export interface RevenueData {
  date: string;
  revenue: number;
}

// Navigation types
export type TabValue = 'home' | 'clients' | 'plans' | 'messages' | 'profile';

export interface NavigationItem {
  label: string;
  value: TabValue;
  icon: string;
  activeIcon: string;
}

