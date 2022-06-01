--빙탄향의 인랑

function c81030140.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81030140)
	e1:SetTarget(c81030140.sptg)
	e1:SetOperation(c81030140.spop)
	c:RegisterEffect(e1)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81030141)
	e2:SetTarget(c81030140.dstg)
	e2:SetOperation(c81030140.dsop)
	c:RegisterEffect(e2)
	
end

--special summon
function c81030140.sptgfilter(c)
	return c:IsDestructable() and c:IsFaceup()
	   and c:IsSetCard(0xca3)
end
function c81030140.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsOnField()
			and chkc:IsControler(tp)
			and c81030140.sptgfilter(chkc)
			end
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return
				c:IsCanBeSpecialSummoned(e,1,tp,false,false)
			and Duel.IsExistingTarget(c81030140.sptgfilter,tp,LOCATION_ONFIELD,0,1,nil)
			and ( ft>0 or Duel.IsExistingTarget(c81030140.sptgfilter,tp,LOCATION_MZONE,0,1,nil) )
			end
	local g=nil
	if ft~=0 then
		local loc=LOCATION_ONFIELD
		if ft<0 then loc=LOCATION_MZONE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,c81030140.sptgfilter,tp,loc,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c81030140.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
	end
end

--destroy
function c81030140.dstgfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81030140.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
				chkc:IsOnField()
			and c81030140.dstgfilter(chkc)
			and chkc~=c
			end
	if chk==0 then return
				c:IsDestructable()
			and Duel.IsExistingTarget(c81030140.dstgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81030140.dstgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end

function c81030140.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(Group.FromCards(tc,c),REASON_EFFECT)
	end
end
