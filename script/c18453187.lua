--오로라 커튼콜
local m=18453187
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil1(c)
	if c:GetType()&TYPE_SPELL+TYPE_EQUIP~=TYPE_SPELL+TYPE_EQUIP or not c:IsAbleToHand() or not c.eff_ct[c][0] then
		return false
	end
	local nolimit=false
	local constup=false
	local i=0
	repeat
		local te=c.eff_ct[c][i]
		if te:GetCode()==EFFECT_EQUIP_LIMIT and te:IsHasType(EFFECT_TYPE_SINGLE) then
			local con=te:GetCondition()
			local val=te:GetValue()
			if not con and type(val)=="number" and val==1 then
				nolimit=true
			end
		elseif te:GetCode()==EFFECT_UPDATE_ATTACK and te:IsHasType(EFFECT_TYPE_EQUIP) then
			local con=te:GetCondition()
			local val=te:GetValue()
			if not te:IsHasType(EFFECT_TYPE_FIELD) and not con and type(val)=="number" and val>=0 then
				constup=true
			end
		end
		i=i+1
	until not c.eff_ct[c][i]
	return nolimit and constup
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	if chk==0 then
		return g:GetClassCount(Card.GetCode)>1
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	if g:GetClassCount(Card.GetCode)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end