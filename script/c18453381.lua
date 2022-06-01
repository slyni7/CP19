--치킨의 대가
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","G")
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(s.tar2)
	e2:SetValue(s.val2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end
function s.tfun1(g)
	return g:IsExists(Card.IsSetCard,1,nil,"치킨")
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil1,tp,"D",0,nil)
	if chk==0 then
		return g:CheckSubGroup(s.tfun1,3,3)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil1,tp,"D",0,nil)
	local sg=g:SelectSubGroup(tp,s.tfun1,false,3,3)
	if #sg==3 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		sg:Sub(tg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function s.tfil2(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
		and c:IsSetCard("치킨") and not c:IsReason(REASON_REPLACE) and c:IsResason(REASON_BATTLE+REASON_EFFECT)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(s.tfil2,1,nil,tp) and c:IsAbleToRemove()
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.val2(e,c)
	local tp=e:GetHandlerPlayer()
	return s.tfil2(c,tp)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
