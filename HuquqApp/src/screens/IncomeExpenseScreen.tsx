import React, { useState } from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { TextInput, Button, Card, Title, RadioButton, Portal, Modal } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RootStackParamList, Transaction } from '@/types/navigation';

type IncomeExpenseScreenNavigationProp = StackNavigationProp<RootStackParamList, 'IncomeExpense'>;

export default function IncomeExpenseScreen() {
  const navigation = useNavigation<IncomeExpenseScreenNavigationProp>();
  const [amount, setAmount] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState('');
  const [type, setType] = useState<'income' | 'expense'>('income');
  const [isEssential, setIsEssential] = useState(false);
  const [showCategoryModal, setShowCategoryModal] = useState(false);

  const categories = {
    income: ['Salaire', 'Investissement', 'Autre'],
    expense: ['Logement', 'Nourriture', 'Santé', 'Éducation', 'Transport', 'Loisirs', 'Dettes', 'Autre']
  };

  const handleSave = () => {
    if (!amount || !description || !category) {
      return;
    }

    const transaction: Transaction = {
      id: Date.now().toString(),
      type,
      amount: parseFloat(amount),
      description,
      category,
      date: new Date(),
      isEssential: type === 'expense' ? isEssential : false,
    };

    // TODO: Save to storage
    console.log('Transaction saved:', transaction);

    // Reset form
    setAmount('');
    setDescription('');
    setCategory('');
    setIsEssential(false);
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <Card.Content>
            <Title>Ajouter une Transaction</Title>

            <RadioButton.Group onValueChange={value => setType(value as 'income' | 'expense')} value={type}>
              <RadioButton.Item label="Revenu" value="income" />
              <RadioButton.Item label="Dépense" value="expense" />
            </RadioButton.Group>

            <TextInput
              label="Montant (€)"
              value={amount}
              onChangeText={setAmount}
              keyboardType="numeric"
              style={styles.input}
            />

            <TextInput
              label="Description"
              value={description}
              onChangeText={setDescription}
              style={styles.input}
            />

            <Button
              mode="outlined"
              onPress={() => setShowCategoryModal(true)}
              style={styles.input}
            >
              {category || 'Sélectionner une catégorie'}
            </Button>

            {type === 'expense' && (
              <RadioButton.Group onValueChange={value => setIsEssential(value === 'true')} value={isEssential.toString()}>
                <RadioButton.Item label="Dépense essentielle" value="true" />
                <RadioButton.Item label="Dépense non-essentielle" value="false" />
              </RadioButton.Group>
            )}

            <Button mode="contained" onPress={handleSave} style={styles.button}>
              Enregistrer
            </Button>
          </Card.Content>
        </Card>
      </ScrollView>

      <Portal>
        <Modal visible={showCategoryModal} onDismiss={() => setShowCategoryModal(false)}>
          <Card style={styles.modalCard}>
            <Card.Content>
              <Title>Choisir une Catégorie</Title>
              {categories[type].map((cat) => (
                <Button
                  key={cat}
                  mode={category === cat ? 'contained' : 'outlined'}
                  onPress={() => {
                    setCategory(cat);
                    setShowCategoryModal(false);
                  }}
                  style={styles.categoryButton}
                >
                  {cat}
                </Button>
              ))}
            </Card.Content>
          </Card>
        </Modal>
      </Portal>
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
  input: {
    marginBottom: 16,
  },
  button: {
    marginTop: 16,
  },
  modalCard: {
    margin: 20,
    maxHeight: '70%',
  },
  categoryButton: {
    marginBottom: 8,
  },
});
