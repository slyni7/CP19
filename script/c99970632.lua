--[ hololive 1st Gen ]
local m=99970632
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xe19),4,2,nil,nil,99)

	--공격력 증가
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCL(1)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)

	--엑시즈 소재 수 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(cm.con3)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	
	--테이밍
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCL(1)
	e2:SetCondition(aux.bdogcon)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--공격력 증가
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(Card.IsSetCard,nil,0xe19)
	Duel.ShuffleDeck(tp)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*300)
		c:RegisterEffect(e1)
	end
end

--엑시즈 소재 수 공격
function cm.con3(e)
	return e:GetHandler():GetOverlayCount()>1
end
function cm.val3(e,c)
	return c:GetOverlayCount()-1
end

--테이밍
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
