export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'getLockNumber' : IDL.Func([], [IDL.Nat], ['query']),
    'getUnlockNumber' : IDL.Func([], [IDL.Nat], ['query']),
    'testLock' : IDL.Func([], [IDL.Nat], []),
    'testWithoutLock' : IDL.Func([], [IDL.Nat], []),
  });
};
export const init = ({ IDL }) => { return []; };
