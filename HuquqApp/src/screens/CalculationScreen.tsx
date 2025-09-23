import React from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { Card, Title, Paragraph } from 'react-native-paper';

export default function CalculationScreen() {
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
            <Title>Calcul du Surplus</Title>
            <Paragraph>Total Revenus: {formatCurrency(8000)}</Paragraph>
            <Paragraph>Dépenses Essentielles: {formatCurrency(3000)}</Paragraph>
            <Paragraph style={styles.surplus}>Surplus: {formatCurrency(5000)}</Paragraph>
          </Card.Content>
        </Card>

        <Card style={styles.card}>
          <Card.Content>
            <Title>Huqúqu’lláh (19%)</Title>
            <Paragraph>19% du Surplus: {formatCurrency(950)}</Paragraph>
            <Paragraph>Déjà Payé: {formatCurrency(0)}</Paragraph>
            <Paragraph style={styles.remaining}>Montant Restant: {formatCurrency(950)}</Paragraph>
          </Card.Content>
        </Card>
      </ScrollView>
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
  surplus: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#4caf50',
  },
  remaining: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#f44336',
  },
});
