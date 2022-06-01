--Nosmirc Imperil
local m=99970514
local cm=_G["c"..m]
function cm.initial_effect(c)

	--함정 몬스터
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	WriteEff(e0,0,"TO")
	c:RegisterEffect(e0)
	
	--패 발동
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e10:SetCondition(cm.handcon)
	c:RegisterEffect(e10)
	
	--Nosmirc
	local e20=MakeEff(c,"FTf","M")
	e20:SetD(m,1)
	e20:SetCategory(CATEGORY_DRAW)
	e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e20:SetCode(EVENT_PHASE+PHASE_END)
	e20:SetCL(1)
	WriteEff(e20,20,"NTO")
	c:RegisterEffect(e20)
	
	--Fallen
	local e30=MakeEff(c,"STf")
	e30:SetCode(EVENT_TO_GRAVE)
	WriteEff(e30,30,"NTO")
	c:RegisterEffect(e30)

	--서치
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(spinel.delay)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--바운스
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(m,2)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1)
	WriteEff(e2,1,"N")
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--함정 몬스터
M_atk,M_def=1900,1000
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe0d,0x21,M_atk,M_def,10,RACE_FIEND,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe0d,0x21,M_atk,M_def,10,RACE_FIEND,ATTRIBUTE_FIRE) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end

--패 발동
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==1
end

--Nosmirc
function cm.con20(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and Duel.GetTurnPlayer()~=tp
end
function cm.tar20(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function cm.op20(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if not Duel.IsPlayerCanDraw(p,2) then return end
	local ac=2
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>2 then
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,0))
		ac=Duel.AnnounceNumber(p,2,3)
	end
	local dr=Duel.Draw(p,ac,REASON_EFFECT)
	if p~=tp and dr~=0 then
		local dmg=dr*500
		Duel.BreakEffect()
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dmg)
	end
end

--Fallen
function cm.con30(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_ADJUST)~=0
end
function cm.setfil(c)
	return c:IsCode(99970511) and c:IsSSetable()
end
function cm.tar30(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cm.setfil,tp,LSTN("DG"),0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op30(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.setfil,tp,LSTN("DG"),0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

--서치
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.filter(c)
	return not c:IsCode(m) and c:IsSetCard(0xe0d) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--바운스
function cm.desfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
