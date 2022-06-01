--[ Pneumamancy ]
local m=99970371
local cm=_G["c"..m]
function cm.initial_effect(c)

	--세트
	local e1=MakeEff(c,"STo")
	e1:SetProperty(spinel.delay)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--소생
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetCode(EVENT_DESTROYED)
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

--세트
function cm.setfilter(c)
	return c:IsSetCard(0xe12) and c:IsType(YuL.ST) and c:IsSSetable()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

--소생
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xe12) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if #g1>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		local g2=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_GRAVE,0,nil,tp)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g2>0 
			and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			--장착
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			if sg then
				if not Duel.Equip(tp,sg:GetFirst(),tc,true) then return end
				local e1=Effect.CreateEffect(tc)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				sg:GetFirst():RegisterEffect(e1)
			end
		end
	end
end
function cm.eqfilter(c,tp) 
	return c:IsSetCard(0xe12) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
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
