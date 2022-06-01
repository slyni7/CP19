--루나틱션 데이모스
function c112600183.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,0,112600183)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600183,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,112600183)
	e3:SetTarget(c112600183.thtg)
	e3:SetOperation(c112600183.thop)
	c:RegisterEffect(e3)
end
function c112600183.thfilter(c)
	return c:IsSetCard(0xe8b)
end
function c112600183.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c112600183.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(c112600183.thfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c112600183.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end