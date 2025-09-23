import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Card, Title, Paragraph } from 'react-native-paper';

export default function HistoryScreen() {
  return (
    <View style={styles.container}>
      <Card style={styles.card}>
        <Card.Content>
          <Title>Historique des Paiements</Title>
          <Paragraph>Aucun paiement enregistré</Paragraph>
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
});
