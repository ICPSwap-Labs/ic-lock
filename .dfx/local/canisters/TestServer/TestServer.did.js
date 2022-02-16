export const idlFactory = ({ IDL }) => {
  return IDL.Service({ 'testCall' : IDL.Func([], [IDL.Bool], []) });
};
export const init = ({ IDL }) => { return []; };
