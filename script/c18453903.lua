--오토마우스
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetD(id,0)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_ADJUST)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BATTLED)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e6,6,"O")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"I","G")
	e7:SetCategory(CATEGORY_TOHAND)
	WriteEff(e7,7,"CTO")
	c:RegisterEffect(e7)
end
s.listed_names={18453902}
function s.tfil1(c)
	return c:IsCode(18453902) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.ofil3(c)
	return c:IsAbleToDeck() and c:GetOwnerTargetCount()>0
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.ofil3,tp,"O","O",nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function s.ofil4(c)
	return c:GetFlagEffect(id)>0
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then
		return
	end
	local rg=g:Filter(Card.IsRelateToEffect,nil,re)
	if #rg==0 then
		return
	end
	for _,ch in ipairs({c:GetFlagEffectLabel(id+1)}) do
		if ch==ev then
			if (Duel.GetCurrentPhase()&(PHASE_DAMAGE|PHASE_DAMAGE_CAL))~=0 and not Duel.IsDamageCalculated() then
				local rc=rg:GetFirst()
				while rc do
					rc:RegisterEffect(id,RESET_PHASE|PHASE_DAMAGE|RESET_EVENT|RESETS_STANDARD,0,1)
					rc=rg:GetNext()
				end
			elseif not c:IsHasEffect(EFFECT_DISABLE) and not c:IsDisabled() then
				Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
			end
			return			
		end
	end
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.ofil4,tp,LSTN("OGR"),LSTN("OGR"),nil)
	if #g>0 and not c:IsHasEffect(EFFECT_DISABLE) and not c:IsDisabled() then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id+1,RESET_CHAIN|RESET_EVENT|RESETS_STANDARD,0,1,ev)
end
function s.cfil7(c)
	return c:IsCode(18453902) and c:IsAbleToDeckAsCost()
end
function s.cost7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil7,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.cfil7,tp,"G",0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.tar7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end