--은하수 너머로 아득히 먼 곳으로 바람에 날려
local m=18453416
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
cm.listed_names={CARD_TIME_CAPSULE}
function cm.tfil11(c)
	return c:IsAbleToRemove(POS_FACEDOWN) and c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,CARD_TIME_CAPSULE)
end
function cm.tfil12(c,tp,tc)
	if not c:IsCode(CARD_TIME_CAPSULE) then
		return false
	end
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc and tc:IsLocation(LOCATION_HAND) then
		ft=ft-1
	end
	return te and te:IsActivatable(tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil)
			and Duel.IEMCard(cm.tfil12,tp,"DG",0,1,nil,tp,c)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil)
	if #g<1 or Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SMCard(tp,cm.tfil12,tp,"DG",0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc then
		Duel.BreakEffect()
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc:CreateEffectRelation(te)
		if co then
			co(te,tp,eg,ep,ev,re,r,rp,1)
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
		e:SetCategory(0)
		e:SetProperty(0)
	end
end