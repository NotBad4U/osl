open Prelude
open Constants
open Constants.K
module Def = struct
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = interned_bottom
let evalisBool (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBool and sort = 
SortBool in match c with 
| [Bool _] -> [Bool true]
(*{| rule ``isBool(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__0) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBool(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_andBool_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andBool_`(_1,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_1) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(288) org.kframework.attributes.Location(Location(288,8,288,37)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as var_1_2) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andBool_`(B,#token("true","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(286) org.kframework.attributes.Location(Location(286,8,286,37)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB_3) :: []),((Bool true) :: [])) when true && (true) -> (varB_3 :: [])
(*{| rule `` `_andBool_`(#token("false","Bool"),_5)=>#token("false","Bool")`` requires isBool(_5) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(287) org.kframework.attributes.Location(Location(287,8,287,37)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: []),((Bool _ as var_5_4) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andBool_`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(285) org.kframework.attributes.Location(Location(285,8,285,37)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool true) :: []),((Bool _ as varB_5) :: [])) when true && (true) -> (varB_5 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalisInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisInt and sort = 
SortBool in match c with 
| [Int _] -> [Bool true]
(*{| rule ``isInt(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__6) :: [])) -> ((Bool true) :: [])
(*{| rule ``isInt(#cint(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isInt(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'cint,((Int _ as varK0_7) :: []),((Int _ as varK1_8) :: [])) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isInt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_9)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisProp (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProp and sort = 
SortBool in match c with 
(*{| rule ``isProp(`copy_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lblcopy_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProp(`mut_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lblmut_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProp(#KToken(#token("Prop","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProp, var__10) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProp(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_11)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisProps (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProps and sort = 
SortBool in match c with 
(*{| rule ``isProps(#props(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProp(K0),isProps(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'props,(varK0_12 :: []),(varK1_13 :: [])) :: [])) when (((isTrue (evalisProp((varK0_12 :: [])) config (-1)))) && ((isTrue (evalisProps((varK1_13 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProps(`.List{"#props"}`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Stop'List'LBraQuotHash'props'QuotRBra') :: [])) -> ((Bool true) :: [])
(*{| rule ``isProps(#KToken(#token("Props","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProps, var__14) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProps(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_15)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisValue (c: k) (config: k) (guard: int) : k = let lbl = 
LblisValue and sort = 
SortBool in match c with 
(*{| rule ``isValue(#ref(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'ref,((Int _ as varK0_16) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isValue(#KToken(#token("Value","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortValue, var__17) :: [])) -> ((Bool true) :: [])
(*{| rule ``isValue(`#void_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'void_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isValue(#rs(K0))=>#token("true","Bool")`` requires isProps(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'rs,(varK0_18 :: [])) :: [])) when (isTrue (evalisProps((varK0_18 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isValue(#immRef(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'immRef,((Int _ as varK0_19) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isValue(#mutRef(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'mutRef,((Int _ as varK0_20) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isValue(#loc(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'loc,((Int _ as varK0_21) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isValue(#Loc(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isValue(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'Loc,(varK0_22 :: []),((Int _ as varK1_23) :: [])) :: [])) when (((isTrue (evalisValue((varK0_22 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isValue(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_24)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisK (c: k) (config: k) (guard: int) : k = let lbl = 
LblisK and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortFunDefCellMap) -> [Bool true]
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
| [_] -> [Bool true] | _ -> [Bool false]
| [Map (s,_,_)] when (s = SortStateCellMap) -> [Bool true]
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
| [Float _] -> [Bool true]
| [Int _] -> [Bool true]
| [Bool _] -> [Bool true]
| [List (s,_,_)] when (s = SortList) -> [Bool true]
| _ -> [Bool true]
| [String _] -> [Bool true]
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisId (c: k) (config: k) (guard: int) : k = let lbl = 
LblisId and sort = 
SortBool in match c with 
(*{| rule ``isId(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__25) :: [])) -> ((Bool true) :: [])
(*{| rule ``isId(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_26)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisExps (c: k) (config: k) (guard: int) : k = let lbl = 
LblisExps and sort = 
SortBool in match c with 
(*{| rule ``isExps(`_,__OSL-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isExps(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(varK0_27 :: []),(varK1_28 :: [])) :: [])) when (((isTrue (evalisExp((varK0_27 :: [])) config (-1)))) && ((isTrue (evalisExps((varK1_28 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExps(#KToken(#token("Exps","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortExps, var__29) :: [])) -> ((Bool true) :: [])
(*{| rule ``isExps(`.List{"_,__OSL-SYNTAX"}`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra') :: [])) -> ((Bool true) :: [])
(*{| rule ``isExps(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_30)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisExp (c: k) (config: k) (guard: int) : k = let lbl = 
LblisExp and sort = 
SortBool in match c with 
(*{| rule ``isExp(#Loc(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isValue(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'Loc,(varK0_31 :: []),((Int _ as varK1_32) :: [])) :: [])) when (((isTrue (evalisValue((varK0_31 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#immRef(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'immRef,((Int _ as varK0_33) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(`*__OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__OSL'Hyph'SYNTAX,(varK0_34 :: [])) :: [])) when (isTrue (evalisExp((varK0_34 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#TransferV(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'TransferV,(varK0_35 :: []),(varK1_36 :: [])) :: [])) when (((isTrue (evalisExp((varK0_35 :: [])) config (-1)))) && ((isTrue (evalisExp((varK1_36 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#lvDref(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'lvDref,(varK0_37 :: [])) :: [])) when (isTrue (evalisExp((varK0_37 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#read(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'read,(varK0_38 :: [])) :: [])) when (isTrue (evalisExp((varK0_38 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#mutRef(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'mutRef,((Int _ as varK0_39) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(`_.__OSL-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Stop'__OSL'Hyph'SYNTAX,(varK0_40 :: []),((Int _ as varK1_41) :: [])) :: [])) when (((isTrue (evalisExp((varK0_40 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#ref(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'ref,((Int _ as varK0_42) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(`#void_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'void_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isExp(#TransferIB(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isK(K0),isK(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'TransferIB,(varK0_43),(varK1_44)) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#loc(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'loc,((Int _ as varK0_45) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#FnCall(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isId(K0),isExps(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'FnCall,(varK0_46 :: []),(varK1_47 :: [])) :: [])) when (((isTrue (evalisId((varK0_46 :: [])) config (-1)))) && ((isTrue (evalisExps((varK1_47 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#uninitialize(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'uninitialize,(varK0_48 :: [])) :: [])) when (isTrue (evalisExp((varK0_48 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#rs(K0))=>#token("true","Bool")`` requires isProps(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'rs,(varK0_49 :: [])) :: [])) when (isTrue (evalisProps((varK0_49 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#TransferMB(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isK(K0),isK(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'TransferMB,(varK0_50),(varK1_51)) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#mutBorrow(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'mutBorrow,(varK0_52 :: [])) :: [])) when (isTrue (evalisExp((varK0_52 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#lv(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'lv,(varK0_53 :: [])) :: [])) when (isTrue (evalisExp((varK0_53 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(`newResource(_)_OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isProps(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblnewResource'LPar'_'RPar'_OSL'Hyph'SYNTAX,(varK0_54 :: [])) :: [])) when (isTrue (evalisProps((varK0_54 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#KToken(#token("Value","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortValue, var__55) :: [])) -> ((Bool true) :: [])
(*{| rule ``isExp(#KToken(#token("Borrow","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBorrow, var__56) :: [])) -> ((Bool true) :: [])
(*{| rule ``isExp(#immBorrow(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'immBorrow,(varK0_57 :: [])) :: [])) when (isTrue (evalisExp((varK0_57 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#KToken(#token("Exp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortExp, var__58) :: [])) -> ((Bool true) :: [])
(*{| rule ``isExp(#Transfer(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'Transfer,(varK0_59 :: []),(varK1_60 :: [])) :: [])) when (((isTrue (evalisExp((varK0_59 :: [])) config (-1)))) && ((isTrue (evalisExp((varK1_60 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isExp(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__61) :: [])) -> ((Bool true) :: [])
(*{| rule ``isExp(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_62)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisDItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisDItem and sort = 
SortBool in match c with 
(*{| rule ``isDItem(#KToken(#token("DItem","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortDItem, var__63) :: [])) -> ((Bool true) :: [])
(*{| rule ``isDItem(#Deallocate(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'Deallocate,(varK0_64 :: [])) :: [])) when (isTrue (evalisExp((varK0_64 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isDItem(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_65)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_FunDefCellMap_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_FunDefCellMap_ and sort = 
SortFunDefCellMap in match c with 
| _ -> try MAP.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisIndexCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIndexCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isIndexCellOpt(noIndexCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoIndexCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexCellOpt(#KToken(#token("IndexCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexCell, var__66) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexCellOpt(`<index>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'index'_GT_',((Int _ as varK0_67) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIndexCellOpt(#KToken(#token("IndexCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexCellOpt, var__68) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_69)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isKCellOpt(noKCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoKCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_70)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__71) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(#KToken(#token("KCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCellOpt, var__72) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_73)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMap and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
(*{| rule ``isMap(#KToken(#token("Map","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMap, var__74) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_75)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisEnvCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisEnvCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isEnvCellOpt(#KToken(#token("EnvCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEnvCellOpt, var__76) :: [])) -> ((Bool true) :: [])
(*{| rule ``isEnvCellOpt(#KToken(#token("EnvCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEnvCell, var__77) :: [])) -> ((Bool true) :: [])
(*{| rule ``isEnvCellOpt(`<env>`(K0))=>#token("true","Bool")`` requires isMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as varK0_78) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isEnvCellOpt(noEnvCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoEnvCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isEnvCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_79)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStoreCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStoreCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isStoreCellOpt(noStoreCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoStoreCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStoreCellOpt(#KToken(#token("StoreCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStoreCellOpt, var__80) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStoreCellOpt(#KToken(#token("StoreCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStoreCell, var__81) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStoreCellOpt(`<store>`(K0))=>#token("true","Bool")`` requires isMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as varK0_82) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStoreCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_83)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisList and sort = 
SortBool in match c with 
| [List (s,_,_)] when (s = SortList) -> [Bool true]
(*{| rule ``isList(#KToken(#token("List","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortList, var__84) :: [])) -> ((Bool true) :: [])
(*{| rule ``isList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_85)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStackCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStackCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isStackCellOpt(#KToken(#token("StackCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStackCellOpt, var__86) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStackCellOpt(#KToken(#token("StackCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStackCell, var__87) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStackCellOpt(`<stack>`(K0))=>#token("true","Bool")`` requires isList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as varK0_88) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStackCellOpt(noStackCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoStackCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStackCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_89)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSet (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSet and sort = 
SortBool in match c with 
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
(*{| rule ``isSet(#KToken(#token("Set","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSet, var__90) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSet(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_91)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWriteCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWriteCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isWriteCellOpt(#KToken(#token("WriteCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWriteCell, var__92) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWriteCellOpt(#KToken(#token("WriteCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWriteCellOpt, var__93) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWriteCellOpt(noWriteCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoWriteCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWriteCellOpt(`<write>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as varK0_94) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWriteCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_95)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTimerCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTimerCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isTimerCellOpt(noTimerCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoTimerCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTimerCellOpt(`<timer>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'timer'_GT_',((Int _ as varK0_96) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTimerCellOpt(#KToken(#token("TimerCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTimerCell, var__97) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTimerCellOpt(#KToken(#token("TimerCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTimerCellOpt, var__98) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTimerCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_99)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisUnsafeModeCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisUnsafeModeCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isUnsafeModeCellOpt(#KToken(#token("UnsafeModeCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnsafeModeCellOpt, var__100) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUnsafeModeCellOpt(`<unsafe-mode>`(K0))=>#token("true","Bool")`` requires isBool(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as varK0_101) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isUnsafeModeCellOpt(noUnsafeModeCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoUnsafeModeCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUnsafeModeCellOpt(#KToken(#token("UnsafeModeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnsafeModeCell, var__102) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUnsafeModeCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_103)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIndexes (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIndexes and sort = 
SortBool in match c with 
(*{| rule ``isIndexes(#KToken(#token("Indexes","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexes, var__104) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexes(#indexes(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isInt(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'indexes,((Int _ as varK0_105) :: []),((Int _ as varK1_106) :: [])) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isIndexes(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_107)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIndexesCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIndexesCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isIndexesCellOpt(#KToken(#token("IndexesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexesCell, var__108) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexesCellOpt(`<indexes>`(K0))=>#token("true","Bool")`` requires isIndexes(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'indexes'_GT_',(varK0_109 :: [])) :: [])) when (isTrue (evalisIndexes((varK0_109 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isIndexesCellOpt(#KToken(#token("IndexesCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexesCellOpt, var__110) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexesCellOpt(noIndexesCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoIndexesCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexesCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_111)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStateCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStateCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isStateCellFragment(`<state>-fragment`(K0,K1,K2,K3,K4,K5,K6,K7,K8))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIndexCellOpt(K0),isKCellOpt(K1)),isEnvCellOpt(K2)),isStoreCellOpt(K3)),isStackCellOpt(K4)),isWriteCellOpt(K5)),isTimerCellOpt(K6)),isUnsafeModeCellOpt(K7)),isIndexesCellOpt(K8)) ensures #token("true","Bool") []|}*)
| ((KApply9(Lbl'_LT_'state'_GT_Hyph'fragment,(varK0_112 :: []),(varK1_113 :: []),(varK2_114 :: []),(varK3_115 :: []),(varK4_116 :: []),(varK5_117 :: []),(varK6_118 :: []),(varK7_119 :: []),(varK8_120 :: [])) :: [])) when (((((((((((((((((isTrue (evalisIndexCellOpt((varK0_112 :: [])) config (-1)))) && ((isTrue (evalisKCellOpt((varK1_113 :: [])) config (-1)))))) && ((isTrue (evalisEnvCellOpt((varK2_114 :: [])) config (-1)))))) && ((isTrue (evalisStoreCellOpt((varK3_115 :: [])) config (-1)))))) && ((isTrue (evalisStackCellOpt((varK4_116 :: [])) config (-1)))))) && ((isTrue (evalisWriteCellOpt((varK5_117 :: [])) config (-1)))))) && ((isTrue (evalisTimerCellOpt((varK6_118 :: [])) config (-1)))))) && ((isTrue (evalisUnsafeModeCellOpt((varK7_119 :: [])) config (-1)))))) && ((isTrue (evalisIndexesCellOpt((varK8_120 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStateCellFragment(#KToken(#token("StateCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCellFragment, var__121) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_122)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateMap (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateMap and sort = 
SortMap in match c with 
| _ -> try MAP.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_orBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(303) org.kframework.attributes.Location(Location(303,8,303,32)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB_123) :: []),((Bool false) :: [])) when true && (true) -> (varB_123 :: [])
(*{| rule `` `_orBool__BOOL`(#token("true","Bool"),_2)=>#token("true","Bool")`` requires isBool(_2) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(300) org.kframework.attributes.Location(Location(300,8,300,34)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool true) :: []),((Bool _ as var_2_124) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(302) org.kframework.attributes.Location(Location(302,8,302,32)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: []),((Bool _ as varB_125) :: [])) when true && (true) -> (varB_125 :: [])
(*{| rule `` `_orBool__BOOL`(_9,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_9) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(301) org.kframework.attributes.Location(Location(301,8,301,34)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as var_9_126) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisBorrow (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBorrow and sort = 
SortBool in match c with 
(*{| rule ``isBorrow(#mutBorrow(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'mutBorrow,(varK0_127 :: [])) :: [])) when (isTrue (evalisExp((varK0_127 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBorrow(#immBorrow(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'immBorrow,(varK0_128 :: [])) :: [])) when (isTrue (evalisExp((varK0_128 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBorrow(#KToken(#token("Borrow","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBorrow, var__129) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBorrow(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_130)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitUnsafeModeCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitUnsafeModeCell and sort = 
SortUnsafeModeCell in match c with 
(*{| rule ``initUnsafeModeCell(.KList)=>`<unsafe-mode>`(#token("false","Bool"))`` requires isBool(#token("false","Bool")) ensures #token("true","Bool") [initializer()]|}*)
| () when (isTrue (evalisBool(((Bool false) :: [])) config (-1))) && (true) -> (KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool false) :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitUnsafeModeCell : k Lazy.t = lazy (evalinitUnsafeModeCell () interned_bottom (-1))
let evaldirectionalityChar (c: k) (config: k) (guard: int) : k = let lbl = 
LbldirectionalityChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_directionality c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSet'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'choice and sort = 
SortK in match c with 
| _ -> try SET.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitFbodyCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitFbodyCell and sort = 
SortFbodyCell in match c with 
(*{| rule ``initFbodyCell(.KList)=>`<fbody>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'fbody'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitFbodyCell : k Lazy.t = lazy (evalinitFbodyCell () interned_bottom (-1))
let eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_update c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisLifetime (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLifetime and sort = 
SortBool in match c with 
| [Int _] -> [Bool true]
(*{| rule ``isLifetime(#KToken(#token("Lifetime","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLifetime, var__131) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLifetime(#cint(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isInt(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'cint,((Int _ as varK0_132) :: []),((Int _ as varK1_133) :: [])) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isLifetime(`'__OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isId(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Apos'__OSL'Hyph'SYNTAX,(varK0_134 :: [])) :: [])) when (isTrue (evalisId((varK0_134 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLifetime(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__135) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLifetime(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_136)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisType (c: k) (config: k) (guard: int) : k = let lbl = 
LblisType and sort = 
SortBool in match c with 
(*{| rule ``isType(#own(K0))=>#token("true","Bool")`` requires isProps(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'own,(varK0_137 :: [])) :: [])) when (isTrue (evalisProps((varK0_137 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isType(#ref(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLifetime(K0),isType(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'ref,(varK0_138 :: []),(varK1_139 :: [])) :: [])) when (((isTrue (evalisLifetime((varK0_138 :: [])) config (-1)))) && ((isTrue (evalisType((varK1_139 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isType(`#voidTy_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'voidTy_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isType(#KToken(#token("Type","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortType, var__140) :: [])) -> ((Bool true) :: [])
(*{| rule ``isType(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_141)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisParameter (c: k) (config: k) (guard: int) : k = let lbl = 
LblisParameter and sort = 
SortBool in match c with 
(*{| rule ``isParameter(#KToken(#token("Parameter","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParameter, var__142) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParameter(#parameter(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isId(K0),isType(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'parameter,(varK0_143 :: []),(varK1_144 :: [])) :: [])) when (((isTrue (evalisId((varK0_143 :: [])) config (-1)))) && ((isTrue (evalisType((varK1_144 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isParameter(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_145)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisParameters (c: k) (config: k) (guard: int) : k = let lbl = 
LblisParameters and sort = 
SortBool in match c with 
(*{| rule ``isParameters(`_,__OSL-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isParameter(K0),isParameters(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(varK0_146 :: []),(varK1_147 :: [])) :: [])) when (((isTrue (evalisParameter((varK0_146 :: [])) config (-1)))) && ((isTrue (evalisParameters((varK1_147 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isParameters(#KToken(#token("Parameters","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParameters, var__148) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParameters(`.List{"_,__OSL-SYNTAX"}`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra') :: [])) -> ((Bool true) :: [])
(*{| rule ``isParameters(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_149)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIndexCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIndexCell and sort = 
SortBool in match c with 
(*{| rule ``isIndexCell(`<index>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'index'_GT_',((Int _ as varK0_150) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIndexCell(#KToken(#token("IndexCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexCell, var__151) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_152)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCell and sort = 
SortBool in match c with 
(*{| rule ``isKCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__153) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_154)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_155)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisEnvCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisEnvCell and sort = 
SortBool in match c with 
(*{| rule ``isEnvCell(#KToken(#token("EnvCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEnvCell, var__156) :: [])) -> ((Bool true) :: [])
(*{| rule ``isEnvCell(`<env>`(K0))=>#token("true","Bool")`` requires isMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as varK0_157) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isEnvCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_158)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStoreCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStoreCell and sort = 
SortBool in match c with 
(*{| rule ``isStoreCell(#KToken(#token("StoreCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStoreCell, var__159) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStoreCell(`<store>`(K0))=>#token("true","Bool")`` requires isMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as varK0_160) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStoreCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_161)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStackCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStackCell and sort = 
SortBool in match c with 
(*{| rule ``isStackCell(#KToken(#token("StackCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStackCell, var__162) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStackCell(`<stack>`(K0))=>#token("true","Bool")`` requires isList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as varK0_163) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStackCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_164)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWriteCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWriteCell and sort = 
SortBool in match c with 
(*{| rule ``isWriteCell(`<write>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as varK0_165) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWriteCell(#KToken(#token("WriteCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWriteCell, var__166) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWriteCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_167)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTimerCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTimerCell and sort = 
SortBool in match c with 
(*{| rule ``isTimerCell(`<timer>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'timer'_GT_',((Int _ as varK0_168) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTimerCell(#KToken(#token("TimerCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTimerCell, var__169) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTimerCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_170)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisUnsafeModeCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisUnsafeModeCell and sort = 
SortBool in match c with 
(*{| rule ``isUnsafeModeCell(#KToken(#token("UnsafeModeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnsafeModeCell, var__171) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUnsafeModeCell(`<unsafe-mode>`(K0))=>#token("true","Bool")`` requires isBool(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as varK0_172) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isUnsafeModeCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_173)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIndexesCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIndexesCell and sort = 
SortBool in match c with 
(*{| rule ``isIndexesCell(`<indexes>`(K0))=>#token("true","Bool")`` requires isIndexes(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'indexes'_GT_',(varK0_174 :: [])) :: [])) when (isTrue (evalisIndexes((varK0_174 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isIndexesCell(#KToken(#token("IndexesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexesCell, var__175) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexesCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_176)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStateCellMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStateCellMap and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortStateCellMap) -> [Bool true]
(*{| rule ``isStateCellMap(#KToken(#token("StateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCell, var__177) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCellMap(`<state>`(K0,K1,K2,K3,K4,K5,K6,K7,K8))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIndexCell(K0),isKCell(K1)),isEnvCell(K2)),isStoreCell(K3)),isStackCell(K4)),isWriteCell(K5)),isTimerCell(K6)),isUnsafeModeCell(K7)),isIndexesCell(K8)) ensures #token("true","Bool") []|}*)
| ((KApply9(Lbl'_LT_'state'_GT_',(varK0_178 :: []),(varK1_179 :: []),(varK2_180 :: []),(varK3_181 :: []),(varK4_182 :: []),(varK5_183 :: []),(varK6_184 :: []),(varK7_185 :: []),(varK8_186 :: [])) :: [])) when (((((((((((((((((isTrue (evalisIndexCell((varK0_178 :: [])) config (-1)))) && ((isTrue (evalisKCell((varK1_179 :: [])) config (-1)))))) && ((isTrue (evalisEnvCell((varK2_180 :: [])) config (-1)))))) && ((isTrue (evalisStoreCell((varK3_181 :: [])) config (-1)))))) && ((isTrue (evalisStackCell((varK4_182 :: [])) config (-1)))))) && ((isTrue (evalisWriteCell((varK5_183 :: [])) config (-1)))))) && ((isTrue (evalisTimerCell((varK6_184 :: [])) config (-1)))))) && ((isTrue (evalisUnsafeModeCell((varK7_185 :: [])) config (-1)))))) && ((isTrue (evalisIndexesCell((varK8_186 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStateCellMap(#KToken(#token("StateCellMap","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCellMap, var__187) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCellMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_188)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFnameCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFnameCell and sort = 
SortBool in match c with 
(*{| rule ``isFnameCell(#KToken(#token("FnameCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFnameCell, var__189) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFnameCell(`<fname>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fname'_GT_',(varK0_190)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFnameCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_191)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFparamsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFparamsCell and sort = 
SortBool in match c with 
(*{| rule ``isFparamsCell(#KToken(#token("FparamsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFparamsCell, var__192) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFparamsCell(`<fparams>`(K0))=>#token("true","Bool")`` requires isParameters(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fparams'_GT_',(varK0_193 :: [])) :: [])) when (isTrue (evalisParameters((varK0_193 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isFparamsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_194)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFretCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFretCell and sort = 
SortBool in match c with 
(*{| rule ``isFretCell(`<fret>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fret'_GT_',(varK0_195)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFretCell(#KToken(#token("FretCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFretCell, var__196) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFretCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_197)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFbodyCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFbodyCell and sort = 
SortBool in match c with 
(*{| rule ``isFbodyCell(`<fbody>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fbody'_GT_',(varK0_198)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFbodyCell(#KToken(#token("FbodyCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFbodyCell, var__199) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFbodyCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_200)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFunDefCellMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunDefCellMap and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortFunDefCellMap) -> [Bool true]
(*{| rule ``isFunDefCellMap(#KToken(#token("FunDefCellMap","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefCellMap, var__201) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefCellMap(`<funDef>`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isFnameCell(K0),isFparamsCell(K1)),isFretCell(K2)),isFbodyCell(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'funDef'_GT_',(varK0_202 :: []),(varK1_203 :: []),(varK2_204 :: []),(varK3_205 :: [])) :: [])) when (((((((isTrue (evalisFnameCell((varK0_202 :: [])) config (-1)))) && ((isTrue (evalisFparamsCell((varK1_203 :: [])) config (-1)))))) && ((isTrue (evalisFretCell((varK2_204 :: [])) config (-1)))))) && ((isTrue (evalisFbodyCell((varK3_205 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isFunDefCellMap(#KToken(#token("FunDefCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefCell, var__206) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefCellMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_207)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStatesCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStatesCell and sort = 
SortBool in match c with 
(*{| rule ``isStatesCell(`<states>`(K0))=>#token("true","Bool")`` requires isStateCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'states'_GT_',((Map (SortStateCellMap,_,_) as varK0_208) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStatesCell(#KToken(#token("StatesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStatesCell, var__209) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStatesCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_210)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNstateCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNstateCell and sort = 
SortBool in match c with 
(*{| rule ``isNstateCell(#KToken(#token("NstateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNstateCell, var__211) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNstateCell(`<nstate>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'nstate'_GT_',((Int _ as varK0_212) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNstateCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_213)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTmpCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTmpCell and sort = 
SortBool in match c with 
(*{| rule ``isTmpCell(#KToken(#token("TmpCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTmpCell, var__214) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTmpCell(`<tmp>`(K0))=>#token("true","Bool")`` requires isList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'tmp'_GT_',((List (SortList,_,_) as varK0_215) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTmpCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_216)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFunDefsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunDefsCell and sort = 
SortBool in match c with 
(*{| rule ``isFunDefsCell(`<funDefs>`(K0))=>#token("true","Bool")`` requires isFunDefCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'funDefs'_GT_',((Map (SortFunDefCellMap,_,_) as varK0_217) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCell(#KToken(#token("FunDefsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefsCell, var__218) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_219)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisCell and sort = 
SortBool in match c with 
(*{| rule ``isCell(#KToken(#token("TmpCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTmpCell, var__220) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("IndexCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexCell, var__221) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("FbodyCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFbodyCell, var__222) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("NstateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNstateCell, var__223) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("WriteCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWriteCell, var__224) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<fname>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fname'_GT_',(varK0_225)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<fparams>`(K0))=>#token("true","Bool")`` requires isParameters(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fparams'_GT_',(varK0_226 :: [])) :: [])) when (isTrue (evalisParameters((varK0_226 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<nstate>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'nstate'_GT_',((Int _ as varK0_227) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<unsafe-mode>`(K0))=>#token("true","Bool")`` requires isBool(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as varK0_228) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__229) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<tmp>`(K0))=>#token("true","Bool")`` requires isList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'tmp'_GT_',((List (SortList,_,_) as varK0_230) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<states>`(K0))=>#token("true","Bool")`` requires isStateCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'states'_GT_',((Map (SortStateCellMap,_,_) as varK0_231) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("EnvCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEnvCell, var__232) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<indexes>`(K0))=>#token("true","Bool")`` requires isIndexes(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'indexes'_GT_',(varK0_233 :: [])) :: [])) when (isTrue (evalisIndexes((varK0_233 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<state>`(K0,K1,K2,K3,K4,K5,K6,K7,K8))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIndexCell(K0),isKCell(K1)),isEnvCell(K2)),isStoreCell(K3)),isStackCell(K4)),isWriteCell(K5)),isTimerCell(K6)),isUnsafeModeCell(K7)),isIndexesCell(K8)) ensures #token("true","Bool") []|}*)
| ((KApply9(Lbl'_LT_'state'_GT_',(varK0_234 :: []),(varK1_235 :: []),(varK2_236 :: []),(varK3_237 :: []),(varK4_238 :: []),(varK5_239 :: []),(varK6_240 :: []),(varK7_241 :: []),(varK8_242 :: [])) :: [])) when (((((((((((((((((isTrue (evalisIndexCell((varK0_234 :: [])) config (-1)))) && ((isTrue (evalisKCell((varK1_235 :: [])) config (-1)))))) && ((isTrue (evalisEnvCell((varK2_236 :: [])) config (-1)))))) && ((isTrue (evalisStoreCell((varK3_237 :: [])) config (-1)))))) && ((isTrue (evalisStackCell((varK4_238 :: [])) config (-1)))))) && ((isTrue (evalisWriteCell((varK5_239 :: [])) config (-1)))))) && ((isTrue (evalisTimerCell((varK6_240 :: [])) config (-1)))))) && ((isTrue (evalisUnsafeModeCell((varK7_241 :: [])) config (-1)))))) && ((isTrue (evalisIndexesCell((varK8_242 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<funDefs>`(K0))=>#token("true","Bool")`` requires isFunDefCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'funDefs'_GT_',((Map (SortFunDefCellMap,_,_) as varK0_243) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("IndexesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexesCell, var__244) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<fbody>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fbody'_GT_',(varK0_245)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TimerCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTimerCell, var__246) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<fret>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fret'_GT_',(varK0_247)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("FretCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFretCell, var__248) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("StackCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStackCell, var__249) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_250)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("UnsafeModeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnsafeModeCell, var__251) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("StoreCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStoreCell, var__252) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("FunDefsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefsCell, var__253) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("FnameCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFnameCell, var__254) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__255) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("FunDefCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefCell, var__256) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<write>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as varK0_257) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<funDef>`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isFnameCell(K0),isFparamsCell(K1)),isFretCell(K2)),isFbodyCell(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'funDef'_GT_',(varK0_258 :: []),(varK1_259 :: []),(varK2_260 :: []),(varK3_261 :: [])) :: [])) when (((((((isTrue (evalisFnameCell((varK0_258 :: [])) config (-1)))) && ((isTrue (evalisFparamsCell((varK1_259 :: [])) config (-1)))))) && ((isTrue (evalisFretCell((varK2_260 :: [])) config (-1)))))) && ((isTrue (evalisFbodyCell((varK3_261 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<stack>`(K0))=>#token("true","Bool")`` requires isList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as varK0_262) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<T>`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isStatesCell(K0),isNstateCell(K1)),isTmpCell(K2)),isFunDefsCell(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'T'_GT_',(varK0_263 :: []),(varK1_264 :: []),(varK2_265 :: []),(varK3_266 :: [])) :: [])) when (((((((isTrue (evalisStatesCell((varK0_263 :: [])) config (-1)))) && ((isTrue (evalisNstateCell((varK1_264 :: [])) config (-1)))))) && ((isTrue (evalisTmpCell((varK2_265 :: [])) config (-1)))))) && ((isTrue (evalisFunDefsCell((varK3_266 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<env>`(K0))=>#token("true","Bool")`` requires isMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as varK0_267) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("Cell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCell, var__268) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("FparamsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFparamsCell, var__269) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("StateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCell, var__270) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<index>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'index'_GT_',((Int _ as varK0_271) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<timer>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'timer'_GT_',((Int _ as varK0_272) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<store>`(K0))=>#token("true","Bool")`` requires isMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as varK0_273) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("StatesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStatesCell, var__274) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_275)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'Set (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Set and sort = 
SortSet in match c with 
| _ -> try SET.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Set : k Lazy.t = lazy (eval'Stop'Set () interned_bottom (-1))
let evalinitWriteCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitWriteCell and sort = 
SortWriteCell in match c with 
(*{| rule ``initWriteCell(.KList)=>`<write>`(`.Set`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'write'_GT_',((Lazy.force const'Stop'Set))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitWriteCell : k Lazy.t = lazy (evalinitWriteCell () interned_bottom (-1))
let evalMap'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'choice and sort = 
SortK in match c with 
| _ -> try MAP.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_List_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_List_ and sort = 
SortList in match c with 
| _ -> try LIST.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalListItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblListItem and sort = 
SortList in match c with 
| _ -> try LIST.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_Set_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Set_ and sort = 
SortSet in match c with 
| _ -> try SET.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalSetItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSetItem and sort = 
SortSet in match c with 
| _ -> try SET.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'List (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'List and sort = 
SortList in match c with 
| _ -> try LIST.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'List : k Lazy.t = lazy (eval'Stop'List () interned_bottom (-1))
let rec eval'Hash'list2Set (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'list2Set and sort = 
SortSet in match c with 
(*{| rule ``#list2Set(`_List_`(`ListItem`(E),L))=>`_Set_`(`SetItem`(E),#list2Set(L))`` requires isList(L) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(93) org.kframework.attributes.Location(Location(93,6,93,62)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((List (SortList, Lbl_List_, (varE_276) :: varL_277)) :: [])) when true && (true) -> ((eval_Set_(((evalSetItem((varE_276)) config (-1))),((eval'Hash'list2Set(((List (SortList, Lbl_List_, varL_277)) :: [])) config (-1)))) config (-1)))
(*{| rule ``#list2Set(`.List`(.KList))=>`.Set`(.KList)`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(92) org.kframework.attributes.Location(Location(92,6,92,30)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((List (SortList, Lbl_List_, [])) :: [])) -> ((Lazy.force const'Stop'Set))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalnotBool_ (c: k) (config: k) (guard: int) : k = let lbl = 
LblnotBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `notBool_`(#token("true","Bool"))=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(282) org.kframework.attributes.Location(Location(282,8,282,29)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool true) :: [])) -> ((Bool false) :: [])
(*{| rule `` `notBool_`(#token("false","Bool"))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(283) org.kframework.attributes.Location(Location(283,8,283,29)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: [])) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'K_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'K_ and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisString (c: k) (config: k) (guard: int) : k = let lbl = 
LblisString and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
(*{| rule ``isString(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__278) :: [])) -> ((Bool true) :: [])
(*{| rule ``isString(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_279)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==String__STRING`(S1,S2)=>`_==K_`(S1,S2)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(514) org.kframework.attributes.Location(Location(514,8,514,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_280) :: []),((String _ as varS2_281) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varS1_280 :: []),(varS2_281 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=String__STRING`(S1,S2)=>`notBool_`(`_==String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(513) org.kframework.attributes.Location(Location(513,8,513,65)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_282) :: []),((String _ as varS2_283) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'String__STRING((varS1_282 :: []),(varS2_283 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalremoveAll (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblremoveAll and sort = 
SortMap in match c with 
| _ -> try MAP.hook_removeAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_impliesBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_impliesBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_implies c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_impliesBool__BOOL`(B,#token("false","Bool"))=>`notBool_`(B)`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(313) org.kframework.attributes.Location(Location(313,8,313,45)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB_284) :: []),((Bool false) :: [])) when true && (true) -> ([Bool ((not ((isTrue [varB_284]))))])
(*{| rule `` `_impliesBool__BOOL`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(310) org.kframework.attributes.Location(Location(310,8,310,36)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool true) :: []),((Bool _ as varB_285) :: [])) when true && (true) -> (varB_285 :: [])
(*{| rule `` `_impliesBool__BOOL`(#token("false","Bool"),_4)=>#token("true","Bool")`` requires isBool(_4) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(311) org.kframework.attributes.Location(Location(311,8,311,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: []),((Bool _ as var_4_286) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(_6,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_6) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(312) org.kframework.attributes.Location(Location(312,8,312,39)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as var_6_287) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalcategoryChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblcategoryChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_category c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'IsMoved (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'IsMoved and sort = 
SortBool in match c with 
(*{| rule ``#IsMoved(Key,#rs(P),`#uninit_OSL-SYNTAX`(.KList))=>#token("false","Bool")`` requires `_andBool_`(isProps(P),isInt(Key)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(148) org.kframework.attributes.Location(Location(148,6,148,45)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (((Int _ as varKey_288) :: []),(KApply1(Lbl'Hash'rs,(varP_289 :: [])) :: []),(KApply0(Lbl'Hash'uninit_OSL'Hyph'SYNTAX) :: [])) when (((isTrue (evalisProps((varP_289 :: [])) config (-1)))) && (true)) && (true) -> ((Bool false) :: [])
(*{| rule ``#IsMoved(Key,#rs(P1),#rs(P2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isProps(P1),isProps(P2)),isInt(Key)),`_==K_`(P1,P2)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(145) org.kframework.attributes.Location(Location(145,6,146,24)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (((Int _ as varKey_290) :: []),(KApply1(Lbl'Hash'rs,(varP1_291 :: [])) :: []),(KApply1(Lbl'Hash'rs,(varP2_292 :: [])) :: [])) when (((((((isTrue (evalisProps((varP1_291 :: [])) config (-1)))) && ((isTrue (evalisProps((varP2_292 :: [])) config (-1)))))) && (true))) && ((isTrue (eval_'EqlsEqls'K_((varP1_291 :: []),(varP2_292 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``#IsMoved(Key,#rs(P),#br(_19,_20,_21))=>#token("false","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isExp(_21),isInt(_20)),isProps(P)),isInt(Key)),isInt(_19)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(149) org.kframework.attributes.Location(Location(149,6,149,48)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (((Int _ as varKey_293) :: []),(KApply1(Lbl'Hash'rs,(varP_294 :: [])) :: []),(KApply3(Lbl'Hash'br,((Int _ as var_19_295) :: []),((Int _ as var_20_296) :: []),(var_21_297 :: [])) :: [])) when (((((((((isTrue (evalisExp((var_21_297 :: [])) config (-1)))) && (true))) && ((isTrue (evalisProps((varP_294 :: [])) config (-1)))))) && (true))) && (true)) && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'_LT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalfindString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_find c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Plus'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'String__STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalsubstrString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblsubstrString and sort = 
SortString in match c with 
| _ -> try STRING.hook_substr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Plus'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_add c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evallengthString (c: k) (config: k) (guard: int) : k = let lbl = 
LbllengthString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_length c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceFirst c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,_12)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(_12),isString(Source)),isString(ToReplace)),`_<Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(543) org.kframework.attributes.Location(Location(543,8,544,57)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_298) :: []),((String _ as varToReplace_299) :: []),((String _ as var_12_300) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_298 :: []),(varToReplace_299 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_298 :: [])
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),substrString(Source,`_+Int__INT`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(Replacement)),isString(ToReplace)),`_>=Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(540) org.kframework.attributes.Location(Location(540,8,542,66)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_301) :: []),((String _ as varToReplace_302) :: []),((String _ as varReplacement_303) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_301 :: []),(varToReplace_302 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_301 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_301 :: []),(varToReplace_302 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_303 :: [])) config (-1))),((evalsubstrString((varSource_301 :: []),((eval_'Plus'Int__INT(((evalfindString((varSource_301 :: []),(varToReplace_302 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_302 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_301 :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'parseInModule (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parseInModule and sort = 
SortKItem in match c with 
| _ -> try IO.hook_parseInModule c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let rec evalisBlocks (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBlocks and sort = 
SortBool in match c with 
(*{| rule ``isBlocks(`_,__OSL-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBlock(K0),isBlocks(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(varK0_304 :: []),(varK1_305 :: [])) :: [])) when (((isTrue (evalisBlock((varK0_304 :: [])) config (-1)))) && ((isTrue (evalisBlocks((varK1_305 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBlocks(`.List{"_,__OSL-SYNTAX"}`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra') :: [])) -> ((Bool true) :: [])
(*{| rule ``isBlocks(#KToken(#token("Blocks","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBlocks, var__306) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBlocks(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_307)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisStmt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStmt and sort = 
SortBool in match c with 
(*{| rule ``isStmt(`unsafe_;_OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isBlock(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblunsafe_'SCln'_OSL'Hyph'SYNTAX,(varK0_308 :: [])) :: [])) when (isTrue (evalisBlock((varK0_308 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#block(K0))=>#token("true","Bool")`` requires isStmts(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'block,(varK0_309 :: [])) :: [])) when (isTrue (evalisStmts((varK0_309 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(val(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblval,(varK0_310 :: [])) :: [])) when (isTrue (evalisExp((varK0_310 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#decl(K0))=>#token("true","Bool")`` requires isId(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'decl,(varK0_311 :: [])) :: [])) when (isTrue (evalisId((varK0_311 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#KToken(#token("Block","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBlock, var__312) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStmt(`destruct_;_OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbldestruct_'SCln'_OSL'Hyph'SYNTAX,(varK0_313 :: [])) :: [])) when (isTrue (evalisExp((varK0_313 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#KToken(#token("Stmt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStmt, var__314) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStmt(#branch(K0))=>#token("true","Bool")`` requires isBlocks(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'branch,(varK0_315 :: [])) :: [])) when (isTrue (evalisBlocks((varK0_315 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(`loop_;_OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isBlock(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblloop_'SCln'_OSL'Hyph'SYNTAX,(varK0_316 :: [])) :: [])) when (isTrue (evalisBlock((varK0_316 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#declTy(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isId(K0),isType(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'declTy,(varK0_317 :: []),(varK1_318 :: [])) :: [])) when (((isTrue (evalisId((varK0_317 :: [])) config (-1)))) && ((isTrue (evalisType((varK1_318 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(`debug_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbldebug_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStmt(`_;_OSL-SYNTAX`(K0))=>#token("true","Bool")`` requires isFunction(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl_'SCln'_OSL'Hyph'SYNTAX,(varK0_319 :: [])) :: [])) when (isTrue (evalisFunction((varK0_319 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#transfer(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'transfer,(varK0_320 :: []),(varK1_321 :: [])) :: [])) when (((isTrue (evalisExp((varK0_320 :: [])) config (-1)))) && ((isTrue (evalisExp((varK1_321 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#repeat(K0))=>#token("true","Bool")`` requires isBlock(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'repeat,(varK0_322 :: [])) :: [])) when (isTrue (evalisBlock((varK0_322 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#mborrow(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'mborrow,(varK0_323 :: []),(varK1_324 :: [])) :: [])) when (((isTrue (evalisExp((varK0_323 :: [])) config (-1)))) && ((isTrue (evalisExp((varK1_324 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#borrow(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isExp(K0),isExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'borrow,(varK0_325 :: []),(varK1_326 :: [])) :: [])) when (((isTrue (evalisExp((varK0_325 :: [])) config (-1)))) && ((isTrue (evalisExp((varK1_326 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#deallocate(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'deallocate,(varK0_327 :: [])) :: [])) when (isTrue (evalisExp((varK0_327 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(#expStmt(K0))=>#token("true","Bool")`` requires isExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'expStmt,(varK0_328 :: [])) :: [])) when (isTrue (evalisExp((varK0_328 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_329)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisStmts (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStmts and sort = 
SortBool in match c with 
(*{| rule ``isStmts(`.List{"___OSL-SYNTAX"}`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Stop'List'LBraQuot'___OSL'Hyph'SYNTAX'QuotRBra') :: [])) -> ((Bool true) :: [])
(*{| rule ``isStmts(#KToken(#token("Stmts","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStmts, var__330) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStmts(`___OSL-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isStmt(K0),isStmts(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl___OSL'Hyph'SYNTAX,(varK0_331 :: []),(varK1_332 :: [])) :: [])) when (((isTrue (evalisStmt((varK0_331 :: [])) config (-1)))) && ((isTrue (evalisStmts((varK1_332 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStmts(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_333)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisBlock (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBlock and sort = 
SortBool in match c with 
(*{| rule ``isBlock(#KToken(#token("Block","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBlock, var__334) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBlock(#block(K0))=>#token("true","Bool")`` requires isStmts(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'block,(varK0_335 :: [])) :: [])) when (isTrue (evalisStmts((varK0_335 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBlock(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_336)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisFunction (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunction and sort = 
SortBool in match c with 
(*{| rule ``isFunction(#KToken(#token("Function","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunction, var__337) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunction(#function(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isId(K0),isParameters(K1)),isType(K2)),isBlock(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'Hash'function,(varK0_338 :: []),(varK1_339 :: []),(varK2_340 :: []),(varK3_341 :: [])) :: [])) when (((((((isTrue (evalisId((varK0_338 :: [])) config (-1)))) && ((isTrue (evalisParameters((varK1_339 :: [])) config (-1)))))) && ((isTrue (evalisType((varK2_340 :: [])) config (-1)))))) && ((isTrue (evalisBlock((varK3_341 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isFunction(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_342)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'Int_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Int_ and sort = 
SortBool in match c with 
| _ -> try INT.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Int_`(I1,I2)=>`_==K_`(I1,I2)`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(379) org.kframework.attributes.Location(Location(379,8,379,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI1_343) :: []),((Int _ as varI2_344) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varI1_343 :: []),(varI2_344 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalordChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblordChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_ord c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys_list'LPar'_'RPar'_MAP (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys_list'LPar'_'RPar'_MAP and sort = 
SortList in match c with 
| _ -> try MAP.hook_keys_list c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFnameCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFnameCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isFnameCellOpt(`<fname>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fname'_GT_',(varK0_345)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFnameCellOpt(#KToken(#token("FnameCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFnameCell, var__346) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFnameCellOpt(noFnameCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoFnameCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFnameCellOpt(#KToken(#token("FnameCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFnameCellOpt, var__347) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFnameCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_348)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKLabel (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKLabel and sort = 
SortBool in match c with 
(*{| rule ``isKLabel(#KToken(#token("KLabel","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKLabel, var__349) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKLabel(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_350)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsize (c: k) (config: k) (guard: int) : k = let lbl = 
Lblsize and sort = 
SortInt in match c with 
| _ -> try SET.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'lookup (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookup and sort = 
SortK in match c with 
| _ -> try MAP.hook_lookup c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalgetKLabel (c: k) (config: k) (guard: int) : k = let lbl = 
LblgetKLabel and sort = 
SortKItem in match c with 
| _ -> try KREFLECTION.hook_getKLabel c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsSlshEqls'K__K'Hyph'EQUAL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'K__K'Hyph'EQUAL and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=K__K-EQUAL`(K1,K2)=>`notBool_`(`_==K_`(K1,K2))`` requires `_andBool_`(isK(K2),isK(K1)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(612) org.kframework.attributes.Location(Location(612,8,612,45)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| ((varK1_351),(varK2_352)) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'K_((varK1_351),(varK2_352)) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalSet'Coln'in (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'in and sort = 
SortBool in match c with 
| _ -> try SET.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Slsh'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Slsh'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_tdiv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_sub c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Perc'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Perc'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_tmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalabsInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblabsInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_abs c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsSlshEqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Int__INT`(I1,I2)=>`notBool_`(`_==Int_`(I1,I2))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(380) org.kframework.attributes.Location(Location(380,8,380,53)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI1_353) :: []),((Int _ as varI2_354) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Int_((varI1_353 :: []),(varI2_354 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_modInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_modInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_emod c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_modInt__INT`(I1,I2)=>`_%Int__INT`(`_+Int__INT`(`_%Int__INT`(I1,absInt(I2)),absInt(I2)),absInt(I2))`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [concrete() contentStartColumn(5) contentStartLine(366) org.kframework.attributes.Location(Location(366,5,369,23)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI1_355) :: []),((Int _ as varI2_356) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_356 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Perc'Int__INT(((eval_'Plus'Int__INT(((eval_'Perc'Int__INT((varI1_355 :: []),((evalabsInt((varI2_356 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_356 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_356 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_divInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_divInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_ediv c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_divInt__INT`(I1,I2)=>`_/Int__INT`(`_-Int__INT`(I1,`_modInt__INT`(I1,I2)),I2)`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(363) org.kframework.attributes.Location(Location(363,8,364,23)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI1_357) :: []),((Int _ as varI2_358) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_358 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Slsh'Int__INT(((eval_'Hyph'Int__INT((varI1_357 :: []),((eval_modInt__INT((varI1_357 :: []),(varI2_358 :: [])) config (-1)))) config (-1))),(varI2_358 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisOItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisOItem and sort = 
SortBool in match c with 
(*{| rule ``isOItem(#borrowMutCK(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(K0),isInt(K1)),isInt(K2)),isInt(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'Hash'borrowMutCK,((Int _ as varK0_359) :: []),((Int _ as varK1_360) :: []),((Int _ as varK2_361) :: []),((Int _ as varK3_362) :: [])) :: [])) when ((((((true) && (true))) && (true))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isOItem(#borrowImmCK(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(K0),isInt(K1)),isInt(K2)),isInt(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'Hash'borrowImmCK,((Int _ as varK0_363) :: []),((Int _ as varK1_364) :: []),((Int _ as varK2_365) :: []),((Int _ as varK3_366) :: [])) :: [])) when ((((((true) && (true))) && (true))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isOItem(#Read(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'Read,(varK0_367)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isOItem(#KToken(#token("OItem","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortOItem, var__368) :: [])) -> ((Bool true) :: [])
(*{| rule ``isOItem(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_369)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'lookupOrDefault (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookupOrDefault and sort = 
SortK in match c with 
| _ -> try MAP.hook_lookupOrDefault c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalString2Base (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblString2Base and sort = 
SortInt in match c with 
| _ -> try STRING.hook_string2base c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec eval'Hash'inProps (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'inProps and sort = 
SortBool in match c with 
(*{| rule ``#inProps(P,`.List{"#props"}`(.KList))=>#token("false","Bool")`` requires isProp(P) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(87) org.kframework.attributes.Location(Location(87,6,87,34)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((varP_370 :: []),(KApply0(Lbl'Stop'List'LBraQuotHash'props'QuotRBra') :: [])) when (isTrue (evalisProp((varP_370 :: [])) config (-1))) && (true) -> ((Bool false) :: [])
(*{| rule ``#inProps(P1,#props(P,Ps))=>#inProps(P1,Ps)`` requires `_andBool_`(`_andBool_`(isProp(P1),isProps(Ps)),`_=/=K__K-EQUAL`(P1,P)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(85) org.kframework.attributes.Location(Location(85,6,86,24)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((varP1_371 :: []),(KApply2(Lbl'Hash'props,(varP_372),(varPs_373 :: [])) :: [])) when (((((isTrue (evalisProp((varP1_371 :: [])) config (-1)))) && ((isTrue (evalisProps((varPs_373 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsSlshEqls'K__K'Hyph'EQUAL((varP1_371 :: []),(varP_372)) config (-1))))) && (true) -> ((eval'Hash'inProps((varP1_371 :: []),(varPs_373 :: [])) config (-1)))
(*{| rule ``#inProps(P,#props(P,Ps))=>#token("true","Bool")`` requires isProp(P) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(84) org.kframework.attributes.Location(Location(84,6,84,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((varP_374 :: []),(KApply2(Lbl'Hash'props,(varP_375 :: []),(varPs_376)) :: [])) when (isTrue (evalisProp((varP_374 :: [])) config (-1))) && (((compare_kitem varP_374 varP_375) = 0) && true) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'isOwnerHasMutProp (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'isOwnerHasMutProp and sort = 
SortBool in match c with 
(*{| rule ``#isOwnerHasMutProp(#rs(PS))=>#token("true","Bool")`` requires `_andBool_`(isProps(PS),#inProps(`mut_OSL-SYNTAX`(.KList),PS)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(365) org.kframework.attributes.Location(Location(365,6,366,32)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((KApply1(Lbl'Hash'rs,(varPS_377 :: [])) :: [])) when (((isTrue (evalisProps((varPS_377 :: [])) config (-1)))) && ((isTrue (eval'Hash'inProps((constmut_OSL'Hyph'SYNTAX :: []),(varPS_377 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``#isOwnerHasMutProp(`#voidTy_OSL-SYNTAX`(.KList))=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(369) org.kframework.attributes.Location(Location(369,6,369,42)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((KApply0(Lbl'Hash'voidTy_OSL'Hyph'SYNTAX) :: [])) -> ((Bool false) :: [])
(*{| rule ``#isOwnerHasMutProp(#ref(_65,_66))=>#token("false","Bool")`` requires `_andBool_`(isLifetime(_65),isType(_66)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(368) org.kframework.attributes.Location(Location(368,6,368,45)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((KApply2(Lbl'Hash'ref,(var_65_378 :: []),(var_66_379 :: [])) :: [])) when (((isTrue (evalisLifetime((var_65_378 :: [])) config (-1)))) && ((isTrue (evalisType((var_66_379 :: [])) config (-1))))) && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'unwrapVal (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'unwrapVal and sort = 
SortInt in match c with 
(*{| rule ``#unwrapVal(V)=>V`` requires isInt(V) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(64) org.kframework.attributes.Location(Location(64,6,64,28)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((Int _ as varV_380) :: [])) when true && (true) -> (varV_380 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'wv (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'wv and sort = 
SortInt in match c with 
(*{| rule ``#wv(`*__OSL-SYNTAX`(E),ENV)=>#wv(E,ENV)`` requires `_andBool_`(isExp(E),isMap(ENV)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(67) org.kframework.attributes.Location(Location(67,6,67,41)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((KApply1(Lbl'Star'__OSL'Hyph'SYNTAX,(varE_381 :: [])) :: []),((Map (SortMap,_,_) as varENV_382) :: [])) when (((isTrue (evalisExp((varE_381 :: [])) config (-1)))) && (true)) && (true) -> ((eval'Hash'wv((varE_381 :: []),(varENV_382 :: [])) config (-1)))
(*{| rule ``#wv(X,ENV)=>#unwrapVal(`Map:lookup`(ENV,X))`` requires `_andBool_`(isMap(ENV),isId(X)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(66) org.kframework.attributes.Location(Location(66,6,66,46)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((varX_383 :: []),((Map (SortMap,_,_) as varENV_384) :: [])) when ((true) && ((isTrue (evalisId((varX_383 :: [])) config (-1))))) && (true) -> ((eval'Hash'unwrapVal(((evalMap'Coln'lookup((varENV_384 :: []),(varX_383 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalBase2String (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblBase2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_base2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalList'Coln'range (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'range and sort = 
SortList in match c with 
| _ -> try LIST.hook_range c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalsizeList (c: k) (config: k) (guard: int) : k = let lbl = 
LblsizeList and sort = 
SortInt in match c with 
| _ -> try LIST.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStream (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStream and sort = 
SortBool in match c with 
(*{| rule ``isStream(#buffer(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'buffer,(varK0_385)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStream(#KToken(#token("Stream","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStream, var__386) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStream(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_387)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitFnameCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitFnameCell and sort = 
SortFnameCell in match c with 
(*{| rule ``initFnameCell(.KList)=>`<fname>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'fname'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitFnameCell : k Lazy.t = lazy (evalinitFnameCell () interned_bottom (-1))
let evalinitKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitKCell and sort = 
SortKCell in match c with 
(*{| rule ``initKCell(Init)=>`<k>`(`Map:lookup`(Init,#token("$PGM","KConfigVar")))`` requires isStmts(`Map:lookup`(Init,#token("$PGM","KConfigVar"))) ensures #token("true","Bool") [initializer()]|}*)
| ((varInit_388)) when (isTrue (evalisStmts(((evalMap'Coln'lookup((varInit_388),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1))) && (true) -> (KApply1(Lbl'_LT_'k'_GT_',((evalMap'Coln'lookup((varInit_388),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitIndexCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitIndexCell and sort = 
SortIndexCell in match c with 
(*{| rule ``initIndexCell(.KList)=>`<index>`(#token("0","Int"))`` requires isInt(#token("0","Int")) ensures #token("true","Bool") [initializer()]|}*)
| () when (isTrue (evalisInt(((Lazy.force int0) :: [])) config (-1))) && (true) -> (KApply1(Lbl'_LT_'index'_GT_',((Lazy.force int0) :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitIndexCell : k Lazy.t = lazy (evalinitIndexCell () interned_bottom (-1))
let evalSet'Coln'difference (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'difference and sort = 
SortSet in match c with 
| _ -> try SET.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_Eqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec eval'Hash'writeCK (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'writeCK and sort = 
SortBool in match c with 
| (((Int _ as var_0_389) :: []),((Int _ as var_1_390) :: []),((Int _ as var_2_391) :: []),(var_3_392)) when guard < 0(*{| rule ``#writeCK(L,B,E,_0)=>#token("false","Bool")`` requires `_andBool_`(`_andBool_`(#setChoice(#writev(L,T),_0),#match(RestS,`Set:difference`(_0,`SetItem`(#writev(L,T))))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(E),isInt(B)),isInt(T)),isSet(RestS)),isInt(L)),`_andBool_`(`_<=Int__INT`(B,T),`_<=Int__INT`(T,E)))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(198) org.kframework.attributes.Location(Location(198,6,199,47)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_3_392) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply2(Lbl'Hash'writev,((Int _ as var_0_393) :: []),((Int _ as var_4_394) :: [])) :: []) as e0 -> (let e = ((evalSet'Coln'difference((var_3_392),((evalSetItem(e0) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_5_395) :: []) when ((((true) && (true))) && (((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'_LT_Eqls'Int__INT((var_1_390 :: []),(var_4_394 :: [])) config (-1)))) && ((isTrue (eval_'_LT_Eqls'Int__INT((var_4_394 :: []),(var_2_391 :: [])) config (-1))))))))) && (((compare_kitem var_0_389 var_0_393) = 0) && true) -> ((Bool false) :: [])| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'writeCK c config 0) else choice| _ -> (eval'Hash'writeCK c config 0))
| (((Int _ as var_0_396) :: []),((Int _ as var_1_397) :: []),((Int _ as var_2_398) :: []),(var_3_399)) when guard < 1(*{| rule ``#writeCK(L,B,E,_0)=>#writeCK(L,B,E,RestS)`` requires `_andBool_`(`_andBool_`(#setChoice(#writev(L1,T),_0),#match(RestS,`Set:difference`(_0,`SetItem`(#writev(L1,T))))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(E),isInt(B)),isInt(T)),isSet(RestS)),isInt(L)),isInt(L1)),`_=/=Int__INT`(L,L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(201) org.kframework.attributes.Location(Location(201,6,202,26)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_3_399) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply2(Lbl'Hash'writev,((Int _ as var_5_400) :: []),((Int _ as var_6_401) :: [])) :: []) as e1 -> (let e = ((evalSet'Coln'difference((var_3_399),((evalSetItem(e1) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_4_402) :: []) when ((((true) && (true))) && (((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_396 :: []),(var_5_400 :: [])) config (-1))))))) && (true) -> ((eval'Hash'writeCK((var_0_396 :: []),(var_1_397 :: []),(var_2_398 :: []),(var_4_402 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'writeCK c config 1) else choice| _ -> (eval'Hash'writeCK c config 1))
| (((Int _ as var_0_403) :: []),((Int _ as var_1_404) :: []),((Int _ as var_2_405) :: []),(var_3_406)) when guard < 2(*{| rule ``#writeCK(L,B,E,_0)=>#writeCK(L,B,E,RestS)`` requires `_andBool_`(`_andBool_`(#setChoice(#writev(L,T),_0),#match(RestS,`Set:difference`(_0,`SetItem`(#writev(L,T))))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(E),isInt(B)),isInt(T)),isSet(RestS)),isInt(L)),`notBool_`(`_andBool_`(`_<=Int__INT`(B,T),`_<=Int__INT`(T,E))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(205) org.kframework.attributes.Location(Location(205,6,206,56)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_3_406) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply2(Lbl'Hash'writev,((Int _ as var_0_407) :: []),((Int _ as var_5_408) :: [])) :: []) as e2 -> (let e = ((evalSet'Coln'difference((var_3_406),((evalSetItem(e2) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_4_409) :: []) when ((((true) && (true))) && (((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((not ((((isTrue (eval_'_LT_Eqls'Int__INT((var_1_404 :: []),(var_5_408 :: [])) config (-1)))) && ((isTrue (eval_'_LT_Eqls'Int__INT((var_5_408 :: []),(var_2_405 :: [])) config (-1))))))))))) && (((compare_kitem var_0_403 var_0_407) = 0) && true) -> ((eval'Hash'writeCK((var_0_403 :: []),(var_1_404 :: []),(var_2_405 :: []),(var_4_409 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'writeCK c config 2) else choice| _ -> (eval'Hash'writeCK c config 2))
(*{| rule ``#writeCK(_53,_54,_55,_0)=>#token("true","Bool")`` requires `_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(isInt(_53),isInt(_55)),isInt(_54))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(208) org.kframework.attributes.Location(Location(208,6,208,34)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((Int _ as var_53_410) :: []),((Int _ as var_54_411) :: []),((Int _ as var_55_412) :: []),(var_0_413)) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_413)) config (-1)))) && (((((true) && (true))) && (true)))) && (true) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let eval_'_LT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_GT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>String__STRING`(S1,S2)=>`_<String__STRING`(S2,S1)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(527) org.kframework.attributes.Location(Location(527,8,527,52)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_414) :: []),((String _ as varS2_415) :: [])) when ((true) && (true)) && (true) -> ((eval_'_LT_'String__STRING((varS2_415 :: []),(varS1_414 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Stop'Map (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Map and sort = 
SortMap in match c with 
| _ -> try MAP.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Map : k Lazy.t = lazy (eval'Stop'Map () interned_bottom (-1))
let evalStateCellMapItem (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblStateCellMapItem and sort = 
SortStateCellMap in match c with 
| _ -> try MAP.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitEnvCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitEnvCell and sort = 
SortEnvCell in match c with 
(*{| rule ``initEnvCell(.KList)=>`<env>`(`.Map`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'env'_GT_',((Lazy.force const'Stop'Map))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitEnvCell : k Lazy.t = lazy (evalinitEnvCell () interned_bottom (-1))
let evalinitStoreCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitStoreCell and sort = 
SortStoreCell in match c with 
(*{| rule ``initStoreCell(.KList)=>`<store>`(`.Map`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'store'_GT_',((Lazy.force const'Stop'Map))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitStoreCell : k Lazy.t = lazy (evalinitStoreCell () interned_bottom (-1))
let evalinitStackCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitStackCell and sort = 
SortStackCell in match c with 
(*{| rule ``initStackCell(.KList)=>`<stack>`(`.List`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'stack'_GT_',((Lazy.force const'Stop'List))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitStackCell : k Lazy.t = lazy (evalinitStackCell () interned_bottom (-1))
let evalinitTimerCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitTimerCell and sort = 
SortTimerCell in match c with 
(*{| rule ``initTimerCell(.KList)=>`<timer>`(#token("0","Int"))`` requires isInt(#token("0","Int")) ensures #token("true","Bool") [initializer()]|}*)
| () when (isTrue (evalisInt(((Lazy.force int0) :: [])) config (-1))) && (true) -> (KApply1(Lbl'_LT_'timer'_GT_',((Lazy.force int0) :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitTimerCell : k Lazy.t = lazy (evalinitTimerCell () interned_bottom (-1))
let evalinitIndexesCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitIndexesCell and sort = 
SortIndexesCell in match c with 
(*{| rule ``initIndexesCell(.KList)=>`<indexes>`(#indexes(#token("0","Int"),#token("0","Int")))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Lazy.force int0) :: []),((Lazy.force int0) :: [])) :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitIndexesCell : k Lazy.t = lazy (evalinitIndexesCell () interned_bottom (-1))
let evalinitStateCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitStateCell and sort = 
SortStateCell in match c with 
(*{| rule ``initStateCell(Init)=>`StateCellMapItem`(initIndexCell(.KList),`<state>`(initIndexCell(.KList),initKCell(Init),initEnvCell(.KList),initStoreCell(.KList),initStackCell(.KList),initWriteCell(.KList),initTimerCell(.KList),initUnsafeModeCell(.KList),initIndexesCell(.KList)))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| ((varInit_416)) -> ((evalStateCellMapItem(((Lazy.force constinitIndexCell)),(KApply9(Lbl'_LT_'state'_GT_',((Lazy.force constinitIndexCell)),((evalinitKCell((varInit_416)) config (-1))),((Lazy.force constinitEnvCell)),((Lazy.force constinitStoreCell)),((Lazy.force constinitStackCell)),((Lazy.force constinitWriteCell)),((Lazy.force constinitTimerCell)),((Lazy.force constinitUnsafeModeCell)),((Lazy.force constinitIndexesCell))) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'parse (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parse and sort = 
SortKItem in match c with 
| _ -> try IO.hook_parse c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'lstat'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lstat'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_lstat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'sort (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'sort and sort = 
SortString in match c with 
| _ -> try KREFLECTION.hook_sort c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStateCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStateCell and sort = 
SortBool in match c with 
(*{| rule ``isStateCell(`<state>`(K0,K1,K2,K3,K4,K5,K6,K7,K8))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIndexCell(K0),isKCell(K1)),isEnvCell(K2)),isStoreCell(K3)),isStackCell(K4)),isWriteCell(K5)),isTimerCell(K6)),isUnsafeModeCell(K7)),isIndexesCell(K8)) ensures #token("true","Bool") []|}*)
| ((KApply9(Lbl'_LT_'state'_GT_',(varK0_417 :: []),(varK1_418 :: []),(varK2_419 :: []),(varK3_420 :: []),(varK4_421 :: []),(varK5_422 :: []),(varK6_423 :: []),(varK7_424 :: []),(varK8_425 :: [])) :: [])) when (((((((((((((((((isTrue (evalisIndexCell((varK0_417 :: [])) config (-1)))) && ((isTrue (evalisKCell((varK1_418 :: [])) config (-1)))))) && ((isTrue (evalisEnvCell((varK2_419 :: [])) config (-1)))))) && ((isTrue (evalisStoreCell((varK3_420 :: [])) config (-1)))))) && ((isTrue (evalisStackCell((varK4_421 :: [])) config (-1)))))) && ((isTrue (evalisWriteCell((varK5_422 :: [])) config (-1)))))) && ((isTrue (evalisTimerCell((varK6_423 :: [])) config (-1)))))) && ((isTrue (evalisUnsafeModeCell((varK7_424 :: [])) config (-1)))))) && ((isTrue (evalisIndexesCell((varK8_425 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isStateCell(#KToken(#token("StateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCell, var__426) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_427)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT__GT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT__GT_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_shr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'stdout_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stdout_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stdout_K-IO`(.KList)=>#token("1","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(741) org.kframework.attributes.Location(Location(741,8,741,20)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| () -> ((Lazy.force int1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stdout_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stdout_K'Hyph'IO () interned_bottom (-1))
let eval'Hash'configuration_K'Hyph'REFLECTION (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'configuration_K'Hyph'REFLECTION and sort = 
SortK in match c with 
| _ -> try KREFLECTION.hook_configuration c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_open c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'open'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'open'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#open(_)_K-IO`(S)=>`#open(_,_)_K-IO`(S,#token("\"rw\"","String"))`` requires isString(S) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(734) org.kframework.attributes.Location(Location(734,8,734,48)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS_428) :: [])) when true && (true) -> ((eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO((varS_428 :: []),((String "rw") :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_<=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S2,S1))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(526) org.kframework.attributes.Location(Location(526,8,526,63)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_429) :: []),((String _ as varS2_430) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS2_430 :: []),(varS1_429 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKResult (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKResult and sort = 
SortBool in match c with 
(*{| rule ``isKResult(#loc(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'loc,((Int _ as varK0_431) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(`#void_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'void_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("KResult","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKResult, var__432) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#rs(K0))=>#token("true","Bool")`` requires isProps(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'rs,(varK0_433 :: [])) :: [])) when (isTrue (evalisProps((varK0_433 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#mutRef(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'mutRef,((Int _ as varK0_434) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Value","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortValue, var__435) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#immRef(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'immRef,((Int _ as varK0_436) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#ref(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'ref,((Int _ as varK0_437) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#Loc(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isValue(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'Loc,(varK0_438 :: []),((Int _ as varK1_439) :: [])) :: [])) when (((isTrue (evalisValue((varK0_438 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_440)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'system (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'system and sort = 
SortKItem in match c with 
| _ -> try IO.hook_system c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_orElseBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orElseBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_orElse c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orElseBool__BOOL`(K,#token("false","Bool"))=>K`` requires isK(K) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(308) org.kframework.attributes.Location(Location(308,8,308,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| ((varK_441),((Bool false) :: [])) when true && (true) -> (varK_441)
(*{| rule `` `_orElseBool__BOOL`(#token("true","Bool"),_3)=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(305) org.kframework.attributes.Location(Location(305,8,305,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool true) :: []),(var_3_442)) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(_0,#token("true","Bool"))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(306) org.kframework.attributes.Location(Location(306,8,306,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| ((var_0_443),((Bool true) :: [])) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(#token("false","Bool"),K)=>K`` requires isK(K) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(307) org.kframework.attributes.Location(Location(307,8,307,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: []),(varK_444)) when true && (true) -> (varK_444)
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Map__MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'parseToken'LPar'_'Comm'_'RPar'_STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parseToken'LPar'_'Comm'_'RPar'_STRING and sort = 
SortKItem in match c with 
| _ -> try STRING.hook_string2token c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalList'Coln'get (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'get and sort = 
SortK in match c with 
| _ -> try LIST.hook_get c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Bool__BOOL`(K1,K2)=>`_==K_`(K1,K2)`` requires `_andBool_`(isBool(K1),isBool(K2)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(614) org.kframework.attributes.Location(Location(614,8,614,43)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varK1_445) :: []),((Bool _ as varK2_446) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varK1_445 :: []),(varK2_446 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_xorBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_xorBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_xor c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_xorBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(295) org.kframework.attributes.Location(Location(295,8,295,38)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: []),((Bool _ as varB_447) :: [])) when true && (true) -> (varB_447 :: [])
(*{| rule `` `_xorBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(296) org.kframework.attributes.Location(Location(296,8,296,38)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB_448) :: []),((Bool false) :: [])) when true && (true) -> (varB_448 :: [])
(*{| rule `` `_xorBool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B1),isBool(B2)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(298) org.kframework.attributes.Location(Location(298,8,298,57)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB1_449) :: []),((Bool _ as varB2_450) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_449 :: []),(varB2_450 :: [])) config (-1))))))])
(*{| rule `` `_xorBool__BOOL`(B,B)=>#token("false","Bool")`` requires isBool(B) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(297) org.kframework.attributes.Location(Location(297,8,297,38)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB_451) :: []),((Bool _ as varB_452) :: [])) when true && (((compare_kitem varB_452 varB_451) = 0) && true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitTmpCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitTmpCell and sort = 
SortTmpCell in match c with 
(*{| rule ``initTmpCell(.KList)=>`<tmp>`(`.List`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'tmp'_GT_',((Lazy.force const'Stop'List))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitTmpCell : k Lazy.t = lazy (evalinitTmpCell () interned_bottom (-1))
let evalFunDefCellMapItem (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblFunDefCellMapItem and sort = 
SortFunDefCellMap in match c with 
| _ -> try MAP.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitFparamsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitFparamsCell and sort = 
SortFparamsCell in match c with 
(*{| rule ``initFparamsCell(.KList)=>`<fparams>`(`.List{"_,__OSL-SYNTAX"}`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'fparams'_GT_',(const'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra' :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitFparamsCell : k Lazy.t = lazy (evalinitFparamsCell () interned_bottom (-1))
let evalinitFretCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitFretCell and sort = 
SortFretCell in match c with 
(*{| rule ``initFretCell(.KList)=>`<fret>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'fret'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitFretCell : k Lazy.t = lazy (evalinitFretCell () interned_bottom (-1))
let evalinitFunDefCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitFunDefCell and sort = 
SortFunDefCell in match c with 
(*{| rule ``initFunDefCell(.KList)=>`FunDefCellMapItem`(initFnameCell(.KList),`<funDef>`(initFnameCell(.KList),initFparamsCell(.KList),initFretCell(.KList),initFbodyCell(.KList)))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> ((evalFunDefCellMapItem(((Lazy.force constinitFnameCell)),(KApply4(Lbl'_LT_'funDef'_GT_',((Lazy.force constinitFnameCell)),((Lazy.force constinitFparamsCell)),((Lazy.force constinitFretCell)),((Lazy.force constinitFbodyCell))) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitFunDefCell : k Lazy.t = lazy (evalinitFunDefCell () interned_bottom (-1))
let evalisFunDefCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunDefCell and sort = 
SortBool in match c with 
(*{| rule ``isFunDefCell(#KToken(#token("FunDefCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefCell, var__453) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefCell(`<funDef>`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isFnameCell(K0),isFparamsCell(K1)),isFretCell(K2)),isFbodyCell(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'funDef'_GT_',(varK0_454 :: []),(varK1_455 :: []),(varK2_456 :: []),(varK3_457 :: [])) :: [])) when (((((((isTrue (evalisFnameCell((varK0_454 :: [])) config (-1)))) && ((isTrue (evalisFparamsCell((varK1_455 :: [])) config (-1)))))) && ((isTrue (evalisFretCell((varK2_456 :: [])) config (-1)))))) && ((isTrue (evalisFbodyCell((varK3_457 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isFunDefCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_458)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIOError (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIOError and sort = 
SortBool in match c with 
(*{| rule ``isIOError(`#EXDEV_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EXDEV_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINTR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINTR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOSYS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOSYS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNRESET_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNRESET_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOPNOTSUPP_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOPNOTSUPP_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESOCKTNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESOCKTNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOENT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOENT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESHUTDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESHUTDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ETIMEDOUT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ETIMEDOUT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ETOOMANYREFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ETOOMANYREFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINVAL_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINVAL_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#noparse_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'noparse_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECHILD_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECHILD_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOEXEC_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOEXEC_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMSGSIZE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMSGSIZE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDEADLK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDEADLK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EFAULT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EFAULT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESRCH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESRCH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPROTOTYPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPROTOTYPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOMEM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOMEM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNABORTED_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNABORTED_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EWOULDBLOCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EWOULDBLOCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTEMPTY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTEMPTY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPIPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPIPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EFBIG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EFBIG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTTY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTTY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTDIR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTDIR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EALREADY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EALREADY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EIO_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EIO_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENFILE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENFILE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDOM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDOM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#E2BIG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'E2BIG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(#KToken(#token("IOError","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIOError, var__459) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EBADF_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EBADF_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EACCES_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EACCES_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EAGAIN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EAGAIN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENXIO_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENXIO_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ERANGE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ERANGE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETUNREACH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETUNREACH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENAMETOOLONG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENAMETOOLONG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOVERFLOW_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOVERFLOW_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMFILE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMFILE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOF_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOF_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ELOOP_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ELOOP_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOSPC_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOSPC_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPROTONOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPROTONOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTCONN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTCONN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPFNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPFNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPERM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPERM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(#unknownIOError(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'unknownIOError,((Int _ as varK0_460) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENODEV_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENODEV_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EBUSY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EBUSY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINPROGRESS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINPROGRESS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTSOCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTSOCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EADDRINUSE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EADDRINUSE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EHOSTUNREACH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EHOSTUNREACH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDESTADDRREQ_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDESTADDRREQ_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOBUFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOBUFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EISCONN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EISCONN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETRESET_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETRESET_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EADDRNOTAVAIL_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EADDRNOTAVAIL_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOPROTOOPT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOPROTOOPT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOLCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOLCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EAFNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EAFNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESPIPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESPIPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EEXIST_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EEXIST_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EISDIR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EISDIR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EROFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EROFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EHOSTDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EHOSTDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNREFUSED_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNREFUSED_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMLINK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMLINK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_461)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'opendir'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'opendir'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_opendir c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'checkInit (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'checkInit and sort = 
SortBool in match c with 
(*{| rule ``#checkInit(X,E,S)=>`_=/=K__K-EQUAL`(`Map:lookup`(S,`Map:lookup`(E,X)),`#uninit_OSL-SYNTAX`(.KList))`` requires `_andBool_`(`_andBool_`(isId(X),isMap(E)),isMap(S)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(348) org.kframework.attributes.Location(Location(348,6,348,56)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((varX_462 :: []),((Map (SortMap,_,_) as varE_463) :: []),((Map (SortMap,_,_) as varS_464) :: [])) when (((((isTrue (evalisId((varX_462 :: [])) config (-1)))) && (true))) && (true)) && (true) -> ((eval_'EqlsSlshEqls'K__K'Hyph'EQUAL(((evalMap'Coln'lookup((varS_464 :: []),((evalMap'Coln'lookup((varE_463 :: []),(varX_462 :: [])) config (-1)))) config (-1))),(const'Hash'uninit_OSL'Hyph'SYNTAX :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let rec eval'Hash'bindParams (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'bindParams and sort = 
SortStmts in match c with 
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(#FnCall(F,Es2),Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#transfer(#FnCall(F,Es2),P),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isExps(Es2),isStmts(SS)),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)),isId(F)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(58) org.kframework.attributes.Location(Location(58,6,59,64)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_465 :: []),(varT_466 :: [])) :: []),(varPs_467 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'FnCall,(varF_468 :: []),(varEs2_469 :: [])) :: []),(varEs_470 :: [])) :: []),(varSS_471 :: [])) when (((((((((((((isTrue (evalisExps((varEs2_469 :: [])) config (-1)))) && ((isTrue (evalisStmts((varSS_471 :: [])) config (-1)))))) && ((isTrue (evalisExps((varEs_470 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_467 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_465 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_466 :: [])) config (-1)))))) && ((isTrue (evalisId((varF_468 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_465 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'transfer,(KApply2(Lbl'Hash'FnCall,(varF_468 :: []),(varEs2_469 :: [])) :: []),(varP_465 :: [])) :: []),((eval'Hash'bindParams((varPs_467 :: []),(varEs_470 :: []),(varSS_471 :: [])) config (-1)))) :: [])) :: [])
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(`newResource(_)_OSL-SYNTAX`(PROPS),Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#transfer(`newResource(_)_OSL-SYNTAX`(PROPS),P),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProps(PROPS),isStmts(SS)),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(55) org.kframework.attributes.Location(Location(55,6,56,70)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_472 :: []),(varT_473 :: [])) :: []),(varPs_474 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply1(LblnewResource'LPar'_'RPar'_OSL'Hyph'SYNTAX,(varPROPS_475 :: [])) :: []),(varEs_476 :: [])) :: []),(varSS_477 :: [])) when (((((((((((isTrue (evalisProps((varPROPS_475 :: [])) config (-1)))) && ((isTrue (evalisStmts((varSS_477 :: [])) config (-1)))))) && ((isTrue (evalisExps((varEs_476 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_474 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_472 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_473 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_472 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'transfer,(KApply1(LblnewResource'LPar'_'RPar'_OSL'Hyph'SYNTAX,(varPROPS_475 :: [])) :: []),(varP_472 :: [])) :: []),((eval'Hash'bindParams((varPs_474 :: []),(varEs_476 :: []),(varSS_477 :: [])) config (-1)))) :: [])) :: [])
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(#immBorrow(E),Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#borrow(P,E),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isStmts(SS),isExp(E)),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(46) org.kframework.attributes.Location(Location(46,6,47,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_478 :: []),(varT_479 :: [])) :: []),(varPs_480 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'immBorrow,(varE_481 :: [])) :: []),(varEs_482 :: [])) :: []),(varSS_483 :: [])) when (((((((((((isTrue (evalisStmts((varSS_483 :: [])) config (-1)))) && ((isTrue (evalisExp((varE_481 :: [])) config (-1)))))) && ((isTrue (evalisExps((varEs_482 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_480 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_478 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_479 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_478 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'borrow,(varP_478 :: []),(varE_481 :: [])) :: []),((eval'Hash'bindParams((varPs_480 :: []),(varEs_482 :: []),(varSS_483 :: [])) config (-1)))) :: [])) :: [])
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(#mutBorrow(E),Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#mborrow(P,E),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isStmts(SS),isExp(E)),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(49) org.kframework.attributes.Location(Location(49,6,50,50)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_484 :: []),(varT_485 :: [])) :: []),(varPs_486 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'mutBorrow,(varE_487 :: [])) :: []),(varEs_488 :: [])) :: []),(varSS_489 :: [])) when (((((((((((isTrue (evalisStmts((varSS_489 :: [])) config (-1)))) && ((isTrue (evalisExp((varE_487 :: [])) config (-1)))))) && ((isTrue (evalisExps((varEs_488 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_486 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_484 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_485 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_484 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'mborrow,(varP_484 :: []),(varE_487 :: [])) :: []),((eval'Hash'bindParams((varPs_486 :: []),(varEs_488 :: []),(varSS_489 :: [])) config (-1)))) :: [])) :: [])
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(E,Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#transfer(E,P),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isStmts(SS),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)),isId(E)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(52) org.kframework.attributes.Location(Location(52,6,53,53)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_490 :: []),(varT_491 :: [])) :: []),(varPs_492 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(varE_493 :: []),(varEs_494 :: [])) :: []),(varSS_495 :: [])) when (((((((((((isTrue (evalisStmts((varSS_495 :: [])) config (-1)))) && ((isTrue (evalisExps((varEs_494 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_492 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_490 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_491 :: [])) config (-1)))))) && ((isTrue (evalisId((varE_493 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_490 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'transfer,(varE_493 :: []),(varP_490 :: [])) :: []),((eval'Hash'bindParams((varPs_492 :: []),(varEs_494 :: []),(varSS_495 :: [])) config (-1)))) :: [])) :: [])
(*{| rule ``#bindParams(`.List{"_,__OSL-SYNTAX"}`(.KList),`.List{"_,__OSL-SYNTAX"}`(.KList),SS)=>SS`` requires isStmts(SS) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(70) org.kframework.attributes.Location(Location(70,6,70,53)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply0(Lbl'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra') :: []),(KApply0(Lbl'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra') :: []),(varSS_496 :: [])) when (isTrue (evalisStmts((varSS_496 :: [])) config (-1))) && (true) -> (varSS_496 :: [])
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(`*__OSL-SYNTAX`(E),Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#transfer(`*__OSL-SYNTAX`(E),P),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isStmts(SS),isExp(E)),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(61) org.kframework.attributes.Location(Location(61,6,62,55)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_497 :: []),(varT_498 :: [])) :: []),(varPs_499 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply1(Lbl'Star'__OSL'Hyph'SYNTAX,(varE_500 :: [])) :: []),(varEs_501 :: [])) :: []),(varSS_502 :: [])) when (((((((((((isTrue (evalisStmts((varSS_502 :: [])) config (-1)))) && ((isTrue (evalisExp((varE_500 :: [])) config (-1)))))) && ((isTrue (evalisExps((varEs_501 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_499 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_497 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_498 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_497 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'transfer,(KApply1(Lbl'Star'__OSL'Hyph'SYNTAX,(varE_500 :: [])) :: []),(varP_497 :: [])) :: []),((eval'Hash'bindParams((varPs_499 :: []),(varEs_501 :: []),(varSS_502 :: [])) config (-1)))) :: [])) :: [])
(*{| rule ``#bindParams(`_,__OSL-SYNTAX`(#parameter(P,T),Ps),`_,__OSL-SYNTAX`(#read(E),Es),SS)=>`___OSL-SYNTAX`(#decl(P),`___OSL-SYNTAX`(#transfer(#read(E),P),#bindParams(Ps,Es,SS)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isStmts(SS),isExp(E)),isExps(Es)),isParameters(Ps)),isId(P)),isType(T)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(64) org.kframework.attributes.Location(Location(64,6,65,57)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| ((KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'parameter,(varP_503 :: []),(varT_504 :: [])) :: []),(varPs_505 :: [])) :: []),(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'read,(varE_506 :: [])) :: []),(varEs_507 :: [])) :: []),(varSS_508 :: [])) when (((((((((((isTrue (evalisStmts((varSS_508 :: [])) config (-1)))) && ((isTrue (evalisExp((varE_506 :: [])) config (-1)))))) && ((isTrue (evalisExps((varEs_507 :: [])) config (-1)))))) && ((isTrue (evalisParameters((varPs_505 :: [])) config (-1)))))) && ((isTrue (evalisId((varP_503 :: [])) config (-1)))))) && ((isTrue (evalisType((varT_504 :: [])) config (-1))))) && (true) -> (KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply1(Lbl'Hash'decl,(varP_503 :: [])) :: []),(KApply2(Lbl___OSL'Hyph'SYNTAX,(KApply2(Lbl'Hash'transfer,(KApply1(Lbl'Hash'read,(varE_506 :: [])) :: []),(varP_503 :: [])) :: []),((eval'Hash'bindParams((varPs_505 :: []),(varEs_507 :: []),(varSS_508 :: [])) config (-1)))) :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisKConfigVar (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKConfigVar and sort = 
SortBool in match c with 
(*{| rule ``isKConfigVar(#KToken(#token("KConfigVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKConfigVar, var__509) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKConfigVar(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_510)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWItem and sort = 
SortBool in match c with 
(*{| rule ``isWItem(#KToken(#token("WItem","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWItem, var__511) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWItem(#writev(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isInt(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'Hash'writev,((Int _ as varK0_512) :: []),((Int _ as varK1_513) :: [])) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isWItem(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_514)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'getenv (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'getenv and sort = 
SortString in match c with 
| _ -> try KREFLECTION.hook_getenv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTmpCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTmpCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isTmpCellOpt(#KToken(#token("TmpCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTmpCell, var__515) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTmpCellOpt(`<tmp>`(K0))=>#token("true","Bool")`` requires isList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'tmp'_GT_',((List (SortList,_,_) as varK0_516) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTmpCellOpt(#KToken(#token("TmpCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTmpCellOpt, var__517) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTmpCellOpt(noTmpCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoTmpCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTmpCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_518)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'And'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'And'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'PipeHyph_GT_'_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'PipeHyph_GT_'_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'LSqB'_'_LT_Hyph'undef'RSqB' (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' and sort = 
SortMap in match c with 
| _ -> try MAP.hook_remove c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec eval'Hash'IsMoveOccurred (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'IsMoveOccurred and sort = 
SortBool in match c with 
| ((var_0_519),((Map (SortMap,_,_) as var_1_520) :: [])) when guard < 0(*{| rule ``#IsMoveOccurred(_0,M2)=>`_andBool_`(#IsMoved(Key,#rs(Props),`Map:lookup`(M2,Key)),#IsMoveOccurred(M,M2))`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(Key,_0),#match(#rs(Props),`Map:lookup`(_0,Key))),#match(M,`_[_<-undef]`(_0,Key))),`_andBool_`(`_andBool_`(`_andBool_`(isMap(M2),isInt(Key)),isMap(M)),isProps(Props))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(138) org.kframework.attributes.Location(Location(138,6,138,125)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
 -> (match (var_0_519) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_2_521) :: []) as e3 -> (let e = ((evalMap'Coln'lookup((var_0_519),e3) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply1(Lbl'Hash'rs,(var_3_522 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_519),e3) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_4_523) :: []) when ((((((true) && (true))) && (true))) && (((((((true) && (true))) && (true))) && ((isTrue (evalisProps((var_3_522 :: [])) config (-1))))))) && (true) -> ([Bool ((((isTrue (eval'Hash'IsMoved(e3,(KApply1(Lbl'Hash'rs,(var_3_522 :: [])) :: []),((evalMap'Coln'lookup((var_1_520 :: []),e3) config (-1)))) config (-1)))) && ((isTrue (eval'Hash'IsMoveOccurred((var_4_523 :: []),(var_1_520 :: [])) config (-1))))))])| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'IsMoveOccurred c config 0) else choice| _ -> (eval'Hash'IsMoveOccurred c config 0))
| ((var_0_524),((Map (SortMap,_,_) as var_1_525) :: [])) when guard < 1(*{| rule ``#IsMoveOccurred(_0,M2)=>`_andBool_`(#token("true","Bool"),#IsMoveOccurred(M,M2))`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(Key,_0),#match(#br(_22,_23,_24),`Map:lookup`(_0,Key))),#match(M,`_[_<-undef]`(_0,Key))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(_22),isMap(M2)),isExp(_24)),isInt(Key)),isInt(_23)),isMap(M))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(142) org.kframework.attributes.Location(Location(142,6,142,95)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
 -> (match (var_0_524) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_3_526) :: []) as e4 -> (let e = ((evalMap'Coln'lookup((var_0_524),e4) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_4_527) :: []),((Int _ as var_5_528) :: []),(var_6_529 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_524),e4) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_2_530) :: []) when ((((((true) && (true))) && (true))) && (((((((((((true) && (true))) && ((isTrue (evalisExp((var_6_529 :: [])) config (-1)))))) && (true))) && (true))) && (true)))) && (true) -> ([Bool (((true) && ((isTrue (eval'Hash'IsMoveOccurred((var_2_530 :: []),(var_1_525 :: [])) config (-1))))))])| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'IsMoveOccurred c config 1) else choice| _ -> (eval'Hash'IsMoveOccurred c config 1))
(*{| rule ``#IsMoveOccurred(_0,M2)=>#token("true","Bool")`` requires `_andBool_`(`_==K_`(`.Map`(.KList),_0),isMap(M2)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(143) org.kframework.attributes.Location(Location(143,6,143,39)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| ((var_0_531),((Map (SortMap,_,_) as varM2_532) :: [])) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Map)),(var_0_531)) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
| ((var_0_533),((Map (SortMap,_,_) as var_1_534) :: [])) when guard < 3(*{| rule ``#IsMoveOccurred(_0,M2)=>`_andBool_`(#token("true","Bool"),#IsMoveOccurred(M,M2))`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(Key,_0),#match(`#uninit_OSL-SYNTAX`(.KList),`Map:lookup`(_0,Key))),#match(M,`_[_<-undef]`(_0,Key))),`_andBool_`(`_andBool_`(isMap(M2),isInt(Key)),isMap(M))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(141) org.kframework.attributes.Location(Location(141,6,141,92)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
 -> (match (var_0_533) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_3_535) :: []) as e5 -> (let e = ((evalMap'Coln'lookup((var_0_533),e5) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply0(Lbl'Hash'uninit_OSL'Hyph'SYNTAX) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_533),e5) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_2_536) :: []) when ((((((true) && (true))) && (true))) && (((((true) && (true))) && (true)))) && (true) -> ([Bool (((true) && ((isTrue (eval'Hash'IsMoveOccurred((var_2_536 :: []),(var_1_534 :: [])) config (-1))))))])| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'IsMoveOccurred c config 3) else choice| _ -> (eval'Hash'IsMoveOccurred c config 3))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalFloatFormat (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblFloatFormat and sort = 
SortString in match c with 
| _ -> try STRING.hook_floatFormat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_StateCellMap_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_StateCellMap_ and sort = 
SortStateCellMap in match c with 
| _ -> try MAP.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_seekEnd c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisFparamsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFparamsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isFparamsCellOpt(`<fparams>`(K0))=>#token("true","Bool")`` requires isParameters(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fparams'_GT_',(varK0_537 :: [])) :: [])) when (isTrue (evalisParameters((varK0_537 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isFparamsCellOpt(#KToken(#token("FparamsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFparamsCellOpt, var__538) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFparamsCellOpt(#KToken(#token("FparamsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFparamsCell, var__539) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFparamsCellOpt(noFparamsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoFparamsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFparamsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_540)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'lc (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lc and sort = 
SortBool in match c with 
(*{| rule ``#lc(L1,L2,L3,L4)=>`_orBool__BOOL`(`_andBool_`(`_<Int__INT`(L1,L3),`_<=Int__INT`(L3,L2)),`_andBool_`(`_<Int__INT`(L1,L4),`_<=Int__INT`(L4,L2)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isInt(L2)),isInt(L3)),isInt(L1)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(272) org.kframework.attributes.Location(Location(272,6,273,55)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((Int _ as varL1_541) :: []),((Int _ as varL2_542) :: []),((Int _ as varL3_543) :: []),((Int _ as varL4_544) :: [])) when ((((((true) && (true))) && (true))) && (true)) && (true) -> ([Bool ((((((isTrue (eval_'_LT_'Int__INT((varL1_541 :: []),(varL3_543 :: [])) config (-1)))) && ((isTrue (eval_'_LT_Eqls'Int__INT((varL3_543 :: []),(varL2_542 :: [])) config (-1)))))) || ((((isTrue (eval_'_LT_'Int__INT((varL1_541 :: []),(varL4_544 :: [])) config (-1)))) && ((isTrue (eval_'_LT_Eqls'Int__INT((varL4_544 :: []),(varL2_542 :: [])) config (-1))))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let rec eval'Hash'borrowmutck (c: k * k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'borrowmutck and sort = 
SortBool in match c with 
| (((Int _ as var_0_545) :: []),(var_1_546),((Int _ as var_2_547) :: []),((Int _ as var_3_548) :: []),((Int _ as var_4_549) :: [])) when guard < 0(*{| rule ``#borrowmutck(L4,_0,L1,L2,L3)=>#borrowmutck(L4,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(#rs(_60),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProps(_60),isInt(L4)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(302) org.kframework.attributes.Location(Location(302,6,303,45)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_546) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | (var_6_550) as e6 -> (let e = ((evalMap'Coln'lookup((var_1_546),e6) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply1(Lbl'Hash'rs,(var_7_551 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_546),e6) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_552) :: []) when ((((((true) && (true))) && (true))) && ((((((((((((isTrue (evalisProps((var_7_551 :: [])) config (-1)))) && (true))) && (true))) && (true))) && (true))) && (true)))) && (true) -> ((eval'Hash'borrowmutck((var_0_545 :: []),(var_5_552 :: []),(var_2_547 :: []),(var_3_548 :: []),(var_4_549 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 0) else choice| _ -> (eval'Hash'borrowmutck c config 0))
| (((Int _ as var_0_553) :: []),(var_1_554),((Int _ as var_2_555) :: []),((Int _ as var_3_556) :: []),((Int _ as var_4_557) :: [])) when guard < 1(*{| rule ``#borrowmutck(L4,_0,L1,L2,L3)=>#borrowmutck(L4,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(#br(_70,_71,#immRef(L5)),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(_70),isInt(L4)),isInt(_71)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L1)),isInt(L5)),`_=/=Int__INT`(L5,L3))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(305) org.kframework.attributes.Location(Location(305,6,307,27)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_554) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | (var_6_558) as e7 -> (let e = ((evalMap'Coln'lookup((var_1_554),e7) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_559) :: []),((Int _ as var_8_560) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_9_561) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_554),e7) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_562) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((var_9_561 :: []),(var_4_557 :: [])) config (-1))))))) && (true) -> ((eval'Hash'borrowmutck((var_0_553 :: []),(var_5_562 :: []),(var_2_555 :: []),(var_3_556 :: []),(var_4_557 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 1) else choice| _ -> (eval'Hash'borrowmutck c config 1))
| (((Int _ as var_0_563) :: []),(var_1_564),((Int _ as var_2_565) :: []),((Int _ as var_3_566) :: []),((Int _ as var_4_567) :: [])) when guard < 2(*{| rule ``#borrowmutck(L,_0,L1,L2,L3)=>#borrowmutck(L,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(#match(#br(_47,_48,_49),`Map:lookup`(_0,L)),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isExp(_49),isMap(M)),isInt(L2)),isInt(_47)),isInt(L3)),isInt(_48)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(337) org.kframework.attributes.Location(Location(337,6,338,47)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (let e = ((evalMap'Coln'lookup((var_1_564),(var_0_563 :: [])) config (-1))) in match e with 
| [Bottom] -> (eval'Hash'borrowmutck c config 2)
| (KApply3(Lbl'Hash'br,((Int _ as var_6_568) :: []),((Int _ as var_7_569) :: []),(var_8_570 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_564),(var_0_563 :: [])) config (-1))) in match e with 
| [Bottom] -> (eval'Hash'borrowmutck c config 2)
| ((Map (SortMap,_,_) as var_5_571) :: []) when ((((true) && (true))) && ((((((((((((((((isTrue (evalisExp((var_8_570 :: [])) config (-1)))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true)))) && (true) -> ((eval'Hash'borrowmutck((var_0_563 :: []),(var_5_571 :: []),(var_2_565 :: []),(var_3_566 :: []),(var_4_567 :: [])) config (-1)))| _ -> (eval'Hash'borrowmutck c config 2))| _ -> (eval'Hash'borrowmutck c config 2))
| (((Int _ as var_0_572) :: []),(var_1_573),((Int _ as var_2_574) :: []),((Int _ as var_3_575) :: []),((Int _ as var_4_576) :: [])) when guard < 3(*{| rule ``#borrowmutck(L5,_0,L1,L2,L4)=>#borrowmutck(L5,M,L1,L2,L4)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(M,`_[_<-undef]`(_0,L))),#match(#br(_42,_43,#mutRef(L3)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isInt(_43)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(_42)),isInt(L1)),isInt(L5)),`_=/=Int__INT`(L3,L4))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(322) org.kframework.attributes.Location(Location(322,6,324,27)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_573) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_6_577) :: []) as e8 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_573),e8) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_578) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_573),e8) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_579) :: []),((Int _ as var_8_580) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_9_581) :: [])) :: [])) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((var_9_581 :: []),(var_4_576 :: [])) config (-1))))))) && (true) -> ((eval'Hash'borrowmutck((var_0_572 :: []),(var_5_578 :: []),(var_2_574 :: []),(var_3_575 :: []),(var_4_576 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 3) else choice| _ -> (eval'Hash'borrowmutck c config 3))
(*{| rule ``#borrowmutck(_25,_0,_26,_27,_28)=>#token("false","Bool")`` requires `_andBool_`(`_==K_`(`.Map`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(isInt(_27),isInt(_26)),isInt(_28)),isInt(_25))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(340) org.kframework.attributes.Location(Location(340,6,340,42)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((Int _ as var_25_582) :: []),(var_0_583),((Int _ as var_26_584) :: []),((Int _ as var_27_585) :: []),((Int _ as var_28_586) :: [])) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Map)),(var_0_583)) config (-1)))) && (((((((true) && (true))) && (true))) && (true)))) && (true) -> ((Bool false) :: [])
| (((Int _ as var_0_587) :: []),(var_1_588),((Int _ as var_2_589) :: []),((Int _ as var_3_590) :: []),((Int _ as var_4_591) :: [])) when guard < 5(*{| rule ``#borrowmutck(L4,_0,L1,L2,L3)=>#borrowmutck(L4,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(`#uninit_OSL-SYNTAX`(.KList),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(319) org.kframework.attributes.Location(Location(319,6,320,45)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_588) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_6_592) :: []) as e9 -> (let e = ((evalMap'Coln'lookup((var_1_588),e9) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply0(Lbl'Hash'uninit_OSL'Hyph'SYNTAX) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_588),e9) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_593) :: []) when ((((((true) && (true))) && (true))) && (((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true)))) && (true) -> ((eval'Hash'borrowmutck((var_0_587 :: []),(var_5_593 :: []),(var_2_589 :: []),(var_3_590 :: []),(var_4_591 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 5) else choice| _ -> (eval'Hash'borrowmutck c config 5))
| (((Int _ as var_0_594) :: []),(var_1_595),((Int _ as var_2_596) :: []),((Int _ as var_3_597) :: []),((Int _ as var_4_598) :: [])) when guard < 6(*{| rule ``#borrowmutck(L5,_0,L1,L2,L3)=>#borrowmutck(L5,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(M,`_[_<-undef]`(_0,L))),#match(#br(BEG,END,#mutRef(L3)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_andBool_`(`_=/=Int__INT`(L5,L),`_==Bool__BOOL`(#lc(L1,L2,BEG,END),#token("false","Bool"))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(326) org.kframework.attributes.Location(Location(326,6,329,75)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_595) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_6_599) :: []) as e10 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_595),e10) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_600) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_595),e10) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_601) :: []),((Int _ as var_8_602) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_4_603) :: [])) :: [])) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_594 :: []),e10) config (-1)))) && ((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'lc((var_2_596 :: []),(var_3_597 :: []),(var_7_601 :: []),(var_8_602 :: [])) config (-1))),((Bool false) :: [])) config (-1))))))))) && (((compare_kitem var_4_598 var_4_603) = 0) && true) -> ((eval'Hash'borrowmutck((var_0_594 :: []),(var_5_600 :: []),(var_2_596 :: []),(var_3_597 :: []),(var_4_598 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 6) else choice| _ -> (eval'Hash'borrowmutck c config 6))
| (((Int _ as var_0_604) :: []),(var_1_605),((Int _ as var_2_606) :: []),((Int _ as var_3_607) :: []),((Int _ as var_4_608) :: [])) when guard < 7(*{| rule ``#borrowmutck(L5,_0,L1,L2,L3)=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(M,`_[_<-undef]`(_0,L))),#match(#br(BEG,END,#mutRef(L3)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_andBool_`(`_=/=Int__INT`(L5,L),`_==Bool__BOOL`(#lc(L1,L2,BEG,END),#token("true","Bool"))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(331) org.kframework.attributes.Location(Location(331,6,334,74)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_605) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_5_609) :: []) as e11 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_605),e11) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_6_610) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_605),e11) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_611) :: []),((Int _ as var_8_612) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_4_613) :: [])) :: [])) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_604 :: []),e11) config (-1)))) && ((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'lc((var_2_606 :: []),(var_3_607 :: []),(var_7_611 :: []),(var_8_612 :: [])) config (-1))),((Bool true) :: [])) config (-1))))))))) && (((compare_kitem var_4_613 var_4_608) = 0) && true) -> ((Bool true) :: [])| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 7) else choice| _ -> (eval'Hash'borrowmutck c config 7))
| (((Int _ as var_0_614) :: []),(var_1_615),((Int _ as var_2_616) :: []),((Int _ as var_3_617) :: []),((Int _ as var_4_618) :: [])) when guard < 8(*{| rule ``#borrowmutck(L5,_0,L1,L2,L3)=>#borrowmutck(L5,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(#br(BEG,END,#immRef(L3)),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_andBool_`(`_=/=Int__INT`(L5,L),`_==Bool__BOOL`(#lc(L1,L2,BEG,END),#token("false","Bool"))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(310) org.kframework.attributes.Location(Location(310,6,312,70)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_615) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_6_619) :: []) as e12 -> (let e = ((evalMap'Coln'lookup((var_1_615),e12) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_620) :: []),((Int _ as var_8_621) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_4_622) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_615),e12) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_623) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_614 :: []),e12) config (-1)))) && ((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'lc((var_2_616 :: []),(var_3_617 :: []),(var_7_620 :: []),(var_8_621 :: [])) config (-1))),((Bool false) :: [])) config (-1))))))))) && (((compare_kitem var_4_618 var_4_622) = 0) && true) -> ((eval'Hash'borrowmutck((var_0_614 :: []),(var_5_623 :: []),(var_2_616 :: []),(var_3_617 :: []),(var_4_618 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 8) else choice| _ -> (eval'Hash'borrowmutck c config 8))
| (((Int _ as var_0_624) :: []),(var_1_625),((Int _ as var_2_626) :: []),((Int _ as var_3_627) :: []),((Int _ as var_4_628) :: [])) when guard < 9(*{| rule ``#borrowmutck(L5,_0,L1,L2,L3)=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(#br(BEG,END,#immRef(L3)),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_andBool_`(`_=/=Int__INT`(L5,L),`_==Bool__BOOL`(#lc(L1,L2,BEG,END),#token("true","Bool"))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(314) org.kframework.attributes.Location(Location(314,6,316,69)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_625) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_5_629) :: []) as e13 -> (let e = ((evalMap'Coln'lookup((var_1_625),e13) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_6_630) :: []),((Int _ as var_7_631) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_4_632) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_625),e13) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_8_633) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_624 :: []),e13) config (-1)))) && ((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'lc((var_2_626 :: []),(var_3_627 :: []),(var_6_630 :: []),(var_7_631 :: [])) config (-1))),((Bool true) :: [])) config (-1))))))))) && (((compare_kitem var_4_628 var_4_632) = 0) && true) -> ((Bool true) :: [])| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowmutck c config 9) else choice| _ -> (eval'Hash'borrowmutck c config 9))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize5 c)))])
let evalmaxInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblmaxInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_max c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalrfindString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblrfindString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_rfind c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let rec evalrfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblrfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_rfindChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``rfindChar(_13,#token("\"\"","String"),_14)=>#token("-1","Int")`` requires `_andBool_`(isInt(_14),isString(_13)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(533) org.kframework.attributes.Location(Location(533,8,533,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as var_13_634) :: []),((String "") :: []),((Int _ as var_14_635) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
(*{| rule ``rfindChar(S1,S2,I)=>`maxInt(_,_)_INT`(rfindString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),rfindChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(S2),isString(S1)),isInt(I)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(532) org.kframework.attributes.Location(Location(532,8,532,182)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_636) :: []),((String _ as varS2_637) :: []),((Int _ as varI_638) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_637 :: []),((String "") :: [])) config (-1))))) && (true) -> ((evalmaxInt'LPar'_'Comm'_'RPar'_INT(((evalrfindString((varS1_636 :: []),((evalsubstrString((varS2_637 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_638 :: [])) config (-1))),((evalrfindChar((varS1_636 :: []),((evalsubstrString((varS2_637 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_637 :: [])) config (-1)))) config (-1))),(varI_638 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Tild'Int__INT (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Tild'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_Map_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Map_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalintersectSet (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblintersectSet and sort = 
SortSet in match c with 
| _ -> try SET.hook_intersection c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalString2Id (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Id and sort = 
SortId in match c with 
(*{| rule `` `String2Id`(S)=>`#parseToken(_,_)_STRING`(#token("\"Id\"","String"),S)`` requires isString(S) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(597) org.kframework.attributes.Location(Location(597,8,597,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS_639) :: [])) when true && (true) -> ((eval'Hash'parseToken'LPar'_'Comm'_'RPar'_STRING(((String "Id") :: []),(varS_639 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalInt2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblInt2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_int2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalfreshId (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshId and sort = 
SortId in match c with 
(*{| rule ``freshId(I)=>`String2Id`(`_+String__STRING`(#token("\"_\"","String"),`Int2String`(I)))`` requires isInt(I) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(600) org.kframework.attributes.Location(Location(600,8,600,62)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI_640) :: [])) when true && (true) -> ((evalString2Id(((eval_'Plus'String__STRING(((String "_") :: []),((evalInt2String((varI_640 :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisUninit (c: k) (config: k) (guard: int) : k = let lbl = 
LblisUninit and sort = 
SortBool in match c with 
(*{| rule ``isUninit(`#uninit_OSL-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'uninit_OSL'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUninit(#KToken(#token("Uninit","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUninit, var__641) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUninit(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_642)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'close'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'close'LPar'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_close c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'unwrapInt (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'unwrapInt and sort = 
SortInt in match c with 
(*{| rule ``#unwrapInt(I)=>I`` requires isInt(I) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(385) org.kframework.attributes.Location(Location(385,6,385,28)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((Int _ as varI_643) :: [])) when true && (true) -> (varI_643 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFretCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFretCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isFretCellOpt(`<fret>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fret'_GT_',(varK0_644)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFretCellOpt(#KToken(#token("FretCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFretCellOpt, var__645) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFretCellOpt(noFretCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoFretCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFretCellOpt(#KToken(#token("FretCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFretCell, var__646) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFretCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_647)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsizeMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblsizeMap and sort = 
SortInt in match c with 
| _ -> try MAP.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFunDefsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunDefsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isFunDefsCellOpt(noFunDefsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoFunDefsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCellOpt(#KToken(#token("FunDefsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefsCellOpt, var__648) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCellOpt(`<funDefs>`(K0))=>#token("true","Bool")`` requires isFunDefCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'funDefs'_GT_',((Map (SortFunDefCellMap,_,_) as varK0_649) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCellOpt(#KToken(#token("FunDefsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefsCell, var__650) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_651)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStatesCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStatesCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isStatesCellOpt(noStatesCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoStatesCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStatesCellOpt(#KToken(#token("StatesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStatesCell, var__652) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStatesCellOpt(`<states>`(K0))=>#token("true","Bool")`` requires isStateCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'states'_GT_',((Map (SortStateCellMap,_,_) as varK0_653) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStatesCellOpt(#KToken(#token("StatesCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStatesCellOpt, var__654) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStatesCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_655)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'getc'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'getc'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_getc c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIndexItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIndexItem and sort = 
SortBool in match c with 
(*{| rule ``isIndexItem(#KToken(#token("IndexItem","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIndexItem, var__656) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexItem(`#increaseTimer_OSL`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'increaseTimer_OSL) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexItem(`#increaseIndex_OSL`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'increaseIndex_OSL) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIndexItem(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_657)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFbodyCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFbodyCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isFbodyCellOpt(#KToken(#token("FbodyCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFbodyCell, var__658) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFbodyCellOpt(`<fbody>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'fbody'_GT_',(varK0_659)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFbodyCellOpt(#KToken(#token("FbodyCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFbodyCellOpt, var__660) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFbodyCellOpt(noFbodyCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoFbodyCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFbodyCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_661)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFunDefCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunDefCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isFunDefCellFragment(#KToken(#token("FunDefCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefCellFragment, var__662) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefCellFragment(`<funDef>-fragment`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isFnameCellOpt(K0),isFparamsCellOpt(K1)),isFretCellOpt(K2)),isFbodyCellOpt(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'funDef'_GT_Hyph'fragment,(varK0_663 :: []),(varK1_664 :: []),(varK2_665 :: []),(varK3_666 :: [])) :: [])) when (((((((isTrue (evalisFnameCellOpt((varK0_663 :: [])) config (-1)))) && ((isTrue (evalisFparamsCellOpt((varK1_664 :: [])) config (-1)))))) && ((isTrue (evalisFretCellOpt((varK2_665 :: [])) config (-1)))))) && ((isTrue (evalisFbodyCellOpt((varK3_666 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isFunDefCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_667)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStatesCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStatesCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isStatesCellFragment(#KToken(#token("StatesCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStatesCellFragment, var__668) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStatesCellFragment(`<states>-fragment`(K0))=>#token("true","Bool")`` requires isStateCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'states'_GT_Hyph'fragment,((Map (SortStateCellMap,_,_) as varK0_669) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStatesCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_670)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalString2Int (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Int and sort = 
SortInt in match c with 
| _ -> try STRING.hook_string2int c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNstateCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNstateCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isNstateCellOpt(#KToken(#token("NstateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNstateCell, var__671) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNstateCellOpt(`<nstate>`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'nstate'_GT_',((Int _ as varK0_672) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNstateCellOpt(#KToken(#token("NstateCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNstateCellOpt, var__673) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNstateCellOpt(noNstateCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoNstateCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNstateCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_674)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isTCellFragment(#KToken(#token("TCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCellFragment, var__675) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(`<T>-fragment`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isStatesCellOpt(K0),isNstateCellOpt(K1)),isTmpCellOpt(K2)),isFunDefsCellOpt(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'T'_GT_Hyph'fragment,(varK0_676 :: []),(varK1_677 :: []),(varK2_678 :: []),(varK3_679 :: [])) :: [])) when (((((((isTrue (evalisStatesCellOpt((varK0_676 :: [])) config (-1)))) && ((isTrue (evalisNstateCellOpt((varK1_677 :: [])) config (-1)))))) && ((isTrue (evalisTmpCellOpt((varK2_678 :: [])) config (-1)))))) && ((isTrue (evalisFunDefsCellOpt((varK3_679 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_680)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_xorInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_xorInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_xor c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'tell'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'tell'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_tell c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalfreshInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshInt and sort = 
SortInt in match c with 
(*{| rule ``freshInt(I)=>I`` requires isInt(I) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(384) org.kframework.attributes.Location(Location(384,8,384,28)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI_681) :: [])) when true && (true) -> (varI_681 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT__LT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT__LT_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_shl c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_write c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'stat'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stat'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_stat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBlockItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBlockItem and sort = 
SortBool in match c with 
(*{| rule ``isBlockItem(`#unsafeBlockend_BLOCK`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'unsafeBlockend_BLOCK) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBlockItem(`#blockend_BLOCK`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'blockend_BLOCK) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBlockItem(#KToken(#token("BlockItem","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBlockItem, var__682) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBlockItem(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_683)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_inList_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_inList_ and sort = 
SortBool in match c with 
| _ -> try LIST.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_Eqls'Set__SET (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Set__SET and sort = 
SortBool in match c with 
| _ -> try SET.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_seek c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'stdin_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stdin_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stdin_K-IO`(.KList)=>#token("0","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(740) org.kframework.attributes.Location(Location(740,8,740,19)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| () -> ((Lazy.force int0) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stdin_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stdin_K'Hyph'IO () interned_bottom (-1))
let eval_'_LT_Eqls'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Map__MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Stop'StateCellMap (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'StateCellMap and sort = 
SortStateCellMap in match c with 
| _ -> try MAP.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'StateCellMap : k Lazy.t = lazy (eval'Stop'StateCellMap () interned_bottom (-1))
let eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL and sort = 
SortK in match c with 
| _ -> try KEQUAL.hook_ite c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalFloat2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblFloat2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_float2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitStatesCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitStatesCell and sort = 
SortStatesCell in match c with 
(*{| rule ``initStatesCell(Init)=>`<states>`(initStateCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| ((varInit_684)) -> (KApply1(Lbl'_LT_'states'_GT_',((evalinitStateCell((varInit_684)) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitNstateCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitNstateCell and sort = 
SortNstateCell in match c with 
(*{| rule ``initNstateCell(.KList)=>`<nstate>`(#token("1","Int"))`` requires isInt(#token("1","Int")) ensures #token("true","Bool") [initializer()]|}*)
| () when (isTrue (evalisInt(((Lazy.force int1) :: [])) config (-1))) && (true) -> (KApply1(Lbl'_LT_'nstate'_GT_',((Lazy.force int1) :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitNstateCell : k Lazy.t = lazy (evalinitNstateCell () interned_bottom (-1))
let eval'Stop'FunDefCellMap (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'FunDefCellMap and sort = 
SortFunDefCellMap in match c with 
| _ -> try MAP.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'FunDefCellMap : k Lazy.t = lazy (eval'Stop'FunDefCellMap () interned_bottom (-1))
let evalinitFunDefsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitFunDefsCell and sort = 
SortFunDefsCell in match c with 
(*{| rule ``initFunDefsCell(.KList)=>`<funDefs>`(`.FunDefCellMap`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'funDefs'_GT_',((Lazy.force const'Stop'FunDefCellMap))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitFunDefsCell : k Lazy.t = lazy (evalinitFunDefsCell () interned_bottom (-1))
let evalinitTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitTCell and sort = 
SortTCell in match c with 
(*{| rule ``initTCell(Init)=>`<T>`(initStatesCell(Init),initNstateCell(.KList),initTmpCell(.KList),initFunDefsCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [initializer()]|}*)
| ((varInit_685)) -> (KApply4(Lbl'_LT_'T'_GT_',((evalinitStatesCell((varInit_685)) config (-1))),((Lazy.force constinitNstateCell)),((Lazy.force constinitTmpCell)),((Lazy.force constinitFunDefsCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replace c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,Count)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),`replace(_,_,_,_)_STRING`(substrString(Source,`_+Int__INT`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)),ToReplace,Replacement,`_-Int__INT`(Count,#token("1","Int"))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(Replacement)),isInt(Count)),isString(ToReplace)),`_>Int__INT`(Count,#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(547) org.kframework.attributes.Location(Location(547,8,550,30)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_686) :: []),((String _ as varToReplace_687) :: []),((String _ as varReplacement_688) :: []),((Int _ as varCount_689) :: [])) when ((((((((true) && (true))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varCount_689 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_686 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_686 :: []),(varToReplace_687 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_688 :: [])) config (-1))),((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_686 :: []),((eval_'Plus'Int__INT(((evalfindString((varSource_686 :: []),(varToReplace_687 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_687 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_686 :: [])) config (-1)))) config (-1))),(varToReplace_687 :: []),(varReplacement_688 :: []),((eval_'Hyph'Int__INT((varCount_689 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,_15,_16,_0)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(_15),isString(Source)),isString(_16)),`_==Int_`(_0,#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(551) org.kframework.attributes.Location(Location(551,8,551,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_690) :: []),((String _ as var_15_691) :: []),((String _ as var_16_692) :: []),((Int _ as var_0_693) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsEqls'Int_((var_0_693 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_690 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let rec evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING and sort = 
SortInt in match c with 
| _ -> try STRING.hook_countAllOccurrences c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>`_+Int__INT`(#token("1","Int"),`countAllOccurrences(_,_)_STRING`(substrString(Source,`_+Int__INT`(findString(Source,ToCount,#token("0","Int")),lengthString(ToCount)),lengthString(Source)),ToCount))`` requires `_andBool_`(`_andBool_`(isString(Source),isString(ToCount)),`_>=Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(537) org.kframework.attributes.Location(Location(537,8,538,60)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_694) :: []),((String _ as varToCount_695) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_694 :: []),(varToCount_695 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int__INT(((Lazy.force int1) :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_694 :: []),((eval_'Plus'Int__INT(((evalfindString((varSource_694 :: []),(varToCount_695 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToCount_695 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_694 :: [])) config (-1)))) config (-1))),(varToCount_695 :: [])) config (-1)))) config (-1)))
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>#token("0","Int")`` requires `_andBool_`(`_andBool_`(isString(Source),isString(ToCount)),`_<Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(535) org.kframework.attributes.Location(Location(535,8,536,59)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_696) :: []),((String _ as varToCount_697) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_696 :: []),(varToCount_697 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceAll c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceAll(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,`countAllOccurrences(_,_)_STRING`(Source,ToReplace))`` requires `_andBool_`(`_andBool_`(isString(Source),isString(Replacement)),isString(ToReplace)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(552) org.kframework.attributes.Location(Location(552,8,552,154)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varSource_698) :: []),((String _ as varToReplace_699) :: []),((String _ as varReplacement_700) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING((varSource_698 :: []),(varToReplace_699 :: []),(varReplacement_700 :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING((varSource_698 :: []),(varToReplace_699 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisBranchTmp (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBranchTmp and sort = 
SortBool in match c with 
(*{| rule ``isBranchTmp(#secondBranch(K0))=>#token("true","Bool")`` requires isBlocks(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'secondBranch,(varK0_701 :: [])) :: [])) when (isTrue (evalisBlocks((varK0_701 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBranchTmp(#KToken(#token("BranchTmp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBranchTmp, var__702) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBranchTmp(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_703)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalchrChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblchrChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_chr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(528) org.kframework.attributes.Location(Location(528,8,528,63)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_704) :: []),((String _ as varS2_705) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS1_704 :: []),(varS2_705 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec eval'Hash'borrowimmck (c: k * k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'borrowimmck and sort = 
SortBool in match c with 
| (((Int _ as var_0_706) :: []),(var_1_707),((Int _ as var_2_708) :: []),((Int _ as var_3_709) :: []),((Int _ as var_4_710) :: [])) when guard < 0(*{| rule ``#borrowimmck(L4,_0,L1,L2,L3)=>#borrowimmck(L4,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(#rs(_39),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isMap(M)),isInt(L2)),isInt(L3)),isInt(L1)),isProps(_39))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(275) org.kframework.attributes.Location(Location(275,6,275,105)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_707) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | (var_6_711) as e14 -> (let e = ((evalMap'Coln'lookup((var_1_707),e14) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply1(Lbl'Hash'rs,(var_7_712 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_707),e14) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_713) :: []) when ((((((true) && (true))) && (true))) && (((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((isTrue (evalisProps((var_7_712 :: [])) config (-1))))))) && (true) -> ((eval'Hash'borrowimmck((var_0_706 :: []),(var_5_713 :: []),(var_2_708 :: []),(var_3_709 :: []),(var_4_710 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowimmck c config 0) else choice| _ -> (eval'Hash'borrowimmck c config 0))
| (((Int _ as var_0_714) :: []),(var_1_715),((Int _ as var_2_716) :: []),((Int _ as var_3_717) :: []),((Int _ as var_4_718) :: [])) when guard < 1(*{| rule ``#borrowimmck(L5,_0,L1,L2,L3)=>#borrowimmck(L5,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(M,`_[_<-undef]`(_0,L))),#match(#br(BEG,END,#mutRef(L3)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_andBool_`(`_=/=Int__INT`(L5,L),`_==Bool__BOOL`(#lc(L1,L2,BEG,END),#token("false","Bool"))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(283) org.kframework.attributes.Location(Location(283,6,285,75)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_715) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_6_719) :: []) as e15 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_715),e15) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_720) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_715),e15) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_721) :: []),((Int _ as var_8_722) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_4_723) :: [])) :: [])) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_714 :: []),e15) config (-1)))) && ((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'lc((var_2_716 :: []),(var_3_717 :: []),(var_7_721 :: []),(var_8_722 :: [])) config (-1))),((Bool false) :: [])) config (-1))))))))) && (((compare_kitem var_4_723 var_4_718) = 0) && true) -> ((eval'Hash'borrowimmck((var_0_714 :: []),(var_5_720 :: []),(var_2_716 :: []),(var_3_717 :: []),(var_4_723 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowimmck c config 1) else choice| _ -> (eval'Hash'borrowimmck c config 1))
| (((Int _ as var_0_724) :: []),(var_1_725),((Int _ as var_2_726) :: []),((Int _ as var_3_727) :: []),((Int _ as var_4_728) :: [])) when guard < 2(*{| rule ``#borrowimmck(L4,_0,L1,L2,L3)=>#borrowimmck(L4,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(M,`_[_<-undef]`(_0,L))),#match(#br(_67,_68,#immRef(_69)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isInt(_69)),isInt(_68)),isMap(M)),isInt(_67)),isInt(L2)),isInt(L3)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(276) org.kframework.attributes.Location(Location(276,6,276,118)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_725) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | (var_6_729) as e16 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_725),e16) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_730) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_725),e16) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_731) :: []),((Int _ as var_8_732) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_9_733) :: [])) :: [])) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true)))) && (true) -> ((eval'Hash'borrowimmck((var_0_724 :: []),(var_5_730 :: []),(var_2_726 :: []),(var_3_727 :: []),(var_4_728 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowimmck c config 2) else choice| _ -> (eval'Hash'borrowimmck c config 2))
| (((Int _ as var_0_734) :: []),(var_1_735),((Int _ as var_2_736) :: []),((Int _ as var_3_737) :: []),((Int _ as var_4_738) :: [])) when guard < 3(*{| rule ``#borrowimmck(L5,_0,L1,L2,L4)=>#borrowimmck(L5,M,L1,L2,L4)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(#br(_50,_51,#mutRef(L3)),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isInt(_51)),isInt(_50)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_=/=Int__INT`(L3,L4))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(279) org.kframework.attributes.Location(Location(279,6,281,27)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_735) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_6_739) :: []) as e17 -> (let e = ((evalMap'Coln'lookup((var_1_735),e17) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_740) :: []),((Int _ as var_8_741) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_9_742) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_735),e17) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_743) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((var_9_742 :: []),(var_4_738 :: [])) config (-1))))))) && (true) -> ((eval'Hash'borrowimmck((var_0_734 :: []),(var_5_743 :: []),(var_2_736 :: []),(var_3_737 :: []),(var_4_738 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowimmck c config 3) else choice| _ -> (eval'Hash'borrowimmck c config 3))
| (((Int _ as var_0_744) :: []),(var_1_745),((Int _ as var_2_746) :: []),((Int _ as var_3_747) :: []),((Int _ as var_4_748) :: [])) when guard < 4(*{| rule ``#borrowimmck(L,_0,L1,L2,L3)=>#borrowimmck(L,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(#match(M,`_[_<-undef]`(_0,L)),#match(#br(BEG,END,#mutRef(L3)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(292) org.kframework.attributes.Location(Location(292,6,293,47)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_745),(var_0_744 :: [])) config (-1))) in match e with 
| [Bottom] -> (eval'Hash'borrowimmck c config 4)
| ((Map (SortMap,_,_) as var_5_749) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_745),(var_0_744 :: [])) config (-1))) in match e with 
| [Bottom] -> (eval'Hash'borrowimmck c config 4)
| (KApply3(Lbl'Hash'br,((Int _ as var_6_750) :: []),((Int _ as var_7_751) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_4_752) :: [])) :: [])) :: []) when ((((true) && (true))) && (((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true)))) && (((compare_kitem var_4_748 var_4_752) = 0) && true) -> ((eval'Hash'borrowimmck((var_0_744 :: []),(var_5_749 :: []),(var_2_746 :: []),(var_3_747 :: []),(var_4_748 :: [])) config (-1)))| _ -> (eval'Hash'borrowimmck c config 4))| _ -> (eval'Hash'borrowimmck c config 4))
| (((Int _ as var_0_753) :: []),(var_1_754),((Int _ as var_2_755) :: []),((Int _ as var_3_756) :: []),((Int _ as var_4_757) :: [])) when guard < 5(*{| rule ``#borrowimmck(L4,_0,L1,L2,L3)=>#borrowimmck(L4,M,L1,L2,L3)`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(`#uninit_OSL-SYNTAX`(.KList),`Map:lookup`(_0,L))),#match(M,`_[_<-undef]`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(L4),isMap(M)),isInt(L2)),isInt(L3)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(277) org.kframework.attributes.Location(Location(277,6,277,106)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_754) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | (var_6_758) as e18 -> (let e = ((evalMap'Coln'lookup((var_1_754),e18) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply0(Lbl'Hash'uninit_OSL'Hyph'SYNTAX) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_754),e18) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_5_759) :: []) when ((((((true) && (true))) && (true))) && (((((((((true) && (true))) && (true))) && (true))) && (true)))) && (true) -> ((eval'Hash'borrowimmck((var_0_753 :: []),(var_5_759 :: []),(var_2_755 :: []),(var_3_756 :: []),(var_4_757 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowimmck c config 5) else choice| _ -> (eval'Hash'borrowimmck c config 5))
| (((Int _ as var_0_760) :: []),(var_1_761),((Int _ as var_2_762) :: []),((Int _ as var_3_763) :: []),((Int _ as var_4_764) :: [])) when guard < 6(*{| rule ``#borrowimmck(L5,_0,L1,L2,L3)=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(L,_0),#match(M,`_[_<-undef]`(_0,L))),#match(#br(BEG,END,#mutRef(L3)),`Map:lookup`(_0,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isMap(M)),isInt(L2)),isInt(L3)),isInt(L)),isInt(L1)),isInt(L5)),`_andBool_`(`_=/=Int__INT`(L5,L),`_==Bool__BOOL`(#lc(L1,L2,BEG,END),#token("true","Bool"))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(287) org.kframework.attributes.Location(Location(287,6,289,74)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_761) with 
| [Map (_,_,collection)] -> let choice = (KMap.fold (fun e v result -> if result == interned_bottom then (match e with | ((Int _ as var_5_765) :: []) as e19 -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_1_761),e19) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Map (SortMap,_,_) as var_6_766) :: []) -> (let e = ((evalMap'Coln'lookup((var_1_761),e19) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| (KApply3(Lbl'Hash'br,((Int _ as var_7_767) :: []),((Int _ as var_8_768) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_4_769) :: [])) :: [])) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsSlshEqls'Int__INT((var_0_760 :: []),e19) config (-1)))) && ((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'lc((var_2_762 :: []),(var_3_763 :: []),(var_7_767 :: []),(var_8_768 :: [])) config (-1))),((Bool true) :: [])) config (-1))))))))) && (((compare_kitem var_4_764 var_4_769) = 0) && true) -> ((Bool true) :: [])| _ -> interned_bottom)| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'borrowimmck c config 6) else choice| _ -> (eval'Hash'borrowimmck c config 6))
(*{| rule ``#borrowimmck(_61,_0,_62,_63,_64)=>#token("false","Bool")`` requires `_andBool_`(`_==K_`(`.Map`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(isInt(_62),isInt(_63)),isInt(_64)),isInt(_61))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(297) org.kframework.attributes.Location(Location(297,6,297,42)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (((Int _ as var_61_770) :: []),(var_0_771),((Int _ as var_62_772) :: []),((Int _ as var_63_773) :: []),((Int _ as var_64_774) :: [])) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Map)),(var_0_771)) config (-1)))) && (((((((true) && (true))) && (true))) && (true)))) && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize5 c)))])
let evalisSeparator (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSeparator and sort = 
SortBool in match c with 
(*{| rule ``isSeparator(#loopEnd(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'loopEnd,((Int _ as varK0_775) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSeparator(#evaluate(K0))=>#token("true","Bool")`` requires isBlock(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'evaluate,(varK0_776 :: [])) :: [])) when (isTrue (evalisBlock((varK0_776 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSeparator(#loopSep(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'loopSep,((Int _ as varK0_777) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSeparator(#KToken(#token("Separator","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSeparator, var__778) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSeparator(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_779)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFunDefsCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFunDefsCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isFunDefsCellFragment(#KToken(#token("FunDefsCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFunDefsCellFragment, var__780) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCellFragment(`<funDefs>-fragment`(K0))=>#token("true","Bool")`` requires isFunDefCellMap(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'funDefs'_GT_Hyph'fragment,((Map (SortFunDefCellMap,_,_) as varK0_781) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isFunDefsCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_782)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = match sort with 
| "Id" -> (evalfreshId ([Int counter]) config (-1))
| "Int" -> (evalfreshInt ([Int counter]) config (-1))
| _ -> invalid_arg ("Cannot find fresh function for sort " ^ sort)let eval'Hash'fresh (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'fresh and sort = 
SortKItem in match c with 
| _ -> try KREFLECTION.hook_fresh c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBorrowItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBorrowItem and sort = 
SortBool in match c with 
(*{| rule ``isBorrowItem(#KToken(#token("BorrowItem","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBorrowItem, var__783) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBorrowItem(#br(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isInt(K0),isInt(K1)),isExp(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'Hash'br,((Int _ as varK0_784) :: []),((Int _ as varK1_785) :: []),(varK2_786 :: [])) :: [])) when ((((true) && (true))) && ((isTrue (evalisExp((varK2_786 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBorrowItem(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_787)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalminInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblminInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_min c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'isConcrete (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'isConcrete and sort = 
SortBool in match c with 
| _ -> try KREFLECTION.hook_isConcrete c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalString2Float (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Float and sort = 
SortFloat in match c with 
| _ -> try STRING.hook_string2float c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_andThenBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andThenBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_andThen c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andThenBool__BOOL`(_8,#token("false","Bool"))=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(293) org.kframework.attributes.Location(Location(293,8,293,36)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| ((var_8_788),((Bool false) :: [])) -> ((Bool false) :: [])
(*{| rule `` `_andThenBool__BOOL`(#token("false","Bool"),_7)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(292) org.kframework.attributes.Location(Location(292,8,292,36)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool false) :: []),(var_7_789)) -> ((Bool false) :: [])
(*{| rule `` `_andThenBool__BOOL`(K,#token("true","Bool"))=>K`` requires isK(K) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(291) org.kframework.attributes.Location(Location(291,8,291,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| ((varK_790),((Bool true) :: [])) when true && (true) -> (varK_790)
(*{| rule `` `_andThenBool__BOOL`(#token("true","Bool"),K)=>K`` requires isK(K) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(290) org.kframework.attributes.Location(Location(290,8,290,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool true) :: []),(varK_791)) when true && (true) -> (varK_791)
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalnewUUID_STRING (c: unit) (config: k) (guard: int) : k = let lbl = 
LblnewUUID_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_uuid c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let eval_'Xor_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_pow c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCell and sort = 
SortBool in match c with 
(*{| rule ``isTCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__792) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCell(`<T>`(K0,K1,K2,K3))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(isStatesCell(K0),isNstateCell(K1)),isTmpCell(K2)),isFunDefsCell(K3)) ensures #token("true","Bool") []|}*)
| ((KApply4(Lbl'_LT_'T'_GT_',(varK0_793 :: []),(varK1_794 :: []),(varK2_795 :: []),(varK3_796 :: [])) :: [])) when (((((((isTrue (evalisStatesCell((varK0_793 :: [])) config (-1)))) && ((isTrue (evalisNstateCell((varK1_794 :: [])) config (-1)))))) && ((isTrue (evalisTmpCell((varK2_795 :: [])) config (-1)))))) && ((isTrue (evalisFunDefsCell((varK3_796 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_797)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'Xor_Perc'Int___INT (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_Perc'Int___INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_powmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortString in match c with 
| _ -> try IO.hook_read c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'argv (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'argv and sort = 
SortList in match c with 
| _ -> try KREFLECTION.hook_argv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'argv : k Lazy.t = lazy (eval'Hash'argv () interned_bottom (-1))
let eval_'Pipe'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Pipe'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_dividesInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_dividesInt__INT and sort = 
SortBool in match c with 
(*{| rule `` `_dividesInt__INT`(I1,I2)=>`_==Int_`(`_%Int__INT`(I2,I1),#token("0","Int"))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(381) org.kframework.attributes.Location(Location(381,8,381,58)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Int _ as varI1_798) :: []),((Int _ as varI2_799) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'Int_(((eval_'Perc'Int__INT((varI2_799 :: []),(varI1_798 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblrandInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_rand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys and sort = 
SortSet in match c with 
| _ -> try MAP.hook_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalvalues (c: k) (config: k) (guard: int) : k = let lbl = 
Lblvalues and sort = 
SortList in match c with 
| _ -> try MAP.hook_values c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblsrandInt and sort = 
SortK in match c with 
| _ -> try INT.hook_srand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_putc c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_in_keys'LPar'_'RPar'_MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_in_keys'LPar'_'RPar'_MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_in_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_findChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``findChar(_10,#token("\"\"","String"),_11)=>#token("-1","Int")`` requires `_andBool_`(isString(_10),isInt(_11)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(531) org.kframework.attributes.Location(Location(531,8,531,32)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as var_10_800) :: []),((String "") :: []),((Int _ as var_11_801) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
(*{| rule ``findChar(S1,S2,I)=>`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),#token("-1","Int")),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),#token("-1","Int")),findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),`minInt(_,_)_INT`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(S2),isString(S1)),isInt(I)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(530) org.kframework.attributes.Location(Location(530,8,530,431)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((String _ as varS1_802) :: []),((String _ as varS2_803) :: []),((Int _ as varI_804) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_803 :: []),((String "") :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindString((varS1_802 :: []),((evalsubstrString((varS2_803 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_804 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindChar((varS1_802 :: []),((evalsubstrString((varS2_803 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_803 :: [])) config (-1)))) config (-1))),(varI_804 :: [])) config (-1)))) else (((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindChar((varS1_802 :: []),((evalsubstrString((varS2_803 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_803 :: [])) config (-1)))) config (-1))),(varI_804 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindString((varS1_802 :: []),((evalsubstrString((varS2_803 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_804 :: [])) config (-1)))) else (((evalminInt'LPar'_'Comm'_'RPar'_INT(((evalfindString((varS1_802 :: []),((evalsubstrString((varS2_803 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_804 :: [])) config (-1))),((evalfindChar((varS1_802 :: []),((evalsubstrString((varS2_803 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_803 :: [])) config (-1)))) config (-1))),(varI_804 :: [])) config (-1)))) config (-1)))))))))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Star'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Star'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_mul c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalId2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblId2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_token2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'stderr_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stderr_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stderr_K-IO`(.KList)=>#token("2","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(742) org.kframework.attributes.Location(Location(742,8,742,20)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| () -> ((Lazy.force int2) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stderr_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stderr_K'Hyph'IO () interned_bottom (-1))
let rec eval'Hash'existRef (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'existRef and sort = 
SortBool in match c with 
| ((var_0_805),(var_1_806),((Int _ as var_2_807) :: [])) when guard < 0(*{| rule ``#existRef(R,_0,C)=>#existRef(R,S,C)`` requires `_andBool_`(`_andBool_`(#setChoice(#br(_30,C1,R1),_0),#match(S,`Set:difference`(_0,`SetItem`(#br(_30,C1,R1))))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(C1),isSet(S)),isInt(C)),isK(R)),isExp(R1)),isInt(_30)),`_=/=K__K-EQUAL`(R,R1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(101) org.kframework.attributes.Location(Location(101,6,102,24)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_806) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply3(Lbl'Hash'br,((Int _ as var_4_808) :: []),((Int _ as var_5_809) :: []),(var_6_810 :: [])) :: []) as e20 -> (let e = ((evalSet'Coln'difference((var_1_806),((evalSetItem(e20) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_3_811) :: []) when ((((true) && (true))) && (((((((((((((true) && (true))) && (true))) && (true))) && ((isTrue (evalisExp((var_6_810 :: [])) config (-1)))))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'K__K'Hyph'EQUAL((var_0_805),(var_6_810 :: [])) config (-1))))))) && (true) -> ((eval'Hash'existRef((var_0_805),(var_3_811 :: []),(var_2_807 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'existRef c config 0) else choice| _ -> (eval'Hash'existRef c config 0))
| ((var_0_812),(var_1_813),((Int _ as var_2_814) :: [])) when guard < 1(*{| rule ``#existRef(R,_0,C)=>#existRef(R,S,C)`` requires `_andBool_`(`_andBool_`(#setChoice(#rs(_29),_0),#match(S,`Set:difference`(_0,`SetItem`(#rs(_29))))),`_andBool_`(`_andBool_`(`_andBool_`(isProps(_29),isSet(S)),isInt(C)),isK(R))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(98) org.kframework.attributes.Location(Location(98,6,98,72)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_813) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply1(Lbl'Hash'rs,(var_4_815 :: [])) :: []) as e21 -> (let e = ((evalSet'Coln'difference((var_1_813),((evalSetItem(e21) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_3_816) :: []) when ((((true) && (true))) && ((((((((isTrue (evalisProps((var_4_815 :: [])) config (-1)))) && (true))) && (true))) && (true)))) && (true) -> ((eval'Hash'existRef((var_0_812),(var_3_816 :: []),(var_2_814 :: [])) config (-1)))| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'existRef c config 1) else choice| _ -> (eval'Hash'existRef c config 1))
| ((var_0_817),(var_1_818),((Int _ as var_2_819) :: [])) when guard < 2(*{| rule ``#existRef(R,_0,C)=>#existRef(R,S,C)`` requires `_andBool_`(`_andBool_`(`Set:in`(`#uninit_OSL-SYNTAX`(.KList),_0),#match(S,`Set:difference`(_0,`SetItem`(`#uninit_OSL-SYNTAX`(.KList))))),`_andBool_`(`_andBool_`(isSet(S),isInt(C)),isK(R))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(99) org.kframework.attributes.Location(Location(99,6,99,73)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (let e = ((evalSet'Coln'difference((var_1_818),((evalSetItem((const'Hash'uninit_OSL'Hyph'SYNTAX :: [])) config (-1)))) config (-1))) in match e with 
| [Bottom] -> (eval'Hash'existRef c config 2)
| ((Set (SortSet,_,_) as var_3_820) :: []) when (((((isTrue (evalSet'Coln'in((const'Hash'uninit_OSL'Hyph'SYNTAX :: []),(var_1_818)) config (-1)))) && (true))) && (((((true) && (true))) && (true)))) && (true) -> ((eval'Hash'existRef((var_0_817),(var_3_820 :: []),(var_2_819 :: [])) config (-1)))| _ -> (eval'Hash'existRef c config 2))
| ((var_0_821),(var_1_822),((Int _ as var_2_823) :: [])) when guard < 3(*{| rule ``#existRef(R,_0,C)=>`_andBool_`(`_>=Int__INT`(C1,C),#token("true","Bool"))`` requires `_andBool_`(`_andBool_`(#setChoice(#br(_46,C1,R),_0),#match(S,`Set:difference`(_0,`SetItem`(#br(_46,C1,R))))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(_46),isInt(C1)),isSet(S)),isInt(C)),isK(R))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(100) org.kframework.attributes.Location(Location(100,6,100,88)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_1_822) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply3(Lbl'Hash'br,((Int _ as var_4_824) :: []),((Int _ as var_3_825) :: []),(var_0_826)) :: []) as e22 -> (let e = ((evalSet'Coln'difference((var_1_822),((evalSetItem(e22) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_5_827) :: []) when ((((true) && (true))) && (((((((((true) && (true))) && (true))) && (true))) && (true)))) && (((compare var_0_821 var_0_826) = 0) && true) -> ([Bool ((((isTrue (eval_'_GT_Eqls'Int__INT((var_3_825 :: []),(var_2_823 :: [])) config (-1)))) && (true)))])| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'existRef c config 3) else choice| _ -> (eval'Hash'existRef c config 3))
(*{| rule ``#existRef(_57,_0,_58)=>#token("false","Bool")`` requires `_andBool_`(`_==K_`(`.Set`(.KList),_0),isInt(_58)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(104) org.kframework.attributes.Location(Location(104,6,104,36)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| ((var_57_828),(var_0_829),((Int _ as var_58_830) :: [])) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_829)) config (-1)))) && (true)) && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisFloat (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFloat and sort = 
SortBool in match c with 
| [Float _] -> [Bool true]
(*{| rule ``isFloat(#KToken(#token("Float","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFloat, var__831) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFloat(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_832)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsSlshEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Bool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B1),isBool(B2)) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(315) org.kframework.attributes.Location(Location(315,8,315,57)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/k/include/builtin/domains.k))]|}*)
| (((Bool _ as varB1_833) :: []),((Bool _ as varB2_834) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_833 :: []),(varB2_834 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKItem and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortFunDefCellMap) -> [Bool true]
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
| [_] -> [Bool true] | _ -> [Bool false]
| [Map (s,_,_)] when (s = SortStateCellMap) -> [Bool true]
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
| [Float _] -> [Bool true]
| [Int _] -> [Bool true]
| [Bool _] -> [Bool true]
| [List (s,_,_)] when (s = SortList) -> [Bool true]
| [String _] -> [Bool true]
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval (c: normal_kitem) (config: k) : k = match c with KApply(lbl, kl) -> (match lbl with 
|LblisDItem -> evalisDItem (normalize1 kl) config (-1)
|Lbl_FunDefCellMap_ -> eval_FunDefCellMap_ (normalize2 kl) config (-1)
|LblisStateCellFragment -> evalisStateCellFragment (normalize1 kl) config (-1)
|LblupdateMap -> evalupdateMap (normalize2 kl) config (-1)
|Lbl_orBool__BOOL -> eval_orBool__BOOL (normalize2 kl) config (-1)
|LblisBorrow -> evalisBorrow (normalize1 kl) config (-1)
|LblinitUnsafeModeCell -> evalinitUnsafeModeCell (normalize0 kl) config (-1)
|LbldirectionalityChar -> evaldirectionalityChar (normalize1 kl) config (-1)
|LblSet'Coln'choice -> evalSet'Coln'choice (normalize1 kl) config (-1)
|LblinitFbodyCell -> evalinitFbodyCell (normalize0 kl) config (-1)
|LblisProp -> evalisProp (normalize1 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP -> eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (normalize3 kl) config (-1)
|LblisCell -> evalisCell (normalize1 kl) config (-1)
|LblinitWriteCell -> evalinitWriteCell (normalize0 kl) config (-1)
|LblMap'Coln'choice -> evalMap'Coln'choice (normalize1 kl) config (-1)
|Lbl'Hash'list2Set -> eval'Hash'list2Set (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'String__STRING -> eval_'EqlsSlshEqls'String__STRING (normalize2 kl) config (-1)
|LblremoveAll -> evalremoveAll (normalize2 kl) config (-1)
|Lbl_impliesBool__BOOL -> eval_impliesBool__BOOL (normalize2 kl) config (-1)
|LblcategoryChar -> evalcategoryChar (normalize1 kl) config (-1)
|LblisFretCell -> evalisFretCell (normalize1 kl) config (-1)
|Lbl'Hash'IsMoved -> eval'Hash'IsMoved (normalize3 kl) config (-1)
|LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|Lbl_List_ -> eval_List_ (normalize2 kl) config (-1)
|Lbl'Hash'parseInModule -> eval'Hash'parseInModule (normalize3 kl) config (-1)
|LblisFunction -> evalisFunction (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'Int_ -> eval_'EqlsEqls'Int_ (normalize2 kl) config (-1)
|LblordChar -> evalordChar (normalize1 kl) config (-1)
|Lblkeys_list'LPar'_'RPar'_MAP -> evalkeys_list'LPar'_'RPar'_MAP (normalize1 kl) config (-1)
|LblisType -> evalisType (normalize1 kl) config (-1)
|LblisMap -> evalisMap (normalize1 kl) config (-1)
|LblisFnameCellOpt -> evalisFnameCellOpt (normalize1 kl) config (-1)
|LblisKLabel -> evalisKLabel (normalize1 kl) config (-1)
|Lblsize -> evalsize (normalize1 kl) config (-1)
|LblMap'Coln'lookup -> evalMap'Coln'lookup (normalize2 kl) config (-1)
|LblgetKLabel -> evalgetKLabel (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'K__K'Hyph'EQUAL -> eval_'EqlsSlshEqls'K__K'Hyph'EQUAL (normalize2 kl) config (-1)
|LblSet'Coln'in -> evalSet'Coln'in (normalize2 kl) config (-1)
|Lbl_divInt__INT -> eval_divInt__INT (normalize2 kl) config (-1)
|LblisOItem -> evalisOItem (normalize1 kl) config (-1)
|LblMap'Coln'lookupOrDefault -> evalMap'Coln'lookupOrDefault (normalize3 kl) config (-1)
|LblString2Base -> evalString2Base (normalize2 kl) config (-1)
|Lbl'Hash'isOwnerHasMutProp -> eval'Hash'isOwnerHasMutProp (normalize1 kl) config (-1)
|Lbl'Hash'wv -> eval'Hash'wv (normalize2 kl) config (-1)
|LblBase2String -> evalBase2String (normalize2 kl) config (-1)
|LblList'Coln'range -> evalList'Coln'range (normalize3 kl) config (-1)
|LblsizeList -> evalsizeList (normalize1 kl) config (-1)
|LblisStream -> evalisStream (normalize1 kl) config (-1)
|LblisFunDefCellMap -> evalisFunDefCellMap (normalize1 kl) config (-1)
|LblinitFnameCell -> evalinitFnameCell (normalize0 kl) config (-1)
|LblinitKCell -> evalinitKCell (normalize1 kl) config (-1)
|LblinitIndexCell -> evalinitIndexCell (normalize0 kl) config (-1)
|Lbl'Hash'writeCK -> eval'Hash'writeCK (normalize4 kl) config (-1)
|Lbl_'_GT_'String__STRING -> eval_'_GT_'String__STRING (normalize2 kl) config (-1)
|Lbl'Stop'Map -> eval'Stop'Map (normalize0 kl) config (-1)
|Lbl_Set_ -> eval_Set_ (normalize2 kl) config (-1)
|LblinitStateCell -> evalinitStateCell (normalize1 kl) config (-1)
|LblisK -> evalisK (normalize1 kl) config (-1)
|Lbl'Hash'parse -> eval'Hash'parse (normalize2 kl) config (-1)
|Lbl'Hash'lstat'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'lstat'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl'Hash'sort -> eval'Hash'sort (normalize1 kl) config (-1)
|LblisIndexesCell -> evalisIndexesCell (normalize1 kl) config (-1)
|Lbl_'Plus'String__STRING -> eval_'Plus'String__STRING (normalize2 kl) config (-1)
|LblisUnsafeModeCellOpt -> evalisUnsafeModeCellOpt (normalize1 kl) config (-1)
|LblisStateCell -> evalisStateCell (normalize1 kl) config (-1)
|Lbl_'_GT__GT_'Int__INT -> eval_'_GT__GT_'Int__INT (normalize2 kl) config (-1)
|Lbl'Hash'stdout_K'Hyph'IO -> eval'Hash'stdout_K'Hyph'IO (normalize0 kl) config (-1)
|Lbl'Hash'configuration_K'Hyph'REFLECTION -> eval'Hash'configuration_K'Hyph'REFLECTION (normalize0 kl) config (-1)
|Lbl'Hash'open'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'open'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'String__STRING -> eval_'_LT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblisParameters -> evalisParameters (normalize1 kl) config (-1)
|LblisFbodyCell -> evalisFbodyCell (normalize1 kl) config (-1)
|LblisIndexesCellOpt -> evalisIndexesCellOpt (normalize1 kl) config (-1)
|Lbl_'Slsh'Int__INT -> eval_'Slsh'Int__INT (normalize2 kl) config (-1)
|LblisFparamsCell -> evalisFparamsCell (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Int__INT -> eval_'_LT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblisKResult -> evalisKResult (normalize1 kl) config (-1)
|LblisTmpCell -> evalisTmpCell (normalize1 kl) config (-1)
|Lbl'Hash'system -> eval'Hash'system (normalize1 kl) config (-1)
|Lbl_orElseBool__BOOL -> eval_orElseBool__BOOL (normalize2 kl) config (-1)
|Lbl_'Hyph'Map__MAP -> eval_'Hyph'Map__MAP (normalize2 kl) config (-1)
|Lbl'Hash'parseToken'LPar'_'Comm'_'RPar'_STRING -> eval'Hash'parseToken'LPar'_'Comm'_'RPar'_STRING (normalize2 kl) config (-1)
|LblisBool -> evalisBool (normalize1 kl) config (-1)
|LblList'Coln'get -> evalList'Coln'get (normalize2 kl) config (-1)
|LbllengthString -> evallengthString (normalize1 kl) config (-1)
|LblSet'Coln'difference -> evalSet'Coln'difference (normalize2 kl) config (-1)
|Lbl_xorBool__BOOL -> eval_xorBool__BOOL (normalize2 kl) config (-1)
|LblisWriteCellOpt -> evalisWriteCellOpt (normalize1 kl) config (-1)
|Lbl_modInt__INT -> eval_modInt__INT (normalize2 kl) config (-1)
|LblinitTmpCell -> evalinitTmpCell (normalize0 kl) config (-1)
|Lbl_'EqlsEqls'K_ -> eval_'EqlsEqls'K_ (normalize2 kl) config (-1)
|LblinitFunDefCell -> evalinitFunDefCell (normalize0 kl) config (-1)
|LblisFunDefCell -> evalisFunDefCell (normalize1 kl) config (-1)
|LblisIOError -> evalisIOError (normalize1 kl) config (-1)
|LblinitTimerCell -> evalinitTimerCell (normalize0 kl) config (-1)
|LblinitFparamsCell -> evalinitFparamsCell (normalize0 kl) config (-1)
|Lbl'Hash'opendir'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'opendir'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl'Hash'checkInit -> eval'Hash'checkInit (normalize3 kl) config (-1)
|Lbl'Hash'bindParams -> eval'Hash'bindParams (normalize3 kl) config (-1)
|LblisKConfigVar -> evalisKConfigVar (normalize1 kl) config (-1)
|LblisWItem -> evalisWItem (normalize1 kl) config (-1)
|Lbl'Hash'getenv -> eval'Hash'getenv (normalize1 kl) config (-1)
|LblisTmpCellOpt -> evalisTmpCellOpt (normalize1 kl) config (-1)
|Lbl_'And'Int__INT -> eval_'And'Int__INT (normalize2 kl) config (-1)
|Lbl_'PipeHyph_GT_'_ -> eval_'PipeHyph_GT_'_ (normalize2 kl) config (-1)
|LblisKCellOpt -> evalisKCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'IsMoveOccurred -> eval'Hash'IsMoveOccurred (normalize2 kl) config (-1)
|LblFloatFormat -> evalFloatFormat (normalize2 kl) config (-1)
|Lbl_StateCellMap_ -> eval_StateCellMap_ (normalize2 kl) config (-1)
|Lbl'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisFparamsCellOpt -> evalisFparamsCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'borrowmutck -> eval'Hash'borrowmutck (normalize5 kl) config (-1)
|LblrfindChar -> evalrfindChar (normalize3 kl) config (-1)
|Lbl'Tild'Int__INT -> eval'Tild'Int__INT (normalize1 kl) config (-1)
|LblisStoreCell -> evalisStoreCell (normalize1 kl) config (-1)
|LblisString -> evalisString (normalize1 kl) config (-1)
|LblisUnsafeModeCell -> evalisUnsafeModeCell (normalize1 kl) config (-1)
|Lbl'Hash'lc -> eval'Hash'lc (normalize4 kl) config (-1)
|LblisBlocks -> evalisBlocks (normalize1 kl) config (-1)
|Lbl_Map_ -> eval_Map_ (normalize2 kl) config (-1)
|LblintersectSet -> evalintersectSet (normalize2 kl) config (-1)
|LblfreshId -> evalfreshId (normalize1 kl) config (-1)
|LblisUninit -> evalisUninit (normalize1 kl) config (-1)
|Lbl'Hash'close'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'close'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl'Hash'unwrapInt -> eval'Hash'unwrapInt (normalize1 kl) config (-1)
|LblisFretCellOpt -> evalisFretCellOpt (normalize1 kl) config (-1)
|LblsizeMap -> evalsizeMap (normalize1 kl) config (-1)
|LblisFunDefsCellOpt -> evalisFunDefsCellOpt (normalize1 kl) config (-1)
|LblisStatesCellOpt -> evalisStatesCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'getc'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'getc'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblisLifetime -> evalisLifetime (normalize1 kl) config (-1)
|LblisIndexItem -> evalisIndexItem (normalize1 kl) config (-1)
|LblisFunDefCellFragment -> evalisFunDefCellFragment (normalize1 kl) config (-1)
|LblisStatesCellFragment -> evalisStatesCellFragment (normalize1 kl) config (-1)
|LblString2Int -> evalString2Int (normalize1 kl) config (-1)
|LblisTCellFragment -> evalisTCellFragment (normalize1 kl) config (-1)
|Lbl_xorInt__INT -> eval_xorInt__INT (normalize2 kl) config (-1)
|Lbl'Hash'tell'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'tell'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl_'_LT_'Int__INT -> eval_'_LT_'Int__INT (normalize2 kl) config (-1)
|LblListItem -> evalListItem (normalize1 kl) config (-1)
|LblfreshInt -> evalfreshInt (normalize1 kl) config (-1)
|LblisTimerCellOpt -> evalisTimerCellOpt (normalize1 kl) config (-1)
|LblisBlock -> evalisBlock (normalize1 kl) config (-1)
|Lbl_'_LT__LT_'Int__INT -> eval_'_LT__LT_'Int__INT (normalize2 kl) config (-1)
|Lbl'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblrfindString -> evalrfindString (normalize3 kl) config (-1)
|Lbl'Hash'stat'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'stat'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblisBlockItem -> evalisBlockItem (normalize1 kl) config (-1)
|Lbl_inList_ -> eval_inList_ (normalize2 kl) config (-1)
|Lbl_'Plus'Int__INT -> eval_'Plus'Int__INT (normalize2 kl) config (-1)
|Lbl_'_LT_Eqls'Set__SET -> eval_'_LT_Eqls'Set__SET (normalize2 kl) config (-1)
|Lbl'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblfindString -> evalfindString (normalize3 kl) config (-1)
|Lbl'Hash'stdin_K'Hyph'IO -> eval'Hash'stdin_K'Hyph'IO (normalize0 kl) config (-1)
|Lbl_'EqlsSlshEqls'Int__INT -> eval_'EqlsSlshEqls'Int__INT (normalize2 kl) config (-1)
|Lbl_'_LT_Eqls'Map__MAP -> eval_'_LT_Eqls'Map__MAP (normalize2 kl) config (-1)
|Lbl_'_LT_'String__STRING -> eval_'_LT_'String__STRING (normalize2 kl) config (-1)
|LblisParameter -> evalisParameter (normalize1 kl) config (-1)
|LblisSet -> evalisSet (normalize1 kl) config (-1)
|Lbl'Stop'StateCellMap -> eval'Stop'StateCellMap (normalize0 kl) config (-1)
|Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL -> eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (normalize3 kl) config (-1)
|LblFloat2String -> evalFloat2String (normalize1 kl) config (-1)
|LblisProps -> evalisProps (normalize1 kl) config (-1)
|LblisNstateCell -> evalisNstateCell (normalize1 kl) config (-1)
|LblisIndexes -> evalisIndexes (normalize1 kl) config (-1)
|LblisStackCell -> evalisStackCell (normalize1 kl) config (-1)
|LblinitTCell -> evalinitTCell (normalize1 kl) config (-1)
|LblString2Id -> evalString2Id (normalize1 kl) config (-1)
|LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|LblmaxInt'LPar'_'Comm'_'RPar'_INT -> evalmaxInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING -> evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (normalize4 kl) config (-1)
|Lbl'Stop'FunDefCellMap -> eval'Stop'FunDefCellMap (normalize0 kl) config (-1)
|LblabsInt -> evalabsInt (normalize1 kl) config (-1)
|Lbl'Stop'List -> eval'Stop'List (normalize0 kl) config (-1)
|LblisBranchTmp -> evalisBranchTmp (normalize1 kl) config (-1)
|Lbl'Hash'inProps -> eval'Hash'inProps (normalize2 kl) config (-1)
|Lbl'Stop'Set -> eval'Stop'Set (normalize0 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' -> eval_'LSqB'_'_LT_Hyph'undef'RSqB' (normalize2 kl) config (-1)
|LblchrChar -> evalchrChar (normalize1 kl) config (-1)
|LblFunDefCellMapItem -> evalFunDefCellMapItem (normalize2 kl) config (-1)
|LblisList -> evalisList (normalize1 kl) config (-1)
|Lbl_'_GT_Eqls'String__STRING -> eval_'_GT_Eqls'String__STRING (normalize2 kl) config (-1)
|Lbl'Hash'borrowimmck -> eval'Hash'borrowimmck (normalize5 kl) config (-1)
|LblinitStackCell -> evalinitStackCell (normalize0 kl) config (-1)
|LblisEnvCellOpt -> evalisEnvCellOpt (normalize1 kl) config (-1)
|LblisIndexCell -> evalisIndexCell (normalize1 kl) config (-1)
|LblisSeparator -> evalisSeparator (normalize1 kl) config (-1)
|LblisFunDefsCellFragment -> evalisFunDefsCellFragment (normalize1 kl) config (-1)
|LblisTimerCell -> evalisTimerCell (normalize1 kl) config (-1)
|Lbl_andBool_ -> eval_andBool_ (normalize2 kl) config (-1)
|LblStateCellMapItem -> evalStateCellMapItem (normalize2 kl) config (-1)
|Lbl'Hash'fresh -> eval'Hash'fresh (normalize1 kl) config (-1)
|LblisBorrowItem -> evalisBorrowItem (normalize1 kl) config (-1)
|LblinitEnvCell -> evalinitEnvCell (normalize0 kl) config (-1)
|LblisStateCellMap -> evalisStateCellMap (normalize1 kl) config (-1)
|LblisExp -> evalisExp (normalize1 kl) config (-1)
|Lbl_'_GT_'Int__INT -> eval_'_GT_'Int__INT (normalize2 kl) config (-1)
|LblminInt'LPar'_'Comm'_'RPar'_INT -> evalminInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|Lbl'Hash'isConcrete -> eval'Hash'isConcrete (normalize1 kl) config (-1)
|LblString2Float -> evalString2Float (normalize1 kl) config (-1)
|Lbl_andThenBool__BOOL -> eval_andThenBool__BOOL (normalize2 kl) config (-1)
|LblnewUUID_STRING -> evalnewUUID_STRING (normalize0 kl) config (-1)
|Lbl_'Xor_'Int__INT -> eval_'Xor_'Int__INT (normalize2 kl) config (-1)
|LblisTCell -> evalisTCell (normalize1 kl) config (-1)
|Lbl_'Xor_Perc'Int___INT -> eval_'Xor_Perc'Int___INT (normalize3 kl) config (-1)
|Lbl_'Perc'Int__INT -> eval_'Perc'Int__INT (normalize2 kl) config (-1)
|LblisKCell -> evalisKCell (normalize1 kl) config (-1)
|Lbl'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisFunDefsCell -> evalisFunDefsCell (normalize1 kl) config (-1)
|LblisStatesCell -> evalisStatesCell (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'Bool__BOOL -> eval_'EqlsEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblinitFretCell -> evalinitFretCell (normalize0 kl) config (-1)
|LblsubstrString -> evalsubstrString (normalize3 kl) config (-1)
|LblisInt -> evalisInt (normalize1 kl) config (-1)
|Lbl'Hash'argv -> eval'Hash'argv (normalize0 kl) config (-1)
|Lbl_'Pipe'Int__INT -> eval_'Pipe'Int__INT (normalize2 kl) config (-1)
|LblisStackCellOpt -> evalisStackCellOpt (normalize1 kl) config (-1)
|LblisFbodyCellOpt -> evalisFbodyCellOpt (normalize1 kl) config (-1)
|LblInt2String -> evalInt2String (normalize1 kl) config (-1)
|Lbl_'_GT_Eqls'Int__INT -> eval_'_GT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblinitStatesCell -> evalinitStatesCell (normalize1 kl) config (-1)
|LblisIndexCellOpt -> evalisIndexCellOpt (normalize1 kl) config (-1)
|LblisWriteCell -> evalisWriteCell (normalize1 kl) config (-1)
|LblisStmt -> evalisStmt (normalize1 kl) config (-1)
|Lbl'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_dividesInt__INT -> eval_dividesInt__INT (normalize2 kl) config (-1)
|LblrandInt -> evalrandInt (normalize1 kl) config (-1)
|Lblkeys -> evalkeys (normalize1 kl) config (-1)
|LblisFnameCell -> evalisFnameCell (normalize1 kl) config (-1)
|Lblvalues -> evalvalues (normalize1 kl) config (-1)
|LblsrandInt -> evalsrandInt (normalize1 kl) config (-1)
|LblinitIndexesCell -> evalinitIndexesCell (normalize0 kl) config (-1)
|LblinitFunDefsCell -> evalinitFunDefsCell (normalize0 kl) config (-1)
|Lbl'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl'Hash'unwrapVal -> eval'Hash'unwrapVal (normalize1 kl) config (-1)
|Lbl_in_keys'LPar'_'RPar'_MAP -> eval_in_keys'LPar'_'RPar'_MAP (normalize2 kl) config (-1)
|LblisStmts -> evalisStmts (normalize1 kl) config (-1)
|LblfindChar -> evalfindChar (normalize3 kl) config (-1)
|LblinitNstateCell -> evalinitNstateCell (normalize0 kl) config (-1)
|LblisId -> evalisId (normalize1 kl) config (-1)
|LblinitStoreCell -> evalinitStoreCell (normalize0 kl) config (-1)
|Lbl_'Star'Int__INT -> eval_'Star'Int__INT (normalize2 kl) config (-1)
|LblisNstateCellOpt -> evalisNstateCellOpt (normalize1 kl) config (-1)
|LblisExps -> evalisExps (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'String__STRING -> eval_'EqlsEqls'String__STRING (normalize2 kl) config (-1)
|LblId2String -> evalId2String (normalize1 kl) config (-1)
|Lbl'Hash'stderr_K'Hyph'IO -> eval'Hash'stderr_K'Hyph'IO (normalize0 kl) config (-1)
|Lbl'Hash'existRef -> eval'Hash'existRef (normalize3 kl) config (-1)
|LblisFloat -> evalisFloat (normalize1 kl) config (-1)
|Lbl_'Hyph'Int__INT -> eval_'Hyph'Int__INT (normalize2 kl) config (-1)
|LblisStoreCellOpt -> evalisStoreCellOpt (normalize1 kl) config (-1)
|LblSetItem -> evalSetItem (normalize1 kl) config (-1)
|LblisValue -> evalisValue (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'Bool__BOOL -> eval_'EqlsSlshEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING -> evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (normalize2 kl) config (-1)
|LblisKItem -> evalisKItem (normalize1 kl) config (-1)
|LblisEnvCell -> evalisEnvCell (normalize1 kl) config (-1)
|LblnotBool_ -> evalnotBool_ (normalize1 kl) config (-1)
| _ -> [denormalize c])
| _ -> [denormalize c]
let rec get_next_op_from_exp(c: kitem) : (k -> k * (step_function)) = step
and step (c:k) : k * step_function =
 try let config = c in match c with 
| _ -> lookups_step c c (-1)
with Sys.Break -> raise (Stuck c)
and lookups_step (c: k) (config: k) (guard: int) : k * step_function = match c with 
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_835)) :: []),(var_1_836),(var_2_837),(var_3_838)) :: []) when guard < 77 -> (match (var_0_835) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> let rec stepElt = fun guard -> if result == interned_bottom then (match e with (*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#expStmt(V)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isValue(V)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(26) org.kframework.attributes.Location(Location(26,6,26,20)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_839) as e24 when guard < 0 -> (let e = ((evalMap'Coln'lookup((var_0_835),e24) config (-1))) in match e with 
| [Bottom] -> (stepElt 0)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_840),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'expStmt,(var_14_841 :: [])) :: var_5_842)) :: []),(var_6_843),(var_7_844),(var_8_845),(var_9_846),(var_10_847),(var_11_848),(var_12_849)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e24) config (-1))) in match e with 
| [Bottom] -> (stepElt 0)
| ((Map (SortStateCellMap,_,_) as var_13_850) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisValue((var_14_841 :: [])) config (-1))))) && (((compare var_4_840 var_4_839) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e24,(KApply9(Lbl'_LT_'state'_GT_',e24,(KApply1(Lbl'_LT_'k'_GT_',(var_5_842)) :: []),(var_6_843),(var_7_844),(var_8_845),(var_9_846),(var_10_847),(var_11_848),(var_12_849)) :: [])) config (-1))),(var_13_850 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 0))| _ -> (stepElt 0))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(`#blockend_BLOCK`(.KList)~>V~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(V~>`#blockend_BLOCK`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isValue(V)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(18) org.kframework.attributes.Location(Location(18,6,18,44)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_851) as e25 when guard < 1 -> (let e = ((evalMap'Coln'lookup((var_0_835),e25) config (-1))) in match e with 
| [Bottom] -> (stepElt 1)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_852),(KApply1(Lbl'_LT_'k'_GT_',(var_5_853 :: KApply0(Lbl'Hash'blockend_BLOCK) :: var_6_854)) :: []),(var_7_855),(var_8_856),(var_9_857),(var_10_858),(var_11_859),(var_12_860),(var_13_861)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e25) config (-1))) in match e with 
| [Bottom] -> (stepElt 1)
| ((Map (SortStateCellMap,_,_) as var_14_862) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisValue((var_5_853 :: [])) config (-1))))) && (((compare var_4_851 var_4_852) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e25,(KApply9(Lbl'_LT_'state'_GT_',e25,(KApply1(Lbl'_LT_'k'_GT_',(const'Hash'blockend_BLOCK :: var_5_853 :: var_6_854)) :: []),(var_7_855),(var_8_856),(var_9_857),(var_10_858),(var_11_859),(var_12_860),(var_13_861)) :: [])) config (-1))),(var_14_862 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 1))| _ -> (stepElt 1))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#FnCall(F,Es)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(#FnCall(F,Es))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExps(Es),isId(F))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(42) org.kframework.attributes.Location(Location(42,6,42,55)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_863) as e26 when guard < 2 -> (let e = ((evalMap'Coln'lookup((var_0_835),e26) config (-1))) in match e with 
| [Bottom] -> (stepElt 2)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_864),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(KApply2(Lbl'Hash'FnCall,(var_5_865 :: []),(var_6_866 :: [])) :: [])) :: var_7_867)) :: []),(var_8_868),(var_9_869),(var_10_870),(var_11_871),(var_12_872),(var_13_873),(var_14_874)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e26) config (-1))) in match e with 
| [Bottom] -> (stepElt 2)
| ((Map (SortStateCellMap,_,_) as var_15_875) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExps((var_6_866 :: [])) config (-1)))) && ((isTrue (evalisId((var_5_865 :: [])) config (-1))))))) && (((compare var_4_863 var_4_864) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e26,(KApply9(Lbl'_LT_'state'_GT_',e26,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'FnCall,(var_5_865 :: []),(var_6_866 :: [])) :: var_7_867)) :: []),(var_8_868),(var_9_869),(var_10_870),(var_11_871),(var_12_872),(var_13_873),(var_14_874)) :: [])) config (-1))),(var_15_875 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 2))| _ -> (stepElt 2))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferMB(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,#rs(PS)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(#ref(F),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(#rs(PS),`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(F),isProps(PS)),isInt(L)),#inProps(`mut_OSL-SYNTAX`(.KList),PS))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(135) org.kframework.attributes.Location(Location(135,6,137,32)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_876) as e27 when guard < 3 -> (let e = ((evalMap'Coln'lookup((var_0_835),e27) config (-1))) in match e with 
| [Bottom] -> (stepElt 3)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_877),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'ref,((Int _ as var_5_878) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_879) :: [])) :: [])) :: var_7_880)) :: []),(var_8_881),(KApply1(Lbl'_LT_'store'_GT_',(var_17_882)) :: []),(var_11_883),(var_12_884),(var_13_885),(var_14_886),(var_15_887)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_17_882),(var_5_878 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 3)
| ((Map (SortMap,_,_) as var_10_888) :: []) -> (let e = ((evalMap'Coln'lookup((var_17_882),(var_5_878 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 3)
| (KApply1(Lbl'Hash'rs,(var_9_889 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e27) config (-1))) in match e with 
| [Bottom] -> (stepElt 3)
| ((Map (SortStateCellMap,_,_) as var_16_890) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && ((isTrue (evalisProps((var_9_889 :: [])) config (-1)))))) && (true))) && ((isTrue (eval'Hash'inProps((constmut_OSL'Hyph'SYNTAX :: []),(var_9_889 :: [])) config (-1))))))) && (((compare var_4_876 var_4_877) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e27,(KApply9(Lbl'_LT_'state'_GT_',e27,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferMB,(KApply1(Lbl'Hash'loc,(var_5_878 :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_879 :: [])) :: [])) :: var_7_880)) :: []),(var_8_881),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_878 :: []),(KApply1(Lbl'Hash'rs,(var_9_889 :: [])) :: [])) config (-1))),(var_10_888 :: [])) config (-1)))) :: []),(var_11_883),(var_12_884),(var_13_885),(var_14_886),(var_15_887)) :: [])) config (-1))),(var_16_890 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 3))| _ -> (stepElt 3))| _ -> (stepElt 3))| _ -> (stepElt 3))
(*{| rule `<T>`(`<states>`(``_6=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#loc(L1)~>DotVar3),_1,`<store>`(`_[_<-_]_MAP`(Rho,L,#br(BEG,TIMER,#immRef(L1)))),_2,`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(C,_52)))),DotVar1)``),_3,_4,_5) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_6),#match(`<state>`(_0,`<k>`(#borrowImmCK(L,BEG,END,L1)~>DotVar3),_1,`<store>`(Rho),_2,`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(C,_52))),`Map:lookup`(_6,_0))),#match(DotVar1,`_[_<-undef]`(_6,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(TIMER),isSet(WRITE)),isBool(UNSAFE_BLOCK)),isInt(_52)),isInt(C)),isInt(END)),isInt(BEG)),isMap(Rho)),isInt(L)),isInt(L1)),`_orBool__BOOL`(`_==Bool__BOOL`(UNSAFE_BLOCK,#token("true","Bool")),`_andBool_`(`_==Bool__BOOL`(#borrowimmck(L,Rho,BEG,TIMER,L1),#token("false","Bool")),#writeCK(L1,BEG,TIMER,WRITE))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(212) org.kframework.attributes.Location(Location(212,6,221,46)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_891) as e28 when guard < 4 -> (let e = ((evalMap'Coln'lookup((var_0_835),e28) config (-1))) in match e with 
| [Bottom] -> (stepElt 4)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_892),(KApply1(Lbl'_LT_'k'_GT_',(KApply4(Lbl'Hash'borrowImmCK,((Int _ as var_9_893) :: []),((Int _ as var_10_894) :: []),((Int _ as var_18_895) :: []),((Int _ as var_5_896) :: [])) :: var_6_897)) :: []),(var_7_898),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_8_899) :: [])) :: []),(var_12_900),(KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as var_13_901) :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_11_902) :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as var_14_903) :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_15_904) :: []),((Int _ as var_16_905) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e28) config (-1))) in match e with 
| [Bottom] -> (stepElt 4)
| ((Map (SortStateCellMap,_,_) as var_17_906) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsEqls'Bool__BOOL((var_14_903 :: []),((Bool true) :: [])) config (-1)))) || ((((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'borrowimmck((var_9_893 :: []),(var_8_899 :: []),(var_10_894 :: []),(var_11_902 :: []),(var_5_896 :: [])) config (-1))),((Bool false) :: [])) config (-1)))) && ((isTrue (eval'Hash'writeCK((var_5_896 :: []),(var_10_894 :: []),(var_11_902 :: []),(var_13_901 :: [])) config (-1))))))))))) && (((compare var_4_891 var_4_892) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e28,(KApply9(Lbl'_LT_'state'_GT_',e28,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loc,(var_5_896 :: [])) :: var_6_897)) :: []),(var_7_898),(KApply1(Lbl'_LT_'store'_GT_',((eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP((var_8_899 :: []),(var_9_893 :: []),(KApply3(Lbl'Hash'br,(var_10_894 :: []),(var_11_902 :: []),(KApply1(Lbl'Hash'immRef,(var_5_896 :: [])) :: [])) :: [])) config (-1)))) :: []),(var_12_900),(KApply1(Lbl'_LT_'write'_GT_',(var_13_901 :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_11_902 :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',(var_14_903 :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_15_904 :: []),(var_16_905 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_17_906 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 4))| _ -> (stepElt 4))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(V~>`#blockend_BLOCK`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(V~>Ss~>`#blockend_BLOCK`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isValue(V),isStmts(Ss))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(24) org.kframework.attributes.Location(Location(24,6,24,56)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_907) as e29 when guard < 5 -> (let e = ((evalMap'Coln'lookup((var_0_835),e29) config (-1))) in match e with 
| [Bottom] -> (stepElt 5)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_908),(KApply1(Lbl'_LT_'k'_GT_',(var_5_909 :: var_15_910 :: KApply0(Lbl'Hash'blockend_BLOCK) :: var_6_911)) :: []),(var_7_912),(var_8_913),(var_9_914),(var_10_915),(var_11_916),(var_12_917),(var_13_918)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e29) config (-1))) in match e with 
| [Bottom] -> (stepElt 5)
| ((Map (SortStateCellMap,_,_) as var_14_919) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisValue((var_5_909 :: [])) config (-1)))) && ((isTrue (evalisStmts((var_15_910 :: [])) config (-1))))))) && (((compare var_4_907 var_4_908) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e29,(KApply9(Lbl'_LT_'state'_GT_',e29,(KApply1(Lbl'_LT_'k'_GT_',(var_5_909 :: const'Hash'blockend_BLOCK :: var_6_911)) :: []),(var_7_912),(var_8_913),(var_9_914),(var_10_915),(var_11_916),(var_12_917),(var_13_918)) :: [])) config (-1))),(var_14_919 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 5))| _ -> (stepElt 5))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#rs(N)~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#rs(N)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#read(#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#rs(N),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(isProps(N),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(179) org.kframework.attributes.Location(Location(179,6,180,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_920) as e30 when guard < 6 -> (let e = ((evalMap'Coln'lookup((var_0_835),e30) config (-1))) in match e with 
| [Bottom] -> (stepElt 6)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_921),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,((Int _ as var_8_922) :: [])) :: [])) :: var_6_923)) :: []),(var_7_924),(KApply1(Lbl'_LT_'store'_GT_',(var_16_925)) :: []),(var_10_926),(var_11_927),(var_12_928),(var_13_929),(var_14_930)) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_925),(var_8_922 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 6)
| (KApply1(Lbl'Hash'rs,(var_5_931 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e30) config (-1))) in match e with 
| [Bottom] -> (stepElt 6)
| ((Map (SortStateCellMap,_,_) as var_15_932) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_925),(var_8_922 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 6)
| ((Map (SortMap,_,_) as var_9_933) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (evalisProps((var_5_931 :: [])) config (-1)))) && (true)))) && (((compare var_4_920 var_4_921) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e30,(KApply9(Lbl'_LT_'state'_GT_',e30,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'rs,(var_5_931 :: [])) :: var_6_923)) :: []),(var_7_924),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_8_922 :: []),(KApply1(Lbl'Hash'rs,(var_5_931 :: [])) :: [])) config (-1))),(var_9_933 :: [])) config (-1)))) :: []),(var_10_926),(var_11_927),(var_12_928),(var_13_929),(var_14_930)) :: [])) config (-1))),(var_15_932 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 6))| _ -> (stepElt 6))| _ -> (stepElt 6))| _ -> (stepElt 6))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Read(#borrowMutCK(L,BEG,END,L1))~>#loc(L1)~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#br(BEG,END,#mutRef(L1))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#read(#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#br(BEG,END,#mutRef(L1)),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(192) org.kframework.attributes.Location(Location(192,6,193,75)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_934) as e31 when guard < 7 -> (let e = ((evalMap'Coln'lookup((var_0_835),e31) config (-1))) in match e with 
| [Bottom] -> (stepElt 7)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_935),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,((Int _ as var_5_936) :: [])) :: [])) :: var_9_937)) :: []),(var_10_938),(KApply1(Lbl'_LT_'store'_GT_',(var_18_939)) :: []),(var_12_940),(var_13_941),(var_14_942),(var_15_943),(var_16_944)) :: []) -> (let e = ((evalMap'Coln'lookup((var_18_939),(var_5_936 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 7)
| (KApply3(Lbl'Hash'br,((Int _ as var_6_945) :: []),((Int _ as var_7_946) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_8_947) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e31) config (-1))) in match e with 
| [Bottom] -> (stepElt 7)
| ((Map (SortStateCellMap,_,_) as var_17_948) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_18_939),(var_5_936 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 7)
| ((Map (SortMap,_,_) as var_11_949) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && (true))) && (true))) && (true)))) && (((compare var_4_935 var_4_934) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e31,(KApply9(Lbl'_LT_'state'_GT_',e31,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(KApply4(Lbl'Hash'borrowMutCK,(var_5_936 :: []),(var_6_945 :: []),(var_7_946 :: []),(var_8_947 :: [])) :: [])) :: KApply1(Lbl'Hash'loc,(var_8_947 :: [])) :: var_9_937)) :: []),(var_10_938),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_936 :: []),(KApply3(Lbl'Hash'br,(var_6_945 :: []),(var_7_946 :: []),(KApply1(Lbl'Hash'mutRef,(var_8_947 :: [])) :: [])) :: [])) config (-1))),(var_11_949 :: [])) config (-1)))) :: []),(var_12_940),(var_13_941),(var_14_942),(var_15_943),(var_16_944)) :: [])) config (-1))),(var_17_948 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 7))| _ -> (stepElt 7))| _ -> (stepElt 7))| _ -> (stepElt 7))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#Transfer1_`(K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(HOLE,K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isExp(HOLE),isExp(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#Transfer) org.kframework.attributes.Location(Location(36,12,36,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1920907467) strict()]|}*)
| (var_4_950) as e32 when guard < 8 -> (let e = ((evalMap'Coln'lookup((var_0_835),e32) config (-1))) in match e with 
| [Bottom] -> (stepElt 8)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_951),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(var_5_952 :: []),(var_6_953 :: [])) :: var_7_954)) :: []),(var_8_955),(var_9_956),(var_10_957),(var_11_958),(var_12_959),(var_13_960),(var_14_961)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e32) config (-1))) in match e with 
| [Bottom] -> (stepElt 8)
| ((Map (SortStateCellMap,_,_) as var_15_962) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisExp((var_5_952 :: [])) config (-1)))) && ((isTrue (evalisExp((var_6_953 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((var_5_952 :: [])) config (-1))))))))))) && (((compare var_4_950 var_4_951) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e32,(KApply9(Lbl'_LT_'state'_GT_',e32,(KApply1(Lbl'_LT_'k'_GT_',(var_5_952 :: KApply1(Lbl'Hash'freezer'Hash'Transfer1_,(var_6_953 :: [])) :: var_7_954)) :: []),(var_8_955),(var_9_956),(var_10_957),(var_11_958),(var_12_959),(var_13_960),(var_14_961)) :: [])) config (-1))),(var_15_962 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 8))| _ -> (stepElt 8))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#lvDref0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lvDref(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#lvDref) org.kframework.attributes.Location(Location(253,12,253,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1932332324) strict()]|}*)
| (var_4_963) as e33 when guard < 9 -> (let e = ((evalMap'Coln'lookup((var_0_835),e33) config (-1))) in match e with 
| [Bottom] -> (stepElt 9)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_964),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lvDref,(var_5_965 :: [])) :: var_6_966)) :: []),(var_7_967),(var_8_968),(var_9_969),(var_10_970),(var_11_971),(var_12_972),(var_13_973)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e33) config (-1))) in match e with 
| [Bottom] -> (stepElt 9)
| ((Map (SortStateCellMap,_,_) as var_14_974) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_965 :: [])) config (-1)))) && (((true) && ((not ((isTrue (evalisKResult((var_5_965 :: [])) config (-1))))))))))) && (((compare var_4_964 var_4_963) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e33,(KApply9(Lbl'_LT_'state'_GT_',e33,(KApply1(Lbl'_LT_'k'_GT_',(var_5_965 :: const'Hash'freezer'Hash'lvDref0_ :: var_6_966)) :: []),(var_7_967),(var_8_968),(var_9_969),(var_10_970),(var_11_971),(var_12_972),(var_13_973)) :: [])) config (-1))),(var_14_974 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 9))| _ -> (stepElt 9))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Transfer(#rs(PS),#loc(L))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,`#uninit_OSL-SYNTAX`(.KList)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#TransferV(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(#rs(PS),`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(F),isProps(PS)),isInt(L)),`notBool_`(#inProps(`copy_OSL-SYNTAX`(.KList),PS)))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(139) org.kframework.attributes.Location(Location(139,6,141,41)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_975) as e34 when guard < 10 -> (let e = ((evalMap'Coln'lookup((var_0_835),e34) config (-1))) in match e with 
| [Bottom] -> (stepElt 10)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_976),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferV,(KApply1(Lbl'Hash'loc,((Int _ as var_9_977) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_978) :: [])) :: [])) :: var_7_979)) :: []),(var_8_980),(KApply1(Lbl'_LT_'store'_GT_',(var_17_981)) :: []),(var_11_982),(var_12_983),(var_13_984),(var_14_985),(var_15_986)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_17_981),(var_9_977 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 10)
| ((Map (SortMap,_,_) as var_10_987) :: []) -> (let e = ((evalMap'Coln'lookup((var_17_981),(var_9_977 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 10)
| (KApply1(Lbl'Hash'rs,(var_5_988 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e34) config (-1))) in match e with 
| [Bottom] -> (stepElt 10)
| ((Map (SortStateCellMap,_,_) as var_16_989) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && ((isTrue (evalisProps((var_5_988 :: [])) config (-1)))))) && (true))) && ((not ((isTrue (eval'Hash'inProps((constcopy_OSL'Hyph'SYNTAX :: []),(var_5_988 :: [])) config (-1))))))))) && (((compare var_4_975 var_4_976) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e34,(KApply9(Lbl'_LT_'state'_GT_',e34,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'rs,(var_5_988 :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_978 :: [])) :: [])) :: var_7_979)) :: []),(var_8_980),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_9_977 :: []),(const'Hash'uninit_OSL'Hyph'SYNTAX :: [])) config (-1))),(var_10_987 :: [])) config (-1)))) :: []),(var_11_982),(var_12_983),(var_13_984),(var_14_985),(var_15_986)) :: [])) config (-1))),(var_16_989 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 10))| _ -> (stepElt 10))| _ -> (stepElt 10))| _ -> (stepElt 10))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#secondBranch(Bs)~>B~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#branch(B,Bs)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isBlocks(Bs),isBlock(B))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(12) org.kframework.attributes.Location(Location(12,6,12,59)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_4_990) as e35 when guard < 11 -> (let e = ((evalMap'Coln'lookup((var_0_835),e35) config (-1))) in match e with 
| [Bottom] -> (stepElt 11)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_991),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'branch,(var_6_992 :: []),(var_5_993 :: [])) :: var_7_994)) :: []),(var_8_995),(var_9_996),(var_10_997),(var_11_998),(var_12_999),(var_13_1000),(var_14_1001)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e35) config (-1))) in match e with 
| [Bottom] -> (stepElt 11)
| ((Map (SortStateCellMap,_,_) as var_15_1002) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisBlocks((var_5_993 :: [])) config (-1)))) && ((isTrue (evalisBlock((var_6_992 :: [])) config (-1))))))) && (((compare var_4_990 var_4_991) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e35,(KApply9(Lbl'_LT_'state'_GT_',e35,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'secondBranch,(var_5_993 :: [])) :: var_6_992 :: var_7_994)) :: []),(var_8_995),(var_9_996),(var_10_997),(var_11_998),(var_12_999),(var_13_1000),(var_14_1001)) :: [])) config (-1))),(var_15_1002 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 11))| _ -> (stepElt 11))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#lvDref(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#lvDref0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#lvDref) org.kframework.attributes.Location(Location(253,12,253,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1932332324) strict()]|}*)
| (var_4_1003) as e36 when guard < 12 -> (let e = ((evalMap'Coln'lookup((var_0_835),e36) config (-1))) in match e with 
| [Bottom] -> (stepElt 12)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1004),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1005 :: KApply0(Lbl'Hash'freezer'Hash'lvDref0_) :: var_6_1006)) :: []),(var_7_1007),(var_8_1008),(var_9_1009),(var_10_1010),(var_11_1011),(var_12_1012),(var_13_1013)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e36) config (-1))) in match e with 
| [Bottom] -> (stepElt 12)
| ((Map (SortStateCellMap,_,_) as var_14_1014) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1005 :: [])) config (-1)))) && (((true) && ((isTrue (evalisKResult((var_5_1005 :: [])) config (-1))))))))) && (((compare var_4_1004 var_4_1003) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e36,(KApply9(Lbl'_LT_'state'_GT_',e36,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lvDref,(var_5_1005 :: [])) :: var_6_1006)) :: []),(var_7_1007),(var_8_1008),(var_9_1009),(var_10_1010),(var_11_1011),(var_12_1012),(var_13_1013)) :: [])) config (-1))),(var_14_1014 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 12))| _ -> (stepElt 12))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#rs(Ps)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(`newResource(_)_OSL-SYNTAX`(Ps)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isProps(Ps)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(18) org.kframework.attributes.Location(Location(18,6,18,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1015) as e37 when guard < 13 -> (let e = ((evalMap'Coln'lookup((var_0_835),e37) config (-1))) in match e with 
| [Bottom] -> (stepElt 13)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1016),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(LblnewResource'LPar'_'RPar'_OSL'Hyph'SYNTAX,(var_5_1017 :: [])) :: var_6_1018)) :: []),(var_7_1019),(var_8_1020),(var_9_1021),(var_10_1022),(var_11_1023),(var_12_1024),(var_13_1025)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e37) config (-1))) in match e with 
| [Bottom] -> (stepElt 13)
| ((Map (SortStateCellMap,_,_) as var_14_1026) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisProps((var_5_1017 :: [])) config (-1))))) && (((compare var_4_1016 var_4_1015) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e37,(KApply9(Lbl'_LT_'state'_GT_',e37,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'rs,(var_5_1017 :: [])) :: var_6_1018)) :: []),(var_7_1019),(var_8_1020),(var_9_1021),(var_10_1022),(var_11_1023),(var_12_1024),(var_13_1025)) :: [])) config (-1))),(var_14_1026 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 13))| _ -> (stepElt 13))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Read(#rs(R))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isProps(R)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(190) org.kframework.attributes.Location(Location(190,6,190,30)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1027) as e38 when guard < 14 -> (let e = ((evalMap'Coln'lookup((var_0_835),e38) config (-1))) in match e with 
| [Bottom] -> (stepElt 14)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1028),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(KApply1(Lbl'Hash'rs,(var_14_1029 :: [])) :: [])) :: var_5_1030)) :: []),(var_6_1031),(var_7_1032),(var_8_1033),(var_9_1034),(var_10_1035),(var_11_1036),(var_12_1037)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e38) config (-1))) in match e with 
| [Bottom] -> (stepElt 14)
| ((Map (SortStateCellMap,_,_) as var_13_1038) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisProps((var_14_1029 :: [])) config (-1))))) && (((compare var_4_1027 var_4_1028) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e38,(KApply9(Lbl'_LT_'state'_GT_',e38,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1030)) :: []),(var_6_1031),(var_7_1032),(var_8_1033),(var_9_1034),(var_10_1035),(var_11_1036),(var_12_1037)) :: [])) config (-1))),(var_13_1038 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 14))| _ -> (stepElt 14))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Transfer(#rs(R),#loc(MR))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#br(_34,_35,#mutRef(MR))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(#rs(R),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#br(_34,_35,#mutRef(MR)),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProps(R),isInt(_35)),isInt(_34)),isInt(L)),isInt(MR))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(122) org.kframework.attributes.Location(Location(122,6,123,59)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1039) as e39 when guard < 15 -> (let e = ((evalMap'Coln'lookup((var_0_835),e39) config (-1))) in match e with 
| [Bottom] -> (stepElt 15)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1040),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'rs,(var_5_1041 :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_9_1042) :: [])) :: [])) :: var_7_1043)) :: []),(var_8_1044),(KApply1(Lbl'_LT_'store'_GT_',(var_19_1045)) :: []),(var_13_1046),(var_14_1047),(var_15_1048),(var_16_1049),(var_17_1050)) :: []) -> (let e = ((evalMap'Coln'lookup((var_19_1045),(var_9_1042 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 15)
| (KApply3(Lbl'Hash'br,((Int _ as var_10_1051) :: []),((Int _ as var_11_1052) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_6_1053) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e39) config (-1))) in match e with 
| [Bottom] -> (stepElt 15)
| ((Map (SortStateCellMap,_,_) as var_18_1054) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_19_1045),(var_9_1042 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 15)
| ((Map (SortMap,_,_) as var_12_1055) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((((((((isTrue (evalisProps((var_5_1041 :: [])) config (-1)))) && (true))) && (true))) && (true))) && (true)))) && (((compare var_4_1040 var_4_1039) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e39,(KApply9(Lbl'_LT_'state'_GT_',e39,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'rs,(var_5_1041 :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_1053 :: [])) :: [])) :: var_7_1043)) :: []),(var_8_1044),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_9_1042 :: []),(KApply3(Lbl'Hash'br,(var_10_1051 :: []),(var_11_1052 :: []),(KApply1(Lbl'Hash'mutRef,(var_6_1053 :: [])) :: [])) :: [])) config (-1))),(var_12_1055 :: [])) config (-1)))) :: []),(var_13_1046),(var_14_1047),(var_15_1048),(var_16_1049),(var_17_1050)) :: [])) config (-1))),(var_18_1054 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 15))| _ -> (stepElt 15))| _ -> (stepElt 15))| _ -> (stepElt 15))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferMB(#read(#loc(F)),#loc(L))~>#uninitialize(#loc(F))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,#br(BEG,END,#mutRef(L1))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#TransferV(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(#br(BEG,END,#mutRef(L1)),`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isInt(F)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(156) org.kframework.attributes.Location(Location(156,6,159,61)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1056) as e40 when guard < 16 -> (let e = ((evalMap'Coln'lookup((var_0_835),e40) config (-1))) in match e with 
| [Bottom] -> (stepElt 16)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1057),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferV,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1058) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_1059) :: [])) :: [])) :: var_7_1060)) :: []),(var_8_1061),(KApply1(Lbl'_LT_'store'_GT_',(var_19_1062)) :: []),(var_13_1063),(var_14_1064),(var_15_1065),(var_16_1066),(var_17_1067)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_19_1062),(var_5_1058 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 16)
| ((Map (SortMap,_,_) as var_12_1068) :: []) -> (let e = ((evalMap'Coln'lookup((var_19_1062),(var_5_1058 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 16)
| (KApply3(Lbl'Hash'br,((Int _ as var_9_1069) :: []),((Int _ as var_10_1070) :: []),(KApply1(Lbl'Hash'mutRef,((Int _ as var_11_1071) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e40) config (-1))) in match e with 
| [Bottom] -> (stepElt 16)
| ((Map (SortStateCellMap,_,_) as var_18_1072) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((((true) && (true))) && (true))) && (true))) && (true)))) && (((compare var_4_1056 var_4_1057) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e40,(KApply9(Lbl'_LT_'state'_GT_',e40,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferMB,(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,(var_5_1058 :: [])) :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_1059 :: [])) :: [])) :: KApply1(Lbl'Hash'uninitialize,(KApply1(Lbl'Hash'loc,(var_5_1058 :: [])) :: [])) :: var_7_1060)) :: []),(var_8_1061),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_1058 :: []),(KApply3(Lbl'Hash'br,(var_9_1069 :: []),(var_10_1070 :: []),(KApply1(Lbl'Hash'mutRef,(var_11_1071 :: [])) :: [])) :: [])) config (-1))),(var_12_1068 :: [])) config (-1)))) :: []),(var_13_1063),(var_14_1064),(var_15_1065),(var_16_1066),(var_17_1067)) :: [])) config (-1))),(var_18_1072 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 16))| _ -> (stepElt 16))| _ -> (stepElt 16))| _ -> (stepElt 16))
(*{| rule `<T>`(`<states>`(``_7=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),`<env>`(ENV),`<store>`(`_[_<-_]_MAP`(ST,#unwrapInt(`Map:lookup`(ENV,X)),#br(C,C,#mutRef(#unwrapInt(`Map:lookup`(ENV,Y)))))),_1,_2,`<timer>`(`_+Int__INT`(TIMER,#token("1","Int"))),_3,`<indexes>`(#indexes(`_+Int__INT`(C,#token("1","Int")),_44)))),DotVar1)``),_4,_5,_6) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_7),#match(`<state>`(_0,`<k>`(#mborrow(X,Y)~>DotVar3),`<env>`(ENV),`<store>`(ST),_1,_2,`<timer>`(TIMER),_3,`<indexes>`(#indexes(C,_44))),`Map:lookup`(_7,_0))),#match(DotVar1,`_[_<-undef]`(_7,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(TIMER),isInt(C)),isMap(ENV)),isId(X)),isInt(_44)),isId(Y)),isMap(ST)),`_andBool_`(#checkInit(Y,ENV,ST),#isOwnerHasMutProp(`Map:lookup`(ST,#unwrapInt(`Map:lookup`(ENV,Y))))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(374) org.kframework.attributes.Location(Location(374,6,379,86)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1073) as e41 when guard < 17 -> (let e = ((evalMap'Coln'lookup((var_0_835),e41) config (-1))) in match e with 
| [Bottom] -> (stepElt 17)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1074),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'mborrow,(var_8_1075 :: []),(var_10_1076 :: [])) :: var_5_1077)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_6_1078) :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_7_1079) :: [])) :: []),(var_11_1080),(var_12_1081),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_13_1082) :: [])) :: []),(var_14_1083),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_9_1084) :: []),((Int _ as var_15_1085) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e41) config (-1))) in match e with 
| [Bottom] -> (stepElt 17)
| ((Map (SortStateCellMap,_,_) as var_16_1086) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((true) && (true))) && (true))) && ((isTrue (evalisId((var_8_1075 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisId((var_10_1076 :: [])) config (-1)))))) && (true))) && ((((isTrue (eval'Hash'checkInit((var_10_1076 :: []),(var_6_1078 :: []),(var_7_1079 :: [])) config (-1)))) && ((isTrue (eval'Hash'isOwnerHasMutProp(((evalMap'Coln'lookup((var_7_1079 :: []),((eval'Hash'unwrapInt(((evalMap'Coln'lookup((var_6_1078 :: []),(var_10_1076 :: [])) config (-1)))) config (-1)))) config (-1)))) config (-1))))))))) && (((compare var_4_1074 var_4_1073) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e41,(KApply9(Lbl'_LT_'state'_GT_',e41,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1077)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_6_1078 :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',((eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP((var_7_1079 :: []),((eval'Hash'unwrapInt(((evalMap'Coln'lookup((var_6_1078 :: []),(var_8_1075 :: [])) config (-1)))) config (-1))),(KApply3(Lbl'Hash'br,(var_9_1084 :: []),(var_9_1084 :: []),(KApply1(Lbl'Hash'mutRef,((eval'Hash'unwrapInt(((evalMap'Coln'lookup((var_6_1078 :: []),(var_10_1076 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) config (-1)))) :: []),(var_11_1080),(var_12_1081),(KApply1(Lbl'_LT_'timer'_GT_',((eval_'Plus'Int__INT((var_13_1082 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_14_1083),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((eval_'Plus'Int__INT((var_9_1084 :: []),((Lazy.force int1) :: [])) config (-1))),(var_15_1085 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_16_1086 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 17))| _ -> (stepElt 17))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(Ss~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#evaluate(#block(Ss))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isStmts(Ss)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(109) org.kframework.attributes.Location(Location(109,6,109,39)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_4_1087) as e42 when guard < 18 -> (let e = ((evalMap'Coln'lookup((var_0_835),e42) config (-1))) in match e with 
| [Bottom] -> (stepElt 18)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1088),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'evaluate,(KApply1(Lbl'Hash'block,(var_5_1089 :: [])) :: [])) :: var_6_1090)) :: []),(var_7_1091),(var_8_1092),(var_9_1093),(var_10_1094),(var_11_1095),(var_12_1096),(var_13_1097)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e42) config (-1))) in match e with 
| [Bottom] -> (stepElt 18)
| ((Map (SortStateCellMap,_,_) as var_14_1098) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisStmts((var_5_1089 :: [])) config (-1))))) && (((compare var_4_1088 var_4_1087) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e42,(KApply9(Lbl'_LT_'state'_GT_',e42,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1089 :: var_6_1090)) :: []),(var_7_1091),(var_8_1092),(var_9_1093),(var_10_1094),(var_11_1095),(var_12_1096),(var_13_1097)) :: [])) config (-1))),(var_14_1098 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 18))| _ -> (stepElt 18))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(S~>Ss~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(`___OSL-SYNTAX`(S,Ss)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isStmts(Ss),isStmt(S))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(20) org.kframework.attributes.Location(Location(20,6,20,32)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1099) as e43 when guard < 19 -> (let e = ((evalMap'Coln'lookup((var_0_835),e43) config (-1))) in match e with 
| [Bottom] -> (stepElt 19)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1100),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl___OSL'Hyph'SYNTAX,(var_5_1101 :: []),(var_6_1102 :: [])) :: var_7_1103)) :: []),(var_8_1104),(var_9_1105),(var_10_1106),(var_11_1107),(var_12_1108),(var_13_1109),(var_14_1110)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e43) config (-1))) in match e with 
| [Bottom] -> (stepElt 19)
| ((Map (SortStateCellMap,_,_) as var_15_1111) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisStmts((var_6_1102 :: [])) config (-1)))) && ((isTrue (evalisStmt((var_5_1101 :: [])) config (-1))))))) && (((compare var_4_1100 var_4_1099) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e43,(KApply9(Lbl'_LT_'state'_GT_',e43,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1101 :: var_6_1102 :: var_7_1103)) :: []),(var_8_1104),(var_9_1105),(var_10_1106),(var_11_1107),(var_12_1108),(var_13_1109),(var_14_1110)) :: [])) config (-1))),(var_15_1111 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 19))| _ -> (stepElt 19))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,`<store>`(`_Map_`(`_|->_`(I,`#uninit_OSL-SYNTAX`(.KList)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Deallocate(#loc(I))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,I))),#match(#rs(_45),`Map:lookup`(_10,I))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isInt(I),isProps(_45))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(401) org.kframework.attributes.Location(Location(401,6,402,63)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1112) as e44 when guard < 20 -> (let e = ((evalMap'Coln'lookup((var_0_835),e44) config (-1))) in match e with 
| [Bottom] -> (stepElt 20)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1113),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Deallocate,(KApply1(Lbl'Hash'loc,((Int _ as var_7_1114) :: [])) :: [])) :: var_5_1115)) :: []),(var_6_1116),(KApply1(Lbl'_LT_'store'_GT_',(var_15_1117)) :: []),(var_9_1118),(var_10_1119),(var_11_1120),(var_12_1121),(var_13_1122)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_15_1117),(var_7_1114 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 20)
| ((Map (SortMap,_,_) as var_8_1123) :: []) -> (let e = ((evalMap'Coln'lookup((var_15_1117),(var_7_1114 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 20)
| (KApply1(Lbl'Hash'rs,(var_16_1124 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e44) config (-1))) in match e with 
| [Bottom] -> (stepElt 20)
| ((Map (SortStateCellMap,_,_) as var_14_1125) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((true) && ((isTrue (evalisProps((var_16_1124 :: [])) config (-1))))))) && (((compare var_4_1113 var_4_1112) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e44,(KApply9(Lbl'_LT_'state'_GT_',e44,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1115)) :: []),(var_6_1116),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1114 :: []),(const'Hash'uninit_OSL'Hyph'SYNTAX :: [])) config (-1))),(var_8_1123 :: [])) config (-1)))) :: []),(var_9_1118),(var_10_1119),(var_11_1120),(var_12_1121),(var_13_1122)) :: [])) config (-1))),(var_14_1125 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 20))| _ -> (stepElt 20))| _ -> (stepElt 20))| _ -> (stepElt 20))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#lv(X)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(#read(X))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isExp(X)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(47) org.kframework.attributes.Location(Location(47,6,47,26)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1126) as e45 when guard < 21 -> (let e = ((evalMap'Coln'lookup((var_0_835),e45) config (-1))) in match e with 
| [Bottom] -> (stepElt 21)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1127),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(KApply1(Lbl'Hash'read,(var_5_1128 :: [])) :: [])) :: var_6_1129)) :: []),(var_7_1130),(var_8_1131),(var_9_1132),(var_10_1133),(var_11_1134),(var_12_1135),(var_13_1136)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e45) config (-1))) in match e with 
| [Bottom] -> (stepElt 21)
| ((Map (SortStateCellMap,_,_) as var_14_1137) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisExp((var_5_1128 :: [])) config (-1))))) && (((compare var_4_1126 var_4_1127) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e45,(KApply9(Lbl'_LT_'state'_GT_',e45,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(var_5_1128 :: [])) :: var_6_1129)) :: []),(var_7_1130),(var_8_1131),(var_9_1132),(var_10_1133),(var_11_1134),(var_12_1135),(var_13_1136)) :: [])) config (-1))),(var_14_1137 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 21))| _ -> (stepElt 21))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#loopEnd(I)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(V~>Rest~>#loopEnd(I)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isValue(V),isInt(I)),isStmts(Rest))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(135) org.kframework.attributes.Location(Location(135,6,135,57)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_4_1138) as e46 when guard < 22 -> (let e = ((evalMap'Coln'lookup((var_0_835),e46) config (-1))) in match e with 
| [Bottom] -> (stepElt 22)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1139),(KApply1(Lbl'_LT_'k'_GT_',(var_15_1140 :: var_16_1141 :: KApply1(Lbl'Hash'loopEnd,((Int _ as var_5_1142) :: [])) :: var_6_1143)) :: []),(var_7_1144),(var_8_1145),(var_9_1146),(var_10_1147),(var_11_1148),(var_12_1149),(var_13_1150)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e46) config (-1))) in match e with 
| [Bottom] -> (stepElt 22)
| ((Map (SortStateCellMap,_,_) as var_14_1151) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisValue((var_15_1140 :: [])) config (-1)))) && (true))) && ((isTrue (evalisStmts((var_16_1141 :: [])) config (-1))))))) && (((compare var_4_1139 var_4_1138) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e46,(KApply9(Lbl'_LT_'state'_GT_',e46,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loopEnd,(var_5_1142 :: [])) :: var_6_1143)) :: []),(var_7_1144),(var_8_1145),(var_9_1146),(var_10_1147),(var_11_1148),(var_12_1149),(var_13_1150)) :: [])) config (-1))),(var_14_1151 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 22))| _ -> (stepElt 22))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#expStmt0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#expStmt(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#expStmt) org.kframework.attributes.Location(Location(51,12,51,73)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/osl-syntax.k)) productionID(1225568095) strict()]|}*)
| (var_4_1152) as e47 when guard < 23 -> (let e = ((evalMap'Coln'lookup((var_0_835),e47) config (-1))) in match e with 
| [Bottom] -> (stepElt 23)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1153),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'expStmt,(var_5_1154 :: [])) :: var_6_1155)) :: []),(var_7_1156),(var_8_1157),(var_9_1158),(var_10_1159),(var_11_1160),(var_12_1161),(var_13_1162)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e47) config (-1))) in match e with 
| [Bottom] -> (stepElt 23)
| ((Map (SortStateCellMap,_,_) as var_14_1163) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1154 :: [])) config (-1)))) && (((true) && ((not ((isTrue (evalisKResult((var_5_1154 :: [])) config (-1))))))))))) && (((compare var_4_1153 var_4_1152) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e47,(KApply9(Lbl'_LT_'state'_GT_',e47,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1154 :: const'Hash'freezer'Hash'expStmt0_ :: var_6_1155)) :: []),(var_7_1156),(var_8_1157),(var_9_1158),(var_10_1159),(var_11_1160),(var_12_1161),(var_13_1162)) :: [])) config (-1))),(var_14_1163 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 23))| _ -> (stepElt 23))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Deallocate(#lv(E))~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#deallocate(E)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isExp(E)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(393) org.kframework.attributes.Location(Location(393,6,393,47)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1164) as e48 when guard < 24 -> (let e = ((evalMap'Coln'lookup((var_0_835),e48) config (-1))) in match e with 
| [Bottom] -> (stepElt 24)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1165),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'deallocate,(var_5_1166 :: [])) :: var_6_1167)) :: []),(var_7_1168),(var_8_1169),(var_9_1170),(var_10_1171),(var_11_1172),(var_12_1173),(var_13_1174)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e48) config (-1))) in match e with 
| [Bottom] -> (stepElt 24)
| ((Map (SortStateCellMap,_,_) as var_14_1175) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisExp((var_5_1166 :: [])) config (-1))))) && (((compare var_4_1165 var_4_1164) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e48,(KApply9(Lbl'_LT_'state'_GT_',e48,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Deallocate,(KApply1(Lbl'Hash'lv,(var_5_1166 :: [])) :: [])) :: var_6_1167)) :: []),(var_7_1168),(var_8_1169),(var_9_1170),(var_10_1171),(var_11_1172),(var_12_1173),(var_13_1174)) :: [])) config (-1))),(var_14_1175 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 24))| _ -> (stepElt 24))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#TransferIB1_`(K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#TransferIB(HOLE,K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isK(HOLE),isK(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#TransferIB) org.kframework.attributes.Location(Location(149,12,149,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(376635015) strict(1)]|}*)
| (var_4_1176) as e49 when guard < 25 -> (let e = ((evalMap'Coln'lookup((var_0_835),e49) config (-1))) in match e with 
| [Bottom] -> (stepElt 25)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1177),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferIB,(var_5_1178),(var_6_1179)) :: var_7_1180)) :: []),(var_8_1181),(var_9_1182),(var_10_1183),(var_11_1184),(var_12_1185),(var_13_1186),(var_14_1187)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e49) config (-1))) in match e with 
| [Bottom] -> (stepElt 25)
| ((Map (SortStateCellMap,_,_) as var_15_1188) :: []) when ((((((true) && (true))) && (true))) && (((((true) && (true))) && (((true) && ((not ((isTrue (evalisKResult((var_5_1178)) config (-1))))))))))) && (((compare var_4_1177 var_4_1176) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e49,(KApply9(Lbl'_LT_'state'_GT_',e49,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1178 @ KApply1(Lbl'Hash'freezer'Hash'TransferIB1_,(var_6_1179)) :: var_7_1180)) :: []),(var_8_1181),(var_9_1182),(var_10_1183),(var_11_1184),(var_12_1185),(var_13_1186),(var_14_1187)) :: [])) config (-1))),(var_15_1188 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 25))| _ -> (stepElt 25))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Transfer(HOLE,K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#Transfer1_`(K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isExp(HOLE),isExp(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#Transfer) org.kframework.attributes.Location(Location(36,12,36,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1920907467) strict()]|}*)
| (var_4_1189) as e50 when guard < 26 -> (let e = ((evalMap'Coln'lookup((var_0_835),e50) config (-1))) in match e with 
| [Bottom] -> (stepElt 26)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1190),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1191 :: KApply1(Lbl'Hash'freezer'Hash'Transfer1_,(var_6_1192 :: [])) :: var_7_1193)) :: []),(var_8_1194),(var_9_1195),(var_10_1196),(var_11_1197),(var_12_1198),(var_13_1199),(var_14_1200)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e50) config (-1))) in match e with 
| [Bottom] -> (stepElt 26)
| ((Map (SortStateCellMap,_,_) as var_15_1201) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisExp((var_5_1191 :: [])) config (-1)))) && ((isTrue (evalisExp((var_6_1192 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((var_5_1191 :: [])) config (-1))))))))) && (((compare var_4_1190 var_4_1189) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e50,(KApply9(Lbl'_LT_'state'_GT_',e50,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(var_5_1191 :: []),(var_6_1192 :: [])) :: var_7_1193)) :: []),(var_8_1194),(var_9_1195),(var_10_1196),(var_11_1197),(var_12_1198),(var_13_1199),(var_14_1200)) :: [])) config (-1))),(var_15_1201 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 26))| _ -> (stepElt 26))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#rs(R)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(#rs(R),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#rs(_56),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(`_andBool_`(isProps(R),isProps(_56)),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(117) org.kframework.attributes.Location(Location(117,6,118,61)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1202) as e51 when guard < 27 -> (let e = ((evalMap'Coln'lookup((var_0_835),e51) config (-1))) in match e with 
| [Bottom] -> (stepElt 27)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1203),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'rs,(var_8_1204 :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_7_1205) :: [])) :: [])) :: var_5_1206)) :: []),(var_6_1207),(KApply1(Lbl'_LT_'store'_GT_',(var_16_1208)) :: []),(var_10_1209),(var_11_1210),(var_12_1211),(var_13_1212),(var_14_1213)) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_1208),(var_7_1205 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 27)
| (KApply1(Lbl'Hash'rs,(var_17_1214 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e51) config (-1))) in match e with 
| [Bottom] -> (stepElt 27)
| ((Map (SortStateCellMap,_,_) as var_15_1215) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_1208),(var_7_1205 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 27)
| ((Map (SortMap,_,_) as var_9_1216) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((((isTrue (evalisProps((var_8_1204 :: [])) config (-1)))) && ((isTrue (evalisProps((var_17_1214 :: [])) config (-1)))))) && (true)))) && (((compare var_4_1203 var_4_1202) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e51,(KApply9(Lbl'_LT_'state'_GT_',e51,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1206)) :: []),(var_6_1207),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1205 :: []),(KApply1(Lbl'Hash'rs,(var_8_1204 :: [])) :: [])) config (-1))),(var_9_1216 :: [])) config (-1)))) :: []),(var_10_1209),(var_11_1210),(var_12_1211),(var_13_1212),(var_14_1213)) :: [])) config (-1))),(var_15_1215 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 27))| _ -> (stepElt 27))| _ -> (stepElt 27))| _ -> (stepElt 27))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#loc(L)~>DotVar3),`<env>`(`_Map_`(`_|->_`(X,L),DotVar4)),_1,_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(X)~>DotVar3),`<env>`(_10),_1,_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(L,`Map:lookup`(_10,X))),#match(DotVar4,`_[_<-undef]`(_10,X))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isInt(L),isExp(X))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(247) org.kframework.attributes.Location(Location(247,6,248,38)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1217) as e52 when guard < 28 -> (let e = ((evalMap'Coln'lookup((var_0_835),e52) config (-1))) in match e with 
| [Bottom] -> (stepElt 28)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1218),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(var_7_1219 :: [])) :: var_6_1220)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_16_1221)) :: []),(var_9_1222),(var_10_1223),(var_11_1224),(var_12_1225),(var_13_1226),(var_14_1227)) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_1221),(var_7_1219 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 28)
| ((Int _ as var_5_1228) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_1221),(var_7_1219 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 28)
| ((Map (SortMap,_,_) as var_8_1229) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e52) config (-1))) in match e with 
| [Bottom] -> (stepElt 28)
| ((Map (SortStateCellMap,_,_) as var_15_1230) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((true) && ((isTrue (evalisExp((var_7_1219 :: [])) config (-1))))))) && (((compare var_4_1218 var_4_1217) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e52,(KApply9(Lbl'_LT_'state'_GT_',e52,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loc,(var_5_1228 :: [])) :: var_6_1220)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1219 :: []),(var_5_1228 :: [])) config (-1))),(var_8_1229 :: [])) config (-1)))) :: []),(var_9_1222),(var_10_1223),(var_11_1224),(var_12_1225),(var_13_1226),(var_14_1227)) :: [])) config (-1))),(var_15_1230 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 28))| _ -> (stepElt 28))| _ -> (stepElt 28))| _ -> (stepElt 28))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(V~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(val(V)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isValue(V)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(388) org.kframework.attributes.Location(Location(388,6,388,23)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1231) as e53 when guard < 29 -> (let e = ((evalMap'Coln'lookup((var_0_835),e53) config (-1))) in match e with 
| [Bottom] -> (stepElt 29)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1232),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lblval,(var_5_1233 :: [])) :: var_6_1234)) :: []),(var_7_1235),(var_8_1236),(var_9_1237),(var_10_1238),(var_11_1239),(var_12_1240),(var_13_1241)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e53) config (-1))) in match e with 
| [Bottom] -> (stepElt 29)
| ((Map (SortStateCellMap,_,_) as var_14_1242) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisValue((var_5_1233 :: [])) config (-1))))) && (((compare var_4_1232 var_4_1231) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e53,(KApply9(Lbl'_LT_'state'_GT_',e53,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1233 :: var_6_1234)) :: []),(var_7_1235),(var_8_1236),(var_9_1237),(var_10_1238),(var_11_1239),(var_12_1240),(var_13_1241)) :: [])) config (-1))),(var_14_1242 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 29))| _ -> (stepElt 29))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Read(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#Read0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isK(HOLE),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#Read) org.kframework.attributes.Location(Location(186,12,186,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(300983713) strict()]|}*)
| (var_4_1243) as e54 when guard < 30 -> (let e = ((evalMap'Coln'lookup((var_0_835),e54) config (-1))) in match e with 
| [Bottom] -> (stepElt 30)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1244),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1245 :: KApply0(Lbl'Hash'freezer'Hash'Read0_) :: var_6_1246)) :: []),(var_7_1247),(var_8_1248),(var_9_1249),(var_10_1250),(var_11_1251),(var_12_1252),(var_13_1253)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e54) config (-1))) in match e with 
| [Bottom] -> (stepElt 30)
| ((Map (SortStateCellMap,_,_) as var_14_1254) :: []) when ((((((true) && (true))) && (true))) && (((true) && (((true) && ((isTrue (evalisKResult((var_5_1245 :: [])) config (-1))))))))) && (((compare var_4_1243 var_4_1244) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e54,(KApply9(Lbl'_LT_'state'_GT_',e54,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(var_5_1245 :: [])) :: var_6_1246)) :: []),(var_7_1247),(var_8_1248),(var_9_1249),(var_10_1250),(var_11_1251),(var_12_1252),(var_13_1253)) :: [])) config (-1))),(var_14_1254 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 30))| _ -> (stepElt 30))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,`<timer>`(`_+Int__INT`(TIMER,#token("1","Int"))),_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(`#increaseTimer_OSL`(.KList)~>DotVar3),_1,_2,_3,_4,`<timer>`(TIMER),_5,_6),`Map:lookup`(_10,_0))),#match(DotVar1,`_[_<-undef]`(_10,_0))),isInt(TIMER)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(77) org.kframework.attributes.Location(Location(77,6,78,48)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1255) as e55 when guard < 31 -> (let e = ((evalMap'Coln'lookup((var_0_835),e55) config (-1))) in match e with 
| [Bottom] -> (stepElt 31)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1256),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Hash'increaseTimer_OSL) :: var_5_1257)) :: []),(var_6_1258),(var_7_1259),(var_8_1260),(var_9_1261),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_10_1262) :: [])) :: []),(var_11_1263),(var_12_1264)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e55) config (-1))) in match e with 
| [Bottom] -> (stepElt 31)
| ((Map (SortStateCellMap,_,_) as var_13_1265) :: []) when ((((((true) && (true))) && (true))) && (true)) && (((compare var_4_1256 var_4_1255) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e55,(KApply9(Lbl'_LT_'state'_GT_',e55,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1257)) :: []),(var_6_1258),(var_7_1259),(var_8_1260),(var_9_1261),(KApply1(Lbl'_LT_'timer'_GT_',((eval_'Plus'Int__INT((var_10_1262 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_11_1263),(var_12_1264)) :: [])) config (-1))),(var_13_1265 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 31))| _ -> (stepElt 31))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#borrowImmCK(L,BEG,END,L1)~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#br(BEG,END,#immRef(L1))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lvDref(#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#br(BEG,END,#immRef(L1)),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(257) org.kframework.attributes.Location(Location(257,6,258,75)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1266) as e56 when guard < 32 -> (let e = ((evalMap'Coln'lookup((var_0_835),e56) config (-1))) in match e with 
| [Bottom] -> (stepElt 32)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1267),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lvDref,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1268) :: [])) :: [])) :: var_9_1269)) :: []),(var_10_1270),(KApply1(Lbl'_LT_'store'_GT_',(var_18_1271)) :: []),(var_12_1272),(var_13_1273),(var_14_1274),(var_15_1275),(var_16_1276)) :: []) -> (let e = ((evalMap'Coln'lookup((var_18_1271),(var_5_1268 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 32)
| (KApply3(Lbl'Hash'br,((Int _ as var_6_1277) :: []),((Int _ as var_7_1278) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_8_1279) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e56) config (-1))) in match e with 
| [Bottom] -> (stepElt 32)
| ((Map (SortStateCellMap,_,_) as var_17_1280) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_18_1271),(var_5_1268 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 32)
| ((Map (SortMap,_,_) as var_11_1281) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && (true))) && (true))) && (true)))) && (((compare var_4_1267 var_4_1266) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e56,(KApply9(Lbl'_LT_'state'_GT_',e56,(KApply1(Lbl'_LT_'k'_GT_',(KApply4(Lbl'Hash'borrowImmCK,(var_5_1268 :: []),(var_6_1277 :: []),(var_7_1278 :: []),(var_8_1279 :: [])) :: var_9_1269)) :: []),(var_10_1270),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_1268 :: []),(KApply3(Lbl'Hash'br,(var_6_1277 :: []),(var_7_1278 :: []),(KApply1(Lbl'Hash'immRef,(var_8_1279 :: [])) :: [])) :: [])) config (-1))),(var_11_1281 :: [])) config (-1)))) :: []),(var_12_1272),(var_13_1273),(var_14_1274),(var_15_1275),(var_16_1276)) :: [])) config (-1))),(var_17_1280 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 32))| _ -> (stepElt 32))| _ -> (stepElt 32))| _ -> (stepElt 32))
(*{| rule `<T>`(`<states>`(``_7=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),`<env>`(`_[_<-_]_MAP`(Rho,X,N)),`<store>`(`_Map_`(`_|->_`(N,`#uninit_OSL-SYNTAX`(.KList)),DotVar4)),`<stack>`(`_List_`(`ListItem`(X),DotVar5)),_1,`<timer>`(`_+Int__INT`(TI,#token("1","Int"))),_2,`<indexes>`(#indexes(`_+Int__INT`(N,#token("1","Int")),_38)))),DotVar1)``),_3,_4,_5) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_7),#match(`<state>`(_0,`<k>`(#decl(X)~>DotVar3),`<env>`(Rho),`<store>`(_6),`<stack>`(DotVar5),_1,`<timer>`(TI),_2,`<indexes>`(#indexes(N,_38))),`Map:lookup`(_7,_0))),#match(DotVar4,_6)),#match(DotVar1,`_[_<-undef]`(_7,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(TI),isInt(_38)),isId(X)),isMap(Rho)),isInt(N))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(28) org.kframework.attributes.Location(Location(28,6,33,59)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1282) as e57 when guard < 33 -> (let e = ((evalMap'Coln'lookup((var_0_835),e57) config (-1))) in match e with 
| [Bottom] -> (stepElt 33)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1283),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'decl,(var_7_1284 :: [])) :: var_5_1285)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_6_1286) :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',(var_16_1287)) :: []),(KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as var_10_1288) :: [])) :: []),(var_11_1289),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_12_1290) :: [])) :: []),(var_13_1291),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_8_1292) :: []),((Int _ as var_14_1293) :: [])) :: [])) :: [])) :: []) -> (let e = (var_16_1287) in match e with 
| [Bottom] -> (stepElt 33)
| ((Map (SortMap,_,_) as var_9_1294) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e57) config (-1))) in match e with 
| [Bottom] -> (stepElt 33)
| ((Map (SortStateCellMap,_,_) as var_15_1295) :: []) when ((((((((true) && (true))) && (true))) && (true))) && (((((((((true) && (true))) && ((isTrue (evalisId((var_7_1284 :: [])) config (-1)))))) && (true))) && (true)))) && (((compare var_4_1283 var_4_1282) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e57,(KApply9(Lbl'_LT_'state'_GT_',e57,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1285)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP((var_6_1286 :: []),(var_7_1284 :: []),(var_8_1292 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_8_1292 :: []),(const'Hash'uninit_OSL'Hyph'SYNTAX :: [])) config (-1))),(var_9_1294 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'stack'_GT_',((eval_List_(((evalListItem((var_7_1284 :: [])) config (-1))),(var_10_1288 :: [])) config (-1)))) :: []),(var_11_1289),(KApply1(Lbl'_LT_'timer'_GT_',((eval_'Plus'Int__INT((var_12_1290 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_13_1291),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((eval_'Plus'Int__INT((var_8_1292 :: []),((Lazy.force int1) :: [])) config (-1))),(var_14_1293 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_15_1295 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 33))| _ -> (stepElt 33))| _ -> (stepElt 33))
(*{| rule `<T>`(`<states>`(``_9=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Transfer(#lv(EF),#lv(TX))~>`#increaseIndex_OSL`(.KList)~>`#increaseTimer_OSL`(.KList)~>DotVar3),`<env>`(ENV),_1,_2,`<write>`(`_Set_`(`SetItem`(#writev(#wv(TX,ENV),TR)),DotVar4)),`<timer>`(TR),_3,_4)),DotVar1)``),_5,_6,_7) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_9),#match(`<state>`(_0,`<k>`(#transfer(EF,TX)~>DotVar3),`<env>`(ENV),_1,_2,`<write>`(_8),`<timer>`(TR),_3,_4),`Map:lookup`(_9,_0))),#match(DotVar4,_8)),#match(DotVar1,`_[_<-undef]`(_9,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isExp(TX),isMap(ENV)),isExp(EF)),isInt(TR))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(49) org.kframework.attributes.Location(Location(49,6,53,68)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1296) as e58 when guard < 34 -> (let e = ((evalMap'Coln'lookup((var_0_835),e58) config (-1))) in match e with 
| [Bottom] -> (stepElt 34)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1297),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'transfer,(var_5_1298 :: []),(var_6_1299 :: [])) :: var_7_1300)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_8_1301) :: [])) :: []),(var_9_1302),(var_10_1303),(KApply1(Lbl'_LT_'write'_GT_',(var_16_1304)) :: []),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_11_1305) :: [])) :: []),(var_13_1306),(var_14_1307)) :: []) -> (let e = (var_16_1304) in match e with 
| [Bottom] -> (stepElt 34)
| ((Set (SortSet,_,_) as var_12_1308) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e58) config (-1))) in match e with 
| [Bottom] -> (stepElt 34)
| ((Map (SortStateCellMap,_,_) as var_15_1309) :: []) when ((((((((true) && (true))) && (true))) && (true))) && ((((((((isTrue (evalisExp((var_6_1299 :: [])) config (-1)))) && (true))) && ((isTrue (evalisExp((var_5_1298 :: [])) config (-1)))))) && (true)))) && (((compare var_4_1297 var_4_1296) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e58,(KApply9(Lbl'_LT_'state'_GT_',e58,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'lv,(var_5_1298 :: [])) :: []),(KApply1(Lbl'Hash'lv,(var_6_1299 :: [])) :: [])) :: const'Hash'increaseIndex_OSL :: const'Hash'increaseTimer_OSL :: var_7_1300)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_8_1301 :: [])) :: []),(var_9_1302),(var_10_1303),(KApply1(Lbl'_LT_'write'_GT_',((eval_Set_(((evalSetItem((KApply2(Lbl'Hash'writev,((eval'Hash'wv((var_6_1299 :: []),(var_8_1301 :: [])) config (-1))),(var_11_1305 :: [])) :: [])) config (-1))),(var_12_1308 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_11_1305 :: [])) :: []),(var_13_1306),(var_14_1307)) :: [])) config (-1))),(var_15_1309 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 34))| _ -> (stepElt 34))| _ -> (stepElt 34))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(`.List{"___OSL-SYNTAX"}`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(21) org.kframework.attributes.Location(Location(21,6,21,17)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1310) as e59 when guard < 35 -> (let e = ((evalMap'Coln'lookup((var_0_835),e59) config (-1))) in match e with 
| [Bottom] -> (stepElt 35)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1311),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Stop'List'LBraQuot'___OSL'Hyph'SYNTAX'QuotRBra') :: var_5_1312)) :: []),(var_6_1313),(var_7_1314),(var_8_1315),(var_9_1316),(var_10_1317),(var_11_1318),(var_12_1319)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e59) config (-1))) in match e with 
| [Bottom] -> (stepElt 35)
| ((Map (SortStateCellMap,_,_) as var_13_1320) :: []) when ((((true) && (true))) && (true)) && (((compare var_4_1311 var_4_1310) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e59,(KApply9(Lbl'_LT_'state'_GT_',e59,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1312)) :: []),(var_6_1313),(var_7_1314),(var_8_1315),(var_9_1316),(var_10_1317),(var_11_1318),(var_12_1319)) :: [])) config (-1))),(var_13_1320 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 35))| _ -> (stepElt 35))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(val(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezerval0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(val) org.kframework.attributes.Location(Location(52,12,52,56)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/osl-syntax.k)) productionID(1664598529) strict()]|}*)
| (var_4_1321) as e60 when guard < 36 -> (let e = ((evalMap'Coln'lookup((var_0_835),e60) config (-1))) in match e with 
| [Bottom] -> (stepElt 36)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1322),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1323 :: KApply0(Lbl'Hash'freezerval0_) :: var_6_1324)) :: []),(var_7_1325),(var_8_1326),(var_9_1327),(var_10_1328),(var_11_1329),(var_12_1330),(var_13_1331)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e60) config (-1))) in match e with 
| [Bottom] -> (stepElt 36)
| ((Map (SortStateCellMap,_,_) as var_14_1332) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1323 :: [])) config (-1)))) && (((true) && ((isTrue (evalisKResult((var_5_1323 :: [])) config (-1))))))))) && (((compare var_4_1322 var_4_1321) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e60,(KApply9(Lbl'_LT_'state'_GT_',e60,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lblval,(var_5_1323 :: [])) :: var_6_1324)) :: []),(var_7_1325),(var_8_1326),(var_9_1327),(var_10_1328),(var_11_1329),(var_12_1330),(var_13_1331)) :: [])) config (-1))),(var_14_1332 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 36))| _ -> (stepElt 36))
(*{| rule `<T>`(`<states>`(``_6=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#loc(L1)~>DotVar3),_1,`<store>`(`_[_<-_]_MAP`(Rho,L,#br(BEG,TIMER,#mutRef(L1)))),_2,`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(C,_40)))),DotVar1)``),_3,_4,_5) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_6),#match(`<state>`(_0,`<k>`(#borrowMutCK(L,BEG,END,L1)~>DotVar3),_1,`<store>`(Rho),_2,`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(C,_40))),`Map:lookup`(_6,_0))),#match(DotVar1,`_[_<-undef]`(_6,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(TIMER),isSet(WRITE)),isBool(UNSAFE_BLOCK)),isInt(C)),isInt(END)),isInt(BEG)),isInt(_40)),isMap(Rho)),isInt(L)),isInt(L1)),`_orBool__BOOL`(`_==Bool__BOOL`(UNSAFE_BLOCK,#token("true","Bool")),`_andBool_`(`_==Bool__BOOL`(#borrowmutck(L,Rho,BEG,TIMER,L1),#token("false","Bool")),#writeCK(L1,BEG,TIMER,WRITE))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(223) org.kframework.attributes.Location(Location(223,6,232,46)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1333) as e61 when guard < 37 -> (let e = ((evalMap'Coln'lookup((var_0_835),e61) config (-1))) in match e with 
| [Bottom] -> (stepElt 37)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1334),(KApply1(Lbl'_LT_'k'_GT_',(KApply4(Lbl'Hash'borrowMutCK,((Int _ as var_9_1335) :: []),((Int _ as var_10_1336) :: []),((Int _ as var_18_1337) :: []),((Int _ as var_5_1338) :: [])) :: var_6_1339)) :: []),(var_7_1340),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_8_1341) :: [])) :: []),(var_12_1342),(KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as var_13_1343) :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_11_1344) :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as var_14_1345) :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_15_1346) :: []),((Int _ as var_16_1347) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e61) config (-1))) in match e with 
| [Bottom] -> (stepElt 37)
| ((Map (SortStateCellMap,_,_) as var_17_1348) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsEqls'Bool__BOOL((var_14_1345 :: []),((Bool true) :: [])) config (-1)))) || ((((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'borrowmutck((var_9_1335 :: []),(var_8_1341 :: []),(var_10_1336 :: []),(var_11_1344 :: []),(var_5_1338 :: [])) config (-1))),((Bool false) :: [])) config (-1)))) && ((isTrue (eval'Hash'writeCK((var_5_1338 :: []),(var_10_1336 :: []),(var_11_1344 :: []),(var_13_1343 :: [])) config (-1))))))))))) && (((compare var_4_1334 var_4_1333) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e61,(KApply9(Lbl'_LT_'state'_GT_',e61,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loc,(var_5_1338 :: [])) :: var_6_1339)) :: []),(var_7_1340),(KApply1(Lbl'_LT_'store'_GT_',((eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP((var_8_1341 :: []),(var_9_1335 :: []),(KApply3(Lbl'Hash'br,(var_10_1336 :: []),(var_11_1344 :: []),(KApply1(Lbl'Hash'mutRef,(var_5_1338 :: [])) :: [])) :: [])) config (-1)))) :: []),(var_12_1342),(KApply1(Lbl'_LT_'write'_GT_',(var_13_1343 :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_11_1344 :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',(var_14_1345 :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_15_1346 :: []),(var_16_1347 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_17_1348 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 37))| _ -> (stepElt 37))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Deallocate(#rs(Ps))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isProps(Ps)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(395) org.kframework.attributes.Location(Location(395,6,395,37)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1349) as e62 when guard < 38 -> (let e = ((evalMap'Coln'lookup((var_0_835),e62) config (-1))) in match e with 
| [Bottom] -> (stepElt 38)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1350),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Deallocate,(KApply1(Lbl'Hash'rs,(var_14_1351 :: [])) :: [])) :: var_5_1352)) :: []),(var_6_1353),(var_7_1354),(var_8_1355),(var_9_1356),(var_10_1357),(var_11_1358),(var_12_1359)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e62) config (-1))) in match e with 
| [Bottom] -> (stepElt 38)
| ((Map (SortStateCellMap,_,_) as var_13_1360) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisProps((var_14_1351 :: [])) config (-1))))) && (((compare var_4_1349 var_4_1350) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e62,(KApply9(Lbl'_LT_'state'_GT_',e62,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1352)) :: []),(var_6_1353),(var_7_1354),(var_8_1355),(var_9_1356),(var_10_1357),(var_11_1358),(var_12_1359)) :: [])) config (-1))),(var_13_1360 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 38))| _ -> (stepElt 38))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#rs(PType)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#rs(PVal)~>#own(PType)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isProps(PType),isProps(PVal)),`_==K_`(PVal,PType))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(38) org.kframework.attributes.Location(Location(38,6,39,29)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| (var_4_1361) as e63 when guard < 39 -> (let e = ((evalMap'Coln'lookup((var_0_835),e63) config (-1))) in match e with 
| [Bottom] -> (stepElt 39)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1362),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'rs,(var_15_1363 :: [])) :: KApply1(Lbl'Hash'own,(var_5_1364 :: [])) :: var_6_1365)) :: []),(var_7_1366),(var_8_1367),(var_9_1368),(var_10_1369),(var_11_1370),(var_12_1371),(var_13_1372)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e63) config (-1))) in match e with 
| [Bottom] -> (stepElt 39)
| ((Map (SortStateCellMap,_,_) as var_14_1373) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisProps((var_5_1364 :: [])) config (-1)))) && ((isTrue (evalisProps((var_15_1363 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'K_((var_15_1363 :: []),(var_5_1364 :: [])) config (-1))))))) && (((compare var_4_1362 var_4_1361) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e63,(KApply9(Lbl'_LT_'state'_GT_',e63,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'rs,(var_5_1364 :: [])) :: var_6_1365)) :: []),(var_7_1366),(var_8_1367),(var_9_1368),(var_10_1369),(var_11_1370),(var_12_1371),(var_13_1372)) :: [])) config (-1))),(var_14_1373 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 39))| _ -> (stepElt 39))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#borrowMutCK(L,BEG,END,L1)~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#br(BEG,END,#immRef(L1))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lvDref(#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#br(BEG,END,#immRef(L1)),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(261) org.kframework.attributes.Location(Location(261,6,262,75)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1374) as e64 when guard < 40 -> (let e = ((evalMap'Coln'lookup((var_0_835),e64) config (-1))) in match e with 
| [Bottom] -> (stepElt 40)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1375),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lvDref,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1376) :: [])) :: [])) :: var_9_1377)) :: []),(var_10_1378),(KApply1(Lbl'_LT_'store'_GT_',(var_18_1379)) :: []),(var_12_1380),(var_13_1381),(var_14_1382),(var_15_1383),(var_16_1384)) :: []) -> (let e = ((evalMap'Coln'lookup((var_18_1379),(var_5_1376 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 40)
| (KApply3(Lbl'Hash'br,((Int _ as var_6_1385) :: []),((Int _ as var_7_1386) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_8_1387) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e64) config (-1))) in match e with 
| [Bottom] -> (stepElt 40)
| ((Map (SortStateCellMap,_,_) as var_17_1388) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_18_1379),(var_5_1376 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 40)
| ((Map (SortMap,_,_) as var_11_1389) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && (true))) && (true))) && (true)))) && (((compare var_4_1375 var_4_1374) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e64,(KApply9(Lbl'_LT_'state'_GT_',e64,(KApply1(Lbl'_LT_'k'_GT_',(KApply4(Lbl'Hash'borrowMutCK,(var_5_1376 :: []),(var_6_1385 :: []),(var_7_1386 :: []),(var_8_1387 :: [])) :: var_9_1377)) :: []),(var_10_1378),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_1376 :: []),(KApply3(Lbl'Hash'br,(var_6_1385 :: []),(var_7_1386 :: []),(KApply1(Lbl'Hash'immRef,(var_8_1387 :: [])) :: [])) :: [])) config (-1))),(var_11_1389 :: [])) config (-1)))) :: []),(var_12_1380),(var_13_1381),(var_14_1382),(var_15_1383),(var_16_1384)) :: [])) config (-1))),(var_17_1388 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 40))| _ -> (stepElt 40))| _ -> (stepElt 40))| _ -> (stepElt 40))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferIB(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,#rs(PS)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(#ref(F),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(#rs(PS),`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(F),isProps(PS)),isInt(L)),`notBool_`(#inProps(`mut_OSL-SYNTAX`(.KList),PS)))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(128) org.kframework.attributes.Location(Location(128,6,130,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1390) as e65 when guard < 41 -> (let e = ((evalMap'Coln'lookup((var_0_835),e65) config (-1))) in match e with 
| [Bottom] -> (stepElt 41)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1391),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'ref,((Int _ as var_5_1392) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_1393) :: [])) :: [])) :: var_7_1394)) :: []),(var_8_1395),(KApply1(Lbl'_LT_'store'_GT_',(var_17_1396)) :: []),(var_11_1397),(var_12_1398),(var_13_1399),(var_14_1400),(var_15_1401)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_17_1396),(var_5_1392 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 41)
| ((Map (SortMap,_,_) as var_10_1402) :: []) -> (let e = ((evalMap'Coln'lookup((var_17_1396),(var_5_1392 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 41)
| (KApply1(Lbl'Hash'rs,(var_9_1403 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e65) config (-1))) in match e with 
| [Bottom] -> (stepElt 41)
| ((Map (SortStateCellMap,_,_) as var_16_1404) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && ((isTrue (evalisProps((var_9_1403 :: [])) config (-1)))))) && (true))) && ((not ((isTrue (eval'Hash'inProps((constmut_OSL'Hyph'SYNTAX :: []),(var_9_1403 :: [])) config (-1))))))))) && (((compare var_4_1391 var_4_1390) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e65,(KApply9(Lbl'_LT_'state'_GT_',e65,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferIB,(KApply1(Lbl'Hash'loc,(var_5_1392 :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_1393 :: [])) :: [])) :: var_7_1394)) :: []),(var_8_1395),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_1392 :: []),(KApply1(Lbl'Hash'rs,(var_9_1403 :: [])) :: [])) config (-1))),(var_10_1402 :: [])) config (-1)))) :: []),(var_11_1397),(var_12_1398),(var_13_1399),(var_14_1400),(var_15_1401)) :: [])) config (-1))),(var_16_1404 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 41))| _ -> (stepElt 41))| _ -> (stepElt 41))| _ -> (stepElt 41))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Deallocate(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#Deallocate0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#Deallocate) org.kframework.attributes.Location(Location(391,12,391,48)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1099717276) strict()]|}*)
| (var_4_1405) as e66 when guard < 42 -> (let e = ((evalMap'Coln'lookup((var_0_835),e66) config (-1))) in match e with 
| [Bottom] -> (stepElt 42)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1406),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1407 :: KApply0(Lbl'Hash'freezer'Hash'Deallocate0_) :: var_6_1408)) :: []),(var_7_1409),(var_8_1410),(var_9_1411),(var_10_1412),(var_11_1413),(var_12_1414),(var_13_1415)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e66) config (-1))) in match e with 
| [Bottom] -> (stepElt 42)
| ((Map (SortStateCellMap,_,_) as var_14_1416) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1407 :: [])) config (-1)))) && (((true) && ((isTrue (evalisKResult((var_5_1407 :: [])) config (-1))))))))) && (((compare var_4_1405 var_4_1406) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e66,(KApply9(Lbl'_LT_'state'_GT_',e66,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Deallocate,(var_5_1407 :: [])) :: var_6_1408)) :: []),(var_7_1409),(var_8_1410),(var_9_1411),(var_10_1412),(var_11_1413),(var_12_1414),(var_13_1415)) :: [])) config (-1))),(var_14_1416 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 42))| _ -> (stepElt 42))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(`#void_OSL-SYNTAX`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(V~>`#void_OSL-SYNTAX`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isValue(V)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(31) org.kframework.attributes.Location(Location(31,6,31,31)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| (var_4_1417) as e67 when guard < 43 -> (let e = ((evalMap'Coln'lookup((var_0_835),e67) config (-1))) in match e with 
| [Bottom] -> (stepElt 43)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1418),(KApply1(Lbl'_LT_'k'_GT_',(var_14_1419 :: KApply0(Lbl'Hash'void_OSL'Hyph'SYNTAX) :: var_5_1420)) :: []),(var_6_1421),(var_7_1422),(var_8_1423),(var_9_1424),(var_10_1425),(var_11_1426),(var_12_1427)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e67) config (-1))) in match e with 
| [Bottom] -> (stepElt 43)
| ((Map (SortStateCellMap,_,_) as var_13_1428) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisValue((var_14_1419 :: [])) config (-1))))) && (((compare var_4_1418 var_4_1417) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e67,(KApply9(Lbl'_LT_'state'_GT_',e67,(KApply1(Lbl'_LT_'k'_GT_',(const'Hash'void_OSL'Hyph'SYNTAX :: var_5_1420)) :: []),(var_6_1421),(var_7_1422),(var_8_1423),(var_9_1424),(var_10_1425),(var_11_1426),(var_12_1427)) :: [])) config (-1))),(var_13_1428 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 43))| _ -> (stepElt 43))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#loc(L)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(#loc(L))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isInt(L)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(250) org.kframework.attributes.Location(Location(250,6,250,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1429) as e68 when guard < 44 -> (let e = ((evalMap'Coln'lookup((var_0_835),e68) config (-1))) in match e with 
| [Bottom] -> (stepElt 44)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1430),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1431) :: [])) :: [])) :: var_6_1432)) :: []),(var_7_1433),(var_8_1434),(var_9_1435),(var_10_1436),(var_11_1437),(var_12_1438),(var_13_1439)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e68) config (-1))) in match e with 
| [Bottom] -> (stepElt 44)
| ((Map (SortStateCellMap,_,_) as var_14_1440) :: []) when ((((((true) && (true))) && (true))) && (true)) && (((compare var_4_1430 var_4_1429) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e68,(KApply9(Lbl'_LT_'state'_GT_',e68,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loc,(var_5_1431 :: [])) :: var_6_1432)) :: []),(var_7_1433),(var_8_1434),(var_9_1435),(var_10_1436),(var_11_1437),(var_12_1438),(var_13_1439)) :: [])) config (-1))),(var_14_1440 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 44))| _ -> (stepElt 44))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Transfer(K0,HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#Transfer0_`(K0)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isExp(HOLE),isExp(K0)),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#Transfer) org.kframework.attributes.Location(Location(36,12,36,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1920907467) strict()]|}*)
| (var_4_1441) as e69 when guard < 45 -> (let e = ((evalMap'Coln'lookup((var_0_835),e69) config (-1))) in match e with 
| [Bottom] -> (stepElt 45)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1442),(KApply1(Lbl'_LT_'k'_GT_',(var_6_1443 :: KApply1(Lbl'Hash'freezer'Hash'Transfer0_,(var_5_1444 :: [])) :: var_7_1445)) :: []),(var_8_1446),(var_9_1447),(var_10_1448),(var_11_1449),(var_12_1450),(var_13_1451),(var_14_1452)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e69) config (-1))) in match e with 
| [Bottom] -> (stepElt 45)
| ((Map (SortStateCellMap,_,_) as var_15_1453) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisExp((var_6_1443 :: [])) config (-1)))) && ((isTrue (evalisExp((var_5_1444 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((var_6_1443 :: [])) config (-1))))))))) && (((compare var_4_1441 var_4_1442) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e69,(KApply9(Lbl'_LT_'state'_GT_',e69,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(var_5_1444 :: []),(var_6_1443 :: [])) :: var_7_1445)) :: []),(var_8_1446),(var_9_1447),(var_10_1448),(var_11_1449),(var_12_1450),(var_13_1451),(var_14_1452)) :: [])) config (-1))),(var_15_1453 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 45))| _ -> (stepElt 45))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferIB(HOLE,K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#TransferIB1_`(K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isK(HOLE),isK(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#TransferIB) org.kframework.attributes.Location(Location(149,12,149,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(376635015) strict(1)]|}*)
| (var_4_1454) as e70 when guard < 46 -> (let e = ((evalMap'Coln'lookup((var_0_835),e70) config (-1))) in match e with 
| [Bottom] -> (stepElt 46)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1455),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1456 :: KApply1(Lbl'Hash'freezer'Hash'TransferIB1_,(var_6_1457)) :: var_7_1458)) :: []),(var_8_1459),(var_9_1460),(var_10_1461),(var_11_1462),(var_12_1463),(var_13_1464),(var_14_1465)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e70) config (-1))) in match e with 
| [Bottom] -> (stepElt 46)
| ((Map (SortStateCellMap,_,_) as var_15_1466) :: []) when ((((((true) && (true))) && (true))) && (((((true) && (true))) && (((true) && ((isTrue (evalisKResult((var_5_1456 :: [])) config (-1))))))))) && (((compare var_4_1455 var_4_1454) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e70,(KApply9(Lbl'_LT_'state'_GT_',e70,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferIB,(var_5_1456 :: []),(var_6_1457)) :: var_7_1458)) :: []),(var_8_1459),(var_9_1460),(var_10_1461),(var_11_1462),(var_12_1463),(var_13_1464),(var_14_1465)) :: [])) config (-1))),(var_15_1466 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 46))| _ -> (stepElt 46))
(*{| rule `<T>`(`<states>`(``_7=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),`<env>`(ENV),`<store>`(`_[_<-_]_MAP`(ST,#unwrapInt(`Map:lookup`(ENV,X)),#br(C,C,#immRef(#unwrapInt(`Map:lookup`(ENV,Y)))))),_1,_2,`<timer>`(`_+Int__INT`(TIMER,#token("1","Int"))),_3,`<indexes>`(#indexes(`_+Int__INT`(C,#token("1","Int")),_33)))),DotVar1)``),_4,_5,_6) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_7),#match(`<state>`(_0,`<k>`(#borrow(X,Y)~>DotVar3),`<env>`(ENV),`<store>`(ST),_1,_2,`<timer>`(TIMER),_3,`<indexes>`(#indexes(C,_33))),`Map:lookup`(_7,_0))),#match(DotVar1,`_[_<-undef]`(_7,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(TIMER),isInt(_33)),isInt(C)),isMap(ENV)),isId(X)),isId(Y)),isMap(ST)),#checkInit(Y,ENV,ST))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(352) org.kframework.attributes.Location(Location(352,6,359,35)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1467) as e71 when guard < 47 -> (let e = ((evalMap'Coln'lookup((var_0_835),e71) config (-1))) in match e with 
| [Bottom] -> (stepElt 47)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1468),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'borrow,(var_8_1469 :: []),(var_10_1470 :: [])) :: var_5_1471)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_6_1472) :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_7_1473) :: [])) :: []),(var_11_1474),(var_12_1475),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_13_1476) :: [])) :: []),(var_14_1477),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_9_1478) :: []),((Int _ as var_15_1479) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e71) config (-1))) in match e with 
| [Bottom] -> (stepElt 47)
| ((Map (SortStateCellMap,_,_) as var_16_1480) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((true) && (true))) && (true))) && (true))) && ((isTrue (evalisId((var_8_1469 :: [])) config (-1)))))) && ((isTrue (evalisId((var_10_1470 :: [])) config (-1)))))) && (true))) && ((isTrue (eval'Hash'checkInit((var_10_1470 :: []),(var_6_1472 :: []),(var_7_1473 :: [])) config (-1))))))) && (((compare var_4_1467 var_4_1468) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e71,(KApply9(Lbl'_LT_'state'_GT_',e71,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1471)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_6_1472 :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',((eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP((var_7_1473 :: []),((eval'Hash'unwrapInt(((evalMap'Coln'lookup((var_6_1472 :: []),(var_8_1469 :: [])) config (-1)))) config (-1))),(KApply3(Lbl'Hash'br,(var_9_1478 :: []),(var_9_1478 :: []),(KApply1(Lbl'Hash'immRef,((eval'Hash'unwrapInt(((evalMap'Coln'lookup((var_6_1472 :: []),(var_10_1470 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) config (-1)))) :: []),(var_11_1474),(var_12_1475),(KApply1(Lbl'_LT_'timer'_GT_',((eval_'Plus'Int__INT((var_13_1476 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_14_1477),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((eval_'Plus'Int__INT((var_9_1478 :: []),((Lazy.force int1) :: [])) config (-1))),(var_15_1479 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_16_1480 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 47))| _ -> (stepElt 47))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#Read0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Read(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isK(HOLE),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#Read) org.kframework.attributes.Location(Location(186,12,186,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(300983713) strict()]|}*)
| (var_4_1481) as e72 when guard < 48 -> (let e = ((evalMap'Coln'lookup((var_0_835),e72) config (-1))) in match e with 
| [Bottom] -> (stepElt 48)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1482),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(var_5_1483)) :: var_6_1484)) :: []),(var_7_1485),(var_8_1486),(var_9_1487),(var_10_1488),(var_11_1489),(var_12_1490),(var_13_1491)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e72) config (-1))) in match e with 
| [Bottom] -> (stepElt 48)
| ((Map (SortStateCellMap,_,_) as var_14_1492) :: []) when ((((((true) && (true))) && (true))) && (((true) && (((true) && ((not ((isTrue (evalisKResult((var_5_1483)) config (-1))))))))))) && (((compare var_4_1481 var_4_1482) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e72,(KApply9(Lbl'_LT_'state'_GT_',e72,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1483 @ const'Hash'freezer'Hash'Read0_ :: var_6_1484)) :: []),(var_7_1485),(var_8_1486),(var_9_1487),(var_10_1488),(var_11_1489),(var_12_1490),(var_13_1491)) :: [])) config (-1))),(var_14_1492 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 48))| _ -> (stepElt 48))
(*{| rule `<T>`(`<states>`(``_9=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferV(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(STORE),_2,_3,_4,_5,`<indexes>`(#indexes(C,_59)))),DotVar1)``),_6,_7,_8) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_9),#match(`<state>`(_0,`<k>`(#Transfer(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(STORE),_2,_3,_4,_5,`<indexes>`(#indexes(C,_59))),`Map:lookup`(_9,_0))),#match(DotVar1,`_[_<-undef]`(_9,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(C),isInt(F)),isMap(STORE)),isInt(L)),isInt(_59)),`_andBool_`(`notBool_`(#existRef(#immRef(F),#list2Set(values(STORE)),C)),`notBool_`(#existRef(#mutRef(F),#list2Set(values(STORE)),C))))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(107) org.kframework.attributes.Location(Location(107,6,111,67)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1493) as e73 when guard < 49 -> (let e = ((evalMap'Coln'lookup((var_0_835),e73) config (-1))) in match e with 
| [Bottom] -> (stepElt 49)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1494),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1495) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_1496) :: [])) :: [])) :: var_7_1497)) :: []),(var_8_1498),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_9_1499) :: [])) :: []),(var_10_1500),(var_11_1501),(var_12_1502),(var_13_1503),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_14_1504) :: []),((Int _ as var_15_1505) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e73) config (-1))) in match e with 
| [Bottom] -> (stepElt 49)
| ((Map (SortStateCellMap,_,_) as var_16_1506) :: []) when ((((((true) && (true))) && (true))) && (((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((not ((isTrue (eval'Hash'existRef((KApply1(Lbl'Hash'immRef,(var_5_1495 :: [])) :: []),((eval'Hash'list2Set(((evalvalues((var_9_1499 :: [])) config (-1)))) config (-1))),(var_14_1504 :: [])) config (-1)))))) && ((not ((isTrue (eval'Hash'existRef((KApply1(Lbl'Hash'mutRef,(var_5_1495 :: [])) :: []),((eval'Hash'list2Set(((evalvalues((var_9_1499 :: [])) config (-1)))) config (-1))),(var_14_1504 :: [])) config (-1))))))))))) && (((compare var_4_1494 var_4_1493) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e73,(KApply9(Lbl'_LT_'state'_GT_',e73,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferV,(KApply1(Lbl'Hash'loc,(var_5_1495 :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_1496 :: [])) :: [])) :: var_7_1497)) :: []),(var_8_1498),(KApply1(Lbl'_LT_'store'_GT_',(var_9_1499 :: [])) :: []),(var_10_1500),(var_11_1501),(var_12_1502),(var_13_1503),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_14_1504 :: []),(var_15_1505 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_16_1506 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 49))| _ -> (stepElt 49))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Transfer(#rs(PS),#loc(L))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,#rs(PS)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#TransferV(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(#rs(PS),`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(F),isProps(PS)),isInt(L)),#inProps(`copy_OSL-SYNTAX`(.KList),PS))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(144) org.kframework.attributes.Location(Location(144,6,146,33)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1507) as e74 when guard < 50 -> (let e = ((evalMap'Coln'lookup((var_0_835),e74) config (-1))) in match e with 
| [Bottom] -> (stepElt 50)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1508),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferV,(KApply1(Lbl'Hash'loc,((Int _ as var_9_1509) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_1510) :: [])) :: [])) :: var_7_1511)) :: []),(var_8_1512),(KApply1(Lbl'_LT_'store'_GT_',(var_17_1513)) :: []),(var_11_1514),(var_12_1515),(var_13_1516),(var_14_1517),(var_15_1518)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_17_1513),(var_9_1509 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 50)
| ((Map (SortMap,_,_) as var_10_1519) :: []) -> (let e = ((evalMap'Coln'lookup((var_17_1513),(var_9_1509 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 50)
| (KApply1(Lbl'Hash'rs,(var_5_1520 :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e74) config (-1))) in match e with 
| [Bottom] -> (stepElt 50)
| ((Map (SortStateCellMap,_,_) as var_16_1521) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && ((isTrue (evalisProps((var_5_1520 :: [])) config (-1)))))) && (true))) && ((isTrue (eval'Hash'inProps((constcopy_OSL'Hyph'SYNTAX :: []),(var_5_1520 :: [])) config (-1))))))) && (((compare var_4_1508 var_4_1507) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e74,(KApply9(Lbl'_LT_'state'_GT_',e74,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'rs,(var_5_1520 :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_1510 :: [])) :: [])) :: var_7_1511)) :: []),(var_8_1512),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_9_1509 :: []),(KApply1(Lbl'Hash'rs,(var_5_1520 :: [])) :: [])) config (-1))),(var_10_1519 :: [])) config (-1)))) :: []),(var_11_1514),(var_12_1515),(var_13_1516),(var_14_1517),(var_15_1518)) :: [])) config (-1))),(var_16_1521 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 50))| _ -> (stepElt 50))| _ -> (stepElt 50))| _ -> (stepElt 50))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#TransferMB1_`(K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#TransferMB(HOLE,K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isK(HOLE),isK(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#TransferMB) org.kframework.attributes.Location(Location(150,12,150,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1344697180) strict(1)]|}*)
| (var_4_1522) as e75 when guard < 51 -> (let e = ((evalMap'Coln'lookup((var_0_835),e75) config (-1))) in match e with 
| [Bottom] -> (stepElt 51)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1523),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferMB,(var_5_1524),(var_6_1525)) :: var_7_1526)) :: []),(var_8_1527),(var_9_1528),(var_10_1529),(var_11_1530),(var_12_1531),(var_13_1532),(var_14_1533)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e75) config (-1))) in match e with 
| [Bottom] -> (stepElt 51)
| ((Map (SortStateCellMap,_,_) as var_15_1534) :: []) when ((((((true) && (true))) && (true))) && (((((true) && (true))) && (((true) && ((not ((isTrue (evalisKResult((var_5_1524)) config (-1))))))))))) && (((compare var_4_1522 var_4_1523) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e75,(KApply9(Lbl'_LT_'state'_GT_',e75,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1524 @ KApply1(Lbl'Hash'freezer'Hash'TransferMB1_,(var_6_1525)) :: var_7_1526)) :: []),(var_8_1527),(var_9_1528),(var_10_1529),(var_11_1530),(var_12_1531),(var_13_1532),(var_14_1533)) :: [])) config (-1))),(var_15_1534 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 51))| _ -> (stepElt 51))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferIB(#read(#loc(F)),#loc(L))~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,#br(BEG,END,#immRef(L1))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#TransferV(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(#br(BEG,END,#immRef(L1)),`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isInt(F)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(153) org.kframework.attributes.Location(Location(153,6,154,61)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1535) as e76 when guard < 52 -> (let e = ((evalMap'Coln'lookup((var_0_835),e76) config (-1))) in match e with 
| [Bottom] -> (stepElt 52)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1536),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferV,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1537) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_6_1538) :: [])) :: [])) :: var_7_1539)) :: []),(var_8_1540),(KApply1(Lbl'_LT_'store'_GT_',(var_19_1541)) :: []),(var_13_1542),(var_14_1543),(var_15_1544),(var_16_1545),(var_17_1546)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_19_1541),(var_5_1537 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 52)
| ((Map (SortMap,_,_) as var_12_1547) :: []) -> (let e = ((evalMap'Coln'lookup((var_19_1541),(var_5_1537 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 52)
| (KApply3(Lbl'Hash'br,((Int _ as var_9_1548) :: []),((Int _ as var_10_1549) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_11_1550) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e76) config (-1))) in match e with 
| [Bottom] -> (stepElt 52)
| ((Map (SortStateCellMap,_,_) as var_18_1551) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((((true) && (true))) && (true))) && (true))) && (true)))) && (((compare var_4_1536 var_4_1535) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e76,(KApply9(Lbl'_LT_'state'_GT_',e76,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferIB,(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,(var_5_1537 :: [])) :: [])) :: []),(KApply1(Lbl'Hash'loc,(var_6_1538 :: [])) :: [])) :: var_7_1539)) :: []),(var_8_1540),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_1537 :: []),(KApply3(Lbl'Hash'br,(var_9_1548 :: []),(var_10_1549 :: []),(KApply1(Lbl'Hash'immRef,(var_11_1550 :: [])) :: [])) :: [])) config (-1))),(var_12_1547 :: [])) config (-1)))) :: []),(var_13_1542),(var_14_1543),(var_15_1544),(var_16_1545),(var_17_1546)) :: [])) config (-1))),(var_18_1551 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 52))| _ -> (stepElt 52))| _ -> (stepElt 52))| _ -> (stepElt 52))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#Deallocate0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Deallocate(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#Deallocate) org.kframework.attributes.Location(Location(391,12,391,48)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1099717276) strict()]|}*)
| (var_4_1552) as e77 when guard < 53 -> (let e = ((evalMap'Coln'lookup((var_0_835),e77) config (-1))) in match e with 
| [Bottom] -> (stepElt 53)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1553),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Deallocate,(var_5_1554 :: [])) :: var_6_1555)) :: []),(var_7_1556),(var_8_1557),(var_9_1558),(var_10_1559),(var_11_1560),(var_12_1561),(var_13_1562)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e77) config (-1))) in match e with 
| [Bottom] -> (stepElt 53)
| ((Map (SortStateCellMap,_,_) as var_14_1563) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1554 :: [])) config (-1)))) && (((true) && ((not ((isTrue (evalisKResult((var_5_1554 :: [])) config (-1))))))))))) && (((compare var_4_1553 var_4_1552) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e77,(KApply9(Lbl'_LT_'state'_GT_',e77,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1554 :: const'Hash'freezer'Hash'Deallocate0_ :: var_6_1555)) :: []),(var_7_1556),(var_8_1557),(var_9_1558),(var_10_1559),(var_11_1560),(var_12_1561),(var_13_1562)) :: [])) config (-1))),(var_14_1563 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 53))| _ -> (stepElt 53))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#loc(I)~>DotVar3),`<env>`(`_Map_`(`_|->_`(X,I),DotVar4)),_1,_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(X)~>DotVar3),`<env>`(_10),_1,_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,X))),#match(I,`Map:lookup`(_10,X))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isId(X),isInt(I))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(44) org.kframework.attributes.Location(Location(44,6,45,39)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1564) as e78 when guard < 54 -> (let e = ((evalMap'Coln'lookup((var_0_835),e78) config (-1))) in match e with 
| [Bottom] -> (stepElt 54)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1565),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(var_7_1566 :: [])) :: var_6_1567)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_16_1568)) :: []),(var_9_1569),(var_10_1570),(var_11_1571),(var_12_1572),(var_13_1573),(var_14_1574)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_1568),(var_7_1566 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 54)
| ((Map (SortMap,_,_) as var_8_1575) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_1568),(var_7_1566 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 54)
| ((Int _ as var_5_1576) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e78) config (-1))) in match e with 
| [Bottom] -> (stepElt 54)
| ((Map (SortStateCellMap,_,_) as var_15_1577) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (evalisId((var_7_1566 :: [])) config (-1)))) && (true)))) && (((compare var_4_1565 var_4_1564) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e78,(KApply9(Lbl'_LT_'state'_GT_',e78,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loc,(var_5_1576 :: [])) :: var_6_1567)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1566 :: []),(var_5_1576 :: [])) config (-1))),(var_8_1575 :: [])) config (-1)))) :: []),(var_9_1569),(var_10_1570),(var_11_1571),(var_12_1572),(var_13_1573),(var_14_1574)) :: [])) config (-1))),(var_15_1577 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 54))| _ -> (stepElt 54))| _ -> (stepElt 54))| _ -> (stepElt 54))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#read(#loc(L))~>DotVar3),`<env>`(`_Map_`(`_|->_`(X,L),DotVar4)),_1,_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#read(X)~>DotVar3),`<env>`(_10),_1,_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(L,`Map:lookup`(_10,X))),#match(DotVar4,`_[_<-undef]`(_10,X))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isId(X),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(176) org.kframework.attributes.Location(Location(176,6,177,39)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1578) as e79 when guard < 55 -> (let e = ((evalMap'Coln'lookup((var_0_835),e79) config (-1))) in match e with 
| [Bottom] -> (stepElt 55)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1579),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'read,(var_7_1580 :: [])) :: var_6_1581)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_16_1582)) :: []),(var_9_1583),(var_10_1584),(var_11_1585),(var_12_1586),(var_13_1587),(var_14_1588)) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_1582),(var_7_1580 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 55)
| ((Int _ as var_5_1589) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_1582),(var_7_1580 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 55)
| ((Map (SortMap,_,_) as var_8_1590) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e79) config (-1))) in match e with 
| [Bottom] -> (stepElt 55)
| ((Map (SortStateCellMap,_,_) as var_15_1591) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (evalisId((var_7_1580 :: [])) config (-1)))) && (true)))) && (((compare var_4_1579 var_4_1578) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e79,(KApply9(Lbl'_LT_'state'_GT_',e79,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,(var_5_1589 :: [])) :: [])) :: var_6_1581)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1580 :: []),(var_5_1589 :: [])) config (-1))),(var_8_1590 :: [])) config (-1)))) :: []),(var_9_1583),(var_10_1584),(var_11_1585),(var_12_1586),(var_13_1587),(var_14_1588)) :: [])) config (-1))),(var_15_1591 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 55))| _ -> (stepElt 55))| _ -> (stepElt 55))| _ -> (stepElt 55))
(*{| rule `<T>`(`<states>`(``_9=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),`<env>`(ENV),_1,`<stack>`(`_List_`(`.List`(.KList),DotVar4)),_2,_3,_4,_5)),DotVar1)``),_6,_7,_8) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_9),#match(`<state>`(_0,`<k>`(`#blockend_BLOCK`(.KList)~>DotVar3),`<env>`(_18),_1,`<stack>`(`_List_`(`ListItem`(ENV),DotVar4)),_2,_3,_4,_5),`Map:lookup`(_9,_0))),#match(DotVar1,`_[_<-undef]`(_9,_0))),`_andBool_`(isMap(ENV),isMap(_18))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(31) org.kframework.attributes.Location(Location(31,6,33,55)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_1592) as e80 when guard < 56 -> (let e = ((evalMap'Coln'lookup((var_0_835),e80) config (-1))) in match e with 
| [Bottom] -> (stepElt 56)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1593),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Hash'blockend_BLOCK) :: var_5_1594)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_14_1595) :: [])) :: []),(var_7_1596),(KApply1(Lbl'_LT_'stack'_GT_',((List (SortList, Lbl_List_, ((Map (SortMap,_,_) as var_6_1597) :: []) :: var_8_1598)) :: [])) :: []),(var_9_1599),(var_10_1600),(var_11_1601),(var_12_1602)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e80) config (-1))) in match e with 
| [Bottom] -> (stepElt 56)
| ((Map (SortStateCellMap,_,_) as var_13_1603) :: []) when ((((((true) && (true))) && (true))) && (((true) && (true)))) && (((compare var_4_1593 var_4_1592) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e80,(KApply9(Lbl'_LT_'state'_GT_',e80,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1594)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_6_1597 :: [])) :: []),(var_7_1596),(KApply1(Lbl'_LT_'stack'_GT_',((eval_List_(((Lazy.force const'Stop'List)),((List (SortList, Lbl_List_, var_8_1598)) :: [])) config (-1)))) :: []),(var_9_1599),(var_10_1600),(var_11_1601),(var_12_1602)) :: [])) config (-1))),(var_13_1603 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 56))| _ -> (stepElt 56))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#rs(R)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(#rs(R),#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(`#uninit_OSL-SYNTAX`(.KList),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(isProps(R),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(114) org.kframework.attributes.Location(Location(114,6,115,62)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1604) as e81 when guard < 57 -> (let e = ((evalMap'Coln'lookup((var_0_835),e81) config (-1))) in match e with 
| [Bottom] -> (stepElt 57)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1605),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(KApply1(Lbl'Hash'rs,(var_8_1606 :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_7_1607) :: [])) :: [])) :: var_5_1608)) :: []),(var_6_1609),(KApply1(Lbl'_LT_'store'_GT_',(var_16_1610)) :: []),(var_10_1611),(var_11_1612),(var_12_1613),(var_13_1614),(var_14_1615)) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_1610),(var_7_1607 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 57)
| (KApply0(Lbl'Hash'uninit_OSL'Hyph'SYNTAX) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e81) config (-1))) in match e with 
| [Bottom] -> (stepElt 57)
| ((Map (SortStateCellMap,_,_) as var_15_1616) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_1610),(var_7_1607 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 57)
| ((Map (SortMap,_,_) as var_9_1617) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (evalisProps((var_8_1606 :: [])) config (-1)))) && (true)))) && (((compare var_4_1605 var_4_1604) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e81,(KApply9(Lbl'_LT_'state'_GT_',e81,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1608)) :: []),(var_6_1609),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1607 :: []),(KApply1(Lbl'Hash'rs,(var_8_1606 :: [])) :: [])) config (-1))),(var_9_1617 :: [])) config (-1)))) :: []),(var_10_1611),(var_11_1612),(var_12_1613),(var_13_1614),(var_14_1615)) :: [])) config (-1))),(var_15_1616 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 57))| _ -> (stepElt 57))| _ -> (stepElt 57))| _ -> (stepElt 57))
(*{| rule `<T>`(`<states>`(``_9=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,`<store>`(`_[_<-_]_MAP`(Rho,L,#br(C,C,#mutRef(F)))),_2,_3,_4,_5,`<indexes>`(#indexes(C,_31)))),DotVar1)``),_6,_7,_8) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_9),#match(`<state>`(_0,`<k>`(#TransferMB(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(Rho),_2,_3,_4,_5,`<indexes>`(#indexes(C,_31))),`Map:lookup`(_9,_0))),#match(DotVar1,`_[_<-undef]`(_9,_0))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(C),isInt(_31)),isInt(F)),isMap(Rho)),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(166) org.kframework.attributes.Location(Location(166,6,168,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1618) as e82 when guard < 58 -> (let e = ((evalMap'Coln'lookup((var_0_835),e82) config (-1))) in match e with 
| [Bottom] -> (stepElt 58)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1619),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferMB,(KApply1(Lbl'Hash'loc,((Int _ as var_10_1620) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_8_1621) :: [])) :: [])) :: var_5_1622)) :: []),(var_6_1623),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_7_1624) :: [])) :: []),(var_11_1625),(var_12_1626),(var_13_1627),(var_14_1628),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_9_1629) :: []),((Int _ as var_15_1630) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e82) config (-1))) in match e with 
| [Bottom] -> (stepElt 58)
| ((Map (SortStateCellMap,_,_) as var_16_1631) :: []) when ((((((true) && (true))) && (true))) && (((((((((true) && (true))) && (true))) && (true))) && (true)))) && (((compare var_4_1618 var_4_1619) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e82,(KApply9(Lbl'_LT_'state'_GT_',e82,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1622)) :: []),(var_6_1623),(KApply1(Lbl'_LT_'store'_GT_',((eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP((var_7_1624 :: []),(var_8_1621 :: []),(KApply3(Lbl'Hash'br,(var_9_1629 :: []),(var_9_1629 :: []),(KApply1(Lbl'Hash'mutRef,(var_10_1620 :: [])) :: [])) :: [])) config (-1)))) :: []),(var_11_1625),(var_12_1626),(var_13_1627),(var_14_1628),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_9_1629 :: []),(var_15_1630 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_16_1631 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 58))| _ -> (stepElt 58))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(`#void_OSL-SYNTAX`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(`#voidTy_OSL-SYNTAX`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(33) org.kframework.attributes.Location(Location(33,6,33,35)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| (var_4_1632) as e83 when guard < 59 -> (let e = ((evalMap'Coln'lookup((var_0_835),e83) config (-1))) in match e with 
| [Bottom] -> (stepElt 59)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1633),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Hash'voidTy_OSL'Hyph'SYNTAX) :: var_5_1634)) :: []),(var_6_1635),(var_7_1636),(var_8_1637),(var_9_1638),(var_10_1639),(var_11_1640),(var_12_1641)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e83) config (-1))) in match e with 
| [Bottom] -> (stepElt 59)
| ((Map (SortStateCellMap,_,_) as var_13_1642) :: []) when ((((true) && (true))) && (true)) && (((compare var_4_1632 var_4_1633) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e83,(KApply9(Lbl'_LT_'state'_GT_',e83,(KApply1(Lbl'_LT_'k'_GT_',(const'Hash'void_OSL'Hyph'SYNTAX :: var_5_1634)) :: []),(var_6_1635),(var_7_1636),(var_8_1637),(var_9_1638),(var_10_1639),(var_11_1640),(var_12_1641)) :: [])) config (-1))),(var_13_1642 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 59))| _ -> (stepElt 59))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#TransferMB(HOLE,K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#TransferMB1_`(K1)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isK(HOLE),isK(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#TransferMB) org.kframework.attributes.Location(Location(150,12,150,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1344697180) strict(1)]|}*)
| (var_4_1643) as e84 when guard < 60 -> (let e = ((evalMap'Coln'lookup((var_0_835),e84) config (-1))) in match e with 
| [Bottom] -> (stepElt 60)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1644),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1645 :: KApply1(Lbl'Hash'freezer'Hash'TransferMB1_,(var_6_1646)) :: var_7_1647)) :: []),(var_8_1648),(var_9_1649),(var_10_1650),(var_11_1651),(var_12_1652),(var_13_1653),(var_14_1654)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e84) config (-1))) in match e with 
| [Bottom] -> (stepElt 60)
| ((Map (SortStateCellMap,_,_) as var_15_1655) :: []) when ((((((true) && (true))) && (true))) && (((((true) && (true))) && (((true) && ((isTrue (evalisKResult((var_5_1645 :: [])) config (-1))))))))) && (((compare var_4_1643 var_4_1644) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e84,(KApply9(Lbl'_LT_'state'_GT_',e84,(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferMB,(var_5_1645 :: []),(var_6_1646)) :: var_7_1647)) :: []),(var_8_1648),(var_9_1649),(var_10_1650),(var_11_1651),(var_12_1652),(var_13_1653),(var_14_1654)) :: [])) config (-1))),(var_15_1655 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 60))| _ -> (stepElt 60))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Read(#borrowImmCK(L,BEG,END,L1))~>#loc(L1)~>DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#br(BEG,END,#immRef(L1))),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#read(#loc(L))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(#br(BEG,END,#immRef(L1)),`Map:lookup`(_10,L))),#match(DotVar1,`_[_<-undef]`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,L))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(END),isInt(BEG)),isInt(L)),isInt(L1))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(182) org.kframework.attributes.Location(Location(182,6,183,75)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1656) as e85 when guard < 61 -> (let e = ((evalMap'Coln'lookup((var_0_835),e85) config (-1))) in match e with 
| [Bottom] -> (stepElt 61)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1657),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1658) :: [])) :: [])) :: var_9_1659)) :: []),(var_10_1660),(KApply1(Lbl'_LT_'store'_GT_',(var_18_1661)) :: []),(var_12_1662),(var_13_1663),(var_14_1664),(var_15_1665),(var_16_1666)) :: []) -> (let e = ((evalMap'Coln'lookup((var_18_1661),(var_5_1658 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 61)
| (KApply3(Lbl'Hash'br,((Int _ as var_6_1667) :: []),((Int _ as var_7_1668) :: []),(KApply1(Lbl'Hash'immRef,((Int _ as var_8_1669) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e85) config (-1))) in match e with 
| [Bottom] -> (stepElt 61)
| ((Map (SortStateCellMap,_,_) as var_17_1670) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_18_1661),(var_5_1658 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 61)
| ((Map (SortMap,_,_) as var_11_1671) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && (true))) && (true))) && (true)))) && (((compare var_4_1657 var_4_1656) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e85,(KApply9(Lbl'_LT_'state'_GT_',e85,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(KApply4(Lbl'Hash'borrowImmCK,(var_5_1658 :: []),(var_6_1667 :: []),(var_7_1668 :: []),(var_8_1669 :: [])) :: [])) :: KApply1(Lbl'Hash'loc,(var_8_1669 :: [])) :: var_9_1659)) :: []),(var_10_1660),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_5_1658 :: []),(KApply3(Lbl'Hash'br,(var_6_1667 :: []),(var_7_1668 :: []),(KApply1(Lbl'Hash'immRef,(var_8_1669 :: [])) :: [])) :: [])) config (-1))),(var_11_1671 :: [])) config (-1)))) :: []),(var_12_1662),(var_13_1663),(var_14_1664),(var_15_1665),(var_16_1666)) :: [])) config (-1))),(var_17_1670 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 61))| _ -> (stepElt 61))| _ -> (stepElt 61))| _ -> (stepElt 61))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,`<store>`(`_Map_`(`_|->_`(L,#br(C,C,#immRef(F))),DotVar4)),_2,_3,_4,_5,`<indexes>`(#indexes(C,_37)))),DotVar1)``),_6,_7,_8) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(#TransferIB(#loc(F),#loc(L))~>DotVar3),_1,`<store>`(_9),_2,_3,_4,_5,`<indexes>`(#indexes(C,_37))),`Map:lookup`(_10,_0))),#match(_36,`Map:lookup`(_9,L))),#match(DotVar4,`_[_<-undef]`(_9,L))),#match(DotVar1,`_[_<-undef]`(_10,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(C),isInt(F)),isInt(_37)),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(161) org.kframework.attributes.Location(Location(161,6,163,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1672) as e86 when guard < 62 -> (let e = ((evalMap'Coln'lookup((var_0_835),e86) config (-1))) in match e with 
| [Bottom] -> (stepElt 62)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1673),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'TransferIB,(KApply1(Lbl'Hash'loc,((Int _ as var_9_1674) :: [])) :: []),(KApply1(Lbl'Hash'loc,((Int _ as var_7_1675) :: [])) :: [])) :: var_5_1676)) :: []),(var_6_1677),(KApply1(Lbl'_LT_'store'_GT_',(var_17_1678)) :: []),(var_11_1679),(var_12_1680),(var_13_1681),(var_14_1682),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_8_1683) :: []),((Int _ as var_15_1684) :: [])) :: [])) :: [])) :: []) -> (let e = ((evalMap'Coln'lookup((var_17_1678),(var_7_1675 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 62)
| (var_18_1685) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_17_1678),(var_7_1675 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 62)
| ((Map (SortMap,_,_) as var_10_1686) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e86) config (-1))) in match e with 
| [Bottom] -> (stepElt 62)
| ((Map (SortStateCellMap,_,_) as var_16_1687) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((true) && (true))) && (true))) && (true)))) && (((compare var_4_1672 var_4_1673) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e86,(KApply9(Lbl'_LT_'state'_GT_',e86,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1676)) :: []),(var_6_1677),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1675 :: []),(KApply3(Lbl'Hash'br,(var_8_1683 :: []),(var_8_1683 :: []),(KApply1(Lbl'Hash'immRef,(var_9_1674 :: [])) :: [])) :: [])) config (-1))),(var_10_1686 :: [])) config (-1)))) :: []),(var_11_1679),(var_12_1680),(var_13_1681),(var_14_1682),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_8_1683 :: []),(var_15_1684 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_16_1687 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 62))| _ -> (stepElt 62))| _ -> (stepElt 62))| _ -> (stepElt 62))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#expStmt(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(HOLE~>`#freezer#expStmt0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),isKResult(HOLE)))) ensures #token("true","Bool") [cool() klabel(#expStmt) org.kframework.attributes.Location(Location(51,12,51,73)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/osl-syntax.k)) productionID(1225568095) strict()]|}*)
| (var_4_1688) as e87 when guard < 63 -> (let e = ((evalMap'Coln'lookup((var_0_835),e87) config (-1))) in match e with 
| [Bottom] -> (stepElt 63)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1689),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1690 :: KApply0(Lbl'Hash'freezer'Hash'expStmt0_) :: var_6_1691)) :: []),(var_7_1692),(var_8_1693),(var_9_1694),(var_10_1695),(var_11_1696),(var_12_1697),(var_13_1698)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e87) config (-1))) in match e with 
| [Bottom] -> (stepElt 63)
| ((Map (SortStateCellMap,_,_) as var_14_1699) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1690 :: [])) config (-1)))) && (((true) && ((isTrue (evalisKResult((var_5_1690 :: [])) config (-1))))))))) && (((compare var_4_1689 var_4_1688) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e87,(KApply9(Lbl'_LT_'state'_GT_',e87,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'expStmt,(var_5_1690 :: [])) :: var_6_1691)) :: []),(var_7_1692),(var_8_1693),(var_9_1694),(var_10_1695),(var_11_1696),(var_12_1697),(var_13_1698)) :: [])) config (-1))),(var_14_1699 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 63))| _ -> (stepElt 63))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#Read(#read(#loc(L)))~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Read(#loc(L))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isInt(L)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(188) org.kframework.attributes.Location(Location(188,6,188,46)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1700) as e88 when guard < 64 -> (let e = ((evalMap'Coln'lookup((var_0_835),e88) config (-1))) in match e with 
| [Bottom] -> (stepElt 64)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1701),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(KApply1(Lbl'Hash'loc,((Int _ as var_5_1702) :: [])) :: [])) :: var_6_1703)) :: []),(var_7_1704),(var_8_1705),(var_9_1706),(var_10_1707),(var_11_1708),(var_12_1709),(var_13_1710)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e88) config (-1))) in match e with 
| [Bottom] -> (stepElt 64)
| ((Map (SortStateCellMap,_,_) as var_14_1711) :: []) when ((((((true) && (true))) && (true))) && (true)) && (((compare var_4_1701 var_4_1700) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e88,(KApply9(Lbl'_LT_'state'_GT_',e88,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'Read,(KApply1(Lbl'Hash'read,(KApply1(Lbl'Hash'loc,(var_5_1702 :: [])) :: [])) :: [])) :: var_6_1703)) :: []),(var_7_1704),(var_8_1705),(var_9_1706),(var_10_1707),(var_11_1708),(var_12_1709),(var_13_1710)) :: [])) config (-1))),(var_14_1711 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 64))| _ -> (stepElt 64))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(B~>`#unsafeBlockend_BLOCK`(.KList)~>DotVar3),_1,_2,_3,_4,_5,`<unsafe-mode>`(#token("true","Bool")),_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(`unsafe_;_OSL-SYNTAX`(B)~>DotVar3),_1,_2,_3,_4,_5,`<unsafe-mode>`(FLAG),_6),`Map:lookup`(_10,_0))),#match(DotVar1,`_[_<-undef]`(_10,_0))),`_andBool_`(isBool(FLAG),isBlock(B))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(36) org.kframework.attributes.Location(Location(36,6,37,52)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_1712) as e89 when guard < 65 -> (let e = ((evalMap'Coln'lookup((var_0_835),e89) config (-1))) in match e with 
| [Bottom] -> (stepElt 65)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1713),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lblunsafe_'SCln'_OSL'Hyph'SYNTAX,(var_5_1714 :: [])) :: var_6_1715)) :: []),(var_7_1716),(var_8_1717),(var_9_1718),(var_10_1719),(var_11_1720),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as var_14_1721) :: [])) :: []),(var_12_1722)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e89) config (-1))) in match e with 
| [Bottom] -> (stepElt 65)
| ((Map (SortStateCellMap,_,_) as var_13_1723) :: []) when ((((((true) && (true))) && (true))) && (((true) && ((isTrue (evalisBlock((var_5_1714 :: [])) config (-1))))))) && (((compare var_4_1712 var_4_1713) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e89,(KApply9(Lbl'_LT_'state'_GT_',e89,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1714 :: const'Hash'unsafeBlockend_BLOCK :: var_6_1715)) :: []),(var_7_1716),(var_8_1717),(var_9_1718),(var_10_1719),(var_11_1720),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool true) :: [])) :: []),(var_12_1722)) :: [])) config (-1))),(var_13_1723 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 65))| _ -> (stepElt 65))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(`newResource(_)_OSL-SYNTAX`(Ps)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(`newResource(_)_OSL-SYNTAX`(Ps))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isProps(Ps)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(39) org.kframework.attributes.Location(Location(39,6,39,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1724) as e90 when guard < 66 -> (let e = ((evalMap'Coln'lookup((var_0_835),e90) config (-1))) in match e with 
| [Bottom] -> (stepElt 66)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1725),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(KApply1(LblnewResource'LPar'_'RPar'_OSL'Hyph'SYNTAX,(var_5_1726 :: [])) :: [])) :: var_6_1727)) :: []),(var_7_1728),(var_8_1729),(var_9_1730),(var_10_1731),(var_11_1732),(var_12_1733),(var_13_1734)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e90) config (-1))) in match e with 
| [Bottom] -> (stepElt 66)
| ((Map (SortStateCellMap,_,_) as var_14_1735) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisProps((var_5_1726 :: [])) config (-1))))) && (((compare var_4_1725 var_4_1724) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e90,(KApply9(Lbl'_LT_'state'_GT_',e90,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(LblnewResource'LPar'_'RPar'_OSL'Hyph'SYNTAX,(var_5_1726 :: [])) :: var_6_1727)) :: []),(var_7_1728),(var_8_1729),(var_9_1730),(var_10_1731),(var_11_1732),(var_12_1733),(var_13_1734)) :: [])) config (-1))),(var_14_1735 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 66))| _ -> (stepElt 66))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(`#blockend_BLOCK`(.KList)~>DotVar3),`<env>`(`_Map_`(`_|->_`(X,L),DotVar4)),`<store>`(`_Map_`(`.Map`(.KList),DotVar5)),`<stack>`(`_List_`(`.List`(.KList),DotVar6)),_1,_2,_3,_4)),DotVar1)``),_5,_6,_7) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(`#blockend_BLOCK`(.KList)~>DotVar3),`<env>`(_8),`<store>`(_9),`<stack>`(`_List_`(`ListItem`(X),DotVar6)),_1,_2,_3,_4),`Map:lookup`(_10,_0))),#match(DotVar4,`_[_<-undef]`(_8,X))),#match(L,`Map:lookup`(_8,X))),#match(DotVar1,`_[_<-undef]`(_10,_0))),#match(_17,`Map:lookup`(_9,L))),#match(DotVar5,`_[_<-undef]`(_9,L))),`_andBool_`(isId(X),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(26) org.kframework.attributes.Location(Location(26,6,29,52)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_1736) as e91 when guard < 67 -> (let e = ((evalMap'Coln'lookup((var_0_835),e91) config (-1))) in match e with 
| [Bottom] -> (stepElt 67)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1737),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Hash'blockend_BLOCK) :: var_5_1738)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_16_1739)) :: []),(KApply1(Lbl'_LT_'store'_GT_',(var_17_1740)) :: []),(KApply1(Lbl'_LT_'stack'_GT_',((List (SortList, Lbl_List_, (var_6_1741 :: []) :: var_10_1742)) :: [])) :: []),(var_11_1743),(var_12_1744),(var_13_1745),(var_14_1746)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_16_1739),(var_6_1741 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 67)
| ((Map (SortMap,_,_) as var_8_1747) :: []) -> (let e = ((evalMap'Coln'lookup((var_16_1739),(var_6_1741 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 67)
| ((Int _ as var_7_1748) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e91) config (-1))) in match e with 
| [Bottom] -> (stepElt 67)
| ((Map (SortStateCellMap,_,_) as var_15_1749) :: []) -> (let e = ((evalMap'Coln'lookup((var_17_1740),(var_7_1748 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 67)
| (var_18_1750) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_17_1740),(var_7_1748 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 67)
| ((Map (SortMap,_,_) as var_9_1751) :: []) when ((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (evalisId((var_6_1741 :: [])) config (-1)))) && (true)))) && (((compare var_4_1736 var_4_1737) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e91,(KApply9(Lbl'_LT_'state'_GT_',e91,(KApply1(Lbl'_LT_'k'_GT_',(const'Hash'blockend_BLOCK :: var_5_1738)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_6_1741 :: []),(var_7_1748 :: [])) config (-1))),(var_8_1747 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((Lazy.force const'Stop'Map)),(var_9_1751 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'stack'_GT_',((eval_List_(((Lazy.force const'Stop'List)),((List (SortList, Lbl_List_, var_10_1742)) :: [])) config (-1)))) :: []),(var_11_1743),(var_12_1744),(var_13_1745),(var_14_1746)) :: [])) config (-1))),(var_15_1749 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 67))| _ -> (stepElt 67))| _ -> (stepElt 67))| _ -> (stepElt 67))| _ -> (stepElt 67))| _ -> (stepElt 67))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#ref(L)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#loc(L)~>#ref(LF,T)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isLifetime(LF),isType(T)),isInt(L))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(44) org.kframework.attributes.Location(Location(44,6,44,70)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
| (var_4_1752) as e92 when guard < 68 -> (let e = ((evalMap'Coln'lookup((var_0_835),e92) config (-1))) in match e with 
| [Bottom] -> (stepElt 68)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1753),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loc,((Int _ as var_5_1754) :: [])) :: KApply2(Lbl'Hash'ref,(var_15_1755 :: []),(var_16_1756 :: [])) :: var_6_1757)) :: []),(var_7_1758),(var_8_1759),(var_9_1760),(var_10_1761),(var_11_1762),(var_12_1763),(var_13_1764)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e92) config (-1))) in match e with 
| [Bottom] -> (stepElt 68)
| ((Map (SortStateCellMap,_,_) as var_14_1765) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisLifetime((var_15_1755 :: [])) config (-1)))) && ((isTrue (evalisType((var_16_1756 :: [])) config (-1)))))) && (true)))) && (((compare var_4_1752 var_4_1753) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e92,(KApply9(Lbl'_LT_'state'_GT_',e92,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'ref,(var_5_1754 :: [])) :: var_6_1757)) :: []),(var_7_1758),(var_8_1759),(var_9_1760),(var_10_1761),(var_11_1762),(var_12_1763),(var_13_1764)) :: [])) config (-1))),(var_14_1765 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 68))| _ -> (stepElt 68))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,_5,_6,`<indexes>`(#indexes(`_+Int__INT`(C,#token("1","Int")),_41)))),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(`#increaseIndex_OSL`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,`<indexes>`(#indexes(C,_41))),`Map:lookup`(_10,_0))),#match(DotVar1,`_[_<-undef]`(_10,_0))),`_andBool_`(isInt(_41),isInt(C))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(74) org.kframework.attributes.Location(Location(74,6,75,63)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1766) as e93 when guard < 69 -> (let e = ((evalMap'Coln'lookup((var_0_835),e93) config (-1))) in match e with 
| [Bottom] -> (stepElt 69)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1767),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Hash'increaseIndex_OSL) :: var_5_1768)) :: []),(var_6_1769),(var_7_1770),(var_8_1771),(var_9_1772),(var_10_1773),(var_11_1774),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_12_1775) :: []),((Int _ as var_13_1776) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e93) config (-1))) in match e with 
| [Bottom] -> (stepElt 69)
| ((Map (SortStateCellMap,_,_) as var_14_1777) :: []) when ((((((true) && (true))) && (true))) && (((true) && (true)))) && (((compare var_4_1766 var_4_1767) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e93,(KApply9(Lbl'_LT_'state'_GT_',e93,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1768)) :: []),(var_6_1769),(var_7_1770),(var_8_1771),(var_9_1772),(var_10_1773),(var_11_1774),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((eval_'Plus'Int__INT((var_12_1775 :: []),((Lazy.force int1) :: [])) config (-1))),(var_13_1776 :: [])) :: [])) :: [])) :: [])) config (-1))),(var_14_1777 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 69))| _ -> (stepElt 69))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#lvDref(#lv(E))~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#lv(`*__OSL-SYNTAX`(E))~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isExp(E)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(255) org.kframework.attributes.Location(Location(255,6,255,39)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1778) as e94 when guard < 70 -> (let e = ((evalMap'Coln'lookup((var_0_835),e94) config (-1))) in match e with 
| [Bottom] -> (stepElt 70)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1779),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lv,(KApply1(Lbl'Star'__OSL'Hyph'SYNTAX,(var_5_1780 :: [])) :: [])) :: var_6_1781)) :: []),(var_7_1782),(var_8_1783),(var_9_1784),(var_10_1785),(var_11_1786),(var_12_1787),(var_13_1788)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e94) config (-1))) in match e with 
| [Bottom] -> (stepElt 70)
| ((Map (SortStateCellMap,_,_) as var_14_1789) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisExp((var_5_1780 :: [])) config (-1))))) && (((compare var_4_1778 var_4_1779) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e94,(KApply9(Lbl'_LT_'state'_GT_',e94,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'lvDref,(KApply1(Lbl'Hash'lv,(var_5_1780 :: [])) :: [])) :: var_6_1781)) :: []),(var_7_1782),(var_8_1783),(var_9_1784),(var_10_1785),(var_11_1786),(var_12_1787),(var_13_1788)) :: [])) config (-1))),(var_14_1789 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 70))| _ -> (stepElt 70))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,`<store>`(`_Map_`(`_|->_`(F,`#uninit_OSL-SYNTAX`(.KList)),DotVar4)),_2,_3,_4,_5,_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#uninitialize(#loc(F))~>DotVar3),_1,`<store>`(_10),_2,_3,_4,_5,_6),`Map:lookup`(_11,_0))),#match(DotVar4,`_[_<-undef]`(_10,F))),#match(_32,`Map:lookup`(_10,F))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isInt(F)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(170) org.kframework.attributes.Location(Location(170,6,171,51)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1790) as e95 when guard < 71 -> (let e = ((evalMap'Coln'lookup((var_0_835),e95) config (-1))) in match e with 
| [Bottom] -> (stepElt 71)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1791),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'uninitialize,(KApply1(Lbl'Hash'loc,((Int _ as var_7_1792) :: [])) :: [])) :: var_5_1793)) :: []),(var_6_1794),(KApply1(Lbl'_LT_'store'_GT_',(var_15_1795)) :: []),(var_9_1796),(var_10_1797),(var_11_1798),(var_12_1799),(var_13_1800)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_15_1795),(var_7_1792 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 71)
| ((Map (SortMap,_,_) as var_8_1801) :: []) -> (let e = ((evalMap'Coln'lookup((var_15_1795),(var_7_1792 :: [])) config (-1))) in match e with 
| [Bottom] -> (stepElt 71)
| (var_16_1802) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e95) config (-1))) in match e with 
| [Bottom] -> (stepElt 71)
| ((Map (SortStateCellMap,_,_) as var_14_1803) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true)) && (((compare var_4_1790 var_4_1791) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e95,(KApply9(Lbl'_LT_'state'_GT_',e95,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1793)) :: []),(var_6_1794),(KApply1(Lbl'_LT_'store'_GT_',((eval_Map_(((eval_'PipeHyph_GT_'_((var_7_1792 :: []),(const'Hash'uninit_OSL'Hyph'SYNTAX :: [])) config (-1))),(var_8_1801 :: [])) config (-1)))) :: []),(var_9_1796),(var_10_1797),(var_11_1798),(var_12_1799),(var_13_1800)) :: [])) config (-1))),(var_14_1803 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 71))| _ -> (stepElt 71))| _ -> (stepElt 71))| _ -> (stepElt 71))
(*{| rule `<T>`(`<states>`(``_9=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(Ss~>`#blockend_BLOCK`(.KList)~>DotVar3),`<env>`(ENV),_1,`<stack>`(`_List_`(`ListItem`(ENV),DotVar4)),_2,_3,_4,_5)),DotVar1)``),_6,_7,_8) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_9),#match(`<state>`(_0,`<k>`(#block(Ss)~>DotVar3),`<env>`(ENV),_1,`<stack>`(DotVar4),_2,_3,_4,_5),`Map:lookup`(_9,_0))),#match(DotVar1,`_[_<-undef]`(_9,_0))),`_andBool_`(isMap(ENV),isStmts(Ss))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(14) org.kframework.attributes.Location(Location(14,6,16,49)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_1804) as e96 when guard < 72 -> (let e = ((evalMap'Coln'lookup((var_0_835),e96) config (-1))) in match e with 
| [Bottom] -> (stepElt 72)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1805),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'block,(var_5_1806 :: [])) :: var_6_1807)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_7_1808) :: [])) :: []),(var_8_1809),(KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as var_9_1810) :: [])) :: []),(var_10_1811),(var_11_1812),(var_12_1813),(var_13_1814)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e96) config (-1))) in match e with 
| [Bottom] -> (stepElt 72)
| ((Map (SortStateCellMap,_,_) as var_14_1815) :: []) when ((((((true) && (true))) && (true))) && (((true) && ((isTrue (evalisStmts((var_5_1806 :: [])) config (-1))))))) && (((compare var_4_1804 var_4_1805) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e96,(KApply9(Lbl'_LT_'state'_GT_',e96,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1806 :: const'Hash'blockend_BLOCK :: var_6_1807)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_7_1808 :: [])) :: []),(var_8_1809),(KApply1(Lbl'_LT_'stack'_GT_',((eval_List_(((evalListItem((var_7_1808 :: [])) config (-1))),(var_9_1810 :: [])) config (-1)))) :: []),(var_10_1811),(var_11_1812),(var_12_1813),(var_13_1814)) :: [])) config (-1))),(var_14_1815 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 72))| _ -> (stepElt 72))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezerval0_`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(val(HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(isExp(HOLE),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(val) org.kframework.attributes.Location(Location(52,12,52,56)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/osl-syntax.k)) productionID(1664598529) strict()]|}*)
| (var_4_1816) as e97 when guard < 73 -> (let e = ((evalMap'Coln'lookup((var_0_835),e97) config (-1))) in match e with 
| [Bottom] -> (stepElt 73)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1817),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lblval,(var_5_1818 :: [])) :: var_6_1819)) :: []),(var_7_1820),(var_8_1821),(var_9_1822),(var_10_1823),(var_11_1824),(var_12_1825),(var_13_1826)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e97) config (-1))) in match e with 
| [Bottom] -> (stepElt 73)
| ((Map (SortStateCellMap,_,_) as var_14_1827) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisExp((var_5_1818 :: [])) config (-1)))) && (((true) && ((not ((isTrue (evalisKResult((var_5_1818 :: [])) config (-1))))))))))) && (((compare var_4_1817 var_4_1816) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e97,(KApply9(Lbl'_LT_'state'_GT_',e97,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1818 :: const'Hash'freezerval0_ :: var_6_1819)) :: []),(var_7_1820),(var_8_1821),(var_9_1822),(var_10_1823),(var_11_1824),(var_12_1825),(var_13_1826)) :: [])) config (-1))),(var_14_1827 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 73))| _ -> (stepElt 73))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(V~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(V~>`.List{"___OSL-SYNTAX"}`(.KList)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isValue(V)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(24) org.kframework.attributes.Location(Location(24,6,24,28)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
| (var_4_1828) as e98 when guard < 74 -> (let e = ((evalMap'Coln'lookup((var_0_835),e98) config (-1))) in match e with 
| [Bottom] -> (stepElt 74)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1829),(KApply1(Lbl'_LT_'k'_GT_',(var_5_1830 :: KApply0(Lbl'Stop'List'LBraQuot'___OSL'Hyph'SYNTAX'QuotRBra') :: var_6_1831)) :: []),(var_7_1832),(var_8_1833),(var_9_1834),(var_10_1835),(var_11_1836),(var_12_1837),(var_13_1838)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e98) config (-1))) in match e with 
| [Bottom] -> (stepElt 74)
| ((Map (SortStateCellMap,_,_) as var_14_1839) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisValue((var_5_1830 :: [])) config (-1))))) && (((compare var_4_1828 var_4_1829) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e98,(KApply9(Lbl'_LT_'state'_GT_',e98,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1830 :: var_6_1831)) :: []),(var_7_1832),(var_8_1833),(var_9_1834),(var_10_1835),(var_11_1836),(var_12_1837),(var_13_1838)) :: [])) config (-1))),(var_14_1839 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 74))| _ -> (stepElt 74))
(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(HOLE~>`#freezer#Transfer0_`(K0)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(#Transfer(K0,HOLE)~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),`_andBool_`(`_andBool_`(isExp(HOLE),isExp(K0)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE))))) ensures #token("true","Bool") [heat() klabel(#Transfer) org.kframework.attributes.Location(Location(36,12,36,40)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k)) productionID(1920907467) strict()]|}*)
| (var_4_1840) as e99 when guard < 75 -> (let e = ((evalMap'Coln'lookup((var_0_835),e99) config (-1))) in match e with 
| [Bottom] -> (stepElt 75)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1841),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'Transfer,(var_6_1842 :: []),(var_5_1843 :: [])) :: var_7_1844)) :: []),(var_8_1845),(var_9_1846),(var_10_1847),(var_11_1848),(var_12_1849),(var_13_1850),(var_14_1851)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e99) config (-1))) in match e with 
| [Bottom] -> (stepElt 75)
| ((Map (SortStateCellMap,_,_) as var_15_1852) :: []) when ((((((true) && (true))) && (true))) && ((((((isTrue (evalisExp((var_5_1843 :: [])) config (-1)))) && ((isTrue (evalisExp((var_6_1842 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((var_5_1843 :: [])) config (-1))))))))))) && (((compare var_4_1840 var_4_1841) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e99,(KApply9(Lbl'_LT_'state'_GT_',e99,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1843 :: KApply1(Lbl'Hash'freezer'Hash'Transfer0_,(var_6_1842 :: [])) :: var_7_1844)) :: []),(var_8_1845),(var_9_1846),(var_10_1847),(var_11_1848),(var_12_1849),(var_13_1850),(var_14_1851)) :: [])) config (-1))),(var_15_1852 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 75))| _ -> (stepElt 75))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar3),_1,_2,_3,_4,_5,`<unsafe-mode>`(#token("false","Bool")),_6)),DotVar1)``),_7,_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(`#unsafeBlockend_BLOCK`(.KList)~>DotVar3),_1,_2,_3,_4,_5,`<unsafe-mode>`(FLAG),_6),`Map:lookup`(_10,_0))),#match(DotVar1,`_[_<-undef]`(_10,_0))),isBool(FLAG)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(39) org.kframework.attributes.Location(Location(39,6,40,53)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/block.k))]|}*)
| (var_4_1853) as e100 when guard < 76 -> (let e = ((evalMap'Coln'lookup((var_0_835),e100) config (-1))) in match e with 
| [Bottom] -> (stepElt 76)
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1854),(KApply1(Lbl'_LT_'k'_GT_',(KApply0(Lbl'Hash'unsafeBlockend_BLOCK) :: var_5_1855)) :: []),(var_6_1856),(var_7_1857),(var_8_1858),(var_9_1859),(var_10_1860),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as var_13_1861) :: [])) :: []),(var_11_1862)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_835),e100) config (-1))) in match e with 
| [Bottom] -> (stepElt 76)
| ((Map (SortStateCellMap,_,_) as var_12_1863) :: []) when ((((((true) && (true))) && (true))) && (true)) && (((compare var_4_1853 var_4_1854) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e100,(KApply9(Lbl'_LT_'state'_GT_',e100,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1855)) :: []),(var_6_1856),(var_7_1857),(var_8_1858),(var_9_1859),(var_10_1860),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool false) :: [])) :: []),(var_11_1862)) :: [])) config (-1))),(var_12_1863 :: [])) config (-1)))) :: []),(var_1_836),(var_2_837),(var_3_838)) :: [])), (StepFunc step))| _ -> (stepElt 76))| _ -> (stepElt 76))
| _ -> (interned_bottom, (StepFunc step))) else (result, f) in stepElt guard) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 77) else (choice, f)| _ -> (lookups_step c config 77))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_1864)) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',((Int _ as var_1_1865) :: [])) :: []),(var_2_1866),(var_3_1867)) :: []) when guard < 81 -> (match (var_0_1864) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> let rec stepElt = fun guard -> if result == interned_bottom then (match e with (*{| rule `<T>`(`<states>`(``_16=>`_StateCellMap_`(`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(Rest),_1,`<store>`(STORE),_2,_3,_4,_5,_6)),`.StateCellMap`(.KList)),DotVar1)``),`<nstate>`(``NS=>`_-Int__INT`(NS,#token("1","Int"))``),_14,_15) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_16),#mapChoice(_7,_16)),#match(`<state>`(_0,`<k>`(#loopSep(I)~>Rest),_1,`<store>`(STORE),_2,_3,_4,_5,_6),`Map:lookup`(_16,_0))),#match(`<state>`(_7,`<k>`(#loopEnd(I2)),_8,`<store>`(STORE2),_9,_10,_11,_12,_13),`Map:lookup`(_16,_7))),#match(DotVar1,`_[_<-undef]`(`_[_<-undef]`(_16,_0),_7))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(NS),isInt(I)),isK(Rest)),isInt(I2)),isMap(STORE)),isMap(STORE2)),`_andBool_`(`_==Bool__BOOL`(#IsMoveOccurred(STORE,STORE2),#token("true","Bool")),`_==Int_`(I,I2)))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(120) org.kframework.attributes.Location(Location(120,6,131,80)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_4_1868) as e102 when guard < 78 -> (match (var_0_1864) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_14_1869) as e103 -> (let e = ((evalMap'Coln'lookup((var_0_1864),e102) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1870),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loopSep,((Int _ as var_15_1871) :: [])) :: var_5_1872)) :: []),(var_6_1873),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_7_1874) :: [])) :: []),(var_8_1875),(var_9_1876),(var_10_1877),(var_11_1878),(var_12_1879)) :: []) -> (let e = ((evalMap'Coln'lookup((var_0_1864),e103) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_14_1880),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loopEnd,((Int _ as var_16_1881) :: [])) :: [])) :: []),(var_17_1882),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_18_1883) :: [])) :: []),(var_19_1884),(var_20_1885),(var_21_1886),(var_22_1887),(var_23_1888)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'(((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1864),e102) config (-1))),e103) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as var_13_1889) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && (((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && ((((isTrue (eval_'EqlsEqls'Bool__BOOL(((eval'Hash'IsMoveOccurred((var_7_1874 :: []),(var_18_1883 :: [])) config (-1))),((Bool true) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_15_1871 :: []),(var_16_1881 :: [])) config (-1))))))))) && (((compare var_14_1869 var_14_1880) = 0) && ((compare var_4_1868 var_4_1870) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((eval_StateCellMap_(((evalStateCellMapItem(e102,(KApply9(Lbl'_LT_'state'_GT_',e102,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1872)) :: []),(var_6_1873),(KApply1(Lbl'_LT_'store'_GT_',(var_7_1874 :: [])) :: []),(var_8_1875),(var_9_1876),(var_10_1877),(var_11_1878),(var_12_1879)) :: [])) config (-1))),((Lazy.force const'Stop'StateCellMap))) config (-1))),(var_13_1889 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',((eval_'Hyph'Int__INT((var_1_1865 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_2_1866),(var_3_1867)) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (stepElt 78) else (choice, f)| _ -> (stepElt 78))
(*{| rule `<T>`(`<states>`(``_2=>`_StateCellMap_`(`_StateCellMap_`(`StateCellMapItem`(`<index>`(NS),`<state>`(`<index>`(NS),`<k>`(#evaluate(B)~>#loopEnd(NS)),`<env>`(ENV),`<store>`(STORE),`<stack>`(STACK),`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(A,C)))),`StateCellMapItem`(DotVar2,`<state>`(DotVar2,`<k>`(#loopSep(NS)~>B~>Rest),`<env>`(ENV),`<store>`(STORE),`<stack>`(STACK),`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(A,C))))),DotVar1)``),`<nstate>`(``NS=>`_+Int__INT`(NS,#token("1","Int"))``),_0,_1) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(DotVar2,_2),#match(`<state>`(DotVar2,`<k>`(#repeat(B)~>Rest),`<env>`(ENV),`<store>`(STORE),`<stack>`(STACK),`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE_BLOCK),`<indexes>`(#indexes(A,C))),`Map:lookup`(_2,DotVar2))),#match(DotVar1,`_[_<-undef]`(_2,DotVar2))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(TIMER),isSet(WRITE)),isInt(A)),isList(STACK)),isBool(UNSAFE_BLOCK)),isInt(NS)),isInt(C)),isMap(ENV)),isK(Rest)),isMap(STORE)),isBlock(B))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(82) org.kframework.attributes.Location(Location(82,6,106,7)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_13_1890) as e104 when guard < 79 -> (let e = ((evalMap'Coln'lookup((var_0_1864),e104) config (-1))) in match e with 
| [Bottom] -> (stepElt 79)
| (KApply9(Lbl'_LT_'state'_GT_',(var_13_1891),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'repeat,(var_4_1892 :: [])) :: var_14_1893)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_5_1894) :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_6_1895) :: [])) :: []),(KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as var_7_1896) :: [])) :: []),(KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as var_8_1897) :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_9_1898) :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as var_10_1899) :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_11_1900) :: []),((Int _ as var_12_1901) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1864),e104) config (-1))) in match e with 
| [Bottom] -> (stepElt 79)
| ((Map (SortStateCellMap,_,_) as var_15_1902) :: []) when ((((((true) && (true))) && (true))) && (((((((((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (evalisBlock((var_4_1892 :: [])) config (-1))))))) && (((compare var_13_1891 var_13_1890) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((eval_StateCellMap_(((evalStateCellMapItem((KApply1(Lbl'_LT_'index'_GT_',(var_1_1865 :: [])) :: []),(KApply9(Lbl'_LT_'state'_GT_',(KApply1(Lbl'_LT_'index'_GT_',(var_1_1865 :: [])) :: []),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'evaluate,(var_4_1892 :: [])) :: KApply1(Lbl'Hash'loopEnd,(var_1_1865 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_5_1894 :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',(var_6_1895 :: [])) :: []),(KApply1(Lbl'_LT_'stack'_GT_',(var_7_1896 :: [])) :: []),(KApply1(Lbl'_LT_'write'_GT_',(var_8_1897 :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_9_1898 :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',(var_10_1899 :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_11_1900 :: []),(var_12_1901 :: [])) :: [])) :: [])) :: [])) config (-1))),((evalStateCellMapItem(e104,(KApply9(Lbl'_LT_'state'_GT_',e104,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'loopSep,(var_1_1865 :: [])) :: var_4_1892 :: var_14_1893)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_5_1894 :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',(var_6_1895 :: [])) :: []),(KApply1(Lbl'_LT_'stack'_GT_',(var_7_1896 :: [])) :: []),(KApply1(Lbl'_LT_'write'_GT_',(var_8_1897 :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_9_1898 :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',(var_10_1899 :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_11_1900 :: []),(var_12_1901 :: [])) :: [])) :: [])) :: [])) config (-1)))) config (-1))),(var_15_1902 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',((eval_'Plus'Int__INT((var_1_1865 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_2_1866),(var_3_1867)) :: [])), (StepFunc step))| _ -> (stepElt 79))| _ -> (stepElt 79))
(*{| rule `<T>`(`<states>`(``_2=>`_StateCellMap_`(`_StateCellMap_`(`StateCellMapItem`(`<index>`(NS),`<state>`(`<index>`(NS),`<k>`(B~>Rest),`<env>`(ENV),`<store>`(STORE),`<stack>`(STACK),`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE),`<indexes>`(#indexes(A,C)))),`StateCellMapItem`(DotVar2,`<state>`(DotVar2,`<k>`(#secondBranch(Bs)~>Rest),`<env>`(ENV),`<store>`(STORE),`<stack>`(STACK),`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE),`<indexes>`(#indexes(A,C))))),DotVar1)``),`<nstate>`(``NS=>`_+Int__INT`(NS,#token("1","Int"))``),_0,_1) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(DotVar2,_2),#match(`<state>`(DotVar2,`<k>`(#secondBranch(`_,__OSL-SYNTAX`(B,Bs))~>Rest),`<env>`(ENV),`<store>`(STORE),`<stack>`(STACK),`<write>`(WRITE),`<timer>`(TIMER),`<unsafe-mode>`(UNSAFE),`<indexes>`(#indexes(A,C))),`Map:lookup`(_2,DotVar2))),#match(DotVar1,`_[_<-undef]`(_2,DotVar2))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isBlocks(Bs),isInt(A)),isInt(TIMER)),isSet(WRITE)),isList(STACK)),isInt(NS)),isInt(C)),isMap(ENV)),isBool(UNSAFE)),isK(Rest)),isMap(STORE)),isBlock(B))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(21) org.kframework.attributes.Location(Location(21,6,42,7)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_14_1903) as e105 when guard < 80 -> (let e = ((evalMap'Coln'lookup((var_0_1864),e105) config (-1))) in match e with 
| [Bottom] -> (stepElt 80)
| (KApply9(Lbl'_LT_'state'_GT_',(var_14_1904),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'secondBranch,(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(var_4_1905 :: []),(var_15_1906 :: [])) :: [])) :: var_5_1907)) :: []),(KApply1(Lbl'_LT_'env'_GT_',((Map (SortMap,_,_) as var_6_1908) :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',((Map (SortMap,_,_) as var_7_1909) :: [])) :: []),(KApply1(Lbl'_LT_'stack'_GT_',((List (SortList,_,_) as var_8_1910) :: [])) :: []),(KApply1(Lbl'_LT_'write'_GT_',((Set (SortSet,_,_) as var_9_1911) :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',((Int _ as var_10_1912) :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',((Bool _ as var_11_1913) :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,((Int _ as var_12_1914) :: []),((Int _ as var_13_1915) :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1864),e105) config (-1))) in match e with 
| [Bottom] -> (stepElt 80)
| ((Map (SortStateCellMap,_,_) as var_16_1916) :: []) when ((((((true) && (true))) && (true))) && ((((((((((((((((((((((((isTrue (evalisBlocks((var_15_1906 :: [])) config (-1)))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (evalisBlock((var_4_1905 :: [])) config (-1))))))) && (((compare var_14_1903 var_14_1904) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((eval_StateCellMap_(((evalStateCellMapItem((KApply1(Lbl'_LT_'index'_GT_',(var_1_1865 :: [])) :: []),(KApply9(Lbl'_LT_'state'_GT_',(KApply1(Lbl'_LT_'index'_GT_',(var_1_1865 :: [])) :: []),(KApply1(Lbl'_LT_'k'_GT_',(var_4_1905 :: var_5_1907)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_6_1908 :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',(var_7_1909 :: [])) :: []),(KApply1(Lbl'_LT_'stack'_GT_',(var_8_1910 :: [])) :: []),(KApply1(Lbl'_LT_'write'_GT_',(var_9_1911 :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_10_1912 :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',(var_11_1913 :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_12_1914 :: []),(var_13_1915 :: [])) :: [])) :: [])) :: [])) config (-1))),((evalStateCellMapItem(e105,(KApply9(Lbl'_LT_'state'_GT_',e105,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'secondBranch,(var_15_1906 :: [])) :: var_5_1907)) :: []),(KApply1(Lbl'_LT_'env'_GT_',(var_6_1908 :: [])) :: []),(KApply1(Lbl'_LT_'store'_GT_',(var_7_1909 :: [])) :: []),(KApply1(Lbl'_LT_'stack'_GT_',(var_8_1910 :: [])) :: []),(KApply1(Lbl'_LT_'write'_GT_',(var_9_1911 :: [])) :: []),(KApply1(Lbl'_LT_'timer'_GT_',(var_10_1912 :: [])) :: []),(KApply1(Lbl'_LT_'unsafe'Hyph'mode'_GT_',(var_11_1913 :: [])) :: []),(KApply1(Lbl'_LT_'indexes'_GT_',(KApply2(Lbl'Hash'indexes,(var_12_1914 :: []),(var_13_1915 :: [])) :: [])) :: [])) :: [])) config (-1)))) config (-1))),(var_16_1916 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',((eval_'Plus'Int__INT((var_1_1865 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_2_1866),(var_3_1867)) :: [])), (StepFunc step))| _ -> (stepElt 80))| _ -> (stepElt 80))
(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`.StateCellMap`(.KList),DotVar1)``),`<nstate>`(``NS=>`_-Int__INT`(NS,#token("1","Int"))``),_8,_9) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(.K),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_10,_0))),#match(DotVar1,`_[_<-undef]`(_10,_0))),`_andBool_`(isInt(NS),`_=/=Int__INT`(NS,#token("1","Int")))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(45) org.kframework.attributes.Location(Location(45,6,54,26)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
| (var_5_1917) as e106 when guard < 81 -> (let e = ((evalMap'Coln'lookup((var_0_1864),e106) config (-1))) in match e with 
| [Bottom] -> (stepElt 81)
| (KApply9(Lbl'_LT_'state'_GT_',(var_5_1918),(KApply1(Lbl'_LT_'k'_GT_',([])) :: []),(var_6_1919),(var_7_1920),(var_8_1921),(var_9_1922),(var_10_1923),(var_11_1924),(var_12_1925)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1864),e106) config (-1))) in match e with 
| [Bottom] -> (stepElt 81)
| ((Map (SortStateCellMap,_,_) as var_4_1926) :: []) when ((((((true) && (true))) && (true))) && (((true) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((var_1_1865 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare var_5_1917 var_5_1918) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((Lazy.force const'Stop'StateCellMap)),(var_4_1926 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',((eval_'Hyph'Int__INT((var_1_1865 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(var_2_1866),(var_3_1867)) :: [])), (StepFunc step))| _ -> (stepElt 81))| _ -> (stepElt 81))
| _ -> (interned_bottom, (StepFunc step))) else (result, f) in stepElt guard) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 81) else (choice, f)| _ -> (lookups_step c config 81))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_1927)) :: []),(var_1_1928),(var_2_1929),(KApply1(Lbl'_LT_'funDefs'_GT_',(var_3_1930)) :: [])) :: []) when guard < 82(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#block(#bindParams(Ps,Es,SS))~>T~>DotVar5),_1,_2,_3,_4,_5,_6,_7)),DotVar3)``),_8,_9,`<funDefs>`(_11)) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(#FnCall(F,Es)~>DotVar5),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_10,_0))),#match(DotVar3,`_[_<-undef]`(_10,_0))),#match(`<funDef>`(`<fname>`(F),`<fparams>`(Ps),`<fret>`(T),`<fbody>`(#block(SS))),`Map:lookup`(_11,`<fname>`(F)))),#match(DotVar1,`_[_<-undef]`(_11,`<fname>`(F)))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isStmts(SS),isExps(Es)),isParameters(Ps)),isType(T)),isId(F))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(25) org.kframework.attributes.Location(Location(25,6,29,27)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
 -> (match (var_0_1927) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_4_1931) as e107 -> (let e = ((evalMap'Coln'lookup((var_0_1927),e107) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1932),(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'Hash'FnCall,(var_18_1933 :: []),(var_6_1934 :: [])) :: var_9_1935)) :: []),(var_10_1936),(var_11_1937),(var_12_1938),(var_13_1939),(var_14_1940),(var_15_1941),(var_16_1942)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1927),e107) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as var_17_1943) :: []) -> (let e = ((evalMap'Coln'lookup((var_3_1930),(KApply1(Lbl'_LT_'fname'_GT_',(var_18_1933 :: [])) :: [])) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply4(Lbl'_LT_'funDef'_GT_',(KApply1(Lbl'_LT_'fname'_GT_',(var_18_1944 :: [])) :: []),(KApply1(Lbl'_LT_'fparams'_GT_',(var_5_1945 :: [])) :: []),(KApply1(Lbl'_LT_'fret'_GT_',(var_8_1946 :: [])) :: []),(KApply1(Lbl'_LT_'fbody'_GT_',(KApply1(Lbl'Hash'block,(var_7_1947 :: [])) :: [])) :: [])) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_3_1930),(KApply1(Lbl'_LT_'fname'_GT_',(var_18_1933 :: [])) :: [])) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortFunDefCellMap,_,_) as var_19_1948) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((((((((((isTrue (evalisStmts((var_7_1947 :: [])) config (-1)))) && ((isTrue (evalisExps((var_6_1934 :: [])) config (-1)))))) && ((isTrue (evalisParameters((var_5_1945 :: [])) config (-1)))))) && ((isTrue (evalisType((var_8_1946 :: [])) config (-1)))))) && ((isTrue (evalisId((var_18_1933 :: [])) config (-1))))))) && (((compare_kitem var_18_1933 var_18_1944) = 0) && ((compare var_4_1931 var_4_1932) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e107,(KApply9(Lbl'_LT_'state'_GT_',e107,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'block,((eval'Hash'bindParams((var_5_1945 :: []),(var_6_1934 :: []),(var_7_1947 :: [])) config (-1)))) :: var_8_1946 :: var_9_1935)) :: []),(var_10_1936),(var_11_1937),(var_12_1938),(var_13_1939),(var_14_1940),(var_15_1941),(var_16_1942)) :: [])) config (-1))),(var_17_1943 :: [])) config (-1)))) :: []),(var_1_1928),(var_2_1929),(KApply1(Lbl'_LT_'funDefs'_GT_',(var_3_1930)) :: [])) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 82) else (choice, f)| _ -> (lookups_step c config 82))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_1949)) :: []),(var_1_1950),(KApply1(Lbl'_LT_'tmp'_GT_',((List (SortList, Lbl_List_, (var_2_1951) :: var_3_1952)) :: [])) :: []),(var_4_1953)) :: []) when guard < 83(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(B~>DotVar4),_1,_2,_3,_4,_5,_6,_7)),DotVar2)``),_8,`<tmp>`(`` `_List_`(`ListItem`(B),DotVar1)=>`_List_`(`.List`(.KList),DotVar1)``),_9) requires `_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(#secondBranch(`.List{"_,__OSL-SYNTAX"}`(.KList))~>DotVar4),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_10,_0))),#match(DotVar2,`_[_<-undef]`(_10,_0))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(18) org.kframework.attributes.Location(Location(18,6,19,43)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
 -> (match (var_0_1949) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_5_1954) as e108 -> (let e = ((evalMap'Coln'lookup((var_0_1949),e108) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_5_1955),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'secondBranch,(KApply0(Lbl'Stop'List'LBraQuot'_'Comm'__OSL'Hyph'SYNTAX'QuotRBra') :: [])) :: var_6_1956)) :: []),(var_7_1957),(var_8_1958),(var_9_1959),(var_10_1960),(var_11_1961),(var_12_1962),(var_13_1963)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1949),e108) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as var_14_1964) :: []) when ((((true) && (true))) && (true)) && (((compare var_5_1954 var_5_1955) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e108,(KApply9(Lbl'_LT_'state'_GT_',e108,(KApply1(Lbl'_LT_'k'_GT_',(var_2_1951 @ var_6_1956)) :: []),(var_7_1957),(var_8_1958),(var_9_1959),(var_10_1960),(var_11_1961),(var_12_1962),(var_13_1963)) :: [])) config (-1))),(var_14_1964 :: [])) config (-1)))) :: []),(var_1_1950),(KApply1(Lbl'_LT_'tmp'_GT_',((eval_List_(((Lazy.force const'Stop'List)),((List (SortList, Lbl_List_, var_3_1952)) :: [])) config (-1)))) :: []),(var_4_1953)) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 83) else (choice, f)| _ -> (lookups_step c config 83))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_1965)) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',((Int _ as var_1_1966) :: [])) :: []),(var_2_1967),(KApply1(Lbl'_LT_'funDefs'_GT_',(var_3_1968)) :: [])) :: []) when guard < 84(*{| rule `<T>`(`<states>`(_12),`<nstate>`(_14),DotVar0,`<funDefs>`(``_13=>`_FunDefCellMap_`(`.FunDefCellMap`(.KList),DotVar1)``)) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_4,_12),#mapChoice(_0,_13)),#match(`<funDef>`(_0,_1,_2,_3),`Map:lookup`(_13,_0))),#match(`<state>`(_4,`<k>`(.K),_5,_6,_7,_8,_9,_10,_11),`Map:lookup`(_12,_4))),#match(DotVar1,`_[_<-undef]`(_13,_0))),#match(DotVar2,`_[_<-undef]`(_12,_4))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#token("true","Bool"),isFnameCell(_0)),isFbodyCell(_3)),isFparamsCell(_1)),isFretCell(_2))),`_==Int_`(_14,#token("1","Int"))) ensures #token("true","Bool") [contentStartColumn(8) contentStartLine(44) org.kframework.attributes.Location(Location(44,8,46,67)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/configuration.k))]|}*)
 -> (match (var_0_1965) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_5_1969) as e109 -> (match (var_3_1968) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_6_1970) as e110 -> (let e = ((evalMap'Coln'lookup((var_3_1968),e110) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply4(Lbl'_LT_'funDef'_GT_',(var_6_1971),(var_7_1972),(var_8_1973),(var_9_1974)) :: []) -> (let e = ((evalMap'Coln'lookup((var_0_1965),e109) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_5_1975),(KApply1(Lbl'_LT_'k'_GT_',([])) :: []),(var_10_1976),(var_11_1977),(var_12_1978),(var_13_1979),(var_14_1980),(var_15_1981),(var_16_1982)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_3_1968),e110) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortFunDefCellMap,_,_) as var_4_1983) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1965),e109) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as var_17_1984) :: []) when ((((((((((((((true) && (true))) && (true))) && (true))) && (true))) && (true))) && (((((((((true) && ((isTrue (evalisFnameCell(e110) config (-1)))))) && ((isTrue (evalisFbodyCell((var_9_1974)) config (-1)))))) && ((isTrue (evalisFparamsCell((var_7_1972)) config (-1)))))) && ((isTrue (evalisFretCell((var_8_1973)) config (-1)))))))) && ((isTrue (eval_'EqlsEqls'Int_((var_1_1966 :: []),((Lazy.force int1) :: [])) config (-1))))) && (((compare var_5_1975 var_5_1969) = 0) && ((compare var_6_1971 var_6_1970) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_1965)) :: []),(KApply1(Lbl'_LT_'nstate'_GT_',(var_1_1966 :: [])) :: []),(var_2_1967),(KApply1(Lbl'_LT_'funDefs'_GT_',((eval_FunDefCellMap_(((Lazy.force const'Stop'FunDefCellMap)),(var_4_1983 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (interned_bottom, (StepFunc step)) else (choice, f)| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 84) else (choice, f)| _ -> (lookups_step c config 84))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_1985)) :: []),(var_1_1986),(var_2_1987),(KApply1(Lbl'_LT_'funDefs'_GT_',(var_3_1988)) :: [])) :: []) when guard < 85(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(DotVar4),_1,_2,_3,_4,_5,_6,_7)),DotVar2)``),_8,_9,`<funDefs>`(``_11=>`_FunDefCellMap_`(`FunDefCellMapItem`(`<fname>`(F),`<funDef>`(`<fname>`(F),`<fparams>`(Ps),`<fret>`(T),`<fbody>`(B))),DotVar1)``)) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#match(DotVar1,_11),#mapChoice(_0,_10)),#match(`<state>`(_0,`<k>`(`_;_OSL-SYNTAX`(#function(F,Ps,T,B))~>DotVar4),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_10,_0))),#match(DotVar2,`_[_<-undef]`(_10,_0))),`_andBool_`(`_andBool_`(`_andBool_`(isParameters(Ps),isType(T)),isId(F)),isBlock(B))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(11) org.kframework.attributes.Location(Location(11,6,18,17)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/call.k))]|}*)
 -> (let e = (var_3_1988) in match e with 
| [Bottom] -> (lookups_step c config 85)
| ((Map (SortFunDefCellMap,_,_) as var_18_1989) :: []) -> (match (var_0_1985) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_4_1990) as e111 -> (let e = ((evalMap'Coln'lookup((var_0_1985),e111) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_1991),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl_'SCln'_OSL'Hyph'SYNTAX,(KApply4(Lbl'Hash'function,(var_14_1992 :: []),(var_15_1993 :: []),(var_16_1994 :: []),(var_17_1995 :: [])) :: [])) :: var_5_1996)) :: []),(var_6_1997),(var_7_1998),(var_8_1999),(var_9_2000),(var_10_2001),(var_11_2002),(var_12_2003)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_1985),e111) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as var_13_2004) :: []) when ((((((((true) && (true))) && (true))) && (true))) && ((((((((isTrue (evalisParameters((var_15_1993 :: [])) config (-1)))) && ((isTrue (evalisType((var_16_1994 :: [])) config (-1)))))) && ((isTrue (evalisId((var_14_1992 :: [])) config (-1)))))) && ((isTrue (evalisBlock((var_17_1995 :: [])) config (-1))))))) && (((compare var_4_1990 var_4_1991) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e111,(KApply9(Lbl'_LT_'state'_GT_',e111,(KApply1(Lbl'_LT_'k'_GT_',(var_5_1996)) :: []),(var_6_1997),(var_7_1998),(var_8_1999),(var_9_2000),(var_10_2001),(var_11_2002),(var_12_2003)) :: [])) config (-1))),(var_13_2004 :: [])) config (-1)))) :: []),(var_1_1986),(var_2_1987),(KApply1(Lbl'_LT_'funDefs'_GT_',((eval_FunDefCellMap_(((evalFunDefCellMapItem((KApply1(Lbl'_LT_'fname'_GT_',(var_14_1992 :: [])) :: []),(KApply4(Lbl'_LT_'funDef'_GT_',(KApply1(Lbl'_LT_'fname'_GT_',(var_14_1992 :: [])) :: []),(KApply1(Lbl'_LT_'fparams'_GT_',(var_15_1993 :: [])) :: []),(KApply1(Lbl'_LT_'fret'_GT_',(var_16_1994 :: [])) :: []),(KApply1(Lbl'_LT_'fbody'_GT_',(var_17_1995 :: [])) :: [])) :: [])) config (-1))),(var_18_1989 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 85) else (choice, f)| _ -> (lookups_step c config 85))| _ -> (lookups_step c config 85))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_0_2005)) :: []),(var_1_2006),(KApply1(Lbl'_LT_'tmp'_GT_',((List (SortList,_,_) as var_2_2007) :: [])) :: []),(var_3_2008)) :: []) when guard < 86(*{| rule `<T>`(`<states>`(``_10=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#secondBranch(Bs)~>DotVar4),_1,_2,_3,_4,_5,_6,_7)),DotVar2)``),_8,`<tmp>`(``DotVar1=>`_List_`(`ListItem`(B),DotVar1)``),_9) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_10),#match(`<state>`(_0,`<k>`(#branch(`_,__OSL-SYNTAX`(B,Bs))~>DotVar4),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_10,_0))),#match(DotVar2,`_[_<-undef]`(_10,_0))),`_andBool_`(isBlocks(Bs),isBlock(B))) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(14) org.kframework.attributes.Location(Location(14,6,15,43)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/control.k))]|}*)
 -> (match (var_0_2005) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_4_2009) as e112 -> (let e = ((evalMap'Coln'lookup((var_0_2005),e112) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_4_2010),(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'branch,(KApply2(Lbl_'Comm'__OSL'Hyph'SYNTAX,(var_15_2011 :: []),(var_5_2012 :: [])) :: [])) :: var_6_2013)) :: []),(var_7_2014),(var_8_2015),(var_9_2016),(var_10_2017),(var_11_2018),(var_12_2019),(var_13_2020)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_0_2005),e112) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as var_14_2021) :: []) when ((((((true) && (true))) && (true))) && ((((isTrue (evalisBlocks((var_5_2012 :: [])) config (-1)))) && ((isTrue (evalisBlock((var_15_2011 :: [])) config (-1))))))) && (((compare var_4_2010 var_4_2009) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e112,(KApply9(Lbl'_LT_'state'_GT_',e112,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'secondBranch,(var_5_2012 :: [])) :: var_6_2013)) :: []),(var_7_2014),(var_8_2015),(var_9_2016),(var_10_2017),(var_11_2018),(var_12_2019),(var_13_2020)) :: [])) config (-1))),(var_14_2021 :: [])) config (-1)))) :: []),(var_1_2006),(KApply1(Lbl'_LT_'tmp'_GT_',((eval_List_(((evalListItem((var_15_2011 :: [])) config (-1))),(var_2_2007 :: [])) config (-1)))) :: []),(var_3_2008)) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 86) else (choice, f)| _ -> (lookups_step c config 86))
| (KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',(var_11_2022)) :: []),(var_8_2023),(var_9_2024),(var_10_2025)) :: []) when guard < 87(*{| rule `<T>`(`<states>`(``_11=>`_StateCellMap_`(`StateCellMapItem`(_0,`<state>`(_0,`<k>`(#read(X)~>DotVar3),_1,_2,_3,_4,_5,_6,_7)),DotVar1)``),_8,_9,_10) requires `_andBool_`(`_andBool_`(`_andBool_`(#mapChoice(_0,_11),#match(`<state>`(_0,`<k>`(X~>DotVar3),_1,_2,_3,_4,_5,_6,_7),`Map:lookup`(_11,_0))),#match(DotVar1,`_[_<-undef]`(_11,_0))),isId(X)) ensures #token("true","Bool") [contentStartColumn(6) contentStartLine(173) org.kframework.attributes.Location(Location(173,6,173,19)) org.kframework.attributes.Source(Source(/home/alessio/Project/osl2/model/./osl.k))]|}*)
 -> (match (var_11_2022) with 
| [Map (_,_,collection)] -> let (choice, f) = (KMap.fold (fun e v (result, f) -> if result == interned_bottom then (match e with | (var_0_2026) as e113 -> (let e = ((evalMap'Coln'lookup((var_11_2022),e113) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| (KApply9(Lbl'_LT_'state'_GT_',(var_0_2027),(KApply1(Lbl'_LT_'k'_GT_',(varX_2028 :: varDotVar3_2029)) :: []),(var_1_2030),(var_2_2031),(var_3_2032),(var_4_2033),(var_5_2034),(var_6_2035),(var_7_2036)) :: []) -> (let e = ((eval_'LSqB'_'_LT_Hyph'undef'RSqB'((var_11_2022),e113) config (-1))) in match e with 
| [Bottom] -> (interned_bottom, (StepFunc step))
| ((Map (SortStateCellMap,_,_) as varDotVar1_2037) :: []) when ((((((true) && (true))) && (true))) && ((isTrue (evalisId((varX_2028 :: [])) config (-1))))) && (((compare var_0_2026 var_0_2027) = 0) && true) -> (((KApply4(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'states'_GT_',((eval_StateCellMap_(((evalStateCellMapItem(e113,(KApply9(Lbl'_LT_'state'_GT_',e113,(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lbl'Hash'read,(varX_2028 :: [])) :: varDotVar3_2029)) :: []),(var_1_2030),(var_2_2031),(var_3_2032),(var_4_2033),(var_5_2034),(var_6_2035),(var_7_2036)) :: [])) config (-1))),(varDotVar1_2037 :: [])) config (-1)))) :: []),(var_8_2023),(var_9_2024),(var_10_2025)) :: [])), (StepFunc step))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step)))| _ -> (interned_bottom, (StepFunc step))) else (result, f)) collection (interned_bottom, (StepFunc step))) in if choice == interned_bottom then (lookups_step c config 87) else (choice, f)| _ -> (lookups_step c config 87))
| _ -> raise (Stuck c)
let make_stuck (config: k) : k = config
let make_unstuck (config: k) : k = config
let get_thread_set (config: k) : k = [Map(SortMap,Lbl_Map_,KMap.empty)]
let set_thread_set (config: k) (set: k) : k = config
end
let () = Plugin.the_definition := Some (module Def)
