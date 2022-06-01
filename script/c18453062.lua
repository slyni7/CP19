--아스트로매지션 네로
local m=18453062
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,18453054,cm.pfil1,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_CODE)	
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(18453054)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetCountLimit(1,m+1)
	e5:SetTarget(cm.tar5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end
function cm.pfil1(c,fc,sub,mg,sg)
	return c:IsLocation(LOCATION_MZONE)
end
function cm.val1(e,c)
	local fc=e:GetHandler()
	local g=fc:GetMaterial()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.tfil2(c,g)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and g and g:IsContains(c)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	local g=te:GetLabelObject()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,g)
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local g=te:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOAHND)
	local tg=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,g)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	else
		return
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	local g=te:GetLabelObject()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,g)
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local g=te:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOAHND)
	local tg=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,g)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	else
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function cm.tfil5(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil5,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.tfil5,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	local tc=te:GetHandler()
	if not tc:IsRelateToEffect(e) then
		return
	end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end