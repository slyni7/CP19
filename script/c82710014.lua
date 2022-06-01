--아르카나 포스 XVII-더 스타
function c82710014.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetTarget(c82710014.tar1)	
	e1:SetOperation(c82710014.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCost(c82710014.cost4)
	e4:SetTarget(c82710014.tar4)
	e4:SetOperation(c82710014.op4)
	c:RegisterEffect(e4)
	if not c82710014.glo_chk then
		c82710014.glo_chk=true
		c82710014[0]=0
		c82710014[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TOSS_COIN)
		ge1:SetOperation(c82710014.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c82710014.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
c82710014.toss_coin=true
function c82710014.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x5) then
		c82710014[ep]=c82710014[ep]+ev
	end
end
function c82710014.gop2(e,tp,eg,ep,ev,re,r,rp)
	c82710014[0]=0
	c82710014[1]=0
end
function c82710014.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710014.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710014.arcanareg(c,res)
	if res==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c82710014.ocon1)
		e1:SetOperation(c82710014.oop1)
		Duel.RegisterEffect(e1,tp)
	elseif res==0 then
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		Duel.DiscardDeck(tp,math.floor(ct/3),REASON_EFFECT)
	end
end
function c82710014.ocon1(e,tp,eg,ep,ev,re,r,rp)
	return c82710014[tp]>0
end
function c82710014.oop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,82710014)
	Duel.Draw(tp,c82710014[tp],REASON_EFFECT)
end
function c82710014.arcanareg(c,coin)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710014.cfil4(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c82710014.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable() and Duel.IsExistingMatchingCard(c82710010.cfil4,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c82710010.cfil4,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c82710014.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c82710014.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end