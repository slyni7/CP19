--쇼팽 에튀드 10-7 마법사
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x2f3),2,2)
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x2f3),nil,2)
	Fusion.AddProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2f3),2,true)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTR(1,1)
	e1:SetOperation(s.op1)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local cicblm=Card.IsCanBeLinkMaterial
	function Card.IsCanBeLinkMaterial(mc,lc,tp)
		if mc:IsLoc("S") and lc==c then
			return true
		end
		return cicblm(mc,lc,tp)
	end
	local cicbxm=Card.IsCanBeXyzMaterial
	function Card.IsCanBeXyzMaterial(mc,xc,tp)
		if mc:IsLoc("S") and xc==c then
			return true
		end
		return cicbxm(mc,xc,tp)
	end
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetTR("H",0)
	e3:SetTarget(s.tar3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e4:SetCountLimit(1,id)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","M")
	e5:SetCode(EVENT_CHAINING)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e5:SetD(id,2)
	e5:SetCL(1,{id,1})
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"Qo","M")
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetD(id,3)
	e6:SetCL(1,{id,2})
	e6:SetCategory(CATEGORY_DRAW)
	WriteEff(e6,6,"CTO")
	c:RegisterEffect(e6,false,REGISTER_FLAG_DETACH_XMAT)
end
s.g1=nil
s.december_fmaterial=true
function s.op1(c,e,tp,sg,mg,lc,og,chk)
	return not s.g1 or #(sg&s.g1)<3
end
function s.val1(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if (summon_type~=SUMMON_TYPE_LINK and summon_type~=SUMMON_TYPE_XYZ) or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			s.g1=Duel.GMGroup(Card.IsFaceup,tp,"S",0,nil)
			s.g1:KeepAlive()
			return s.g1
		end
	elseif chk==2 then
		if s.g1 then
			s.g1:DeleteGroup()
		end
		s.g1=nil
	end
end
function s.tar3(e,c)
	local r=c:GetReason()
	if r&REASON_EFFECT==0 then
		return false
	end
	local re=c:GetReasonEffect()
	if not re then
		return false
	end
	local rc=re:GetHandler()
	if not rc:IsSetCard(0x2f3) then
		return false
	end
	local tid=c:GetTurnID()
	if Duel.GetTurnCount()~=tid then
		return false
	end
	return true
end
function s.tfil4(c,e,tp,zone)
	return c:IsSetCard(0x2f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLoc("G") and chkc:IsControler(tp) and s.tfil4(chkc,e,tp,zone) end
	if chk==0 then
		return zone~=0 and Duel.IETarget(s.tfil4,tp,"G",0,1,nil,e,tp,zone)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil4,tp,"G",0,1,1,nil,e,tp,zone)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local con=re:GetCondition()
	local tg=re:GetTarget()
	Auxiliary.ChopinEtudeSetCode=0x2f3
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	res=(not con or con(e,tp,teg,tep,tev,tre,tr,trp)) and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
	Auxiliary.ChopinEtudeSetCode=nil
	if chk==0 then
		e:SetProperty(0)
		return res
	end
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	Auxiliary.ChopinEtudeSetCode=0x2f3
	e:SetProperty(re:GetProperty())
	if tg then
		tg(e,tp,teg,tep,tev,tre,tr,trp,1)
	end
	Duel.ClearOperationInfo(0)
	Auxiliary.ChopinEtudeSetCode=nil
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
	local rc=re:GetHandler()
	Duel.SPOI(0,CATEGORY_NEGATE,eg,1,0,0)
	if rc:IsRelateToEffect(re) then
		Duel.SPOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local c=e:GetHandler()
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	local op=re:GetOperation()
	if op then
		Auxiliary.ChopinEtudeSetCode=0x2f3
		op(e,tp,teg,tep,tev,tre,tr,trp)
		Auxiliary.ChopinEtudeSetCode=nil
	end
	local rc=re:GetHandler()
	local b1=Duel.IsChainNegatable(ev)
	local b2=rc:IsRelateToEffect(re) and rc:IsDestructable()
	local opt=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if opt==1 then
		Duel.BreakEffect()
		Duel.NegateActivation(ev)
	elseif opt==2 then
		Duel.BreakEffect()
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tfil6(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2f3) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,true)~=nil
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.tfil6,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tfil6,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local te=e:GetLabelObject()
	if not te then
		return
	end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
