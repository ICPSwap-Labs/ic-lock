import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'getLockNumber' : () => Promise<bigint>,
  'getUnlockNumber' : () => Promise<bigint>,
  'testLock' : () => Promise<bigint>,
  'testWithoutLock' : () => Promise<bigint>,
}
