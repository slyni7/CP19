--[LittleWitch]
local m=99970586
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--오더 소환
	RevLim(c)
	aux.AddOrderProcedure(c,"<",nil,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsPosition,POS_DEFENSE))

	--코스트 변경
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(m)
	e0:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e0)
	
	--세트
	local e2=MakeEff(c,"I","M")
	e2:SetCL(1,m)
	e2:SetCost(YuL.discard(1,1))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--공수 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe16))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
end

cm.CardType_Order=true

--세트
function cm.setf(c)
	return c:IsSetCard(0xe16) and c:IsType(YuL.ST) and c:IsSSetable()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.setf,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g:GetFirst())
	end
end
