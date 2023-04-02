--고스트 버니
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"FC","HM")
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(s.tar1)
	e1:SetValue(s.val1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","HM")
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","HM")
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	WriteEff(e3,3,"NTO")
	WriteEff(e3,2,"C")
	c:RegisterEffect(e3)
end
s.square_mana={ATTRIBUTE_FIRE,0x0,ATTRIBUTE_LIGHT}
s.custom_type=CUSTOMTYPE_SQUARE
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckLPCost(tp,1800) and eg:IsExists(Card.IsOnField,1,nil) and Duel.GetFlagEffect(tp,id)==0
	end
	local g=eg:Filter(Card.IsOnField,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	g:Select(tp,0,#g,nil)
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0))
end
function s.val1(e,c)
	return c:IsOnField()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	if c:IsOnField() then
		Duel.HintSelection(Group.FromCards(c))
	elseif c:IsLoc("H") then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.PayLPCost(tp,1800)
	local g=eg:Filter(Card.IsOnField,nil)
	Duel.HintSelection(g)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=c:GetFlagEffect(id)>0
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return res and not c:IsStatus(STATUS_BATTLE_DESTROYED) and loc&LOCATION_ONFIELD~=0
		and Duel.IsChainNegatable(ev)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=c:GetFlagEffect(id)>0
	return res and Duel.GetCurrentChain(true)==0
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
