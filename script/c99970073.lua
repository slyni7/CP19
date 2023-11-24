--[ Star Absorber ]
local s,id=GetID()
function s.initial_effect(c)

	local es=MakeEff(c,"S","M")
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetValue(function(e,c) return c:GetLevel()*100 end)
	c:RegisterEffect(es)
	
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(function(e) return e:GetHandler():GetLevel()~=e:GetHandler():GetOriginalLevel() end)
	e3:SetValue(function(e,c) return Duel.GetCounter(0,1,1,0x1051)*-200 end)
	c:RegisterEffect(e3)
	
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1051,3,REASON_COST)
		and e:GetHandler():GetAttackAnnouncedCount()==0 end
	Duel.RemoveCounter(tp,1,1,0x1051,3,REASON_COST)
end
function s.tar1fil(c)
	return c:IsSetCard(0xd36) and c:IsM() and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end