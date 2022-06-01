--클래식 메모리즈 - 카나데
local m=76859906
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf","M")
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_RECOVER)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetTR("M",0)
	e3:SetValue(1)
	e3:SetTarget(cm.tar3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S","M")
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FTo","HG")
	e6:SetCode(m)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_CHAIN_END)
		ge3:SetOperation(cm.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.gofil1(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 then
		cm[0]=cm[0]+eg:FilterCount(cm.gofil1,nil)
		if cm[0]>=2 then
			Duel.RaiseEvent(eg,m,re,r,rp,0,0)
		end
	end
end
function cm.gop3(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2c0) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop12)
	Duel.RegisterEffect(e2,tp)
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_MONSTER) then
		return
	end
	if Duel.NegateEffect(ev) then
		Duel.Hint(HINT_CARD,0,m)
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,0,0,tp,ev)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
function cm.tar3(e,c)
	return c:IsSetCard(0x2c0)
end
function cm.val4(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end