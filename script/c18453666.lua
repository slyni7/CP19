--시무르그 네스트
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetD(id,0)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.operation1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetTarget(s.target2)
	e4:SetOperation(s.operation2)
	c:RegisterEffect(e4)
end
function s.ofil1(c)
	return c:IsMonster() and c:IsSetCard(0x12d) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.STarget(tp,aux.TRUE,tp,0,"O",1,1,nil)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=MakeEff(c,"F","F")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetTR("M",0)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		e1:SetTarget(s.otar21)
		e1:SetValue(s.oval21)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"FC","F")
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCL(1)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(tc)
		e2:SetLabel(fid)
		e2:SetOperation(s.ocon22)
		e2:SetOperation(s.oop22)
		c:RegisterEffect(e1)
	end
end
function s.otar21(e,c)
	return c:IsSetCard(0x12d)
end
function s.oval21(e,re,rp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	return rc==tc and rc:GetFlagEffectLabel(id)==fid
end
function s.ocon22(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc:GetFlagEffectLabel(id)~=fid then
		e:Reset()
		return false
	end
	return true
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	e:Reset()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter1(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x12d) and c:IsAbleToHand()
end
function s.filter2(c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsAbleToGrave()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
