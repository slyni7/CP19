--로제어리에-역공도섬
function c18452907.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18452907,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,18452907)
	e2:SetTarget(c18452907.thtg)
	e2:SetOperation(c18452907.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18452907,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,50005219)
	e3:SetCondition(c18452907.spcon)
	e3:SetTarget(c18452907.sptg)
	e3:SetOperation(c18452907.spop)
	c:RegisterEffect(e3)
	--EDOPro
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SSET_COST)
	e4:SetOperation(c18452907.op4)
	c:RegisterEffect(e4)
end
function c18452907.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c18452907.thfilter(c,e,tp)
	return c:IsSetCard(0x2da)
		and (c:IsAbleToHand()
			or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
			or (c:IsSSetable() and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)))
end
function c18452907.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsSetCard,1,nil,0x2da) then
			if g:IsExists(c18452907.thfilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(18452907,2)) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c18452907.thfilter,1,1,nil,e,tp)
				local sc=sg:GetFirst()
				local off=1
				local ops={}
				local opval={}
				if sc:IsAbleToHand() then
					ops[off]=aux.Stringid(18452907,3)
					opval[off-1]=1
					off=off+1
				end
				if (sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
					or (sc:IsSSetable() and (sc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) then
					ops[off]=aux.Stringid(18452907,4)
					opval[off-1]=2
					off=off+1
				end
				if off==1 then
					return
				end
				local op=Duel.SelectOption(tp,table.unpack(ops))
				if opval[op]==1 then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				elseif opval[op]==2 then
					if sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
						Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
						Duel.ConfirmCards(1-tp,sc)
					elseif sc:IsSSetable() and (sc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
						Duel.SSet(tp,sc)
					end
				end
			end
			if tc:IsRelateToEffect(e) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
function c18452907.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c18452907.spfilter(c,e,tp)
	return c:IsSetCard(0x12da) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18452907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18452907.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c18452907.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18452907.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18452907.op4(e,tp,eg,ep,ev,re,r,rp)
	if not IREDO_COMES_TRUE then
		local c=e:GetHandler()
		c:Type(TYPE_SPELL+TYPE_FIELD)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SSET)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c18452907.oop41)
		Duel.RegisterEffect(e1,tp)
	end
end
function c18452907.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:Type(TYPE_TRAP+TYPE_FIELD)
	e:Reset()
end