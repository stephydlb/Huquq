import { Transaction } from '@/types/navigation';

export class CalculationService {
  static calculateSurplus(transactions: Transaction[]): number {
    const totalIncome = transactions
      .filter(t => t.type === 'income')
      .reduce((sum, t) => sum + t.amount, 0);

    const essentialExpenses = transactions
      .filter(t => t.type === 'expense' && t.isEssential)
      .reduce((sum, t) => sum + t.amount, 0);

    return totalIncome - essentialExpenses;
  }

  static calculateHuquq(surplus: number): number {
    return surplus * 0.19;
  }

  static calculateRemaining(huquqAmount: number, payments: any[]): number {
    const totalPaid = payments.reduce((sum, p) => sum + p.amount, 0);
    return Math.max(0, huquqAmount - totalPaid);
  }

  static formatCurrency(amount: number, currency: string = 'EUR'): string {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency,
    }).format(amount);
  }

  static convertToGold(amount: number, goldPricePerGram: number): number {
    // 1 mithqal = 4.25 grams
    const grams = amount / goldPricePerGram;
    const mithqals = grams / 4.25;
    return mithqals;
  }
}
