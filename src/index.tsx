import { NativeModules } from 'react-native';
const { OpenSms } = NativeModules;

interface OpenSmsInterface {
  displaySMSComposerSheet(props: {
    body: string;
    recipients: string[];
  }): Promise<string>;
  Types: { [key: string]: string };
}

const Types = {
  Sent: 'sent',
  Cancelled: 'cancelled',
  Failed: 'failed',
  NotSupported: 'notsupported',
};

const OpenSmsModule = {
  displaySMSComposerSheet: (props: { body: string; recipients: string[] }) =>
    OpenSms.displaySMSComposerSheet(props),
  Types: Types,
};

export default OpenSmsModule as OpenSmsInterface;
