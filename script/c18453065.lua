--아스트로매지션 서쳐
local m=18453065
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tfil1(c,tp,exist)
	local b=exist~=nil and exist or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,18453054)
	return c:IsSetCard(0xffd) and c:IsAbleToHand() and (b or c:IsCode(18453054))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.ofil11(c)
	return (c:IsFaceup() and c:IsOnField()) or (c:IsPublic() and c:IsLocation(LOCATION_HAND))
end
function cm.ofil12(c)
	return not c:IsCode(18453054)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,18453054)
	local fg=g:Filter(cm.ofil11,1,nil)
	local sg=Duel.GetMatchingGroup(cm.tfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local ng=sg:Filter(cm.ofil12,1,nil)
	local exist=false
	if #g>0 and #fg==0 and #ng>0 and (#sg==#ng or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		local cg=g:Clone()
		cg:Sub(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=cg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tg)
		if tc:IsLocation(LOCATION_HAND) then
			Duel.ShuffleHand(tp)
		end
		exist=true
	end
	local b=#fg>0 or exist
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,b)
	if #ag>0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end