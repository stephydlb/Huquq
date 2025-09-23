import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Card, Title, Paragraph, Switch, Button } from 'react-native-paper';

export default function SettingsScreen() {
  const [notifications, setNotifications] = React.useState(true);
  const [biometricLock, setBiometricLock] = React.useState(false);

  return (
    <View style={styles.container}>
      <Card style={styles.card}>
        <Card.Content>
          <Title>Sécurité</Title>
          <View style={styles.setting}>
            <Paragraph>Verrouillage biométrique</Paragraph>
            <Switch value={biometricLock} onValueChange={setBiometricLock} />
          </View>
        </Card.Content>
      </Card>

      <Card style={styles.card}>
        <Card.Content>
          <Title>Notifications</Title>
          <View style={styles.setting}>
            <Paragraph>Rappels de paiement</Paragraph>
            <Switch value={notifications} onValueChange={setNotifications} />
          </View>
        </Card.Content>
      </Card>

      <Card style={styles.card}>
        <Card.Content>
          <Title>Données</Title>
          <Button mode="outlined" style={styles.button}>
            Exporter les données
          </Button>
          <Button mode="outlined" style={styles.button}>
            Importer les données
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
  setting: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 8,
  },
  button: {
    marginBottom: 8,
  },
});
