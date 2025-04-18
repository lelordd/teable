import type { RouteConfig } from '@asteasolutions/zod-to-openapi';
import {
  createFieldRoSchema,
  fieldVoSchema,
  IdPrefix,
  viewRoSchema,
  viewVoSchema,
  recordSchema,
} from '@teable/core';
import { axios } from '../axios';
import { createRecordsRoSchema, fieldKeyTypeRoSchema } from '../record';
import { registerRoute, urlBuilder } from '../utils';
import { z } from '../zod';

export const tableFullVoSchema = z
  .object({
    id: z.string().startsWith(IdPrefix.Table).openapi({
      description: 'The id of table.',
    }),
    name: z.string().openapi({
      description: 'The name of the table.',
    }),
    dbTableName: z
      .string()
      .regex(/^[a-z]\w{0,62}$/i, {
        message: 'Invalid name format',
      })
      .openapi({
        description:
          'Table name in backend database. Limitation: 1-63 characters, start with letter, can only contain letters, numbers and underscore, case insensitive, cannot be duplicated with existing db table name in the base.',
      }),
    description: z.string().optional().openapi({
      description: 'The description of the table.',
    }),
    icon: z.string().emoji().optional().openapi({
      description: 'The emoji icon string of the table.',
    }),
    fields: fieldVoSchema.array().openapi({
      description: 'The fields of the table.',
    }),
    views: viewVoSchema.array().openapi({
      description: 'The views of the table.',
    }),
    records: recordSchema.array().openapi({
      description: 'The records of the table.',
    }),
    order: z.number().optional(),
    lastModifiedTime: z.string().optional().openapi({
      description: 'The last modified time of the table.',
    }),
    defaultViewId: z.string().startsWith(IdPrefix.View).optional().openapi({
      description: 'The default view id of the table.',
    }),
  })
  .openapi({
    description: 'Complete table structure data and initial record data.',
  });

export type ITableFullVo = z.infer<typeof tableFullVoSchema>;

export const tableVoSchema = tableFullVoSchema.omit({
  fields: true,
  views: true,
  records: true,
});

export type ITableVo = z.infer<typeof tableVoSchema>;

export const tableRoSchema = tableFullVoSchema
  .omit({
    id: true,
    lastModifiedTime: true,
    defaultViewId: true,
  })
  .partial({
    name: true,
    dbTableName: true,
  })
  .merge(
    z.object({
      name: tableFullVoSchema.shape.name.min(1).optional(),
      description: tableFullVoSchema.shape.description.nullable(),
      icon: tableFullVoSchema.shape.icon.nullable(),
      fieldKeyType: fieldKeyTypeRoSchema,
      fields: createFieldRoSchema.array().optional().openapi({
        description:
          'The fields of the table. If it is empty, 3 fields include SingleLineText, Number, SingleSelect will and 3 empty records be generated by default.',
      }),
      views: viewRoSchema.array().optional().openapi({
        description:
          'The views of the table. If it is empty, a grid view will be generated by default.',
      }),
      records: createRecordsRoSchema.shape.records.optional().openapi({
        description:
          'The record data of the table. If it is empty, 3 empty records will be generated by default.',
      }),
    })
  )
  .openapi({
    description: 'params for create a table',
  });

export type ICreateTableRo = z.infer<typeof tableRoSchema>;

export const tableRoWithDefaultSchema = tableRoSchema.required({
  fields: true,
  views: true,
});

export type ICreateTableWithDefault = z.infer<typeof tableRoWithDefaultSchema>;

export const tablePropertyKeySchema = tableRoSchema.pick({
  name: true,
  dbTableName: true,
  description: true,
  icon: true,
  order: true,
});

export const tableOpSchema = tableVoSchema.pick({
  id: true,
  name: true,
  description: true,
  order: true,
  icon: true,
  lastModifiedTime: true,
});

export const tableListVoSchema = tableVoSchema.array().openapi({
  description: 'The list of tables.',
});

export const CREATE_TABLE = '/base/{baseId}/table/';

export const CreateTableRoute: RouteConfig = registerRoute({
  method: 'post',
  path: CREATE_TABLE,
  summary: 'Create table',
  description:
    'Create a new table in the specified base with customizable fields, views, and initial records. Default configurations will be applied if not specified.',
  request: {
    params: z.object({
      baseId: z.string(),
    }),
    body: {
      content: {
        'application/json': {
          schema: tableRoSchema,
        },
      },
    },
  },
  responses: {
    201: {
      description: 'Returns data about a table.',
      content: {
        'application/json': {
          schema: tableFullVoSchema,
        },
      },
    },
  },
  tags: ['table'],
});

export const createTable = async (baseId: string, tableRo: ICreateTableRo = {}) => {
  return axios.post<ITableFullVo>(urlBuilder(CREATE_TABLE, { baseId }), tableRo);
};
