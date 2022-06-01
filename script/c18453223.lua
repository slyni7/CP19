--Terr@forming
local m=18453223
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.tfil2(c)
	if c:GetType()&TYPE_SPELL+TYPE_QUICKPLAY+TYPE_FIELD~=TYPE_SPELL+TYPE_QUICKPLAY+TYPE_FIELD
		or not c:IsAbleToHand() or not c.eff_ct[c][0] then
		return false
	end
	local res=false
	local i=0
	repeat
		local te=c.eff_ct[c][i]
		if te:GetCode()==EFFECT_QP_ACT_IN_NTPHAND and te:IsHasType(EFFECT_TYPE_SINGLE) then
			local con=te:GetCondition()
			if not con then
				res=true
				break
			end
		end
		i=i+1
	until not c.eff_ct[c][i]
	return res
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end