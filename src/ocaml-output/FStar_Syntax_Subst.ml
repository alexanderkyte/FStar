
open Prims
# 58 "FStar.Syntax.Subst.fst"
let rec force_uvar : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_uvar (uv, _31_12) -> begin
(match ((FStar_Unionfind.find uv)) with
| FStar_Syntax_Syntax.Fixed (t') -> begin
(force_uvar t')
end
| _31_18 -> begin
t
end)
end
| _31_20 -> begin
t
end))

# 67 "FStar.Syntax.Subst.fst"
let rec force_delayed_thunk : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (f, m) -> begin
(match ((FStar_ST.read m)) with
| None -> begin
(match (f) with
| FStar_Util.Inr (c) -> begin
(
# 72 "FStar.Syntax.Subst.fst"
let t' = (let _113_8 = (c ())
in (force_delayed_thunk _113_8))
in (
# 72 "FStar.Syntax.Subst.fst"
let _31_30 = (FStar_ST.op_Colon_Equals m (Some (t')))
in t'))
end
| _31_33 -> begin
t
end)
end
| Some (t') -> begin
(
# 75 "FStar.Syntax.Subst.fst"
let t' = (force_delayed_thunk t')
in (
# 75 "FStar.Syntax.Subst.fst"
let _31_37 = (FStar_ST.op_Colon_Equals m (Some (t')))
in t'))
end)
end
| _31_40 -> begin
t
end))

# 78 "FStar.Syntax.Subst.fst"
let rec compress_univ : FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun u -> (match (u) with
| FStar_Syntax_Syntax.U_unif (u') -> begin
(match ((FStar_Unionfind.find u')) with
| Some (u) -> begin
(compress_univ u)
end
| _31_47 -> begin
u
end)
end
| _31_49 -> begin
u
end))

# 90 "FStar.Syntax.Subst.fst"
let subst_to_string = (fun s -> (let _113_15 = (FStar_All.pipe_right s (FStar_List.map (fun _31_54 -> (match (_31_54) with
| (b, _31_53) -> begin
b.FStar_Syntax_Syntax.ppname.FStar_Ident.idText
end))))
in (FStar_All.pipe_right _113_15 (FStar_String.concat ", "))))

# 93 "FStar.Syntax.Subst.fst"
let subst_bv : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term Prims.option = (fun a s -> (FStar_Util.find_map s (fun _31_1 -> (match (_31_1) with
| FStar_Syntax_Syntax.DB (i, t) when (i = a.FStar_Syntax_Syntax.index) -> begin
Some (t)
end
| _31_63 -> begin
None
end))))

# 94 "FStar.Syntax.Subst.fst"
let subst_nm : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term Prims.option = (fun a s -> (FStar_Util.find_map s (fun _31_2 -> (match (_31_2) with
| FStar_Syntax_Syntax.NM (x, i) when (FStar_Syntax_Syntax.bv_eq a x) -> begin
(let _113_26 = (FStar_Syntax_Syntax.bv_to_tm (
# 95 "FStar.Syntax.Subst.fst"
let _31_71 = x
in {FStar_Syntax_Syntax.ppname = _31_71.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = i; FStar_Syntax_Syntax.sort = _31_71.FStar_Syntax_Syntax.sort}))
in Some (_113_26))
end
| FStar_Syntax_Syntax.NT (x, t) when (FStar_Syntax_Syntax.bv_eq a x) -> begin
Some (t)
end
| _31_78 -> begin
None
end))))

# 98 "FStar.Syntax.Subst.fst"
let subst_univ_bv : Prims.int  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.universe Prims.option = (fun x s -> (FStar_Util.find_map s (fun _31_3 -> (match (_31_3) with
| FStar_Syntax_Syntax.UN (y, t) when (x = y) -> begin
Some (t)
end
| _31_87 -> begin
None
end))))

# 101 "FStar.Syntax.Subst.fst"
let subst_univ_nm : FStar_Syntax_Syntax.univ_name  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.universe Prims.option = (fun x s -> (FStar_Util.find_map s (fun _31_4 -> (match (_31_4) with
| FStar_Syntax_Syntax.UD (y, i) when (x.FStar_Ident.idText = y.FStar_Ident.idText) -> begin
Some (FStar_Syntax_Syntax.U_bvar (i))
end
| _31_96 -> begin
None
end))))

# 108 "FStar.Syntax.Subst.fst"
let rec apply_until_some = (fun f s -> (match (s) with
| [] -> begin
None
end
| s0::rest -> begin
(match ((f s0)) with
| None -> begin
(apply_until_some f rest)
end
| Some (st) -> begin
Some ((rest, st))
end)
end))

# 115 "FStar.Syntax.Subst.fst"
let map_some_curry = (fun f x _31_5 -> (match (_31_5) with
| None -> begin
x
end
| Some (a, b) -> begin
(f a b)
end))

# 119 "FStar.Syntax.Subst.fst"
let apply_until_some_then_map = (fun f s g t -> (let _113_64 = (apply_until_some f s)
in (FStar_All.pipe_right _113_64 (map_some_curry g t))))

# 123 "FStar.Syntax.Subst.fst"
let rec subst_univ : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun s u -> (
# 124 "FStar.Syntax.Subst.fst"
let u = (compress_univ u)
in (match (u) with
| FStar_Syntax_Syntax.U_bvar (x) -> begin
(apply_until_some_then_map (subst_univ_bv x) s subst_univ u)
end
| FStar_Syntax_Syntax.U_name (x) -> begin
(apply_until_some_then_map (subst_univ_nm x) s subst_univ u)
end
| (FStar_Syntax_Syntax.U_zero) | (FStar_Syntax_Syntax.U_unknown) | (FStar_Syntax_Syntax.U_unif (_)) -> begin
u
end
| FStar_Syntax_Syntax.U_succ (u) -> begin
(let _113_69 = (subst_univ s u)
in FStar_Syntax_Syntax.U_succ (_113_69))
end
| FStar_Syntax_Syntax.U_max (us) -> begin
(let _113_70 = (FStar_List.map (subst_univ s) us)
in FStar_Syntax_Syntax.U_max (_113_70))
end)))

# 139 "FStar.Syntax.Subst.fst"
let rec subst' : FStar_Syntax_Syntax.subst_ts  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun s t -> (match (s) with
| ([]) | ([]::[]) -> begin
t
end
| _31_140 -> begin
(
# 143 "FStar.Syntax.Subst.fst"
let t0 = (force_delayed_thunk t)
in (match (t0.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) -> begin
t0
end
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t', s'), m) -> begin
(FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl ((t', (FStar_List.append s' s)))) t.FStar_Syntax_Syntax.pos)
end
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inr (_31_159), _31_162) -> begin
(FStar_All.failwith "Impossible: force_delayed_thunk removes lazy delayed nodes")
end
| FStar_Syntax_Syntax.Tm_bvar (a) -> begin
(apply_until_some_then_map (subst_bv a) s subst' t0)
end
| FStar_Syntax_Syntax.Tm_name (a) -> begin
(apply_until_some_then_map (subst_nm a) s subst' t0)
end
| FStar_Syntax_Syntax.Tm_type (u) -> begin
(let _113_86 = (let _113_85 = (subst_univ s u)
in FStar_Syntax_Syntax.Tm_type (_113_85))
in (FStar_Syntax_Syntax.mk _113_86 None t0.FStar_Syntax_Syntax.pos))
end
| _31_172 -> begin
(FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl ((t0, s))) t.FStar_Syntax_Syntax.pos)
end))
end))
and subst_flags' : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.cflags Prims.list  ->  FStar_Syntax_Syntax.cflags Prims.list = (fun s flags -> (FStar_All.pipe_right flags (FStar_List.map (fun _31_6 -> (match (_31_6) with
| FStar_Syntax_Syntax.DECREASES (a) -> begin
(let _113_91 = (subst' s a)
in FStar_Syntax_Syntax.DECREASES (_113_91))
end
| f -> begin
f
end)))))
and subst_comp_typ' : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  FStar_Syntax_Syntax.comp_typ  ->  FStar_Syntax_Syntax.comp_typ = (fun s t -> (match (s) with
| ([]) | ([]::[]) -> begin
t
end
| _31_185 -> begin
(
# 179 "FStar.Syntax.Subst.fst"
let _31_186 = t
in (let _113_98 = (subst' s t.FStar_Syntax_Syntax.result_typ)
in (let _113_97 = (FStar_List.map (fun _31_190 -> (match (_31_190) with
| (t, imp) -> begin
(let _113_95 = (subst' s t)
in (_113_95, imp))
end)) t.FStar_Syntax_Syntax.effect_args)
in (let _113_96 = (subst_flags' s t.FStar_Syntax_Syntax.flags)
in {FStar_Syntax_Syntax.effect_name = _31_186.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _113_98; FStar_Syntax_Syntax.effect_args = _113_97; FStar_Syntax_Syntax.flags = _113_96}))))
end))
and subst_comp' : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax = (fun s t -> (match (s) with
| ([]) | ([]::[]) -> begin
t
end
| _31_197 -> begin
(match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t) -> begin
(let _113_101 = (subst' s t)
in (FStar_Syntax_Syntax.mk_Total _113_101))
end
| FStar_Syntax_Syntax.GTotal (t) -> begin
(let _113_102 = (subst' s t)
in (FStar_Syntax_Syntax.mk_GTotal _113_102))
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(let _113_103 = (subst_comp_typ' s ct)
in (FStar_Syntax_Syntax.mk_Comp _113_103))
end)
end))
and compose_subst : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.subst_elt Prims.list Prims.list = (fun s1 s2 -> (FStar_List.append s1 s2))

# 194 "FStar.Syntax.Subst.fst"
let shift : Prims.int  ->  FStar_Syntax_Syntax.subst_elt  ->  FStar_Syntax_Syntax.subst_elt = (fun n s -> (match (s) with
| FStar_Syntax_Syntax.DB (i, t) -> begin
FStar_Syntax_Syntax.DB (((i + n), t))
end
| FStar_Syntax_Syntax.UN (i, t) -> begin
FStar_Syntax_Syntax.UN (((i + n), t))
end
| FStar_Syntax_Syntax.NM (x, i) -> begin
FStar_Syntax_Syntax.NM ((x, (i + n)))
end
| FStar_Syntax_Syntax.UD (x, i) -> begin
FStar_Syntax_Syntax.UD ((x, (i + n)))
end
| FStar_Syntax_Syntax.NT (_31_225) -> begin
s
end))

# 200 "FStar.Syntax.Subst.fst"
let shift_subst : Prims.int  ->  FStar_Syntax_Syntax.subst_t  ->  FStar_Syntax_Syntax.subst_t = (fun n s -> (FStar_List.map (shift n) s))

# 201 "FStar.Syntax.Subst.fst"
let shift_subst' : Prims.int  ->  FStar_Syntax_Syntax.subst_t Prims.list  ->  FStar_Syntax_Syntax.subst_t Prims.list = (fun n s -> (FStar_All.pipe_right s (FStar_List.map (shift_subst n))))

# 202 "FStar.Syntax.Subst.fst"
let subst_binder' = (fun s _31_234 -> (match (_31_234) with
| (x, imp) -> begin
(let _113_121 = (
# 202 "FStar.Syntax.Subst.fst"
let _31_235 = x
in (let _113_120 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_235.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_235.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_120}))
in (_113_121, imp))
end))

# 203 "FStar.Syntax.Subst.fst"
let subst_binders' = (fun s bs -> (FStar_All.pipe_right bs (FStar_List.mapi (fun i b -> if (i = 0) then begin
(subst_binder' s b)
end else begin
(let _113_126 = (shift_subst' i s)
in (subst_binder' _113_126 b))
end))))

# 207 "FStar.Syntax.Subst.fst"
let subst_arg' = (fun s _31_244 -> (match (_31_244) with
| (t, imp) -> begin
(let _113_129 = (subst' s t)
in (_113_129, imp))
end))

# 208 "FStar.Syntax.Subst.fst"
let subst_args' = (fun s -> (FStar_List.map (subst_arg' s)))

# 209 "FStar.Syntax.Subst.fst"
let subst_pat' : FStar_Syntax_Syntax.subst_t Prims.list  ->  (FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t  ->  (FStar_Syntax_Syntax.pat * Prims.int) = (fun s p -> (
# 210 "FStar.Syntax.Subst.fst"
let rec aux = (fun n p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_31_254) -> begin
(p, n)
end
| FStar_Syntax_Syntax.Pat_disj (p::ps) -> begin
(
# 216 "FStar.Syntax.Subst.fst"
let _31_262 = (aux n p)
in (match (_31_262) with
| (p, m) -> begin
(
# 217 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (fun p -> (let _113_142 = (aux n p)
in (Prims.fst _113_142))) ps)
in ((
# 218 "FStar.Syntax.Subst.fst"
let _31_265 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _31_265.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_265.FStar_Syntax_Syntax.p}), m))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 221 "FStar.Syntax.Subst.fst"
let _31_282 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _31_273 _31_276 -> (match ((_31_273, _31_276)) with
| ((pats, n), (p, imp)) -> begin
(
# 222 "FStar.Syntax.Subst.fst"
let _31_279 = (aux n p)
in (match (_31_279) with
| (p, m) -> begin
(((p, imp))::pats, m)
end))
end)) ([], n)))
in (match (_31_282) with
| (pats, n) -> begin
((
# 224 "FStar.Syntax.Subst.fst"
let _31_283 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _31_283.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_283.FStar_Syntax_Syntax.p}), n)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 227 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 228 "FStar.Syntax.Subst.fst"
let x = (
# 228 "FStar.Syntax.Subst.fst"
let _31_288 = x
in (let _113_145 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_288.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_288.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_145}))
in ((
# 229 "FStar.Syntax.Subst.fst"
let _31_291 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _31_291.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_291.FStar_Syntax_Syntax.p}), (n + 1))))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 232 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 233 "FStar.Syntax.Subst.fst"
let x = (
# 233 "FStar.Syntax.Subst.fst"
let _31_296 = x
in (let _113_146 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_296.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_296.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_146}))
in ((
# 234 "FStar.Syntax.Subst.fst"
let _31_299 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _31_299.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_299.FStar_Syntax_Syntax.p}), (n + 1))))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 237 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 238 "FStar.Syntax.Subst.fst"
let x = (
# 238 "FStar.Syntax.Subst.fst"
let _31_306 = x
in (let _113_147 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_306.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_306.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_147}))
in (
# 239 "FStar.Syntax.Subst.fst"
let t0 = (subst' s t0)
in ((
# 240 "FStar.Syntax.Subst.fst"
let _31_310 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_310.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_310.FStar_Syntax_Syntax.p}), n))))
end))
in (aux 0 p)))

# 243 "FStar.Syntax.Subst.fst"
let push_subst_lcomp : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.lcomp Prims.option  ->  FStar_Syntax_Syntax.lcomp Prims.option = (fun s lopt -> (match (lopt) with
| None -> begin
None
end
| Some (l) -> begin
(let _113_155 = (
# 246 "FStar.Syntax.Subst.fst"
let _31_317 = l
in (let _113_154 = (subst' s l.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _31_317.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _113_154; FStar_Syntax_Syntax.cflags = _31_317.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _31_319 -> (match (()) with
| () -> begin
(let _113_153 = (l.FStar_Syntax_Syntax.comp ())
in (subst_comp' s _113_153))
end))}))
in Some (_113_155))
end))

# 249 "FStar.Syntax.Subst.fst"
let push_subst : FStar_Syntax_Syntax.subst_ts  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun s t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_31_323) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_uvar (_)) -> begin
t
end
| (FStar_Syntax_Syntax.Tm_type (_)) | (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_name (_)) -> begin
(subst' s t)
end
| FStar_Syntax_Syntax.Tm_uinst (t', us) -> begin
(
# 265 "FStar.Syntax.Subst.fst"
let us = (FStar_List.map (subst_univ s) us)
in (FStar_Syntax_Syntax.mk_Tm_uinst t' us))
end
| FStar_Syntax_Syntax.Tm_app (t0, args) -> begin
(let _113_166 = (let _113_165 = (let _113_164 = (subst' s t0)
in (let _113_163 = (subst_args' s args)
in (_113_164, _113_163)))
in FStar_Syntax_Syntax.Tm_app (_113_165))
in (FStar_Syntax_Syntax.mk _113_166 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_ascribed (t0, t1, lopt) -> begin
(let _113_170 = (let _113_169 = (let _113_168 = (subst' s t0)
in (let _113_167 = (subst' s t1)
in (_113_168, _113_167, lopt)))
in FStar_Syntax_Syntax.Tm_ascribed (_113_169))
in (FStar_Syntax_Syntax.mk _113_170 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(
# 273 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length bs)
in (
# 274 "FStar.Syntax.Subst.fst"
let s' = (shift_subst' n s)
in (let _113_175 = (let _113_174 = (let _113_173 = (subst_binders' s bs)
in (let _113_172 = (subst' s' body)
in (let _113_171 = (push_subst_lcomp s' lopt)
in (_113_173, _113_172, _113_171))))
in FStar_Syntax_Syntax.Tm_abs (_113_174))
in (FStar_Syntax_Syntax.mk _113_175 None t.FStar_Syntax_Syntax.pos))))
end
| FStar_Syntax_Syntax.Tm_arrow (bs, comp) -> begin
(
# 278 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length bs)
in (let _113_180 = (let _113_179 = (let _113_178 = (subst_binders' s bs)
in (let _113_177 = (let _113_176 = (shift_subst' n s)
in (subst_comp' _113_176 comp))
in (_113_178, _113_177)))
in FStar_Syntax_Syntax.Tm_arrow (_113_179))
in (FStar_Syntax_Syntax.mk _113_180 None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_refine (x, phi) -> begin
(
# 282 "FStar.Syntax.Subst.fst"
let x = (
# 282 "FStar.Syntax.Subst.fst"
let _31_374 = x
in (let _113_181 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_374.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_374.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_181}))
in (
# 283 "FStar.Syntax.Subst.fst"
let phi = (let _113_182 = (shift_subst' 1 s)
in (subst' _113_182 phi))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_refine ((x, phi))) None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_match (t0, pats) -> begin
(
# 287 "FStar.Syntax.Subst.fst"
let t0 = (subst' s t0)
in (
# 288 "FStar.Syntax.Subst.fst"
let pats = (FStar_All.pipe_right pats (FStar_List.map (fun _31_386 -> (match (_31_386) with
| (pat, wopt, branch) -> begin
(
# 289 "FStar.Syntax.Subst.fst"
let _31_389 = (subst_pat' s pat)
in (match (_31_389) with
| (pat, n) -> begin
(
# 290 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 291 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _113_184 = (subst' s w)
in Some (_113_184))
end)
in (
# 294 "FStar.Syntax.Subst.fst"
let branch = (subst' s branch)
in (pat, wopt, branch))))
end))
end))))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_match ((t0, pats))) None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_let ((is_rec, lbs), body) -> begin
(
# 299 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length lbs)
in (
# 300 "FStar.Syntax.Subst.fst"
let sn = (shift_subst' n s)
in (
# 301 "FStar.Syntax.Subst.fst"
let body = (subst' sn body)
in (
# 302 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 303 "FStar.Syntax.Subst.fst"
let lbt = (subst' s lb.FStar_Syntax_Syntax.lbtyp)
in (
# 304 "FStar.Syntax.Subst.fst"
let lbd = if (is_rec && (FStar_Util.is_left lb.FStar_Syntax_Syntax.lbname)) then begin
(subst' sn lb.FStar_Syntax_Syntax.lbdef)
end else begin
(subst' s lb.FStar_Syntax_Syntax.lbdef)
end
in (
# 307 "FStar.Syntax.Subst.fst"
let _31_409 = lb
in {FStar_Syntax_Syntax.lbname = _31_409.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _31_409.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = lbt; FStar_Syntax_Syntax.lbeff = _31_409.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = lbd}))))))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_let (((is_rec, lbs), body))) None t.FStar_Syntax_Syntax.pos)))))
end
| FStar_Syntax_Syntax.Tm_meta (t0, FStar_Syntax_Syntax.Meta_pattern (ps)) -> begin
(let _113_190 = (let _113_189 = (let _113_188 = (subst' s t0)
in (let _113_187 = (let _113_186 = (FStar_All.pipe_right ps (FStar_List.map (subst_args' s)))
in FStar_Syntax_Syntax.Meta_pattern (_113_186))
in (_113_188, _113_187)))
in FStar_Syntax_Syntax.Tm_meta (_113_189))
in (FStar_Syntax_Syntax.mk _113_190 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_meta (t, m) -> begin
(let _113_193 = (let _113_192 = (let _113_191 = (subst' s t)
in (_113_191, m))
in FStar_Syntax_Syntax.Tm_meta (_113_192))
in (FStar_Syntax_Syntax.mk _113_193 None t.FStar_Syntax_Syntax.pos))
end))

# 316 "FStar.Syntax.Subst.fst"
let rec compress : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (
# 317 "FStar.Syntax.Subst.fst"
let t = (force_delayed_thunk t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t, s), memo) -> begin
(
# 320 "FStar.Syntax.Subst.fst"
let t' = (let _113_196 = (push_subst s t)
in (compress _113_196))
in (
# 321 "FStar.Syntax.Subst.fst"
let _31_431 = (FStar_Unionfind.update_in_tx memo (Some (t')))
in t'))
end
| _31_434 -> begin
(force_uvar t)
end)))

# 327 "FStar.Syntax.Subst.fst"
let subst : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun s t -> (subst' ((s)::[]) t))

# 328 "FStar.Syntax.Subst.fst"
let subst_comp : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun s t -> (subst_comp' ((s)::[]) t))

# 329 "FStar.Syntax.Subst.fst"
let closing_subst = (fun bs -> (let _113_208 = (FStar_List.fold_right (fun _31_443 _31_446 -> (match ((_31_443, _31_446)) with
| ((x, _31_442), (subst, n)) -> begin
((FStar_Syntax_Syntax.NM ((x, n)))::subst, (n + 1))
end)) bs ([], 0))
in (FStar_All.pipe_right _113_208 Prims.fst)))

# 331 "FStar.Syntax.Subst.fst"
let open_binders' = (fun bs -> (
# 332 "FStar.Syntax.Subst.fst"
let rec aux = (fun bs o -> (match (bs) with
| [] -> begin
([], o)
end
| (x, imp)::bs' -> begin
(
# 335 "FStar.Syntax.Subst.fst"
let x' = (
# 335 "FStar.Syntax.Subst.fst"
let _31_457 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_214 = (subst o x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_457.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_457.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_214}))
in (
# 336 "FStar.Syntax.Subst.fst"
let o = (let _113_218 = (let _113_216 = (let _113_215 = (FStar_Syntax_Syntax.bv_to_name x')
in (0, _113_215))
in FStar_Syntax_Syntax.DB (_113_216))
in (let _113_217 = (shift_subst 1 o)
in (_113_218)::_113_217))
in (
# 337 "FStar.Syntax.Subst.fst"
let _31_463 = (aux bs' o)
in (match (_31_463) with
| (bs', o) -> begin
(((x', imp))::bs', o)
end))))
end))
in (aux bs [])))

# 340 "FStar.Syntax.Subst.fst"
let open_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun bs -> (let _113_221 = (open_binders' bs)
in (Prims.fst _113_221)))

# 341 "FStar.Syntax.Subst.fst"
let open_term' : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.subst_t) = (fun bs t -> (
# 342 "FStar.Syntax.Subst.fst"
let _31_469 = (open_binders' bs)
in (match (_31_469) with
| (bs', opening) -> begin
(let _113_226 = (subst opening t)
in (bs', _113_226, opening))
end)))

# 344 "FStar.Syntax.Subst.fst"
let open_term : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term) = (fun bs t -> (
# 345 "FStar.Syntax.Subst.fst"
let _31_476 = (open_term' bs t)
in (match (_31_476) with
| (b, t, _31_475) -> begin
(b, t)
end)))

# 347 "FStar.Syntax.Subst.fst"
let open_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp) = (fun bs t -> (
# 348 "FStar.Syntax.Subst.fst"
let _31_481 = (open_binders' bs)
in (match (_31_481) with
| (bs', opening) -> begin
(let _113_235 = (subst_comp opening t)
in (bs', _113_235))
end)))

# 352 "FStar.Syntax.Subst.fst"
let open_pat : FStar_Syntax_Syntax.pat  ->  (FStar_Syntax_Syntax.pat * FStar_Syntax_Syntax.subst_t) = (fun p -> (
# 353 "FStar.Syntax.Subst.fst"
let rec aux_disj = (fun sub renaming p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (_31_488) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Syntax_Syntax.Pat_constant (_31_491) -> begin
p
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 360 "FStar.Syntax.Subst.fst"
let _31_497 = p
in (let _113_248 = (let _113_247 = (let _113_246 = (FStar_All.pipe_right pats (FStar_List.map (fun _31_501 -> (match (_31_501) with
| (p, b) -> begin
(let _113_245 = (aux_disj sub renaming p)
in (_113_245, b))
end))))
in (fv, _113_246))
in FStar_Syntax_Syntax.Pat_cons (_113_247))
in {FStar_Syntax_Syntax.v = _113_248; FStar_Syntax_Syntax.ty = _31_497.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_497.FStar_Syntax_Syntax.p}))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 364 "FStar.Syntax.Subst.fst"
let yopt = (FStar_Util.find_map renaming (fun _31_7 -> (match (_31_7) with
| (x', y) when (x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText = x'.FStar_Syntax_Syntax.ppname.FStar_Ident.idText) -> begin
Some (y)
end
| _31_509 -> begin
None
end)))
in (
# 367 "FStar.Syntax.Subst.fst"
let y = (match (yopt) with
| None -> begin
(
# 368 "FStar.Syntax.Subst.fst"
let _31_512 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_250 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_512.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_512.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_250}))
end
| Some (y) -> begin
y
end)
in (
# 370 "FStar.Syntax.Subst.fst"
let _31_517 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (y); FStar_Syntax_Syntax.ty = _31_517.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_517.FStar_Syntax_Syntax.p})))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 373 "FStar.Syntax.Subst.fst"
let x' = (
# 373 "FStar.Syntax.Subst.fst"
let _31_521 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_251 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_521.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_521.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_251}))
in (
# 374 "FStar.Syntax.Subst.fst"
let _31_524 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x'); FStar_Syntax_Syntax.ty = _31_524.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_524.FStar_Syntax_Syntax.p}))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 377 "FStar.Syntax.Subst.fst"
let x = (
# 377 "FStar.Syntax.Subst.fst"
let _31_530 = x
in (let _113_252 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_530.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_530.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_252}))
in (
# 378 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in (
# 379 "FStar.Syntax.Subst.fst"
let _31_534 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_534.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_534.FStar_Syntax_Syntax.p})))
end))
in (
# 381 "FStar.Syntax.Subst.fst"
let rec aux = (fun sub renaming p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_31_543) -> begin
(p, sub, renaming)
end
| FStar_Syntax_Syntax.Pat_disj (p::ps) -> begin
(
# 387 "FStar.Syntax.Subst.fst"
let _31_552 = (aux sub renaming p)
in (match (_31_552) with
| (p, sub, renaming) -> begin
(
# 388 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (aux_disj sub renaming) ps)
in ((
# 389 "FStar.Syntax.Subst.fst"
let _31_554 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _31_554.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_554.FStar_Syntax_Syntax.p}), sub, renaming))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 392 "FStar.Syntax.Subst.fst"
let _31_574 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _31_563 _31_566 -> (match ((_31_563, _31_566)) with
| ((pats, sub, renaming), (p, imp)) -> begin
(
# 393 "FStar.Syntax.Subst.fst"
let _31_570 = (aux sub renaming p)
in (match (_31_570) with
| (p, sub, renaming) -> begin
(((p, imp))::pats, sub, renaming)
end))
end)) ([], sub, renaming)))
in (match (_31_574) with
| (pats, sub, renaming) -> begin
((
# 395 "FStar.Syntax.Subst.fst"
let _31_575 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _31_575.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_575.FStar_Syntax_Syntax.p}), sub, renaming)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 398 "FStar.Syntax.Subst.fst"
let x' = (
# 398 "FStar.Syntax.Subst.fst"
let _31_579 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_261 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_579.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_579.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_261}))
in (
# 399 "FStar.Syntax.Subst.fst"
let sub = (let _113_265 = (let _113_263 = (let _113_262 = (FStar_Syntax_Syntax.bv_to_name x')
in (0, _113_262))
in FStar_Syntax_Syntax.DB (_113_263))
in (let _113_264 = (shift_subst 1 sub)
in (_113_265)::_113_264))
in ((
# 400 "FStar.Syntax.Subst.fst"
let _31_583 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x'); FStar_Syntax_Syntax.ty = _31_583.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_583.FStar_Syntax_Syntax.p}), sub, ((x, x'))::renaming)))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 403 "FStar.Syntax.Subst.fst"
let x' = (
# 403 "FStar.Syntax.Subst.fst"
let _31_587 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_266 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_587.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_587.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_266}))
in (
# 404 "FStar.Syntax.Subst.fst"
let sub = (let _113_270 = (let _113_268 = (let _113_267 = (FStar_Syntax_Syntax.bv_to_name x')
in (0, _113_267))
in FStar_Syntax_Syntax.DB (_113_268))
in (let _113_269 = (shift_subst 1 sub)
in (_113_270)::_113_269))
in ((
# 405 "FStar.Syntax.Subst.fst"
let _31_591 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x'); FStar_Syntax_Syntax.ty = _31_591.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_591.FStar_Syntax_Syntax.p}), sub, ((x, x'))::renaming)))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 408 "FStar.Syntax.Subst.fst"
let x = (
# 408 "FStar.Syntax.Subst.fst"
let _31_597 = x
in (let _113_271 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_597.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_597.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_271}))
in (
# 409 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in ((
# 410 "FStar.Syntax.Subst.fst"
let _31_601 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_601.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_601.FStar_Syntax_Syntax.p}), sub, renaming)))
end))
in (
# 412 "FStar.Syntax.Subst.fst"
let _31_607 = (aux [] [] p)
in (match (_31_607) with
| (p, sub, _31_606) -> begin
(p, sub)
end)))))

# 415 "FStar.Syntax.Subst.fst"
let open_branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun _31_611 -> (match (_31_611) with
| (p, wopt, e) -> begin
(
# 416 "FStar.Syntax.Subst.fst"
let _31_614 = (open_pat p)
in (match (_31_614) with
| (p, opening) -> begin
(
# 417 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _113_274 = (subst opening w)
in Some (_113_274))
end)
in (
# 420 "FStar.Syntax.Subst.fst"
let e = (subst opening e)
in (p, wopt, e)))
end))
end))

# 423 "FStar.Syntax.Subst.fst"
let close : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun bs t -> (let _113_279 = (closing_subst bs)
in (subst _113_279 t)))

# 424 "FStar.Syntax.Subst.fst"
let close_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun bs c -> (let _113_284 = (closing_subst bs)
in (subst_comp _113_284 c)))

# 425 "FStar.Syntax.Subst.fst"
let close_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun bs -> (
# 426 "FStar.Syntax.Subst.fst"
let rec aux = (fun s bs -> (match (bs) with
| [] -> begin
[]
end
| (x, imp)::tl -> begin
(
# 429 "FStar.Syntax.Subst.fst"
let x = (
# 429 "FStar.Syntax.Subst.fst"
let _31_634 = x
in (let _113_291 = (subst s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_634.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_634.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_291}))
in (
# 430 "FStar.Syntax.Subst.fst"
let s' = (let _113_292 = (shift_subst 1 s)
in (FStar_Syntax_Syntax.NM ((x, 0)))::_113_292)
in (let _113_293 = (aux s' tl)
in ((x, imp))::_113_293)))
end))
in (aux [] bs)))

# 434 "FStar.Syntax.Subst.fst"
let close_lcomp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.lcomp  ->  FStar_Syntax_Syntax.lcomp = (fun bs lc -> (
# 435 "FStar.Syntax.Subst.fst"
let s = (closing_subst bs)
in (
# 436 "FStar.Syntax.Subst.fst"
let _31_641 = lc
in (let _113_300 = (subst s lc.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _31_641.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _113_300; FStar_Syntax_Syntax.cflags = _31_641.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _31_643 -> (match (()) with
| () -> begin
(let _113_299 = (lc.FStar_Syntax_Syntax.comp ())
in (subst_comp s _113_299))
end))}))))

# 439 "FStar.Syntax.Subst.fst"
let close_pat : (FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t  ->  ((FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t * FStar_Syntax_Syntax.subst_elt Prims.list) = (fun p -> (
# 440 "FStar.Syntax.Subst.fst"
let rec aux = (fun sub p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_31_651) -> begin
(p, sub)
end
| FStar_Syntax_Syntax.Pat_disj (p::ps) -> begin
(
# 446 "FStar.Syntax.Subst.fst"
let _31_659 = (aux sub p)
in (match (_31_659) with
| (p, sub) -> begin
(
# 447 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (fun p -> (let _113_308 = (aux sub p)
in (Prims.fst _113_308))) ps)
in ((
# 448 "FStar.Syntax.Subst.fst"
let _31_662 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _31_662.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_662.FStar_Syntax_Syntax.p}), sub))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 451 "FStar.Syntax.Subst.fst"
let _31_679 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _31_670 _31_673 -> (match ((_31_670, _31_673)) with
| ((pats, sub), (p, imp)) -> begin
(
# 452 "FStar.Syntax.Subst.fst"
let _31_676 = (aux sub p)
in (match (_31_676) with
| (p, sub) -> begin
(((p, imp))::pats, sub)
end))
end)) ([], sub)))
in (match (_31_679) with
| (pats, sub) -> begin
((
# 454 "FStar.Syntax.Subst.fst"
let _31_680 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _31_680.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_680.FStar_Syntax_Syntax.p}), sub)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 457 "FStar.Syntax.Subst.fst"
let x = (
# 457 "FStar.Syntax.Subst.fst"
let _31_684 = x
in (let _113_311 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_684.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_684.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_311}))
in (
# 458 "FStar.Syntax.Subst.fst"
let sub = (let _113_312 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.NM ((x, 0)))::_113_312)
in ((
# 459 "FStar.Syntax.Subst.fst"
let _31_688 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _31_688.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_688.FStar_Syntax_Syntax.p}), sub)))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 462 "FStar.Syntax.Subst.fst"
let x = (
# 462 "FStar.Syntax.Subst.fst"
let _31_692 = x
in (let _113_313 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_692.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_692.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_313}))
in (
# 463 "FStar.Syntax.Subst.fst"
let sub = (let _113_314 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.NM ((x, 0)))::_113_314)
in ((
# 464 "FStar.Syntax.Subst.fst"
let _31_696 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _31_696.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_696.FStar_Syntax_Syntax.p}), sub)))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 467 "FStar.Syntax.Subst.fst"
let x = (
# 467 "FStar.Syntax.Subst.fst"
let _31_702 = x
in (let _113_315 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_702.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_702.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_315}))
in (
# 468 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in ((
# 469 "FStar.Syntax.Subst.fst"
let _31_706 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_706.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_706.FStar_Syntax_Syntax.p}), sub)))
end))
in (aux [] p)))

# 472 "FStar.Syntax.Subst.fst"
let close_branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun _31_711 -> (match (_31_711) with
| (p, wopt, e) -> begin
(
# 473 "FStar.Syntax.Subst.fst"
let _31_714 = (close_pat p)
in (match (_31_714) with
| (p, closing) -> begin
(
# 474 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _113_318 = (subst closing w)
in Some (_113_318))
end)
in (
# 477 "FStar.Syntax.Subst.fst"
let e = (subst closing e)
in (p, wopt, e)))
end))
end))

# 480 "FStar.Syntax.Subst.fst"
let univ_var_opening : FStar_Syntax_Syntax.univ_names  ->  (FStar_Syntax_Syntax.subst_elt Prims.list * FStar_Syntax_Syntax.univ_name Prims.list) = (fun us -> (
# 481 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 482 "FStar.Syntax.Subst.fst"
let _31_727 = (let _113_323 = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> (
# 483 "FStar.Syntax.Subst.fst"
let u' = (FStar_Syntax_Syntax.new_univ_name (Some (u.FStar_Ident.idRange)))
in (FStar_Syntax_Syntax.UN (((n - i), FStar_Syntax_Syntax.U_name (u'))), u')))))
in (FStar_All.pipe_right _113_323 FStar_List.unzip))
in (match (_31_727) with
| (s, us') -> begin
(s, us')
end))))

# 487 "FStar.Syntax.Subst.fst"
let open_univ_vars : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.term) = (fun us t -> (
# 488 "FStar.Syntax.Subst.fst"
let _31_732 = (univ_var_opening us)
in (match (_31_732) with
| (s, us') -> begin
(
# 489 "FStar.Syntax.Subst.fst"
let t = (subst s t)
in (us', t))
end)))

# 492 "FStar.Syntax.Subst.fst"
let open_univ_vars_comp : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.comp) = (fun us c -> (
# 493 "FStar.Syntax.Subst.fst"
let _31_738 = (univ_var_opening us)
in (match (_31_738) with
| (s, us') -> begin
(let _113_332 = (subst_comp s c)
in (us', _113_332))
end)))

# 496 "FStar.Syntax.Subst.fst"
let close_univ_vars : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun us t -> (
# 497 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 498 "FStar.Syntax.Subst.fst"
let s = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UD ((u, (n - i))))))
in (subst s t))))

# 501 "FStar.Syntax.Subst.fst"
let close_univ_vars_comp : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun us c -> (
# 502 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 503 "FStar.Syntax.Subst.fst"
let s = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UD ((u, (n - i))))))
in (subst_comp s c))))

# 506 "FStar.Syntax.Subst.fst"
let is_top_level : FStar_Syntax_Syntax.letbinding Prims.list  ->  Prims.bool = (fun _31_8 -> (match (_31_8) with
| {FStar_Syntax_Syntax.lbname = FStar_Util.Inr (_31_763); FStar_Syntax_Syntax.lbunivs = _31_761; FStar_Syntax_Syntax.lbtyp = _31_759; FStar_Syntax_Syntax.lbeff = _31_757; FStar_Syntax_Syntax.lbdef = _31_755}::_31_753 -> begin
true
end
| _31_768 -> begin
false
end))

# 510 "FStar.Syntax.Subst.fst"
let open_let_rec : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.letbinding Prims.list * FStar_Syntax_Syntax.term) = (fun lbs t -> if (is_top_level lbs) then begin
(lbs, t)
end else begin
(FStar_All.failwith "NYI: open_let_rec")
end)

# 514 "FStar.Syntax.Subst.fst"
let close_let_rec : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.letbinding Prims.list * FStar_Syntax_Syntax.term) = (fun lbs t -> if (is_top_level lbs) then begin
(lbs, t)
end else begin
(FStar_All.failwith "NYI: close_let_rec")
end)

# 519 "FStar.Syntax.Subst.fst"
let mk_subst_binders = (fun args -> (
# 520 "FStar.Syntax.Subst.fst"
let _31_781 = (FStar_List.fold_right (fun a _31_777 -> (match (_31_777) with
| (s, i) -> begin
((FStar_Syntax_Syntax.DB ((i, (Prims.fst a))))::s, (i + 1))
end)) args ([], 0))
in (match (_31_781) with
| (s, _31_780) -> begin
s
end)))

# 523 "FStar.Syntax.Subst.fst"
let subst_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.args  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun bs args t -> (let _113_364 = (mk_subst_binders args)
in (subst _113_364 t)))

# 524 "FStar.Syntax.Subst.fst"
let subst_binders_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.args  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun bs args t -> (let _113_371 = (mk_subst_binders args)
in (subst_comp _113_371 t)))

# 527 "FStar.Syntax.Subst.fst"
let close_tscheme : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.tscheme = (fun binders _31_791 -> (match (_31_791) with
| (us, t) -> begin
(
# 528 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length binders) - 1)
in (
# 529 "FStar.Syntax.Subst.fst"
let k = (FStar_List.length us)
in (
# 530 "FStar.Syntax.Subst.fst"
let s = (FStar_List.mapi (fun i _31_798 -> (match (_31_798) with
| (x, _31_797) -> begin
FStar_Syntax_Syntax.NM ((x, (k + (n - i))))
end)) binders)
in (
# 531 "FStar.Syntax.Subst.fst"
let t = (subst s t)
in (us, t)))))
end))

# 534 "FStar.Syntax.Subst.fst"
let close_univ_vars_tscheme : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.tscheme = (fun us _31_804 -> (match (_31_804) with
| (us', t) -> begin
(
# 535 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 536 "FStar.Syntax.Subst.fst"
let k = (FStar_List.length us')
in (
# 537 "FStar.Syntax.Subst.fst"
let s = (FStar_List.mapi (fun i x -> FStar_Syntax_Syntax.UD ((x, (k + (n - i))))) us)
in (let _113_384 = (subst s t)
in (us', _113_384)))))
end))

# 540 "FStar.Syntax.Subst.fst"
let opening_of_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.subst_t = (fun bs -> (
# 541 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length bs) - 1)
in (FStar_All.pipe_right bs (FStar_List.mapi (fun i _31_816 -> (match (_31_816) with
| (x, _31_815) -> begin
(let _113_390 = (let _113_389 = (FStar_Syntax_Syntax.bv_to_name x)
in ((n - i), _113_389))
in FStar_Syntax_Syntax.DB (_113_390))
end))))))




