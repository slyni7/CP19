--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	aux.AddXyzProcedureLevelFree(c,s.pfil1,s.pfun1,2,2)
	
	--1
	local e2=MakeEff(c,"Qf","M")
	e2:SetD(id,0)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(spinel.rmovcost(1))
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	
	--2
	local e3=MakeEff(c,"I","M")
	e3:SetD(id,1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.tar3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	
	--3
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(function(e) return e:GetHandler():GetOverlayCount()==0 end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)

end

function s.pfil1(c,xc)
	return c:IsXyzLevel(xc,4) and c:IsSetCard(0x5d6e)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
s.square_mana={ATT_E,ATT_X,ATT_X,ATT_N}
s.custom_type=CUSTOMTYPE_SQUARE

--1
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--2
function s.tar3fil(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5d6e)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.tar3fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tar3fil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,s.tar3fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end
