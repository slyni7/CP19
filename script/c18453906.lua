--이겨야 한다
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","S")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetD(id,0)
	e2:SetCL(1)
	WriteEff(e2,2,"T")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","S")
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetD(id,1)
	e3:SetCL(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","S")
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetD(id,2)
	e4:SetCL(1)
	WriteEff(e4,4,"NT")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FTo","S")
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetD(id,3)
	e5:SetCL(1)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"Qo","S")
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetD(id,4)
	e6:SetCL(1)
	WriteEff(e6,6,"NTO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"I","S")
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e7:SetD(id,5)
	e7:SetCL(1)
	WriteEff(e7,7,"TO")
	c:RegisterEffect(e7)
end
s.listed_names={18453902}
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
		return chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(nil,tp,"O","O",1,nil)
	end
	Duel.STarget(tp,nil,tp,"O","O",1,1,nil)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLoc,1,nil,"O")
end
function s.tfil3(c)
	return c:IsCode(18453902) and c:IsAbleToGrave()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.nfil4(c,tp)
	return c:IsCode(18453902) and c:IsControler(tp)
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil4,1,nil,tp)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("G")
	end
	if chk==0 then
		return Duel.IETarget(nil,tp,"G","G",1,nil)
	end
	Duel.STarget(tp,nil,tp,"G","G",1,1,nil)
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLoc,1,nil,"G")
end
function s.tfil5(c)
	return c:IsCode(18453902) and c:IsAbleToHand()
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil5,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil5,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsCode(18453902) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=re:GetHandler()
	if chkc then
		return false
	end
	if chk==0 then
		return rc:IsRelateToEffect(re) and rc:IsCanBeEffectTarget(e)
	end
	Duel.SetTargetCard(rc)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:CancelToGrave()
	end
end
function s.tfil71(c)
	return c:IsCode(18453902) and c:IsAbleToDeck() and c:IsFaceup()
end
function s.tfil72(c)
	return not c:IsCode(id) and c:ListsCode(18453902) and c:IsAbleToHand()
end
function s.tar7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and s.tfil71(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil71,tp,"O",0,1,nil) and Duel.IEMCard(s.tfil72,tp,"D",0,1,nil)
	end
	local g=Duel.STarget(tp,s.tfil71,tp,"O",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op7(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.tfil72,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			return
		end
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end