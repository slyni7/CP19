--야상곡 칠흑의 달
--카드군 번호: 0xc90
function c81235010.initial_effect(c)

	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81235010,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81235010)
	e1:SetTarget(c81235010.tg1)
	e1:SetOperation(c81235010.op1)
	c:RegisterEffect(e1)
	
	--기동
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81235010,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81235011)
	e2:SetTarget(c81235010.tg2)
	e2:SetOperation(c81235010.op2)
	c:RegisterEffect(e2)
end

--서치
function c81235010.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc90) and not c:IsCode(81235010)
end
function c81235010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c81235010.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81235010.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81235010.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--기동
function c81235010.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsFacedown()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,71,72)
	e:SetLabel(res)
	Duel.SetChainLimit(c81235010.lim(g:GetFirst()))
end
function c81235010.lim(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c81235010.op2(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
		if ( ( res==0 and tc:IsType(TYPE_SPELL) ) or ( res==1 and tc:IsType(TYPE_TRAP) ) )
		and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable()
			and Duel.SelectYesNo(tp,aux.Stringid(81235010,3)) then
				Duel.BreakEffect()
				Duel.SSet(tp,tc)
			end
		end
	end
end


