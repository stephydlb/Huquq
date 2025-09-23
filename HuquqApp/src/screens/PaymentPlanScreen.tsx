import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Card, Title, Paragraph, Button } from 'react-native-paper';

export default function PaymentPlanScreen() {
  return (
    <View style={styles.container}>
      <Card style={styles.card}>
        <Card.Content>
          <Title>Plan de Paiement</Title>
          <Paragraph>Montant total: 950€</Paragraph>
          <Paragraph>Plan mensuel: 79.17€/mois pendant 12 mois</Paragraph>
          <Button mode="contained" style={styles.button}>
            Créer un Plan
          </Button>
        </Card.Content>
      </Card>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    padding: 16,
  },
  card: {
    marginBottom: 16,
  },
  button: {
    marginTop: 16,
  },
});
