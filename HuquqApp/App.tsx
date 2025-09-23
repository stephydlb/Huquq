import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { Provider as PaperProvider } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';

// Import screens
import DashboardScreen from '@/screens/DashboardScreen';
import IncomeExpenseScreen from '@/screens/IncomeExpenseScreen';
import CalculationScreen from '@/screens/CalculationScreen';
import PaymentPlanScreen from '@/screens/PaymentPlanScreen';
import HistoryScreen from '@/screens/HistoryScreen';
import SettingsScreen from '@/screens/SettingsScreen';

// Import types
import { RootStackParamList } from '@/types/navigation';

const Stack = createStackNavigator<RootStackParamList>();

export default function App() {
  return (
    <SafeAreaProvider>
      <PaperProvider>
        <NavigationContainer>
          <Stack.Navigator
            initialRouteName="Dashboard"
            screenOptions={{
              headerStyle: {
                backgroundColor: '#1976d2',
              },
              headerTintColor: '#fff',
              headerTitleStyle: {
                fontWeight: 'bold',
              },
            }}
          >
            <Stack.Screen
              name="Dashboard"
              component={DashboardScreen}
              options={{ title: 'Huquq Assistant' }}
            />
            <Stack.Screen
              name="IncomeExpense"
              component={IncomeExpenseScreen}
              options={{ title: 'Revenus & Dépenses' }}
            />
            <Stack.Screen
              name="Calculation"
              component={CalculationScreen}
              options={{ title: 'Calcul du Surplus' }}
            />
            <Stack.Screen
              name="PaymentPlan"
              component={PaymentPlanScreen}
              options={{ title: 'Plan de Paiement' }}
            />
            <Stack.Screen
              name="History"
              component={HistoryScreen}
              options={{ title: 'Historique' }}
            />
            <Stack.Screen
              name="Settings"
              component={SettingsScreen}
              options={{ title: 'Paramètres' }}
            />
          </Stack.Navigator>
        </NavigationContainer>
      </PaperProvider>
    </SafeAreaProvider>
  );
}
