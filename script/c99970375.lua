--[ Pneumamancy ]
local m=99970375
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xe12),nil,nil,cm.pneu_tg,cm.pneu_op)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK)

	--제어
	local e2=MakeEff(c,"Qo","S")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--서치
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCL(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	WriteEff(e4,4,"N")
	c:RegisterEffect(e4)
	
end

--영령술
function cm.tdfil(c)
	return c:IsSetCard(0xe12) and c:IsAbleToDeck()
end
function cm.pneu_op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfil,tp,LOCATION_GRAVE,0,1,3,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end

--제어
function cm.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe12) and c:GetSequence()<5
end
function cm.seqfilter2(c)
	return c:GetSequence()<5
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,cm.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsControler(1-tp) then return end
	if Duel.IsExistingMatchingCard(cm.seqfilter2,tp,0,LOCATION_MZONE,1,tc) and
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.HintSelection(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g2=Duel.SelectMatchingCard(tp,cm.seqfilter2,tp,LOCATION_MZONE,0,1,1,tc)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc,tc2)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)		
	end
end

--서치
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_MODULE
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_EFFECT
end
function cm.filter(c)
	return c:IsSetCard(0xe12) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
