--Don't get too close
local m=18453781
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function cm.nfil1(c)
	return c:IsFaceup() and (c:IsSetCard(0x45) or c:IsCustomType(CUSTOMTYPE_SKULL) or c:IsCode(70781052))
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil) and rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end