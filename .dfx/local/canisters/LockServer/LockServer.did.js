export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'del' : IDL.Func([IDL.Text], [], []),
    'get' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'setNx' : IDL.Func(
        [IDL.Text],
        [IDL.Record({ 'status' : IDL.Bool, 'time' : IDL.Int })],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
