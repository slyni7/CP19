--HMS(로열 네이비) 빅토리어스
--카드군 번호: 0xcb7
local m=81200200
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.mfil0,nil,nil,aux.NonTuner(Card.IsSetCard,0xcb7),1,99)
	
	--데미지는 배가 된다
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(0x04)
	e2:SetCondition(cm.cn2)
	c:RegisterEffect(e2)
	
	--상대 몬스터를 파괴한다
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetRange(0x04)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--덱으로 되돌린다
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(0x04)
	e4:SetCountLimit(1,m+2)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--싱크로 소재
function cm.mfil0(c)
	return c:IsType(TYPE_TUNER) or c:IsCode(81200020)
end

--소환 유발
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.nfil0(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(0x40)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,1-tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetTargetRange(0,1)
	e1:SetValue(DOUBLE_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end

--그 몬스터를 파괴한다
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsLevelAbove(7) and bc:IsRelateToBattle()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then
		return bc and bc:IsRelateToBattle() and bc:IsDestructable()
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)~=0 then
		Duel.Damage(p,d,REASON_EFFECT)
	end
end

--덱으로 되돌린다
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
	and ep~=tp and re:IsActiveType(0x1) and Duel.IsChainNegatable(ev)
end
function cm.tfil0(c)
	return c:IsAbleToDeck() and ( c:IsSetCard(0xcb7) or c:IsSetCard(0xcb8) )
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=3
	if not re:GetHandler():IsDestructable() then ct=1 end
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.tarfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0x10,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if #g>=2 and re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if #g==3 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500) end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:Filter(Card.IsRelateToEffect,nil,e)
	if tc and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,0x01) then 
			Duel.ShuffleDeck(tp)
		end
		local ct=g:FilterCount(Card.IsLocation,nil,0x01+0x40)
		if ct==0 then 
			return false
		end
		Duel.NegateActivation(ev)
		if ct>=2 and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
		if ct==3 then 
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
