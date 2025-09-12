import { Coach, Client, Plan, Session, AuthResponse } from '../types';

// Mock data matching Flutter MockApiService
const mockCoach: Coach = {
  id: 'mock_coach_123',
  name: 'Test Coach',
  email: 'test@coach.com',
  phone: '+1234567890',
  bio: 'Test coach for frontend development',
  certificates: ['Test Certificate'],
  subscriptionTier: 'pro',
  clientLimit: 100,
  createdAt: new Date().toISOString(),
  lastActive: new Date().toISOString(),
  settings: {},
};

const mockClients: Client[] = [
  {
    id: 'client_1',
    coachId: 'mock_coach_123',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '+1234567890',
    status: 'active',
    subscriptionProgress: 0.75,
    joinedAt: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
    lastSession: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
    goals: { weight_loss: '10 lbs', muscle_gain: '5 lbs' },
    stats: { height: '6ft', weight: '180 lbs' },
    sessionHistory: [],
  },
  {
    id: 'client_2',
    coachId: 'mock_coach_123',
    name: 'Jane Smith',
    email: 'jane@example.com',
    phone: '+0987654321',
    status: 'pending',
    subscriptionProgress: 0.25,
    joinedAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
    lastSession: undefined,
    goals: { strength: 'Bench 200 lbs' },
    stats: { height: '5ft 6in', weight: '140 lbs' },
    sessionHistory: [],
  },
  {
    id: 'client_3',
    coachId: 'mock_coach_123',
    name: 'Ahmed Hassan',
    email: 'ahmed@example.com',
    phone: '+201234567890',
    status: 'active',
    subscriptionProgress: 0.9,
    joinedAt: new Date(Date.now() - 60 * 24 * 60 * 60 * 1000).toISOString(),
    lastSession: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
    goals: { endurance: 'Run 10K', flexibility: 'Touch toes' },
    stats: { height: '5ft 10in', weight: '165 lbs' },
    sessionHistory: [],
  },
];

const mockPlans: Plan[] = [
  {
    id: 'plan_1',
    coachId: 'mock_coach_123',
    name: 'Fat Loss Program',
    description: 'Comprehensive weight loss program with cardio and strength training',
    price: 500,
    duration: 30,
    features: ['Personalized meal plan', 'Weekly check-ins', 'Exercise videos'],
    isActive: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    revenue: 1500,
  },
  {
    id: 'plan_2',
    coachId: 'mock_coach_123',
    name: 'Muscle Building',
    description: 'Strength training program for muscle mass gain',
    price: 750,
    duration: 45,
    features: ['Progressive overload', 'Nutrition guidance', 'Form correction'],
    isActive: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    revenue: 2250,
  },
];

class MockApiService {
  private static instance: MockApiService;
  private isAuthenticated = false;

  static getInstance(): MockApiService {
    if (!MockApiService.instance) {
      MockApiService.instance = new MockApiService();
    }
    return MockApiService.instance;
  }

  // Simulate network delay
  private async delay(ms: number = 1000): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  // Authentication methods
  async signUp(data: {
    name: string;
    email: string;
    phone: string;
    password: string;
  }): Promise<AuthResponse> {
    await this.delay(800);
    
    if (data.email === 'test@coach.com') {
      throw new Error('Email already exists');
    }

    const newCoach: Coach = {
      ...mockCoach,
      id: `coach_${Date.now()}`,
      name: data.name,
      email: data.email,
      phone: data.phone,
    };

    this.isAuthenticated = true;
    return { coach: newCoach };
  }

  async signIn(data: { email: string; password: string }): Promise<AuthResponse> {
    await this.delay(800);

    if (data.email === 'test@coach.com' && data.password === 'password') {
      this.isAuthenticated = true;
      return { coach: mockCoach };
    }

    throw new Error('Invalid email or password');
  }

  async signOut(): Promise<void> {
    await this.delay(300);
    this.isAuthenticated = false;
  }

  async forgotPassword(email: string): Promise<void> {
    await this.delay(1000);
    // Mock success - in real app would send email
  }

  // Social authentication
  async signInWithGoogle(data: {
    googleToken: string;
    name?: string;
    email?: string;
    profilePhotoUrl?: string;
  }): Promise<AuthResponse> {
    await this.delay(1000);
    
    const coach: Coach = {
      ...mockCoach,
      name: data.name || 'Google User',
      email: data.email || 'google@example.com',
      profilePhotoUrl: data.profilePhotoUrl,
    };

    this.isAuthenticated = true;
    return { coach };
  }

  async signInWithFacebook(data: {
    facebookToken: string;
    name?: string;
    email?: string;
    profilePhotoUrl?: string;
  }): Promise<AuthResponse> {
    await this.delay(1000);
    
    const coach: Coach = {
      ...mockCoach,
      name: data.name || 'Facebook User',
      email: data.email || 'facebook@example.com',
      profilePhotoUrl: data.profilePhotoUrl,
    };

    this.isAuthenticated = true;
    return { coach };
  }

  async signInWithApple(data: {
    appleToken: string;
    name?: string;
    email?: string;
    profilePhotoUrl?: string;
  }): Promise<AuthResponse> {
    await this.delay(1000);
    
    const coach: Coach = {
      ...mockCoach,
      name: data.name || 'Apple User',
      email: data.email || 'apple@example.com',
      profilePhotoUrl: data.profilePhotoUrl,
    };

    this.isAuthenticated = true;
    return { coach };
  }

  // Client methods
  async getClients(): Promise<Client[]> {
    await this.delay(500);
    if (!this.isAuthenticated) throw new Error('Not authenticated');
    return [...mockClients];
  }

  async addClient(client: Omit<Client, 'id' | 'coachId' | 'joinedAt'>): Promise<Client> {
    await this.delay(800);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const newClient: Client = {
      ...client,
      id: `client_${Date.now()}`,
      coachId: mockCoach.id,
      joinedAt: new Date().toISOString(),
    };

    mockClients.unshift(newClient);
    return newClient;
  }

  async updateClient(client: Client): Promise<Client> {
    await this.delay(600);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const index = mockClients.findIndex(c => c.id === client.id);
    if (index !== -1) {
      mockClients[index] = { ...client };
      return mockClients[index];
    }

    throw new Error('Client not found');
  }

  async deleteClient(clientId: string): Promise<void> {
    await this.delay(500);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const index = mockClients.findIndex(c => c.id === clientId);
    if (index !== -1) {
      mockClients.splice(index, 1);
    } else {
      throw new Error('Client not found');
    }
  }

  // Plan methods
  async getPlans(): Promise<Plan[]> {
    await this.delay(500);
    if (!this.isAuthenticated) throw new Error('Not authenticated');
    return [...mockPlans];
  }

  async addPlan(plan: Omit<Plan, 'id' | 'coachId' | 'createdAt' | 'updatedAt'>): Promise<Plan> {
    await this.delay(800);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const newPlan: Plan = {
      ...plan,
      id: `plan_${Date.now()}`,
      coachId: mockCoach.id,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    mockPlans.unshift(newPlan);
    return newPlan;
  }

  async updatePlan(plan: Plan): Promise<Plan> {
    await this.delay(600);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const index = mockPlans.findIndex(p => p.id === plan.id);
    if (index !== -1) {
      mockPlans[index] = { ...plan, updatedAt: new Date().toISOString() };
      return mockPlans[index];
    }

    throw new Error('Plan not found');
  }

  async deletePlan(planId: string): Promise<void> {
    await this.delay(500);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const index = mockPlans.findIndex(p => p.id === planId);
    if (index !== -1) {
      mockPlans.splice(index, 1);
    } else {
      throw new Error('Plan not found');
    }
  }

  // Profile methods
  async updateCoachProfile(data: {
    name?: string;
    bio?: string;
    profilePhotoUrl?: string;
  }): Promise<Coach> {
    await this.delay(600);
    if (!this.isAuthenticated) throw new Error('Not authenticated');

    const updatedCoach = { ...mockCoach, ...data };
    return updatedCoach;
  }

  // Image upload
  async uploadImage(file: File): Promise<string> {
    await this.delay(2000);
    if (!this.isAuthenticated) throw new Error('Not authenticated');
    
    // Mock image URL
    return `https://example.com/uploads/${file.name}`;
  }
}

export default MockApiService.getInstance();

