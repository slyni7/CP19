--¸á¶ûÈ¦¸¯: Âù¶õÇÏ°Ô ºû³ª´ø ³» ¸ð½ÀÀº
local m=18452758
local cm=_G["c"..m]
function cm.initial_effect(c)
	 local e1=aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x2d3))
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","S")
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return tc and (tc==a or tc==d)
end
function cm.tfil3(c,tp,tc)
	GlobalVirusRelease=tc
	local te=c:CheckActivateEffect(false,false,false)
	local res=te and c:IsSetCard("¹ÙÀÌ·¯½º") and Duel.GetLocCount(tp,"S")>0 and
		c:IsType(TYPE_TRAP) and te:IsActivatable(tp)
	GlobalVirusRelease=nil
	return res
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,"D",0,1,nil,tp,tc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HITNMSG_RESOLVECARD)
	local g=Duel.STarget(tp,cm.tfil3,tp,"D",0,1,1,nil,tp,tc)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and cm.tfil3(tc,tp,ec) then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if bit.band(tpe,TYPE_FIELD)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		Duel.HintActivation(te)
		e:SetActiveEffect(te)
		te:UseCountLimit(tp,1,true)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
			tc:CancelToGrave(false)
		end
		tc:CreateEffectRelation(te)
		if co then
			GlobalVirusRelease=tc
			co(te,tp,eg,ep,ev,re,r,rp,1)
			GlobalVirusRelease=nil
		end
		if tg then
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local etc=nil
		if g then
			etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op and not tc:IsDisabled() then
			op(te,tp,eg,ep,ev,re,r,rp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
		e:SetActiveEffect(nil)
		e:SetCategory(0)
		e:SetProperty(0)
		Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.tfil4(c,tp)
	return c:IsSetCard(0x2d3) and c:IsType(TYPE_SPELL) and c:IsSSetable()
		and (c:IsType(TYPE_FIELD) or Duel.GetLocCount(tp,"S")>0)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil4(chkc,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"G",0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.STarget(tp,cm.tfil4,tp,"G",0,1,1,nil,tp)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end