import { useMutation } from '@tanstack/react-query';
import { importBase, type ImportBaseRo, type INotifyVo } from '@teable/openapi';
import {
  Button,
  cn,
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@teable/ui-lib/shadcn';
import { useRouter } from 'next/router';
import { useTranslation } from 'next-i18next';
import React from 'react';
import { spaceConfig } from '@/features/i18n/space.config';
import { UploadPanel } from './UploadPanel';

interface IUploadPanelDialogProps {
  spaceId: string;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export const UploadPanelDialog = (props: IUploadPanelDialogProps) => {
  const { open, onOpenChange, spaceId } = props;
  const { t } = useTranslation(spaceConfig.i18nNamespaces);
  const [file, setFile] = React.useState<File | null>(null);
  const [notify, setNotify] = React.useState<INotifyVo | null>(null);

  const router = useRouter();

  const { mutate: importBaseFn } = useMutation({
    mutationFn: (importBaseRo: ImportBaseRo) => importBase(importBaseRo),
    onSuccess: (result) => {
      const {
        base: { id: baseId },
      } = result.data;
      onOpenChange(false);
      router.push(`/base/${baseId}`);
    },
  });

  return (
    <Dialog
      open={open}
      onOpenChange={(open) => {
        onOpenChange(open);
        if (!open) {
          setFile(null);
          setNotify(null);
        }
      }}
    >
      <DialogContent className="min-w-[700px]">
        <DialogHeader>
          <DialogTitle>{t('space:spaceSetting.importBase')}</DialogTitle>
        </DialogHeader>
        <div className="w-full">
          <UploadPanel
            file={file}
            onClose={() => {
              setFile(null);
              setNotify(null);
            }}
            onChange={(file) => {
              setFile(file);
            }}
            accept=".tea"
            onFinished={(notify) => {
              setNotify(notify);
            }}
          />
        </div>
        <DialogFooter className={cn('opacity-100', { 'opacity-0': !notify })}>
          <Button
            variant={'default'}
            size={'sm'}
            onClick={() => {
              notify && importBaseFn({ spaceId, notify });
            }}
          >
            {t('space:import.confirm')}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
