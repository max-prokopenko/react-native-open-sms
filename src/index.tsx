import { requireNativeComponent, ViewStyle } from 'react-native';

type OpenSmsProps = {
  color: string;
  style: ViewStyle;
};

export const OpenSmsViewManager = requireNativeComponent<OpenSmsProps>(
  'OpenSmsView'
);

export default OpenSmsViewManager;
