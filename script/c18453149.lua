--도로보네코 느와르
local m=18453149
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,cm.pfun1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	if IREDO_COMES_TRUE then
		e3:SetSpeed(3)
	else
		e3:SetSpellSpeed(3)
	end
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"A")
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetCategory(CATEGORY_DISABLE_SUMMON)
	if IREDO_COMES_TRUE then
		e4:SetSpeed(3)
	else
		e4:SetSpellSpeed(3)
	end
	WriteEff(e4,3,"C")
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e6)
	if not cm.global_effect then
		cm.global_effect=true
		local ge1=MakeEff(c,"F")
		ge1:SetCode(EFFECT_CAPABLE_CHANGE_POSITION)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetTR("S","S")
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.pfun1(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==#g
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable(true)
	end
	Duel.SSet(tp,c)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2e4) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"M",0,1,nil) and Duel.GetMZoneCount(tp,c,tp)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2e4,0x4011,-2,-2,0,0,0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,cm.tfil2,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocCount(tp,"M")
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2e4,0x4011,-2,-2,0,0,0) then
		for i=1,ft do
			local token=Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(tc:GetDefense())
			token:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(tc:GetAttribute())
			token:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(tc:GetLevel())
			token:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CHANGE_RACE)
			e5:SetValue(tc:GetRace())
			token:RegisterEffect(e5)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("S") and c:IsFacedown() and c:GetType()&TYPE_TRAP+TYPE_COUNTER==TYPE_TRAP+TYPE_COUNTER and not c:IsStatus(STATUS_SET_TURN)
		and rp~=tp and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.nfil3(c)
	return c:IsSetCard(0x2e4) and c:IsSSetable(true) and c:IsFaceup()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and Duel.IEMCard(cm.nfil3,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.nfil3,tp,"M",0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SSet(tp,tc)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	e:GetHandler():CancelToGrave(false)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("S") and c:IsFacedown() and c:GetType()&TYPE_TRAP+TYPE_COUNTER==TYPE_TRAP+TYPE_COUNTER and not c:IsStatus(STATUS_SET_TURN)
		and rp~=tp and Duel.GetCurrentChain()==0
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	e:GetHandler():CancelToGrave(false)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end