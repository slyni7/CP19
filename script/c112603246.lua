--매지컬 디폴트 그루비
local m=112603246
local cm=_G["c"..m]
function cm.initial_effect(c)
	--beyond summon
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,"<",aux.FilterBoolFunction(Card.IsSetCard,0xe9e),"L")
	--search
	local e30=Effect.CreateEffect(c)
	e30:SetDescription(aux.Stringid(m,0))
	e30:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e30:SetType(EFFECT_TYPE_IGNITION)
	e30:SetRange(LOCATION_MZONE)
	e30:SetCountLimit(1)
	e30:SetTarget(cm.thtg)
	e30:SetOperation(cm.thop)
	c:RegisterEffect(e30)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end

cm.custom_type=CUSTOMTYPE_BEYOND

--search
function cm.thfilter(c)
	return c:IsSetCard(0xe9d)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(cm.thfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end

--draw
function cm.filter(c)
	return c:IsSetCard(0xe9e) and c:IsReleasableByEffect()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.CheckReleaseGroupEx(tp,cm.filter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.SelectReleaseGroupEx(tp,cm.filter,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Draw(tp,rct,REASON_EFFECT)
	end
end