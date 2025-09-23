import React, { useState, useEffect } from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { Card, Title, Paragraph, Button, FAB } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RootStackParamList } from '@/types/navigation';

type DashboardScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Dashboard'>;

export default function DashboardScreen() {
  const navigation = useNavigation<DashboardScreenNavigationProp>();
  const [totalSurplus, setTotalSurplus] = useState(0);
  const [huquqAmount, setHuquqAmount] = useState(0);
  const [remainingAmount, setRemainingAmount] = useState(0);
  const [nextPayment, setNextPayment] = useState<Date | null>(null);

  useEffect(() => {
    // TODO: Load data from storage
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    // TODO: Implement data loading from storage
    setTotalSurplus(5000);
    setHuquqAmount(950);
    setRemainingAmount(950);
    setNextPayment(new Date());
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'EUR',
    }).format(amount);
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <Card.Content>
            <Title>Surplus Total</Title>
            <Paragraph style={styles.amount}>{formatCurrency(totalSurplus)}</Paragraph>
          </Card.Content>
        </Card>

        <Card style={styles.card}>
          <Card.Content>
            <Title>Huqúqu’lláh (19%)</Title>
            <Paragraph style={styles.amount}>{formatCurrency(huquqAmount)}</Paragraph>
          </Card.Content>
        </Card>

        <Card style={styles.card}>
          <Card.Content>
            <Title>Montant Restant</Title>
            <Paragraph style={styles.amount}>{formatCurrency(remainingAmount)}</Paragraph>
          </Card.Content>
        </Card>

        {nextPayment && (
          <Card style={styles.card}>
            <Card.Content>
              <Title>Prochain Paiement</Title>
              <Paragraph>{nextPayment.toLocaleDateString('fr-FR')}</Paragraph>
            </Card.Content>
          </Card>
        )}

        <View style={styles.buttonContainer}>
          <Button
            mode="contained"
            onPress={() => navigation.navigate('IncomeExpense')}
            style={styles.button}
          >
            Gérer Revenus/Dépenses
          </Button>

          <Button
            mode="contained"
            onPress={() => navigation.navigate('Calculation')}
            style={styles.button}
          >
            Voir Calcul Détaillé
          </Button>

          <Button
            mode="contained"
            onPress={() => navigation.navigate('PaymentPlan')}
            style={styles.button}
          >
            Plan de Paiement
          </Button>

          <Button
            mode="outlined"
            onPress={() => navigation.navigate('History')}
            style={styles.button}
          >
            Historique
          </Button>
        </View>
      </ScrollView>

      <FAB
        icon="plus"
        onPress={() => navigation.navigate('IncomeExpense')}
        style={styles.fab}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  scrollView: {
    flex: 1,
    padding: 16,
  },
  card: {
    marginBottom: 16,
  },
  amount: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1976d2',
  },
  buttonContainer: {
    marginTop: 20,
  },
  button: {
    marginBottom: 12,
  },
  fab: {
    position: 'absolute',
    margin: 16,
    right: 0,
    bottom: 0,
  },
});
