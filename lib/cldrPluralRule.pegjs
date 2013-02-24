CONDITION    = a:SUBCONDITION " and "i b:CONDITION { return {type: 'and', operands: [a, b]}; }
             / a:SUBCONDITION " or "i b:CONDITION  { return {type: 'or', operands: [a, b]}; }
             / " not "i a:CONDITION                { return {type: 'not', operand: a}; }
             / SUBCONDITION

SUBCONDITION = ex:EXPRESSION " is not "i i:INT     { return {type: 'isnot', operands: [ex, i] }; }
             / ex:EXPRESSION " is "i i:INT         { return {type: 'is', operands: [ex, i]}; }
             / ex:EXPRESSION " within "i rangelist:RANGELIST  { return {type: 'within', operands: [ex, rangelist]}; }
             / ex:EXPRESSION " not within "i rangelist:RANGELIST { return {type: 'notwithin', operands: [ex, rangelist]}; }
             / ex:EXPRESSION " in "i rangelist:RANGELIST { return {type: 'in', operands: [ex, rangelist]}; }
             / ex:EXPRESSION " not in "i rangelist:RANGELIST  { return {type: 'notin', operands: [ex, rangelist]}; }

EXPRESSION   = t:TERM " mod "i i:INT {return {type: 'mod', operands: [t, i]}; }
             / TERM

TERM         = INT
             / "n"i                                { return {type: 'n'}; }

RANGELIST    = range:RANGE " "* "," " "* rangelist:RANGELIST      { rangelist.ranges.unshift(range); return rangelist; }
             / range:RANGE                            { return {type: 'rangelist', ranges: [range]}; }

RANGE        = min:INT " "* ".." " "* max:INT                { return {type: 'range', min: min, max: max}; }
             / i:INT                               { return i; }

INT          = sign:[-+]? digits:[0-9]+            { return {type: 'number', value: parseInt(sign + digits.join(""), 10)}; }
