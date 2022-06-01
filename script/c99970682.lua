--[ hololive Gamers ]
local m=99970682
local cm=_G["c"..m]
function cm.initial_effect(c)

	--펜듈럼
	Pendulum.AddProcedure(c)
	
	--P: 펜듈럼 소환 제약
	local e9=MakeEff(c,"F","P")
	e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e9:SetTargetRange(1,0)
	e9:SetTarget(cm.splimit)
	c:RegisterEffect(e9)
	
	--P: 샐비지
	local e1=MakeEff(c,"I","P")
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--M: 서치
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(spinel.stypecon(SUMT_P))
	c:RegisterEffect(e3)
	
	--M: 내성
	local e4=MakeEff(c,"S","M")
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(cm.con4)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	
end

--P: 펜듈럼 소환 제약
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsSetCard(0xe19) and c:IsType(TYPE_MONSTER)) and (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--P: 샐비지
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),m+1)
end
function cm.tar1fil(c)
	return c:IsSetCard(0xe19) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--M: 서치
function cm.tar2fil(c)
	return c:IsCode(m+1) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(cm.tar2fil,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--M: 내성
function cm.con4fil(c)
	return c:IsFaceup() and c:IsCode(m+1)
end
function cm.con4(e)
	return Duel.IsExistingMatchingCard(cm.con4fil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
