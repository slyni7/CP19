--[ Pneumamancy ]
local m=99970372
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(spinel.delay)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--특수 소환 + 회복
	local e2=MakeEff(c,"FTo","H")
	e2:SetD(m,1)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(spinel.delay)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
	--영령술
	local e0=MakeEff(c,"Qo","M")
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e0,0,"TO")
	c:RegisterEffect(e0)
	
end

--서치
function cm.filter(c)
	return c:IsSetCard(0xe12) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--특수 소환 + 회복
function cm.confil(c,tp)
	return c:IsPreviousSetCard(0xe12) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.confil,1,nil,tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end

--영령술
function cm.cpfilter(c,ec,e,tp,eg,ep,ev,re,r,rp)
	return c:IsSetCard(0xe12) and c:IsType(YuL.ST) and c:GetEquipTarget()==ec
		and (c.pneu_tg==nil or c.pneu_tg(e,tp,eg,ep,ev,re,r,rp,0))
		and not c:IsEquipTurn()
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		local tc=e:GetLabelObject()
		local N=_G["c"..tc:GetCode()]
		local tg=N.pneu_tg
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_SZONE,0,1,nil,c,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_SZONE,0,1,1,nil,c,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local N=_G["c"..tc:GetCode()]
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=N.pneu_tg
	local te=tc:GetActivateEffect()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local N=_G["c"..te:GetHandler():GetCode()]
	local op=N.pneu_op
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoGrave(te:GetHandler(),REASON_EFFECT)
end
