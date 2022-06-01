--[LittleWitch]
local m=99970589
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)

	--서치
	local e1=MakeEff(c,"I","S")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--회복
	local e3=MakeEff(c,"FC","S")
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_TO_HAND)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	
	--파괴 대체
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(cm.reptg)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	
end

--서치
function cm.thfilter(c)
	return c:IsSetCard(0xe16) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LSTN("DG"),0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LSTN("DG"))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LSTN("DG"),0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--회복
function cm.filter(c)
	return c:IsPreviousLocation(LSTN("O"))
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end

--파괴 대체
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Damage(tp,2000,REASON_EFFECT)
		return true
	else return false end
end
