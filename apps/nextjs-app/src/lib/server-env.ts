import React from 'react';

export interface IServerEnv {
  driver?: string;
  brandName?: string;
  brandLogo?: string;
  templateSiteLink?: string;
  microsoftClarityId?: string;
  umamiWebSiteId?: string;
  umamiUrl?: string;
  sentryDsn?: string;
  socialAuthProviders?: string[];
  storagePrefix?: string;
  edition?: string;
  passwordLoginDisabled?: boolean;
  // global settings
  globalSettings?: {
    disallowSignUp?: boolean;
    disallowSpaceCreation?: boolean;
    disallowSpaceInvitation?: boolean;
    aiConfig?: {
      enable: boolean;
    };
  };
  enableDomainEmail?: boolean;
  maxSearchFieldCount?: number;
}

export const EnvContext = React.createContext<IServerEnv>({});
