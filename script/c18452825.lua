--트라이네 클라이네
local m=18452825
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,CARD_EINE_KLEINE,3,true,true)
	local e1=MakeEff(c,"S","MG")
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(CARD_EINE_KLEINE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.cfil21(c)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToRemoveAsCost()
end
function cm.cfil22(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,CARD_EINE_KLEINE)
	if c:IsHasEffect(EFFECT_EINE_KLEINE) then
		local rg=Duel.GMGroup(cm.cfil21,tp,"G",0,nil)
		g:Merge(rg)
	end
	if chk==0 then
		return g:IsExists(cm.cfil22,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc:IsLoc("G") then
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
		local te=c:IsHasEffect(EFFECT_EINE_KLEINE)
		te:UseCountLimit(tp)
	else
		if c~=tc then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
		Duel.Release(tg,REASON_COST)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("M") and chkc:IsControlerCanBeChanged()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsControlerCanBeChanged,tp,0,"M",1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,Card.IsControlerCanBeChanged,tp,0,"M",1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() and e:GetLabel()>0 then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c:GetBaseDefense()*2)
		c:RegisterEffect(e2)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_PIERCE)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
end