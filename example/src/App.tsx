import * as React from 'react';

import { StyleSheet, TouchableOpacity, View, Text } from 'react-native';
import OpenSms from '@lowkey/react-native-open-sms';

export default function App() {
  const openComposer = () => {
    OpenSms.displaySMSComposerSheet({
      body: 'Hello my dear friend!',
      recipients: ['1234567890'],
    }).then((result: string) => {
      switch (result) {
        case OpenSms.Types.Sent:
          console.log('Message was sent!');
          break;
        case OpenSms.Types.Cancelled:
          console.log('Sending was cancelled!');
          break;
        case OpenSms.Types.Failed:
          console.log('Sending failed');
          break;
        case OpenSms.Types.NotSupported:
          console.log('Sending is not supported');
          break;
        default:
          console.log('Error occupied', result);
          break;
      }
    });
  };
  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.button} onPress={openComposer}>
        <Text style={styles.buttonText}>Open message composer</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
    backgroundColor: '#777',
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 50,
    paddingVertical: 25,
    borderRadius: 20,
  },
  buttonText: { color: '#fff' },
});
