export type RootStackParamList = {
  Dashboard: undefined;
  IncomeExpense: undefined;
  Calculation: undefined;
  PaymentPlan: undefined;
  History: undefined;
  Settings: undefined;
};

export type Transaction = {
  id: string;
  type: 'income' | 'expense' | 'payment';
  amount: number;
  description: string;
  category: string;
  date: Date;
  isEssential?: boolean;
};

export type PaymentPlan = {
  id: string;
  totalAmount: number;
  remainingAmount: number;
  startDate: Date;
  endDate: Date;
  frequency: 'monthly' | 'quarterly' | 'yearly';
  paymentAmount: number;
  currency: 'EUR' | 'USD' | 'gold';
};

export type GoldPrice = {
  price: number;
  currency: string;
  unit: 'gram' | 'troy_ounce' | 'mithqal';
  timestamp: Date;
  source: string;
};
