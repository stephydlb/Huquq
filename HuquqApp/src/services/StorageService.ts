import AsyncStorage from '@react-native-async-storage/async-storage';
import EncryptedStorage from 'react-native-encrypted-storage';

export class StorageService {
  private static readonly TRANSACTIONS_KEY = 'huquq_transactions';
  private static readonly SETTINGS_KEY = 'huquq_settings';
  private static readonly PAYMENTS_KEY = 'huquq_payments';

  // Transactions
  static async saveTransactions(transactions: any[]): Promise<void> {
    try {
      await AsyncStorage.setItem(this.TRANSACTIONS_KEY, JSON.stringify(transactions));
    } catch (error) {
      console.error('Error saving transactions:', error);
    }
  }

  static async getTransactions(): Promise<any[]> {
    try {
      const data = await AsyncStorage.getItem(this.TRANSACTIONS_KEY);
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('Error getting transactions:', error);
      return [];
    }
  }

  // Settings
  static async saveSettings(settings: any): Promise<void> {
    try {
      await EncryptedStorage.setItem(this.SETTINGS_KEY, JSON.stringify(settings));
    } catch (error) {
      console.error('Error saving settings:', error);
    }
  }

  static async getSettings(): Promise<any> {
    try {
      const data = await EncryptedStorage.getItem(this.SETTINGS_KEY);
      return data ? JSON.parse(data) : {};
    } catch (error) {
      console.error('Error getting settings:', error);
      return {};
    }
  }

  // Payments
  static async savePayments(payments: any[]): Promise<void> {
    try {
      await AsyncStorage.setItem(this.PAYMENTS_KEY, JSON.stringify(payments));
    } catch (error) {
      console.error('Error saving payments:', error);
    }
  }

  static async getPayments(): Promise<any[]> {
    try {
      const data = await AsyncStorage.getItem(this.PAYMENTS_KEY);
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('Error getting payments:', error);
      return [];
    }
  }
}
