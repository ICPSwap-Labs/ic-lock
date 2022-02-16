import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'del' : (arg_0: string) => Promise<undefined>,
  'get' : (arg_0: string) => Promise<boolean>,
  'setNx' : (arg_0: string) => Promise<{ 'status' : boolean, 'time' : bigint }>,
}
