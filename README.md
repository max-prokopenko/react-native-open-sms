# react-native-open-sms

Open a system standard interface, which lets the user compose and send SMS messages.(iMessage etc)

![EB4B4044-6A97-43D3-8253-80E0A94A5AA8](https://user-images.githubusercontent.com/20337903/114843299-576f1700-9de2-11eb-92bc-b7e759838da1.GIF)

## Installation

```sh
npm install @lowkey/react-native-open-sms
```
or
```sh
yarn add @lowkey/react-native-open-sms
```

Install pods
```sh
npx pod-install
```

## Usage

```js
import OpenSms from '@lowkey/react-native-open-sms';

// ...

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

```

## Props
| Prop  | Type  | Description | Required |
| ----------------| ---------------- |:----------------:|:----------------:|
| body      | String      | Message Text     |false     |
| recipients      | string[]      | Message recipients     |true     |

## Types

Action types returned when promise is resolved

| Type  | Description | 
| ----------------| ---------------- |
| OpenSms.Types.Sent      | Message was sent      |
| OpenSms.Types.Cancelled      | User canceled message sending      |
| OpenSms.Types.Failed      | Message sending failed      |
| OpenSms.Types.NotSupported      | Message sending is not supported (iOS simulator)      |

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
