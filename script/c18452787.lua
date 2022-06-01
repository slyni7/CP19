--정령 대축제
local m=18452787
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeckAsCost(tp,4)
	end
	Duel.DiscardDeck(tp,4,REASON_COST)
	local og=Duel.GetOperatedGroup()
	og:KeepAlive()
	e:SetLabelObject(og)
end
function cm.ofil11(c,g)
	if not c:IsAbleToHand() or not g:IsExists(cm.ofil13,1,nil,c:GetAttribute()) then
		return false
	end
	return (c:IsLevel(4) and c:IsSetCard("정령") and not c:IsSummonableCard())
		or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665)
end
function cm.ofil12(c)
	return c:IsSetCard("초정령") and c:IsXyzSummonable(nil)
end
function cm.ofil13(c,att)
	return c:GetAttribute()&att>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	local og=e:GetLabelObject()
	if Duel.IEMCard(cm.ofil11,tp,"D",0,1,nil,og) then
		ops[off]=16*m
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetFlagEffect(tp,m)<1 and Duel.IEMCard(cm.ofil12,tp,"E",0,1,nil) then
		ops[off]=16*m+1
		opval[off-1]=2
		off=off+1
	end
	if off<2 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GMGroup(cm.ofil11,tp,"D",0,nil,og)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,4)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	elseif opval[op]==2 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.ofil12,tp,"E",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.XyzSummon(tp,tc,nil)
			local e1=MakeEff(c,"S")
			e1:SetCode(m)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end