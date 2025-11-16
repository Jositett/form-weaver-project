// Shared types between frontend and backend

export interface FormField {
  id: string;
  type: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url' | 'date' | 'time' | 'textarea' | 'select' | 'radio' | 'checkbox';
  label: string;
  placeholder?: string;
  required?: boolean;
  validation?: {
    minLength?: number;
    maxLength?: number;
    min?: number;
    max?: number;
    pattern?: string;
  };
  options?: string[]; // For select, radio, checkbox
}

export interface FormSchema {
  id: string;
  workspaceId: string;
  title: string;
  description?: string;
  fields: FormField[];
  status: 'draft' | 'published' | 'archived';
  version: number;
  createdBy: string;
  createdAt: string;
  updatedAt: string;
}

export interface FormSubmission {
  id: string;
  formId: string;
  data: Record<string, any>;
  metadata?: {
    ipAddress?: string;
    userAgent?: string;
    referrer?: string;
  };
  submittedAt: string;
}

export interface User {
  id: string;
  email: string;
  name?: string;
  emailVerified: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface Workspace {
  id: string;
  name: string;
  slug: string;
  ownerId: string;
  planType: 'free' | 'prepaid' | 'pro' | 'business' | 'enterprise';
  createdAt: string;
  updatedAt: string;
}

export interface ApiResponse<T = any> {
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  limit: number;
  hasMore: boolean;
}
