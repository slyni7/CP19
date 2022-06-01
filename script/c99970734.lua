--[ Juuki ]
local m=99970734
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--링크 소환
	RevLim(c)
	Link.AddProcedure(c,cm.matfilter,1,1)
	
	--서치 / 덤핑
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCL(1,m)
	e1:SetCondition(spinel.stypecon(SUMT_L))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--공격력 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	
end

--링크 소환
function cm.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x3d6d,lc,sumtype,tp) and not c:IsType(TYPE_LINK,lc,sumtype,tp)
end

--서치 / 덤핑
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) end
end
function cm.op1fil(c)
	return c:IsSetCard(0x3d6d) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,4) then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	if #g>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(cm.op1fil,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.op1fil,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end

--공격력 증가
function cm.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x3d6d)*100
end
